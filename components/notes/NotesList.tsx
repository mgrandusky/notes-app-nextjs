"use client";

import Link from "next/link";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Star, Archive, Trash2, Edit } from "lucide-react";
import { formatDistanceToNow } from "date-fns";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";

interface Note {
  id: string;
  title: string;
  content: string;
  tags: string[];
  isFavorite: boolean;
  isArchived: boolean;
  createdAt: Date;
  updatedAt: Date;
}

interface NotesListProps {
  notes: Note[];
}

export default function NotesList({ notes }: NotesListProps) {
  const router = useRouter();

  const toggleFavorite = async (noteId: string, e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    try {
      await fetch(`/api/notes/${noteId}/favorite`, {
        method: "PATCH",
      });
      toast.success("Note updated");
      router.refresh();
    } catch (error) {
      toast.error("Failed to update note");
    }
  };

  const toggleArchive = async (noteId: string, e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    try {
      await fetch(`/api/notes/${noteId}/archive`, {
        method: "PATCH",
      });
      toast.success("Note updated");
      router.refresh();
    } catch (error) {
      toast.error("Failed to update note");
    }
  };

  const deleteNote = async (noteId: string, e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (!confirm("Are you sure you want to delete this note?")) {
      return;
    }

    try {
      await fetch(`/api/notes/${noteId}`, {
        method: "DELETE",
      });
      toast.success("Note deleted");
      router.refresh();
    } catch (error) {
      toast.error("Failed to delete note");
    }
  };

  if (notes.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500 dark:text-gray-400 text-lg">
          No notes found. Create your first note!
        </p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {notes.map((note) => (
        <Link key={note.id} href={`/dashboard/notes/${note.id}/edit`}>
          <Card className="p-6 hover:shadow-lg transition-shadow cursor-pointer h-full">
            <div className="flex justify-between items-start mb-3">
              <h3 className="text-xl font-semibold line-clamp-2 flex-1">
                {note.title}
              </h3>
              <Button
                variant="ghost"
                size="icon"
                onClick={(e) => toggleFavorite(note.id, e)}
                className="flex-shrink-0"
              >
                <Star
                  className={cn(
                    "w-5 h-5",
                    note.isFavorite && "fill-yellow-400 text-yellow-400"
                  )}
                />
              </Button>
            </div>

            <p className="text-gray-600 dark:text-gray-400 line-clamp-3 mb-4">
              {note.content.replace(/<[^>]*>/g, "").substring(0, 150)}...
            </p>

            {note.tags.length > 0 && (
              <div className="flex flex-wrap gap-2 mb-4">
                {note.tags.map((tag) => (
                  <span
                    key={tag}
                    className="px-2 py-1 bg-blue-100 dark:bg-blue-900 text-blue-700 dark:text-blue-200 text-xs rounded-full"
                  >
                    {tag}
                  </span>
                ))}
              </div>
            )}

            <div className="flex justify-between items-center text-sm text-gray-500 dark:text-gray-400 mt-auto">
              <span>
                {formatDistanceToNow(new Date(note.updatedAt), {
                  addSuffix: true,
                })}
              </span>

              <div className="flex gap-2">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={(e) => toggleArchive(note.id, e)}
                >
                  <Archive className="w-4 h-4" />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={(e) => deleteNote(note.id, e)}
                >
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            </div>
          </Card>
        </Link>
      ))}
    </div>
  );
}
