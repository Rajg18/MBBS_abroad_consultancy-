import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { MDXRemote } from "next-mdx-remote/rsc";
import { getAllPosts, getPostBySlug } from "@/lib/blog";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { APPLY_URL, SITE_URL } from "@/lib/site-config";

export function generateStaticParams() {
  return getAllPosts().map((post) => ({ slug: post.slug }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const post = getPostBySlug(slug);
  if (!post) return {};

  return {
    title: post.title,
    description: post.description,
    alternates: { canonical: `${SITE_URL}/blog/${post.slug}` },
  };
}

function formatDate(date: string) {
  return new Date(date).toLocaleDateString("en-IN", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
}

export default async function BlogPostPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const post = getPostBySlug(slug);
  if (!post) notFound();

  const related = getAllPosts()
    .filter((p) => p.slug !== post.slug)
    .slice(0, 2);

  const articleJsonLd = {
    "@context": "https://schema.org",
    "@type": "BlogPosting",
    headline: post.title,
    description: post.description,
    datePublished: post.date,
    dateModified: post.updatedAt ?? post.date,
    author: { "@type": "Organization", name: post.author },
  };

  return (
    <div className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(articleJsonLd) }}
      />

      <PageBreadcrumb items={[{ label: "Blog", href: "/blog" }, { label: post.title }]} />

      <div className="mt-4 flex flex-wrap items-center gap-2">
        <Badge variant="secondary">{post.category}</Badge>
        <span className="text-xs text-muted-foreground">
          {formatDate(post.date)} · {post.author}
        </span>
      </div>

      <h1 className="mt-3 text-3xl font-bold text-foreground sm:text-4xl">{post.title}</h1>

      <article className="prose prose-neutral mt-8 max-w-none prose-headings:font-bold prose-headings:text-foreground prose-a:text-primary prose-strong:text-foreground">
        <MDXRemote source={post.content} />
      </article>

      <div className="mt-10 flex flex-wrap gap-2">
        {post.tags.map((tag) => (
          <Badge key={tag} variant="outline" className="text-muted-foreground">
            #{tag}
          </Badge>
        ))}
      </div>

      <div className="mt-10 flex flex-col items-center gap-3 rounded-xl bg-primary p-6 text-center text-white sm:flex-row sm:justify-between sm:text-left">
        <p className="font-semibold">Ready to start your own application?</p>
        <Button asChild className="bg-accent text-primary-dark hover:bg-accent-dark">
          <Link href={APPLY_URL}>Go to Application</Link>
        </Button>
      </div>

      {related.length > 0 && (
        <div className="mt-14">
          <h2 className="text-xl font-bold text-foreground">More from the blog</h2>
          <div className="mt-4 grid gap-4 sm:grid-cols-2">
            {related.map((p) => (
              <Link
                key={p.slug}
                href={`/blog/${p.slug}`}
                className="rounded-xl border border-border bg-card p-5 transition-shadow hover:shadow-md"
              >
                <p className="font-semibold text-foreground">{p.title}</p>
                <p className="mt-1 text-sm text-muted-foreground">{p.description}</p>
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
