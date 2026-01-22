import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { content, action } = await request.json();

    if (!content || !action) {
      return NextResponse.json(
        { error: "Content and action are required" },
        { status: 400 }
      );
    }

    const actionPrompts = {
      improve: "Improve the writing quality, clarity, and flow of this text while keeping the same meaning:",
      expand: "Expand this text with more details, examples, and explanations:",
      shorten: "Make this text more concise while keeping the key points:",
      rephrase: "Rephrase this text in a different way while maintaining the same meaning:",
      professional: "Rewrite this text in a more professional and formal tone:",
      casual: "Rewrite this text in a more casual and friendly tone:",
    };

    const prompt = actionPrompts[action as keyof typeof actionPrompts];

    if (!prompt) {
      return NextResponse.json(
        { error: "Invalid action" },
        { status: 400 }
      );
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a helpful writing assistant. Provide only the improved text without explanations or meta-commentary.",
        },
        {
          role: "user",
          content: `${prompt}\n\n${content}`,
        },
      ],
      temperature: 0.7,
      max_tokens: 1000,
    });

    const result = completion.choices[0].message.content;

    return NextResponse.json({ result });
  } catch (error: any) {
    console.error("Writing assist error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to process writing assistance" },
      { status: 500 }
    );
  }
}
