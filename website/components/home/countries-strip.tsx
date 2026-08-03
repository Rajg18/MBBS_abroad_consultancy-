import Link from "next/link";
import { CountryCard } from "@/components/countries/country-card";
import type { Country } from "@/lib/api";

export function CountriesStrip({ countries }: { countries: Country[] }) {
  return (
    <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <div className="flex items-end justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold text-foreground sm:text-3xl">
            Where you could study
          </h2>
          <p className="mt-2 text-muted-foreground">
            Every country below is one we actively place students in —
            college counts update as admissions open and close.
          </p>
        </div>
        <Link
          href="/countries"
          className="hidden shrink-0 text-sm font-semibold text-primary hover:underline sm:block"
        >
          View all countries →
        </Link>
      </div>

      <div className="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4">
        {countries.map((country) => (
          <CountryCard key={country.name} country={country} />
        ))}
      </div>

      <Link
        href="/countries"
        className="mt-6 block text-center text-sm font-semibold text-primary hover:underline sm:hidden"
      >
        View all countries →
      </Link>
    </section>
  );
}
