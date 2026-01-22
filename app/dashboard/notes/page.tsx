import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import NotesList from "@/components/notes/NotesList";
import { redirect } from "next/navigation";

export default async function NotesPage({
  searchParams,
}: {
  searchParams: { favorites?: string; search?: string; tag?: string };
}) {
  const session = await auth();

  if (!session?.user?.id) {
    redirect("/login");
  }

  const where: any = {
    userId: session.user.id,
    isArchived: false,
  };

  if (searchParams.favorites === "true") {
    where.isFavorite = true;
  }

  if (searchParams.search) {
    where.OR = [
      { title: { contains: searchParams.search, mode: "insensitive" } },
      { content: { contains: searchParams.search, mode: "insensitive" } },
    ];
  }

  if (searchParams.tag) {
    where.tags = { has: searchParams.tag };
  }

  const notes = await prisma.note.findMany({
    where,
    orderBy: { updatedAt: "desc" },
  });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          {searchParams.favorites ? "Favorite Notes" : "My Notes"}
        </h1>
        <p className="text-gray-600 dark:text-gray-400 mt-2">
          {notes.length} {notes.length === 1 ? "note" : "notes"}
        </p>
      </div>

      <NotesList notes={notes} />
    </div>
  );
}
