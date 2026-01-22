"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card } from "@/components/ui/card";
import { toast } from "sonner";
import { Save, ArrowLeft } from "lucide-react";
import Link from "next/link";
import AIToolsPanel from "@/components/ai/AIToolsPanel";

interface Note {
  id: string;
  title: string;
  content: string;
  tags: string[];
}

interface NoteEditorProps {
  note?: Note;
}

export default function NoteEditor({ note }: NoteEditorProps) {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    title: note?.title || "",
    content: note?.content || "",
    tags: note?.tags.join(", ") || "",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const tags = formData.tags
        .split(",")
        .map((tag) => tag.trim())
        .filter((tag) => tag);

      const url = note ? `/api/notes/${note.id}` : "/api/notes";
      const method = note ? "PUT" : "POST";

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          title: formData.title,
          content: formData.content,
          tags,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to save note");
      }

      toast.success(note ? "Note updated!" : "Note created!");
      router.push("/dashboard/notes");
      router.refresh();
    } catch (error) {
      toast.error("Failed to save note");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <div className="lg:col-span-2">
        <form onSubmit={handleSubmit}>
          <Card className="p-6">
            <div className="space-y-6">
              <div>
                <Label htmlFor="title">Title</Label>
                <Input
                  id="title"
                  value={formData.title}
                  onChange={(e) =>
                    setFormData({ ...formData, title: e.target.value })
                  }
                  placeholder="Enter note title..."
                  required
                  disabled={isLoading}
                  className="text-2xl font-semibold mt-2"
                />
              </div>

              <div>
                <Label htmlFor="content">Content</Label>
                <textarea
                  id="content"
                  value={formData.content}
                  onChange={(e) =>
                    setFormData({ ...formData, content: e.target.value })
                  }
                  placeholder="Write your note here..."
                  required
                  disabled={isLoading}
                  rows={15}
                  className="w-full mt-2 px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 dark:bg-gray-800 dark:text-white resize-none"
                />
              </div>

              <div>
                <Label htmlFor="tags">Tags (comma separated)</Label>
                <Input
                  id="tags"
                  value={formData.tags}
                  onChange={(e) =>
                    setFormData({ ...formData, tags: e.target.value })
                  }
                  placeholder="work, personal, ideas..."
                  disabled={isLoading}
                  className="mt-2"
                />
              </div>

              <div className="flex gap-4">
                <Button type="submit" disabled={isLoading} className="flex items-center gap-2">
                  <Save className="w-4 h-4" />
                  {isLoading ? "Saving..." : note ? "Update Note" : "Create Note"}
                </Button>

                <Link href="/dashboard/notes">
                  <Button type="button" variant="outline" className="flex items-center gap-2">
                    <ArrowLeft className="w-4 h-4" />
                    Cancel
                  </Button>
                </Link>
              </div>
            </div>
          </Card>
        </form>
      </div>

      <div className="lg:col-span-1">
        <AIToolsPanel
          noteId={note?.id}
          content={formData.content}
          onContentUpdate={(newContent) => 
            setFormData({ ...formData, content: newContent })
          }
          onTagsUpdate={(tags) => 
            setFormData({ ...formData, tags: tags.join(", ") })
          }
        />
      </div>
    </div>
  );
}
