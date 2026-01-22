import { NextResponse } from "next/server";
import { auth } from "@/lib/auth";
import { openai } from "@/lib/openai";

export async function POST(request: Request) {
  try {
    const session = await auth();
    
    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { content } = await request.json();

    if (!content) {
      return NextResponse.json(
        { error: "Content is required" },
        { status: 400 }
      );
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: "You are a sentiment analysis assistant. Analyze the emotional tone and return a JSON object with: sentiment (positive/negative/neutral), confidence (0-1), emotions (array of detected emotions), and summary (brief explanation).",
        },
        {
          role: "user",
          content: `Analyze the sentiment of this text:\n\n${content}`,
        },
      ],
      temperature: 0.3,
      max_tokens: 300,
      response_format: { type: "json_object" },
    });

    const analysis = JSON.parse(completion.choices[0].message.content || "{}");

    return NextResponse.json(analysis);
  } catch (error: any) {
    console.error("Sentiment analysis error:", error);
    
    if (!process.env.OPENAI_API_KEY) {
      return NextResponse.json(
        { error: "OpenAI API key not configured" },
        { status: 500 }
      );
    }
    
    return NextResponse.json(
      { error: error.message || "Failed to analyze sentiment" },
      { status: 500 }
    );
  }
}
