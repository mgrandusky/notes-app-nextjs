import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { content, targetLanguage } = await request.json();

    if (!content || !targetLanguage) {
      return NextResponse.json(
        { error: "Content and target language are required" },
        { status: 400 }
      );
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: `You are a professional translator. Translate the following text to ${targetLanguage}. Provide only the translation without explanations.`,
        },
        {
          role: "user",
          content: content,
        },
      ],
      temperature: 0.3,
      max_tokens: 2000,
    });

    const translation = completion.choices[0].message.content;

    return NextResponse.json({ translation });
  } catch (error: any) {
    console.error("Translation error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to translate" },
      { status: 500 }
    );
  }
}
