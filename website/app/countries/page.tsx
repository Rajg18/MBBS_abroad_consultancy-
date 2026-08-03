import type { Metadata } from "next";
import { getCountries } from "@/lib/api";
import { CountryCard } from "@/components/countries/country-card";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";

export const metadata: Metadata = {
  title: "Countries to Study MBBS Abroad 2026",
  description:
    "Compare NMC-approved MBBS study destinations abroad — college counts, open admissions, and guidance for each country we place students in.",
};

export default async function CountriesPage() {
  const countries = await getCountries();

  return (
    <div className="mx-auto max-w-6xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "Countries" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">
        Where to Study MBBS Abroad
      </h1>
      <p className="mt-3 max-w-2xl text-muted-foreground">
        We place students across {countries.length} countries, each screened for NMC-recognised
        medical colleges. Pick a country to see its colleges, intake status, and what to expect.
      </p>

      <div className="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4">
        {countries.map((country) => (
          <CountryCard key={country.name} country={country} />
        ))}
      </div>
    </div>
  );
}
