import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";
import { prisma } from "@/lib/prisma";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { message, noteId, conversationHistory } = await request.json();

    if (!message) {
      return NextResponse.json(
        { error: "Message is required" },
        { status: 400 }
      );
    }

    // Get note context if noteId provided
    let context = "";
    if (noteId) {
      const note = await prisma.note.findFirst({
        where: { id: noteId, userId: session.user.id },
      });
      
      if (note) {
        context = `\n\nNote Context:\nTitle: ${note.title}\nContent: ${note.content}`;
      }
    }

    // Get user's recent notes for context
    const recentNotes = await prisma.note.findMany({
      where: { userId: session.user.id, isArchived: false },
      orderBy: { updatedAt: "desc" },
      take: 5,
      select: { title: true, tags: true },
    });

    const notesContext = recentNotes.length > 0
      ? `\n\nYour recent notes: ${recentNotes.map(n => `"${n.title}" (tags: ${n.tags.join(", ")})`).join(", ")}`
      : "";

    const messages: any[] = [
      {
        role: "system",
        content: `You are an intelligent AI assistant for a note-taking app. Your name is NotesAI. You help users:
- Answer questions about their notes
- Provide writing suggestions and tips
- Help organize and categorize notes
- Brainstorm ideas
- Explain concepts
- Summarize information
- Generate content

Be friendly, helpful, and concise. If asked about specific notes, refer to the context provided.${context}${notesContext}`,
      },
    ];

    // Add conversation history
    if (conversationHistory && Array.isArray(conversationHistory)) {
      messages.push(...conversationHistory);
    }

    // Add current message
    messages.push({
      role: "user",
      content: message,
    });

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages,
      temperature: 0.7,
      max_tokens: 1000,
    });

    const reply = completion.choices[0].message.content;

    // Save chat message to database
    await prisma.chatMessage.create({
      data: {
        userId: session.user.id,
        role: "user",
        content: message,
        noteId,
      },
    });

    await prisma.chatMessage.create({
      data: {
        userId: session.user.id,
        role: "assistant",
        content: reply || "",
        noteId,
      },
    });

    return NextResponse.json({ reply });
  } catch (error: any) {
    console.error("Chat error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to process chat" },
      { status: 500 }
    );
  }
}

// Get chat history
export async function GET(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const noteId = searchParams.get("noteId");
    const limit = parseInt(searchParams.get("limit") || "50");

    const where: any = {
      userId: session.user.id,
    };

    if (noteId) {
      where.noteId = noteId;
    }

    const messages = await prisma.chatMessage.findMany({
      where,
      orderBy: { createdAt: "asc" },
      take: limit,
    });

    return NextResponse.json({ messages });
  } catch (error: any) {
    console.error("Chat history error:", error);
    return NextResponse.json(
      { error: "Failed to fetch chat history" },
      { status: 500 }
    );
  }
}
