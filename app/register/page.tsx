import { auth } from "@/lib/auth";
import { redirect } from "next/navigation";
import RegisterForm from "@/components/auth/RegisterForm";
import Link from "next/link";

export default async function RegisterPage() {
  const session = await auth();
  
  if (session) {
    redirect("/dashboard/notes");
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-gray-800 p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold mb-2 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
            Create Account
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Start taking notes with AI
          </p>
        </div>
        
        <RegisterForm />
        
        <p className="text-center mt-6 text-sm text-gray-600 dark:text-gray-400">
          Already have an account?{" "}
          <Link href="/login" className="text-blue-600 hover:underline font-semibold">
            Sign in
          </Link>
        </p>
      </div>
    </div>
  );
}
