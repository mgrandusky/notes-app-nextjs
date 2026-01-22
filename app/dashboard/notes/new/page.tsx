import NoteEditor from "@/components/notes/NoteEditor";

export default function NewNotePage() {
  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
        Create New Note
      </h1>
      <NoteEditor />
    </div>
  );
}
