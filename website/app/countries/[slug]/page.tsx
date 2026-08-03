import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getColleges, getCountries } from "@/lib/api";
import { slugify } from "@/lib/slug";
import { countryFaqs, countryIntro } from "@/lib/country-content";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { CollegeDirectory } from "@/components/colleges/college-directory";
import { Badge } from "@/components/ui/badge";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";

async function findCountry(slug: string) {
  const countries = await getCountries();
  return countries.find((c) => slugify(c.name) === slug);
}

export async function generateStaticParams() {
  const countries = await getCountries();
  return countries.map((c) => ({ slug: slugify(c.name) }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const country = await findCountry(slug);
  if (!country) return {};

  return {
    title: `MBBS in ${country.name} 2026 — Fees, Colleges & Admission`,
    description: `Explore ${country.collegeCount} NMC-approved MBBS colleges in ${country.name}. ${country.openCount} open for the current intake. Free guidance from application to admission.`,
  };
}

export default async function CountryDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const country = await findCountry(slug);
  if (!country) notFound();

  const colleges = await getColleges(country.name);
  const faqs = countryFaqs(country.name);

  const faqJsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((f) => ({
      "@type": "Question",
      name: f.question,
      acceptedAnswer: { "@type": "Answer", text: f.answer },
    })),
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-10 sm:px-6">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd) }}
      />

      <PageBreadcrumb items={[{ label: "Countries", href: "/countries" }, { label: country.name }]} />

      <div className="mt-4 flex flex-wrap items-center gap-3">
        <span className="text-3xl" aria-hidden>
          {country.flag}
        </span>
        <h1 className="text-3xl font-bold text-foreground sm:text-4xl">
          MBBS in {country.name}
        </h1>
        <Badge className="bg-accent-tint text-accent-dark">
          {country.openCount} open now
        </Badge>
      </div>

      <p className="mt-4 max-w-2xl text-muted-foreground">
        {countryIntro(country.name, country.collegeCount, country.openCount)}
      </p>

      <div className="mt-10">
        <h2 className="text-xl font-bold text-foreground">
          Colleges in {country.name}
        </h2>
        <div className="mt-4">
          <CollegeDirectory
            colleges={colleges}
            countries={[country.name]}
            showCountryFilter={false}
          />
        </div>
      </div>

      <div className="mt-14 max-w-3xl">
        <h2 className="text-xl font-bold text-foreground">Frequently asked questions</h2>
        <Accordion type="single" collapsible className="mt-4">
          {faqs.map((faq) => (
            <AccordionItem key={faq.question} value={faq.question}>
              <AccordionTrigger className="text-left font-semibold">
                {faq.question}
              </AccordionTrigger>
              <AccordionContent className="text-muted-foreground">{faq.answer}</AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </div>
    </div>
  );
}
