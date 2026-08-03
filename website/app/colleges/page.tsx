import { Suspense } from "react";
import type { Metadata } from "next";
import { getColleges, getCountries } from "@/lib/api";
import { CollegeDirectoryWithParams } from "@/components/colleges/college-directory-with-params";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";

export const metadata: Metadata = {
  title: "MBBS Colleges Abroad — Browse 100+ NMC-Approved Universities",
  description:
    "Search and filter 100+ NMC-approved MBBS colleges abroad by country, program level, and admission status. Compare intake and find the right fit for 2026.",
};

export default async function CollegesPage() {
  const [colleges, countries] = await Promise.all([getColleges(), getCountries()]);
  const countryNames = countries.map((c) => c.name);

  return (
    <div className="mx-auto max-w-6xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "Colleges" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">
        MBBS Colleges Abroad
      </h1>
      <p className="mt-3 max-w-2xl text-muted-foreground">
        Browse our full directory of {colleges.length} NMC-approved medical colleges across{" "}
        {countries.length} countries. Filter by country, program level, or admission status to
        find the right fit for the current intake.
      </p>

      <div className="mt-8">
        <Suspense fallback={<p className="text-muted-foreground">Loading colleges…</p>}>
          <CollegeDirectoryWithParams colleges={colleges} countries={countryNames} />
        </Suspense>
      </div>
    </div>
  );
}
