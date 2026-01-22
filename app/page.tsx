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
