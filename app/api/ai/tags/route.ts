import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { title, content } = await request.json();

    if (!title || !content) {
      return NextResponse.json(
        { error: "Title and content are required" },
        { status: 400 }
      );
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a helpful assistant that generates relevant tags for notes. Return only a comma-separated list of 3-5 tags, no explanation.",
        },
        {
          role: "user",
          content: `Generate relevant tags for this note:\n\nTitle: ${title}\n\nContent: ${content}`,
        },
      ],
      temperature: 0.5,
      max_tokens: 100,
    });

    const tagsString = completion.choices[0].message.content || "";
    const tags = tagsString.split(",").map((tag) => tag.trim()).filter(Boolean);

    return NextResponse.json({ tags });
  } catch (error: any) {
    console.error("Tags generation error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to generate tags" },
      { status: 500 }
    );
  }
}
