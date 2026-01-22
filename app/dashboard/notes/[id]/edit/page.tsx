import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { redirect } from "next/navigation";
import NoteEditor from "@/components/notes/NoteEditor";

export default async function EditNotePage({
  params,
}: {
  params: { id: string };
}) {
  const session = await auth();

  if (!session?.user?.id) {
    redirect("/login");
  }

  const note = await prisma.note.findFirst({
    where: {
      id: params.id,
      userId: session.user.id,
    },
  });

  if (!note) {
    redirect("/dashboard/notes");
  }

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
        Edit Note
      </h1>
      <NoteEditor note={note} />
    </div>
  );
}
