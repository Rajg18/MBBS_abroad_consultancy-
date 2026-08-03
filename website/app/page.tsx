import { getColleges, getCountries } from "@/lib/api";
import { getAllPosts } from "@/lib/blog";
import { HeroSection } from "@/components/home/hero-section";
import { CountriesStrip } from "@/components/home/countries-strip";
import { TrustSection } from "@/components/home/trust-section";
import { ProcessSection } from "@/components/home/process-section";
import { FeaturedColleges } from "@/components/home/featured-colleges";
import { BlogTeaser } from "@/components/home/blog-teaser";
import { CtaBanner } from "@/components/home/cta-banner";

export default async function Home() {
  const [countries, colleges] = await Promise.all([getCountries(), getColleges()]);
  const posts = getAllPosts();

  // One open college per country, diversified rather than the first N rows,
  // capped to a showcase-sized set.
  const seenCountries = new Set<string>();
  const featured = colleges
    .filter((c) => c.admissionOpen)
    .filter((c) => {
      if (seenCountries.has(c.country)) return false;
      seenCountries.add(c.country);
      return true;
    })
    .slice(0, 6);

  return (
    <>
      <HeroSection collegeCount={colleges.length} />
      <CountriesStrip countries={countries} />
      <TrustSection />
      <ProcessSection />
      <FeaturedColleges colleges={featured} />
      <BlogTeaser posts={posts} />
      <CtaBanner />
    </>
  );
}
