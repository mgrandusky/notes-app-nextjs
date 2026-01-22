#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Building Complete Notes App${NC}\n"

# ============================================
# PART 1: AUTH COMPONENTS
# ============================================

echo -e "${GREEN}Creating auth components...${NC}"

mkdir -p app/login
mkdir -p app/register
mkdir -p app/api/auth/register
mkdir -p components/auth

# Login Page
cat > app/login/page.tsx << 'LOGINPAGE'
import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import LoginForm from "@/components/auth/LoginForm";
import Link from "next/link";

export default async function LoginPage() {
  const session = await auth();
  
  if (session) {
    redirect("/dashboard/notes");
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold mb-2 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
            Welcome Back
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Sign in to your account
          </p>
        </div>
        
        <LoginForm />
        
        <p className="text-center mt-6 text-sm text-gray-600 dark:text-gray-400">
          Don't have an account?{" "}
          <Link href="/register" className="text-blue-600 hover:underline font-semibold">
            Sign up
          </Link>
        </p>
      </div>
    </div>
  );
}
LOGINPAGE

# Register Page
cat > app/register/page.tsx << 'REGISTERPAGE'
import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import RegisterForm from "@/components/auth/RegisterForm";
import Link from "next/link";

export default async function RegisterPage() {
  const session = await auth();
  
  if (session) {
    redirect("/dashboard/notes");
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold mb-2 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
            Create Account
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Start taking notes with AI
          </p>
        </div>
        
        <RegisterForm />
        
        <p className="text-center mt-6 text-sm text-gray-600 dark:text-gray-400">
          Already have an account?{" "}
          <Link href="/login" className="text-blue-600 hover:underline font-semibold">
            Sign in
          </Link>
        </p>
      </div>
    </div>
  );
}
REGISTERPAGE

# Login Form Component
cat > components/auth/LoginForm.tsx << 'LOGINFORM'
"use client";

import { useState } from "react";
import { signIn } from "next-auth/react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";

