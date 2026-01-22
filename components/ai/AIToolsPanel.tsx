"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { 
  Sparkles, 
  Tag, 
  Languages, 
  CheckCircle, 
  Wand2,
  TrendingUp
} from "lucide-react";
import { toast } from "sonner";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

interface AIToolsPanelProps {
  noteId?: string;
  content: string;
  onContentUpdate?: (newContent: string) => void;
  onTagsUpdate?: (tags: string[]) => void;
}

export default function AIToolsPanel({ 
  noteId, 
  content, 
  onContentUpdate,
  onTagsUpdate 
}: AIToolsPanelProps) {
  const [isLoading, setIsLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<string | null>(null);
  const [result, setResult] = useState<string>("");

  const handleSummarize = async (length: string) => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/summarize", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content, length }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to summarize");
      }

      setResult(data.summary);
      setActiveTab("result");
      toast.success("Summary generated!");
    } catch (error: any) {
      toast.error(error.message || "Failed to generate summary");
    } finally {
      setIsLoading(false);
    }
  };

  const handleGenerateTags = async () => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/tags", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ title: "Note", content }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to generate tags");
      }

      if (onTagsUpdate) {
        onTagsUpdate(data.tags);
      }
      toast.success("Tags generated!");
    } catch (error: any) {
      toast.error(error.message || "Failed to generate tags");
    } finally {
      setIsLoading(false);
    }
  };

  const handleWritingAssist = async (action: string) => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/writing-assist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content, action }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to process");
      }

      setResult(data.result);
      setActiveTab("result");
      toast.success("Content improved!");
    } catch (error: any) {
      toast.error(error.message || "Failed to improve content");
    } finally {
      setIsLoading(false);
    }
  };

  const handleTranslate = async (language: string) => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/translate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content, targetLanguage: language }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to translate");
      }

      setResult(data.translation);
      setActiveTab("result");
      toast.success("Translation complete!");
    } catch (error: any) {
      toast.error(error.message || "Failed to translate");
    } finally {
      setIsLoading(false);
    }
  };

  const handleGrammarCheck = async () => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/grammar", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to check grammar");
      }

      setResult(data.correctedText);
      setActiveTab("result");
      toast.success(`Found ${data.errorCount || 0} error(s)`);
    } catch (error: any) {
      toast.error(error.message || "Failed to check grammar");
    } finally {
      setIsLoading(false);
    }
  };

  const handleSentiment = async () => {
    setIsLoading(true);
    try {
      const response = await fetch("/api/ai/sentiment", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content }),
      });

      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || "Failed to analyze sentiment");
      }

      setResult(JSON.stringify(data, null, 2));
      setActiveTab("result");
      toast.success("Sentiment analyzed!");
    } catch (error: any) {
      toast.error(error.message || "Failed to analyze sentiment");
    } finally {
      setIsLoading(false);
    }
  };

  const applyResult = () => {
    if (onContentUpdate && result) {
      onContentUpdate(result);
      toast.success("Applied to note!");
      setResult("");
      setActiveTab(null);
    }
  };

  return (
    <Card className="p-6 space-y-6">
      <div>
        <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
          <Sparkles className="w-5 h-5 text-blue-500" />
          AI Tools
        </h3>

        <div className="space-y-4">
          <div>
            <Label className="text-sm font-medium mb-2 block">Summarize</Label>
            <div className="flex gap-2">
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleSummarize("short")}
                disabled={isLoading || !content}
              >
                Short
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleSummarize("medium")}
                disabled={isLoading || !content}
              >
                Medium
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleSummarize("long")}
                disabled={isLoading || !content}
              >
                Long
              </Button>
            </div>
          </div>

          <div>
            <Button
              size="sm"
              variant="outline"
              onClick={handleGenerateTags}
              disabled={isLoading || !content}
              className="w-full justify-start"
            >
              <Tag className="w-4 h-4 mr-2" />
              Generate Tags
            </Button>
          </div>

          <div>
            <Label className="text-sm font-medium mb-2 block">Writing Assistant</Label>
            <div className="grid grid-cols-2 gap-2">
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleWritingAssist("improve")}
                disabled={isLoading || !content}
              >
                <Wand2 className="w-4 h-4 mr-1" />
                Improve
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleWritingAssist("expand")}
                disabled={isLoading || !content}
              >
                Expand
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleWritingAssist("shorten")}
                disabled={isLoading || !content}
              >
                Shorten
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleWritingAssist("rephrase")}
                disabled={isLoading || !content}
              >
                Rephrase
              </Button>
            </div>
          </div>

          <div>
            <Label className="text-sm font-medium mb-2 block">Translate</Label>
            <div className="grid grid-cols-2 gap-2">
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleTranslate("Spanish")}
                disabled={isLoading || !content}
              >
                <Languages className="w-4 h-4 mr-1" />
                Spanish
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleTranslate("French")}
                disabled={isLoading || !content}
              >
                French
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleTranslate("German")}
                disabled={isLoading || !content}
              >
                German
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => handleTranslate("Japanese")}
                disabled={isLoading || !content}
              >
                Japanese
              </Button>
            </div>
          </div>

          <div>
            <Button
              size="sm"
              variant="outline"
              onClick={handleGrammarCheck}
              disabled={isLoading || !content}
              className="w-full justify-start"
            >
              <CheckCircle className="w-4 h-4 mr-2" />
              Grammar Check
            </Button>
          </div>

          <div>
            <Button
              size="sm"
              variant="outline"
              onClick={handleSentiment}
              disabled={isLoading || !content}
              className="w-full justify-start"
            >
              <TrendingUp className="w-4 h-4 mr-2" />
              Sentiment Analysis
            </Button>
          </div>
        </div>
      </div>

      {activeTab === "result" && result && (
        <div className="space-y-3">
          <Label className="text-sm font-medium">Result</Label>
          <Textarea
            value={result}
            onChange={(e) => setResult(e.target.value)}
            rows={8}
            className="font-mono text-sm"
          />
          <div className="flex gap-2">
            <Button onClick={applyResult} size="sm">
              Apply to Note
            </Button>
            <Button 
              onClick={() => {
                setResult("");
                setActiveTab(null);
              }} 
              variant="outline" 
              size="sm"
            >
              Cancel
            </Button>
          </div>
        </div>
      )}

      {isLoading && (
        <div className="text-center text-sm text-gray-500">
          Processing with AI...
        </div>
      )}
    </Card>
  );
}
