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
