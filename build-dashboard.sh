#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Building Dashboard & Notes UI${NC}\n"

# ============================================
# PART 3: DASHBOARD LAYOUT & PAGES
# ============================================

echo -e "${GREEN}Creating dashboard layout...${NC}"

mkdir -p app/dashboard
mkdir -p app/dashboard/notes
mkdir -p app/dashboard/notes/new
mkdir -p app/dashboard/notes/[id]/edit
mkdir -p app/dashboard/archived
mkdir -p components/layout
mkdir -p components/notes

# Dashboard Layout
cat > app/dashboard/layout.tsx << 'DASHLAYOUT'
import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import DashboardNav from "@/components/layout/DashboardNav";

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const session = await auth();

  if (!session) {
    redirect("/login");
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <DashboardNav user={session.user} />
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {children}
      </main>
    </div>
  );
}
DASHLAYOUT

# Dashboard Navigation
cat > components/layout/DashboardNav.tsx << 'DASHNAV'
"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Button } from "@/components/ui/button";
import { signOut } from "next-auth/react";
import { 
  FileText, 
  Archive, 
  Star, 
  LogOut, 
  Plus,
  Moon,
  Sun
} from "lucide-react";
import { useTheme } from "next-themes";
import { cn } from "@/lib/utils";

interface DashboardNavProps {
  user: any;
}

export default function DashboardNav({ user }: DashboardNavProps) {
  const pathname = usePathname();
  const { theme, setTheme } = useTheme();

  const navItems = [
    { href: "/dashboard/notes", label: "Notes", icon: FileText },
    { href: "/dashboard/notes?favorites=true", label: "Favorites", icon: Star },
    { href: "/dashboard/archived", label: "Archived", icon: Archive },
  ];

  return (
    <nav className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center space-x-8">
            <Link href="/dashboard/notes" className="flex items-center">
              <h1 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
                Notes App
              </h1>
            </Link>
            
            <div className="hidden md:flex space-x-4">
              {navItems.map((item) => {
                const Icon = item.icon;
                const isActive = pathname === item.href || pathname.startsWith(item.href);
                
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={cn(
                      "flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors",
                      isActive
                        ? "bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-200"
                        : "text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700"
                    )}
                  >
                    <Icon className="w-4 h-4" />
                    {item.label}
                  </Link>
                );
              })}
            </div>
          </div>

          <div className="flex items-center space-x-4">
            <Link href="/dashboard/notes/new">
              <Button size="sm" className="flex items-center gap-2">
                <Plus className="w-4 h-4" />
                New Note
              </Button>
            </Link>

            <Button
              variant="ghost"
              size="icon"
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            >
              {theme === "dark" ? (
                <Sun className="w-5 h-5" />
              ) : (
                <Moon className="w-5 h-5" />
              )}
            </Button>

            <div className="flex items-center gap-3">
              <span className="text-sm text-gray-700 dark:text-gray-300">
                {user?.name || user?.email}
              </span>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => signOut({ callbackUrl: "/" })}
              >
                <LogOut className="w-5 h-5" />
              </Button>
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
DASHNAV

# Notes List Page
cat > app/dashboard/notes/page.tsx << 'NOTESPAGE'
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
NOTESPAGE

# Archived Notes Page
cat > app/dashboard/archived/page.tsx << 'ARCHIVEDPAGE'
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
ARCHIVEDPAGE

# Notes List Component
cat > components/notes/NotesList.tsx << 'NOTESLIST'
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
NOTESLIST

# New Note Page
cat > app/dashboard/notes/new/page.tsx << 'NEWNOTE'
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
NEWNOTE

# Edit Note Page
cat > app/dashboard/notes/[id]/edit/page.tsx << 'EDITNOTE'
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
EDITNOTE

# Note Editor Component
cat > components/notes/NoteEditor.tsx << 'NOTEEDITOR'
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
  );
}
NOTEEDITOR

echo -e "${GREEN}✅ Dashboard & Notes UI Complete!${NC}\n"
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Application is ready!${NC}"
echo -e "${BLUE}========================================${NC}\n"
echo -e "Visit: ${GREEN}http://localhost:3003${NC}\n"
echo -e "You can now:"
echo -e "  ✓ Register a new account"
echo -e "  ✓ Login"
echo -e "  ✓ Create, edit, delete notes"
echo -e "  ✓ Favorite and archive notes"
echo -e "  ✓ Search and filter notes"
echo -e "\n${BLUE}Next: Add AI features (summarize, tags, chat, etc.)${NC}\n"
