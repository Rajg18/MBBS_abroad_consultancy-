import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { slugify } from "@/lib/slug";
import type { Country } from "@/lib/api";

export function CountryCard({ country }: { country: Country }) {
  return (
    <Link href={`/countries/${slugify(country.name)}`}>
      <Card className="h-full transition-shadow hover:shadow-md">
        <CardContent className="flex flex-col items-start gap-2 p-4">
          <span className="text-2xl" aria-hidden>
            {country.flag}
          </span>
          <p className="font-semibold text-foreground">{country.name}</p>
          <div className="flex flex-wrap gap-1.5">
            <Badge variant="secondary">{country.collegeCount} colleges</Badge>
            {country.openCount > 0 && (
              <Badge className="bg-accent-tint text-accent-dark">{country.openCount} open</Badge>
            )}
          </div>
        </CardContent>
      </Card>
    </Link>
  );
}
