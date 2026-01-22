import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import NotesList from "@/components/notes/NotesList";
import { redirect } from "next/navigation";

export default async function ArchivedPage() {
  const session = await auth();

  if (!session?.user?.id) {
    redirect("/login");
  }

  const notes = await prisma.note.findMany({
    where: {
      userId: session.user.id,
      isArchived: true,
    },
    orderBy: { updatedAt: "desc" },
  });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          Archived Notes
        </h1>
        <p className="text-gray-600 dark:text-gray-400 mt-2">
          {notes.length} archived {notes.length === 1 ? "note" : "notes"}
        </p>
      </div>

      <NotesList notes={notes} />
    </div>
  );
}
