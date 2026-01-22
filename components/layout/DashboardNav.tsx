"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Button } from "@/components/ui/button";
import { signOut } from "next-auth/react";
import { 
  FileText, 
  Archive, 
  Star, 
  LogOut, 
  Plus,
  Moon,
  Sun
} from "lucide-react";
import { useTheme } from "next-themes";
import { cn } from "@/lib/utils";

interface DashboardNavProps {
  user: any;
}

export default function DashboardNav({ user }: DashboardNavProps) {
  const pathname = usePathname();
  const { theme, setTheme } = useTheme();

  const navItems = [
    { href: "/dashboard/notes", label: "Notes", icon: FileText },
    { href: "/dashboard/notes?favorites=true", label: "Favorites", icon: Star },
    { href: "/dashboard/archived", label: "Archived", icon: Archive },
  ];

  return (
    <nav className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex items-center space-x-8">
            <Link href="/dashboard/notes" className="flex items-center">
              <h1 className="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
                Notes App
              </h1>
            </Link>
            
            <div className="hidden md:flex space-x-4">
              {navItems.map((item) => {
                const Icon = item.icon;
                const isActive = pathname === item.href || pathname.startsWith(item.href);
                
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    className={cn(
                      "flex items-center gap-2 px-3 py-2 rounded-md text-sm font-medium transition-colors",
                      isActive
                        ? "bg-blue-100 text-blue-700 dark:bg-blue-900 dark:text-blue-200"
                        : "text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-700"
                    )}
                  >
                    <Icon className="w-4 h-4" />
                    {item.label}
                  </Link>
                );
              })}
            </div>
          </div>

          <div className="flex items-center space-x-4">
            <Link href="/dashboard/notes/new">
              <Button size="sm" className="flex items-center gap-2">
                <Plus className="w-4 h-4" />
                New Note
              </Button>
            </Link>

            <Button
              variant="ghost"
              size="icon"
              onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            >
              {theme === "dark" ? (
                <Sun className="w-5 h-5" />
              ) : (
                <Moon className="w-5 h-5" />
              )}
            </Button>

            <div className="flex items-center gap-3">
              <span className="text-sm text-gray-700 dark:text-gray-300">
                {user?.name || user?.email}
              </span>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => signOut({ callbackUrl: "/" })}
              >
                <LogOut className="w-5 h-5" />
              </Button>
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
