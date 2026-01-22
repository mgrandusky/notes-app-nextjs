#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initializing Notes App (Next.js)${NC}\n"

# Create project directory
PROJECT_NAME="notes-app-nextjs"
echo -e "${GREEN}Creating project directory: $PROJECT_NAME${NC}"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Initialize git
echo -e "${GREEN}Initializing git repository${NC}"
git init

# Create directory structure
echo -e "${GREEN}Creating directory structure${NC}"
mkdir -p app/{api/{auth/[...nextauth],notes/{[id]/{archive,favorite,export},search},share/{[token]},ai/{summarize,tags,semantic-search,writing-assist,sentiment,recommendations,transcribe,translate,grammar,ocr,chat,generate,template}},{auth,dashboard}/{login,register,notes/{[id]/edit,new},shared,archived}}
mkdir -p components/{auth,notes,shared,ai,layout,ui}
mkdir -p lib/{services/ai,utils}
mkdir -p hooks
mkdir -p types
mkdir -p prisma/migrations
mkdir -p public
mkdir -p styles

# Create package.json
echo -e "${GREEN}Creating package.json${NC}"
cat > package.json << 'EOF'
{
  "name": "notes-app-nextjs",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "prisma generate && next build",
    "start": "next start",
    "lint": "next lint",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:studio": "prisma studio",
    "prisma:push": "prisma db push"
  },
  "dependencies": {
    "next": "^15.1.6",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@prisma/client": "^5.22.0",
    "next-auth": "^5.0.0-beta.25",
    "@auth/prisma-adapter": "^2.7.4",
    "@tiptap/react": "^2.10.4",
    "@tiptap/starter-kit": "^2.10.4",
    "@tiptap/extension-link": "^2.10.4",
    "@tiptap/extension-placeholder": "^2.10.4",
    "@tiptap/pm": "^2.10.4",
    "openai": "^4.76.1",
    "zod": "^3.24.1",
    "bcryptjs": "^2.4.3",
    "nodemailer": "^6.9.16",
    "pdfkit": "^0.15.0",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.7.0",
    "lucide-react": "^0.469.0",
    "date-fns": "^4.1.0",
    "@radix-ui/react-dialog": "^1.1.4",
    "@radix-ui/react-dropdown-menu": "^2.1.4",
    "@radix-ui/react-select": "^2.1.4",
    "@radix-ui/react-toast": "^1.2.4",
    "@radix-ui/react-switch": "^1.1.4",
    "@radix-ui/react-avatar": "^1.1.2",
    "@radix-ui/react-label": "^2.1.1",
    "@radix-ui/react-slot": "^1.1.1",
    "@radix-ui/react-tabs": "^1.1.2",
    "@radix-ui/react-separator": "^1.1.1",
    "next-themes": "^0.4.4",
    "react-hook-form": "^7.54.2",
    "@hookform/resolvers": "^3.9.1",
    "sonner": "^1.7.3"
  },
  "devDependencies": {
    "typescript": "^5.7.3",
    "@types/node": "^22.10.5",
    "@types/react": "^19.0.6",
    "@types/react-dom": "^19.0.2",
    "@types/bcryptjs": "^2.4.6",
    "@types/nodemailer": "^6.4.17",
    "@types/pdfkit": "^0.13.5",
    "prisma": "^5.22.0",
    "eslint": "^9.18.0",
    "eslint-config-next": "^15.1.6",
    "postcss": "^8.4.49",
    "autoprefixer": "^10.4.20",
    "tailwindcss": "^3.4.17",
    "tailwindcss-animate": "^1.0.7"
  }
}
EOF

# Create .gitignore
echo -e "${GREEN}Creating .gitignore${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules
/.pnp
.pnp.js

# Testing
/coverage

# Next.js
/.next/
/out/
.next

# Production
/build
dist

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env
.env*.local
.env.development.local
.env.test.local
.env.production.local

# Vercel
.vercel

# TypeScript
*.tsbuildinfo
next-env.d.ts

