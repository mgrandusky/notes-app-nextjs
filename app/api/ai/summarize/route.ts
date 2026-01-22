import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { content, length = "medium" } = await request.json();

    if (!content) {
      return NextResponse.json(
        { error: "Content is required" },
        { status: 400 }
      );
    }

    const lengthPrompts = {
      short: "in 2-3 sentences",
      medium: "in 1 paragraph (4-6 sentences)",
      long: "in 2-3 paragraphs with key points",
    };

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a helpful assistant that creates concise summaries.",
        },
        {
          role: "user",
          content: `Summarize the following text ${lengthPrompts[length as keyof typeof lengthPrompts]}:\n\n${content}`,
        },
      ],
      temperature: 0.7,
      max_tokens: 500,
    });

    const summary = completion.choices[0].message.content;

    return NextResponse.json({ summary });
  } catch (error: any) {
    console.error("Summarize error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to generate summary" },
      { status: 500 }
    );
  }
}
