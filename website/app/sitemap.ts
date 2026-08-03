import type { MetadataRoute } from "next";
import { getColleges, getCountries } from "@/lib/api";
import { getAllPosts } from "@/lib/blog";
import { slugify } from "@/lib/slug";
import { SITE_URL } from "@/lib/site-config";

// Required for static export ("output: export") — resolves once at build time.
export const dynamic = "force-static";

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const [colleges, countries] = await Promise.all([getColleges(), getCountries()]);

  const staticRoutes = ["", "/countries", "/colleges", "/about", "/contact", "/apply", "/blog"].map(
    (path) => ({
      url: `${SITE_URL}${path}`,
      lastModified: new Date(),
    }),
  );

  const countryRoutes = countries.map((c) => ({
    url: `${SITE_URL}/countries/${slugify(c.name)}`,
    lastModified: new Date(),
  }));

  const collegeRoutes = colleges.map((c) => ({
    url: `${SITE_URL}/colleges/${c.id}`,
    lastModified: new Date(),
  }));

  const blogRoutes = getAllPosts().map((p) => ({
    url: `${SITE_URL}/blog/${p.slug}`,
    lastModified: p.updatedAt ?? p.date,
  }));

  return [...staticRoutes, ...countryRoutes, ...collegeRoutes, ...blogRoutes];
}