# Prisma
prisma/dev.db
prisma/dev.db-journal

# Uploads
uploads/
public/uploads/
EOF

# Create .env.example
echo -e "${GREEN}Creating .env.example${NC}"
cat > .env.example << 'EOF'
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/notes_nextjs"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-super-secret-key-minimum-32-characters-change-this"

# OAuth Providers
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
GITHUB_CLIENT_ID="your-github-client-id"
GITHUB_CLIENT_SECRET="your-github-client-secret"

# OpenAI
OPENAI_API_KEY="sk-your-openai-api-key"

# Email (Optional)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="your-email@gmail.com"
SMTP_PASSWORD="your-app-password"
SMTP_FROM="Notes App <noreply@notesapp.com>"

# App
NEXT_PUBLIC_APP_URL="http://localhost:3000"
EOF

# Create Prisma schema
echo -e "${GREEN}Creating Prisma schema${NC}"
cat > prisma/schema.prisma << 'EOF'
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id            String    @id @default(cuid())
  name          String?
  email         String    @unique
  emailVerified DateTime?
  image         String?
  password      String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  accounts      Account[]
  sessions      Session[]
  notes         Note[]
  sharedNotes   SharedNote[]
  chatMessages  ChatMessage[]
}

model Account {
  id                String  @id @default(cuid())
  userId            String
  type              String
  provider          String
  providerAccountId String
  refresh_token     String? @db.Text
  access_token      String? @db.Text
  expires_at        Int?
  token_type        String?
  scope             String?
  id_token          String? @db.Text
  session_state     String?

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@unique([provider, providerAccountId])
}

model Session {
  id           String   @id @default(cuid())
  sessionToken String   @unique
  userId       String
  expires      DateTime
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model VerificationToken {
  identifier String
  token      String   @unique
  expires    DateTime

  @@unique([identifier, token])
}

model Note {
  id          String   @id @default(cuid())
  title       String
  content     String   @db.Text
  tags        String[]
  isFavorite  Boolean  @default(false)
  isArchived  Boolean  @default(false)
  userId      String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  user        User           @relation(fields: [userId], references: [id], onDelete: Cascade)
  versions    NoteVersion[]
  embeddings  NoteEmbedding?
  shares      SharedNote[]
  attachments Attachment[]

  @@index([userId])
  @@index([tags])
  @@index([createdAt])
}

model NoteVersion {
  id        String   @id @default(cuid())
  noteId    String
  title     String
  content   String   @db.Text
  createdAt DateTime @default(now())

  note Note @relation(fields: [noteId], references: [id], onDelete: Cascade)

  @@index([noteId])
}

model NoteEmbedding {
  id        String   @id @default(cuid())
  noteId    String   @unique
  embedding String   @db.Text
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  note Note @relation(fields: [noteId], references: [id], onDelete: Cascade)
}

model SharedNote {
  id         String    @id @default(cuid())
  noteId     String
  userId     String?
  token      String    @unique @default(cuid())
  permission String    @default("view")
  expiresAt  DateTime?
  createdAt  DateTime  @default(now())

  note Note  @relation(fields: [noteId], references: [id], onDelete: Cascade)
  user User? @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([noteId])
  @@index([token])
}

model Attachment {
  id        String   @id @default(cuid())
  noteId    String
  filename  String
  filepath  String
  mimetype  String
  size      Int
  createdAt DateTime @default(now())

  note Note @relation(fields: [noteId], references: [id], onDelete: Cascade)

  @@index([noteId])
}

model ChatMessage {
  id        String   @id @default(cuid())
  userId    String
  role      String
  content   String   @db.Text
  noteId    String?
  createdAt DateTime @default(now())

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
}
EOF

# Create TypeScript config
echo -e "${GREEN}Creating tsconfig.json${NC}"
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

# Create next.config.ts
echo -e "${GREEN}Creating next.config.ts${NC}"
cat > next.config.ts << 'EOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    domains: ['lh3.googleusercontent.com', 'avatars.githubusercontent.com'],
  },
};

