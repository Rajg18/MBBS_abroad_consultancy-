import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { Post } from "@/lib/blog";

export function BlogTeaser({ posts }: { posts: Post[] }) {
  if (posts.length === 0) return null;

  return (
    <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <div className="flex items-end justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold text-foreground sm:text-3xl">From the blog</h2>
          <p className="mt-2 text-muted-foreground">
            Practical guidance on eligibility, country selection, and getting your documents ready.
          </p>
        </div>
        <Link
          href="/blog"
          className="hidden shrink-0 text-sm font-semibold text-primary hover:underline sm:block"
        >
          Read the blog →
        </Link>
      </div>

      <div className="mt-8 grid gap-4 sm:grid-cols-3">
        {posts.slice(0, 3).map((post) => (
          <Link key={post.slug} href={`/blog/${post.slug}`}>
            <Card className="h-full transition-shadow hover:shadow-md">
              <CardContent className="p-5">
                <Badge variant="secondary">{post.category}</Badge>
                <p className="mt-3 font-semibold text-foreground">{post.title}</p>
                <p className="mt-2 text-sm text-muted-foreground">{post.description}</p>
              </CardContent>
            </Card>
          </Link>
        ))}
      </div>

      <Link
        href="/blog"
        className="mt-6 block text-center text-sm font-semibold text-primary hover:underline sm:hidden"
      >
        Read the blog →
      </Link>
    </section>
  );
}