export default function LoginForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      const result = await signIn("credentials", {
        email: formData.email,
        password: formData.password,
        redirect: false,
      });

      if (result?.error) {
        toast.error("Invalid email or password");
      } else {
        toast.success("Logged in successfully!");
        router.push("/dashboard/notes");
        router.refresh();
      }
    } catch (error) {
      toast.error("An error occurred. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleOAuthSignIn = async (provider: "google" | "github") => {
    try {
      await signIn(provider, { callbackUrl: "/dashboard/notes" });
    } catch (error) {
      toast.error("Failed to sign in with " + provider);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Sign In</CardTitle>
        <CardDescription>Enter your credentials to access your account</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              placeholder="you@example.com"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              placeholder="••••••••"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "Signing in..." : "Sign In"}
          </Button>
        </form>

        <div className="mt-6">
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <span className="w-full border-t" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-background px-2 text-muted-foreground">
                Or continue with
              </span>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4 mt-6">
            <Button
              type="button"
              variant="outline"
              onClick={() => handleOAuthSignIn("google")}
              disabled={isLoading}
            >
              Google
            </Button>
            <Button
              type="button"
              variant="outline"
              onClick={() => handleOAuthSignIn("github")}
              disabled={isLoading}
            >
              GitHub
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
LOGINFORM

# Register Form Component
cat > components/auth/RegisterForm.tsx << 'REGISTERFORM'
"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { toast } from "sonner";

export default function RegisterForm() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
    confirmPassword: "",
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (formData.password !== formData.confirmPassword) {
      toast.error("Passwords do not match");
      return;
    }

    if (formData.password.length < 6) {
      toast.error("Password must be at least 6 characters");
      return;
    }

    setIsLoading(true);

    try {
      const response = await fetch("/api/auth/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: formData.name,
          email: formData.email,
          password: formData.password,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        toast.error(data.error || "Registration failed");
        return;
      }

      toast.success("Account created! Redirecting to login...");
      setTimeout(() => {
        router.push("/login");
      }, 1000);
    } catch (error) {
      toast.error("An error occurred. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle>Create Account</CardTitle>
        <CardDescription>Fill in your details to get started</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="name">Name</Label>
            <Input
              id="name"
              type="text"
              placeholder="John Doe"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              type="email"
              placeholder="you@example.com"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="password">Password</Label>
            <Input
              id="password"
              type="password"
              placeholder="••••••••"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="confirmPassword">Confirm Password</Label>
            <Input
              id="confirmPassword"
              type="password"
              placeholder="••••••••"
              value={formData.confirmPassword}
              onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
              required
              disabled={isLoading}
            />
          </div>

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "Creating account..." : "Create Account"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
REGISTERFORM

# ============================================
# PART 2: API ROUTES
# ============================================

echo -e "${GREEN}Creating API routes...${NC}"

# NextAuth API Route
cat > app/api/auth/[...nextauth]/route.ts << 'NEXTAUTHROUTE'
import { handlers } from "@/lib/auth";

export const { GET, POST } = handlers;
NEXTAUTHROUTE

# Register API Route
cat > app/api/auth/register/route.ts << 'REGISTERROUTE'
import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import bcrypt from "bcryptjs";

export async function POST(request: Request) {
  try {
    const { name, email, password } = await request.json();

    if (!name || !email || !password) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return NextResponse.json(
        { error: "User already exists" },
        { status: 400 }
      );
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    });

    return NextResponse.json(
      { message: "User created successfully", userId: user.id },
      { status: 201 }
    );
  } catch (error) {
    console.error("Registration error:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
REGISTERROUTE

# Notes API Routes
mkdir -p app/api/notes

cat > app/api/notes/route.ts << 'NOTESROUTE'
import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const archived = searchParams.get("archived") === "true";
    const favorites = searchParams.get("favorites") === "true";
    const search = searchParams.get("search");
    const tag = searchParams.get("tag");

    const where: any = {
      userId: session.user.id,
      isArchived: archived,
    };

    if (favorites) {
      where.isFavorite = true;
    }

    if (search) {
      where.OR = [
        { title: { contains: search, mode: "insensitive" } },
        { content: { contains: search, mode: "insensitive" } },
      ];
    }

    if (tag) {
      where.tags = { has: tag };
    }

    const notes = await prisma.note.findMany({
      where,
      orderBy: { updatedAt: "desc" },
      include: {
        _count: {
          select: { versions: true },
        },
      },
    });

    return NextResponse.json(notes);
  } catch (error) {
    console.error("Error fetching notes:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { title, content, tags } = await request.json();

    if (!title || !content) {
      return NextResponse.json(
        { error: "Title and content are required" },
        { status: 400 }
      );
    }

    const note = await prisma.note.create({
      data: {
        title,
        content,
        tags: tags || [],
        userId: session.user.id,
      },
    });

    return NextResponse.json(note, { status: 201 });
  } catch (error) {
    console.error("Error creating note:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
NOTESROUTE

# Individual Note API Routes
mkdir -p app/api/notes/[id]

cat > app/api/notes/[id]/route.ts << 'NOTEIDROUTE'
import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const note = await prisma.note.findFirst({
      where: {
        id: params.id,
        userId: session.user.id,
      },
      include: {
        versions: {
          orderBy: { createdAt: "desc" },
          take: 10,
        },
      },
    });

    if (!note) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 });
    }

    return NextResponse.json(note);
  } catch (error) {
    console.error("Error fetching note:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function PUT(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { title, content, tags } = await request.json();

    const existingNote = await prisma.note.findFirst({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    if (!existingNote) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 });
    }

    // Create version history
    await prisma.noteVersion.create({
      data: {
        noteId: params.id,
        title: existingNote.title,
        content: existingNote.content,
      },
    });

    const note = await prisma.note.update({
      where: { id: params.id },
      data: {
        title,
        content,
        tags: tags || existingNote.tags,
      },
    });

    return NextResponse.json(note);
  } catch (error) {
    console.error("Error updating note:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const note = await prisma.note.findFirst({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    if (!note) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 });
    }

    await prisma.note.delete({
      where: { id: params.id },
    });

    return NextResponse.json({ message: "Note deleted" });
  } catch (error) {
    console.error("Error deleting note:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
NOTEIDROUTE

# Favorite/Archive Routes
mkdir -p app/api/notes/[id]/favorite
mkdir -p app/api/notes/[id]/archive

cat > app/api/notes/[id]/favorite/route.ts << 'FAVORITEROUTE'
import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function PATCH(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const note = await prisma.note.findFirst({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    if (!note) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 });
    }

    const updatedNote = await prisma.note.update({
      where: { id: params.id },
      data: { isFavorite: !note.isFavorite },
    });

    return NextResponse.json(updatedNote);
  } catch (error) {
    console.error("Error toggling favorite:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
FAVORITEROUTE

cat > app/api/notes/[id]/archive/route.ts << 'ARCHIVEROUTE'
import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { prisma } from "@/lib/prisma";

export async function PATCH(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const note = await prisma.note.findFirst({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    if (!note) {
      return NextResponse.json({ error: "Note not found" }, { status: 404 });
    }

    const updatedNote = await prisma.note.update({
      where: { id: params.id },
      data: { isArchived: !note.isArchived },
    });

    return NextResponse.json(updatedNote);
  } catch (error) {
    console.error("Error toggling archive:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
ARCHIVEROUTE

echo -e "${GREEN}✅ Part 1 & 2 Complete: Auth components and API routes created${NC}\n"