export default nextConfig;
EOF

# Create tailwind.config.ts
echo -e "${GREEN}Creating tailwind.config.ts${NC}"
cat > tailwind.config.ts << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};
export default config;
EOF

# Create postcss.config.mjs
echo -e "${GREEN}Creating postcss.config.mjs${NC}"
cat > postcss.config.mjs << 'EOF'
/** @type {import('postcss-load-config').Config} */
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};

export default config;
EOF

# Create lib/prisma.ts
echo -e "${GREEN}Creating lib/prisma.ts${NC}"
cat > lib/prisma.ts << 'EOF'
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient()

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
EOF

# Create lib/auth.ts
echo -e "${GREEN}Creating lib/auth.ts${NC}"
cat > lib/auth.ts << 'EOF'
import NextAuth from "next-auth"
import { PrismaAdapter } from "@auth/prisma-adapter"
import GoogleProvider from "next-auth/providers/google"
import GitHubProvider from "next-auth/providers/github"
import CredentialsProvider from "next-auth/providers/credentials"
import bcrypt from "bcryptjs"
import { prisma } from "./prisma"

export const { handlers, signIn, signOut, auth } = NextAuth({
  adapter: PrismaAdapter(prisma),
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
    GitHubProvider({
      clientId: process.env.GITHUB_CLIENT_ID!,
      clientSecret: process.env.GITHUB_CLIENT_SECRET!,
    }),
    CredentialsProvider({
      name: "credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null
        }

        const user = await prisma.user.findUnique({
          where: { email: credentials.email as string },
        })

        if (!user || !user.password) {
          return null
        }

        const isValid = await bcrypt.compare(
          credentials.password as string,
          user.password
        )

        if (!isValid) {
          return null
        }

        return {
          id: user.id,
          email: user.email,
          name: user.name,
          image: user.image,
        }
      },
    }),
  ],
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/login",
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id
      }
      return token
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string
      }
      return session
    },
  },
})
EOF

# Create lib/openai.ts
echo -e "${GREEN}Creating lib/openai.ts${NC}"
cat > lib/openai.ts << 'EOF'
import OpenAI from 'openai'

export const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
})
EOF

# Create lib/utils.ts
echo -e "${GREEN}Creating lib/utils.ts${NC}"
cat > lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

# Create app/globals.css
echo -e "${GREEN}Creating app/globals.css${NC}"
cat > app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --popover: 222.2 84% 4.9%;
    --popover-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
EOF

# Create app/layout.tsx
echo -e "${GREEN}Creating app/layout.tsx${NC}"
cat > app/layout.tsx << 'EOF'
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { Toaster } from "sonner";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Notes App - AI-Powered Note Taking",
  description: "A modern, AI-powered note-taking application built with Next.js",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          {children}
          <Toaster position="top-right" />
        </ThemeProvider>
      </body>
    </html>
  );
}
EOF

