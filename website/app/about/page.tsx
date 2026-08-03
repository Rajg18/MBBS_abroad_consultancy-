import type { Metadata } from "next";
import Link from "next/link";
import { getColleges, getCountries } from "@/lib/api";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { CONTACT } from "@/lib/site-config";

export const metadata: Metadata = {
  title: "About Us",
  description:
    "Sree Consultancy helps Indian students navigate MBBS admissions abroad — from choosing a country and college to submitting a complete, NMC-aware application.",
};

const WHY_US = [
  {
    title: "NMC-aware screening",
    body: "Every college in our directory is checked against National Medical Commission recognition status before it's listed — we don't add colleges we haven't screened.",
  },
  {
    title: "One guided flow, start to finish",
    body: "Country, then college, then documents, then review — the same structured process every applicant goes through, so nothing gets missed.",
  },
  {
    title: "Secure document handling",
    body: "Marksheets, NEET scorecards, and identity documents are collected through an encrypted upload flow, not over chat or email.",
  },
  {
    title: "A real person reviews every application",
    body: "Submissions don't just sit in a database — our team is notified immediately and follows up directly.",
  },
];

export default async function AboutPage() {
  const [colleges, countries] = await Promise.all([getColleges(), getCountries()]);

  const stats = [
    { value: `${countries.length}`, label: "Countries" },
    { value: `${colleges.length}`, label: "Colleges tracked" },
    { value: `${colleges.filter((c) => c.admissionOpen).length}`, label: "Open right now" },
  ];

  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "About" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">About Sree Consultancy</h1>
      <p className="mt-4 text-lg text-muted-foreground">
        We help Indian students find and apply to NMC-recognised MBBS colleges abroad — narrowing
        down countries and colleges, handling documents securely, and staying with each applicant
        from first look to submission.
      </p>

      <div className="mt-10 grid grid-cols-3 gap-4 rounded-xl border border-border bg-card p-6 text-center">
        {stats.map((s) => (
          <div key={s.label}>
            <p className="text-2xl font-bold text-primary sm:text-3xl">{s.value}</p>
            <p className="mt-1 text-xs text-muted-foreground sm:text-sm">{s.label}</p>
          </div>
        ))}
      </div>

      <div className="mt-14">
        <h2 className="text-xl font-bold text-foreground">Why students work with us</h2>
        <div className="mt-4 grid gap-4 sm:grid-cols-2">
          {WHY_US.map((item) => (
            <Card key={item.title}>
              <CardContent className="p-5">
                <p className="font-semibold text-foreground">{item.title}</p>
                <p className="mt-2 text-sm text-muted-foreground">{item.body}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      {/*
        PLACEHOLDER — replace with the real founder/team bio, credentials, and
        years of experience before launch. Left deliberately generic rather
        than inventing a name or track record.
      */}
      <div className="mt-14 rounded-xl border border-dashed border-border p-6">
        <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
          Our team — [placeholder, replace before launch]
        </p>
        <p className="mt-2 text-muted-foreground">
          Add a short founder/team bio here: background, years of experience guiding MBBS-abroad
          admissions, and any credentials or affiliations worth stating.
        </p>
      </div>

      <div className="mt-8 rounded-xl border border-border bg-card p-6">
        <p className="font-semibold text-foreground">Our office</p>
        <p className="mt-1 text-muted-foreground">{CONTACT.addressLine}</p>
      </div>

      <div className="mt-14 flex flex-col items-center gap-3 rounded-xl bg-primary p-8 text-center text-white sm:flex-row sm:justify-between sm:text-left">
        <div>
          <p className="text-lg font-semibold">Ready to explore your options?</p>
          <p className="mt-1 text-sm text-white/80">
            Browse colleges by country or start your application directly.
          </p>
        </div>
        <Button asChild className="bg-accent text-primary-dark hover:bg-accent-dark">
          <Link href="/colleges">Browse Colleges</Link>
        </Button>
      </div>
    </div>
  );
}
