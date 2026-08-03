import fs from "fs";
import path from "path";
import matter from "gray-matter";

const BLOG_DIR = path.join(process.cwd(), "content", "blog");

export type PostFrontmatter = {
  title: string;
  description: string;
  date: string;
  updatedAt?: string;
  author: string;
  category: string;
  tags: string[];
  coverImage?: string;
  draft?: boolean;
};

export type Post = PostFrontmatter & {
  slug: string;
  content: string;
};

function readPost(slug: string): Post {
  const filePath = path.join(BLOG_DIR, slug, "index.mdx");
  const raw = fs.readFileSync(filePath, "utf-8");
  const { data, content } = matter(raw);
  return { ...(data as PostFrontmatter), slug, content };
}

export function getAllPosts(): Post[] {
  if (!fs.existsSync(BLOG_DIR)) return [];
  const slugs = fs.readdirSync(BLOG_DIR).filter((entry) =>
    fs.existsSync(path.join(BLOG_DIR, entry, "index.mdx")),
  );
  return slugs
    .map(readPost)
    .filter((post) => process.env.NODE_ENV !== "production" || !post.draft)
    .sort((a, b) => (a.date < b.date ? 1 : -1));
}

export function getPostBySlug(slug: string): Post | undefined {
  try {
    return readPost(slug);
  } catch {
    return undefined;
  }
}
