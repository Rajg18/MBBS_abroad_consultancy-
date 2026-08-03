import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Link from "next/link";
import { getColleges } from "@/lib/api";
import { collegeDescription } from "@/lib/college-content";
import { slugify } from "@/lib/slug";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { CollegeCard } from "@/components/colleges/college-card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { APPLY_URL, SITE_URL } from "@/lib/site-config";

export async function generateStaticParams() {
  const colleges = await getColleges();
  return colleges.map((c) => ({ id: c.id }));
}

async function findCollege(id: string) {
  const colleges = await getColleges();
  return colleges.find((c) => c.id === id);
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const college = await findCollege(id);
  if (!college) return {};

  const title = `${college.name} — MBBS Admission 2026`;
  const description = collegeDescription(college).slice(0, 155);

  return {
    title,
    description,
    alternates: { canonical: `${SITE_URL}/colleges/${college.id}` },
  };
}

export default async function CollegeDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const [college, allColleges] = await Promise.all([findCollege(id), getColleges()]);
  if (!college) notFound();

  const related = allColleges
    .filter((c) => c.country === college.country && c.id !== college.id)
    .slice(0, 3);

  const courseJsonLd = {
    "@context": "https://schema.org",
    "@type": "Course",
    name: `${college.program} — ${college.name}`,
    description: collegeDescription(college),
    provider: {
      "@type": "EducationalOrganization",
      name: college.name,
      address: college.country,
    },
    ...(college.durationYears
      ? { timeRequired: `P${college.durationYears}Y` }
      : {}),
    ...(college.feesPerYearUsd
      ? {
          offers: {
            "@type": "Offer",
            price: college.feesPerYearUsd,
            priceCurrency: "USD",
            category: "per year",
          },
        }
      : {}),
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-10 sm:px-6">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(courseJsonLd) }}
      />

      <PageBreadcrumb
        items={[
          { label: "Colleges", href: "/colleges" },
          { label: college.country, href: `/countries/${slugify(college.country)}` },
          { label: college.name },
        ]}
      />

      <div className="mt-4 flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-foreground sm:text-4xl">{college.name}</h1>
          <p className="mt-2 text-muted-foreground">
            {college.country} · {college.program} · {college.level}
          </p>
        </div>
        <Badge
          className={
            college.admissionOpen
              ? "bg-accent-tint text-accent-dark"
              : "text-muted-foreground"
          }
          variant={college.admissionOpen ? "default" : "outline"}
        >
          {college.admissionOpen ? "Admissions Open" : "Admissions Closed"}
        </Badge>
      </div>

      <div className="mt-8 grid gap-8 lg:grid-cols-[2fr_1fr]">
        <div>
          <div className="grid grid-cols-3 gap-3 rounded-xl border border-border bg-card p-4 text-center">
            <div>
              <p className="text-xs uppercase tracking-wide text-muted-foreground">Fees / year</p>
              <p className="mt-1 font-semibold text-foreground">
                {college.feesPerYearUsd ? `$${college.feesPerYearUsd.toLocaleString()}` : "On request"}
              </p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-muted-foreground">Duration</p>
              <p className="mt-1 font-semibold text-foreground">
                {college.durationYears ? `${college.durationYears} years` : "6 years"}
              </p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wide text-muted-foreground">Intake</p>
              <p className="mt-1 font-semibold text-foreground">{college.intake}</p>
            </div>
          </div>

          <div className="mt-8">
            <h2 className="text-xl font-bold text-foreground">About {college.name}</h2>
            <p className="mt-3 text-muted-foreground">{collegeDescription(college)}</p>
          </div>

          {college.highlights.length > 0 && (
            <div className="mt-8">
              <h2 className="text-xl font-bold text-foreground">Highlights</h2>
              <ul className="mt-3 space-y-2">
                {college.highlights.map((h) => (
                  <li key={h} className="flex gap-2 text-muted-foreground">
                    <span className="text-accent-dark">•</span>
                    <span>{h}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </div>

        <aside className="h-fit rounded-xl border border-border bg-card p-6">
          <p className="font-semibold text-foreground">Ready to apply?</p>
          <p className="mt-2 text-sm text-muted-foreground">
            Start your application and our team will guide you through {college.name}&apos;s
            requirements step by step.
          </p>
          <Button
            asChild
            className="mt-4 w-full bg-accent text-primary-dark hover:bg-accent-dark"
          >
            <Link href={APPLY_URL}>Go to Application</Link>
          </Button>
        </aside>
      </div>

      {related.length > 0 && (
        <div className="mt-14">
          <h2 className="text-xl font-bold text-foreground">More colleges in {college.country}</h2>
          <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {related.map((c) => (
              <CollegeCard key={c.id} college={c} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
