import type { Metadata } from "next";
import Link from "next/link";
import { getAllPosts } from "@/lib/blog";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export const metadata: Metadata = {
  title: "Blog — MBBS Abroad Guidance",
  description:
    "Practical guidance on MBBS abroad admissions — NEET eligibility, choosing a country, document checklists, and more.",
};

function formatDate(date: string) {
  return new Date(date).toLocaleDateString("en-IN", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

export default function BlogIndexPage() {
  const posts = getAllPosts();

  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "Blog" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">Blog</h1>
      <p className="mt-3 max-w-2xl text-muted-foreground">
        Practical guidance on MBBS-abroad admissions — eligibility, choosing a country, and what
        to prepare before you apply.
      </p>

      <div className="mt-8 space-y-4">
        {posts.map((post) => (
          <Link key={post.slug} href={`/blog/${post.slug}`}>
            <Card className="transition-shadow hover:shadow-md">
              <CardContent className="p-6">
                <div className="flex flex-wrap items-center gap-2">
                  <Badge variant="secondary">{post.category}</Badge>
                  <span className="text-xs text-muted-foreground">{formatDate(post.date)}</span>
                </div>
                <p className="mt-3 text-lg font-semibold text-foreground">{post.title}</p>
                <p className="mt-2 text-sm text-muted-foreground">{post.description}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>
    </div>
  );
}