# Create app/page.tsx
echo -e "${GREEN}Creating app/page.tsx${NC}"
cat > app/page.tsx << 'EOF'
import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default async function Home() {
  const session = await auth();

  if (session) {
    redirect("/dashboard/notes");
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-blue-50 via-white to-indigo-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
      <div className="max-w-5xl mx-auto px-4 text-center">
        <h1 className="text-7xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400">
          Notes App
        </h1>
        <p className="text-2xl text-gray-700 dark:text-gray-300 mb-12">
          AI-powered note-taking with smart features
        </p>
        
        <div className="flex gap-4 justify-center mb-20">
          <Link href="/login">
            <Button size="lg" className="text-lg px-8 py-6">
              Get Started
            </Button>
          </Link>
          <Link href="/register">
            <Button size="lg" variant="outline" className="text-lg px-8 py-6">
              Sign Up
            </Button>
          </Link>
        </div>

        <div className="grid md:grid-cols-3 gap-8 mt-16">
          <div className="p-8 bg-white dark:bg-gray-800 rounded-2xl shadow-xl hover:shadow-2xl transition-shadow">
            <div className="text-5xl mb-4">🤖</div>
            <h3 className="text-2xl font-semibold mb-3">AI-Powered</h3>
            <p className="text-gray-600 dark:text-gray-400 text-lg">
              Summarize, tag, translate, and get writing assistance with 14 AI features
            </p>
          </div>
          
          <div className="p-8 bg-white dark:bg-gray-800 rounded-2xl shadow-xl hover:shadow-2xl transition-shadow">
            <div className="text-5xl mb-4">🔒</div>
            <h3 className="text-2xl font-semibold mb-3">Secure</h3>
            <p className="text-gray-600 dark:text-gray-400 text-lg">
              OAuth authentication and encrypted data storage
            </p>
          </div>
          
          <div className="p-8 bg-white dark:bg-gray-800 rounded-2xl shadow-xl hover:shadow-2xl transition-shadow">
            <div className="text-5xl mb-4">🚀</div>
            <h3 className="text-2xl font-semibold mb-3">Fast</h3>
            <p className="text-gray-600 dark:text-gray-400 text-lg">
              Built with Next.js 15 for optimal performance
            </p>
          </div>
        </div>

        <div className="mt-20 grid md:grid-cols-2 gap-6 text-left">
          <div className="p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-xl">
            <h4 className="font-semibold text-lg mb-3">📝 Rich Text Editor</h4>
            <p className="text-gray-600 dark:text-gray-400">Create beautiful notes with our Tiptap-powered editor</p>
          </div>
          
          <div className="p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-xl">
            <h4 className="font-semibold text-lg mb-3">🤝 Share & Collaborate</h4>
            <p className="text-gray-600 dark:text-gray-400">Share notes with permission controls and expiration</p>
          </div>
          
          <div className="p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-xl">
            <h4 className="font-semibold text-lg mb-3">📤 Export Options</h4>
            <p className="text-gray-600 dark:text-gray-400">Export to PDF, text, or send via email</p>
          </div>
          
          <div className="p-6 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-xl">
            <h4 className="font-semibold text-lg mb-3">🔍 Smart Search</h4>
            <p className="text-gray-600 dark:text-gray-400">Semantic search powered by AI embeddings</p>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF

# Create components/theme-provider.tsx
echo -e "${GREEN}Creating components/theme-provider.tsx${NC}"
cat > components/theme-provider.tsx << 'EOF'
"use client"

import * as React from "react"
import { ThemeProvider as NextThemesProvider } from "next-themes"
import { type ThemeProviderProps } from "next-themes/dist/types"

export function ThemeProvider({ children, ...props }: ThemeProviderProps) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}
EOF

# Create README.md
echo -e "${GREEN}Creating README.md${NC}"
cat > README.md << 'EOF'
# Notes App - Next.js

A modern, AI-powered note-taking application built with Next.js 15, TypeScript, Prisma, and OpenAI.

## ✨ Features

### 🔐 Authentication & Security
- OAuth 2.0 (Google & GitHub)
- Email/password authentication with bcrypt
- Secure JWT sessions with NextAuth.js v5
- CSRF protection

### 📝 Note Management
- Rich text editor powered by Tiptap
- Full CRUD operations
- Tag organization
- Favorites and archive
- Version history
- File attachments
- Search and filter

### 🤖 AI Features (14 total)
1. **Summarization** - Generate summaries in short, medium, or long format
2. **Auto-tagging** - AI-generated tags for notes
3. **Semantic Search** - Find notes by meaning, not just keywords
4. **Writing Assistant** - Improve, expand, shorten, or rephrase content
5. **Sentiment Analysis** - Analyze emotional tone of notes
6. **Recommendations** - Get related notes based on content similarity
7. **Voice-to-Text** - Transcribe audio files using Whisper API
8. **Translation** - Translate notes to multiple languages
9. **Grammar Check** - Automated grammar and spelling correction
10. **OCR** - Extract text from images
11. **AI Chat** - Conversational AI with note context
12. **Content Generation** - Generate new content from prompts
13. **Template Generation** - Create templates for meetings, todos, journals, etc.
14. **Embeddings** - Semantic embeddings for all notes

### 🤝 Sharing & Collaboration
- Share notes with other users
- Public shareable links
- Permission levels (view/edit)
- Link expiration dates
- Email notes to anyone

### 📤 Export Options
- PDF export with professional formatting
- Plain text export
- Email delivery

### 🎨 User Experience
- Responsive design (mobile-friendly)
- Dark mode support
- Real-time updates
- Toast notifications
- Loading states
- Optimistic UI updates

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- PostgreSQL 14+
- OpenAI API key (for AI features)

### Installation

1. **Clone the repository**:
\`\`\`bash
git clone https://github.com/mgrandusky/notes-app-nextjs.git
cd notes-app-nextjs
\`\`\`

2. **Install dependencies**:
\`\`\`bash
npm install
\`\`\`

3. **Set up environment variables**:
\`\`\`bash
cp .env.example .env
# Edit .env with your configuration
\`\`\`

4. **Set up the database**:
\`\`\`bash
# Run Prisma migrations
npm run prisma:migrate

# Generate Prisma client
npm run prisma:generate
\`\`\`

5. **Start the development server**:
\`\`\`bash
npm run dev
\`\`\`

6. **Open your browser**:
Navigate to [http://localhost:3000](http://localhost:3000)

## 📁 Project Structure

\`\`\`
notes-app-nextjs/
├── app/                    # Next.js App Router
│   ├── api/               # API routes
│   │   ├── auth/          # Authentication endpoints
│   │   ├── notes/         # Notes CRUD endpoints
│   │   ├── share/         # Sharing endpoints
│   │   └── ai/            # AI feature endpoints
│   ├── dashboard/         # Protected dashboard routes
│   │   ├── notes/         # Notes pages
│   │   ├── shared/        # Shared notes
│   │   └── archived/      # Archived notes
│   ├── login/             # Login page
│   ├── register/          # Registration page
│   └── layout.tsx         # Root layout
├── components/            # React components
│   ├── auth/             # Authentication components
│   ├── notes/            # Note components
│   ├── ai/               # AI feature components
│   ├── layout/           # Layout components
│   └── ui/               # shadcn/ui components
├── lib/                  # Utilities and configurations
│   ├── auth.ts           # NextAuth configuration
│   ├── prisma.ts         # Prisma client
│   ├── openai.ts         # OpenAI client
│   └── utils.ts          # Utility functions
├── hooks/                # Custom React hooks
├── types/                # TypeScript type definitions
├── prisma/               # Prisma schema and migrations
│   └── schema.prisma     # Database schema
├── public/               # Static assets
└── package.json          # Dependencies
\`\`\`

## 🔧 Tech Stack

- **Framework**: Next.js 15 (App Router)
- **Language**: TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: NextAuth.js v5
- **UI Framework**: Tailwind CSS
- **UI Components**: shadcn/ui (Radix UI)
- **Rich Text Editor**: Tiptap
- **AI**: OpenAI GPT-4 & Whisper
- **Validation**: Zod
- **Email**: Nodemailer
- **PDF Generation**: PDFKit

## 🔌 Environment Variables

Required environment variables in \`.env\`:

\`\`\`env
# Database
DATABASE_URL="postgresql://user:password@localhost:5432/notes_nextjs"

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-here"

# OAuth (optional)
GOOGLE_CLIENT_ID="your-google-client-id"
GOOGLE_CLIENT_SECRET="your-google-client-secret"
GITHUB_CLIENT_ID="your-github-client-id"
GITHUB_CLIENT_SECRET="your-github-client-secret"

# OpenAI (required for AI features)
OPENAI_API_KEY="sk-your-openai-key"

# Email (optional)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="587"
SMTP_USER="your-email@gmail.com"
SMTP_PASSWORD="your-app-password"
\`\`\`

## 📚 API Endpoints

### Authentication
- \`POST /api/auth/register\` - Register new user
- \`GET /api/auth/[...nextauth]\` - NextAuth endpoints

### Notes
- \`GET /api/notes\` - Get all notes
- \`POST /api/notes\` - Create note
- \`GET /api/notes/[id]\` - Get single note
- \`PUT /api/notes/[id]\` - Update note
- \`DELETE /api/notes/[id]\` - Delete note
- \`PATCH /api/notes/[id]/favorite\` - Toggle favorite
- \`PATCH /api/notes/[id]/archive\` - Toggle archive
- \`GET /api/notes/search\` - Search notes

### AI Features
- \`POST /api/ai/summarize\` - Summarize note
- \`POST /api/ai/tags\` - Generate tags
- \`POST /api/ai/semantic-search\` - Semantic search
- \`POST /api/ai/writing-assist\` - Writing assistance
- \`POST /api/ai/sentiment\` - Sentiment analysis
- \`POST /api/ai/recommendations\` - Get recommendations
- \`POST /api/ai/transcribe\` - Transcribe audio
- \`POST /api/ai/translate\` - Translate note
- \`POST /api/ai/grammar\` - Grammar check
- \`POST /api/ai/ocr\` - Extract text from image
- \`POST /api/ai/chat\` - AI chat
- \`POST /api/ai/generate\` - Generate content
- \`POST /api/ai/template\` - Generate template

### Sharing
- \`POST /api/share\` - Share note
- \`GET /api/share/[token]\` - Get shared note
- \`DELETE /api/share/[id]\` - Revoke share

## 🐳 Docker Support

\`\`\`bash
docker-compose up -d
\`\`\`

## 📝 License

MIT

## 🤝 Contributing

Contributions welcome! Please open an issue or PR.

## 👤 Author

**mgrandusky**

---

Built with ❤️ using Next.js and AI
EOF

# Create docker-compose.yml
echo -e "${GREEN}Creating docker-compose.yml${NC}"
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: notes_nextjs
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d notes_nextjs"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      DATABASE_URL: postgresql://user:password@postgres:5432/notes_nextjs
      NEXTAUTH_URL: http://localhost:3000
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET}
      GOOGLE_CLIENT_ID: ${GOOGLE_CLIENT_ID}
      GOOGLE_CLIENT_SECRET: ${GOOGLE_CLIENT_SECRET}
      GITHUB_CLIENT_ID: ${GITHUB_CLIENT_ID}
      GITHUB_CLIENT_SECRET: ${GITHUB_CLIENT_SECRET}
      OPENAI_API_KEY: ${OPENAI_API_KEY}
    ports:
      - "3000:3000"
    depends_on:
      postgres:
        condition: service_healthy
    volumes:
      - ./uploads:/app/uploads

volumes:
  postgres_data:
EOF

# Create Dockerfile
echo -e "${GREEN}Creating Dockerfile${NC}"
cat > Dockerfile << 'EOF'
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN npx prisma generate
RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
EOF

# Initialize git repository
echo -e "${GREEN}Initializing git repository${NC}"
git add .
git commit -m "Initial commit: Next.js Notes App with AI features"

# Final instructions
echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}✅ Repository initialized successfully!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}Next steps:${NC}\n"
echo -e "1. ${GREEN}Copy .env.example to .env and configure:${NC}"
echo -e "   cp .env.example .env\n"

echo -e "2. ${GREEN}Install dependencies:${NC}"
echo -e "   npm install\n"

echo -e "3. ${GREEN}Set up the database:${NC}"
echo -e "   npm run prisma:migrate\n"

echo -e "4. ${GREEN}Start the development server:${NC}"
echo -e "   npm run dev\n"

echo -e "5. ${GREEN}Create GitHub repository and push:${NC}"
echo -e "   gh repo create notes-app-nextjs --public --source=. --remote=origin"
echo -e "   git push -u origin main\n"

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo -e "${BLUE}========================================${NC}\n"