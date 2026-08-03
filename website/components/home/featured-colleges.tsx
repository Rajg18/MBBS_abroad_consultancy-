import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { College } from "@/lib/api";

export function FeaturedColleges({ colleges }: { colleges: College[] }) {
  if (colleges.length === 0) return null;

  return (
    <section className="bg-secondary/60 py-16">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="flex items-end justify-between gap-4">
          <div>
            <h2 className="text-2xl font-bold text-foreground sm:text-3xl">
              Open admissions right now
            </h2>
            <p className="mt-2 text-muted-foreground">
              A few colleges currently accepting applications for this intake.
            </p>
          </div>
          <Link
            href="/colleges"
            className="hidden shrink-0 text-sm font-semibold text-primary hover:underline sm:block"
          >
            Browse all colleges →
          </Link>
        </div>

        <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {colleges.map((college) => (
            <Link key={college.id} href={`/colleges/${college.id}`}>
              <Card className="h-full transition-shadow hover:shadow-md">
                <CardContent className="p-5">
                  <div className="flex items-start justify-between gap-2">
                    <p className="font-semibold text-foreground">{college.name}</p>
                    <Badge className="shrink-0 bg-accent-tint text-accent-dark">
                      Open
                    </Badge>
                  </div>
                  <p className="mt-1 text-sm text-muted-foreground">
                    {college.country} · {college.level}
                  </p>
                  <p className="mt-3 text-xs uppercase tracking-wide text-muted-foreground">
                    Intake {college.intake}
                  </p>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>

        <Link
          href="/colleges"
          className="mt-6 block text-center text-sm font-semibold text-primary hover:underline sm:hidden"
        >
          Browse all colleges →
        </Link>
      </div>
    </section>
  );
}
