# AI-Powered Notes App

A modern note-taking application built with Next.js 15 featuring AI-powered tools for summarization, translation, grammar checking, and intelligent writing assistance.

## Features

### Core Features
- User authentication with email/password and OAuth
- Create, edit, delete, and organize notes
- Favorite and archive notes
- Custom tags and search
- Version history tracking

### AI Features
- AI Summarization (short, medium, long)
- Auto-generate tags
- Writing Assistant (improve, expand, shorten, rephrase)
- Translation (Spanish, French, German, Japanese)
- Grammar and spelling check
- Sentiment analysis

## Tech Stack

- Next.js 15
- TypeScript
- PostgreSQL
- Prisma ORM
- NextAuth.js v5
- OpenAI GPT-3.5
- Tailwind CSS
- shadcn/ui

## Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL
- OpenAI API key

### Setup

Clone and install:

    git clone https://github.com/mgrandusky/notes-app-nextjs.git
    cd notes-app-nextjs
    npm install

Create .env file:

    DATABASE_URL="postgresql://postgres:postgres@localhost:5433/notes_nextjs"
    NEXTAUTH_URL="http://localhost:3000"
    NEXTAUTH_SECRET="your-secret-here"
    OPENAI_API_KEY="sk-your-key-here"

Run migrations:

    npm run prisma:migrate

Start dev server:

    npm run dev

Open http://localhost:3000

## Environment Variables

- DATABASE_URL - PostgreSQL connection string
- NEXTAUTH_URL - Application URL
- NEXTAUTH_SECRET - Auth secret (32+ characters)
- OPENAI_API_KEY - OpenAI API key

## Scripts

- npm run dev - Development server
- npm run build - Build for production
- npm run start - Start production server
- npm run prisma:migrate - Run database migrations
- npm run prisma:studio - Open database GUI

## Project Structure

    app/
      api/
        ai/           - AI feature endpoints
        auth/         - Authentication
        notes/        - Note operations
      dashboard/      - Dashboard pages
      login/          - Login page
      register/       - Registration page
    components/
      ai/             - AI tools
      auth/           - Auth forms
      notes/          - Note components
      ui/             - UI components
    lib/
      auth.ts         - NextAuth config
      openai.ts       - OpenAI client
      prisma.ts       - Prisma client
    prisma/
      schema.prisma   - Database schema

## Deployment

Deploy to Vercel:

1. Push to GitHub
2. Import to Vercel
3. Add environment variables
4. Deploy

Database options: Vercel Postgres, Supabase, Railway, or Neon

## License

MIT

## Author

Mason Grandusky
- GitHub: @mgrandusky

## Acknowledgments

Built with Next.js, OpenAI, Prisma, NextAuth.js, Tailwind CSS, and shadcn/ui
