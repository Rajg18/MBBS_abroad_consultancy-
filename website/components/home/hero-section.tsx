import Link from "next/link";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";
import { APPLY_URL } from "@/lib/site-config";

const STATS = [
  { value: "25+", label: "Countries" },
  { value: "100%", label: "Guided Support" },
];

export function HeroSection({
  collegeCount,
}: {
  /** Live count from /api/colleges, passed in so this stays a server component. */
  collegeCount: number;
}) {
  return (
    <section className="mx-auto max-w-6xl px-4 pt-10 sm:px-6 sm:pt-14">
      <div className="overflow-hidden rounded-3xl bg-gradient-to-br from-primary to-primary-dark px-6 py-14 text-center sm:px-10 sm:py-20">
        <span className="inline-flex items-center rounded-full border border-accent/50 bg-accent/15 px-4 py-2 text-sm font-medium text-accent">
          Study MBBS Abroad · Intake 2026-2027
        </span>

        <h1 className="mx-auto mt-6 max-w-3xl text-balance text-4xl font-extrabold leading-tight text-white sm:text-5xl md:text-6xl">
          Your medical career, beyond borders.
        </h1>

        <p className="mx-auto mt-5 max-w-xl text-base leading-relaxed text-white/80 sm:text-lg">
          Transform your medical aspirations into achievement. We operate in
          25+ countries, and mainly recommend the ones where Indian student
          strength is strong and institutes are NMC-approved.
        </p>

        <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
          <Button
            asChild
            size="lg"
            className="bg-accent text-primary-dark hover:bg-accent-dark"
          >
            <Link href={APPLY_URL}>
              Go to Application <ArrowRight className="ml-1 h-4 w-4" />
            </Link>
          </Button>
          <Button
            asChild
            size="lg"
            variant="outline"
            className="border-white/30 bg-transparent text-white hover:bg-white/10 hover:text-white"
          >
            <Link href="/countries">Explore Countries</Link>
          </Button>
        </div>

        <div className="mx-auto mt-12 flex max-w-md flex-wrap items-center justify-center gap-x-10 gap-y-6 border-t border-white/15 pt-8">
          {STATS.map((stat) => (
            <div key={stat.label} className="text-center">
              <p className="text-3xl font-extrabold text-accent">{stat.value}</p>
              <p className="mt-1 text-sm text-white/75">{stat.label}</p>
            </div>
          ))}
          <div className="text-center">
            <p className="text-3xl font-extrabold text-accent">{collegeCount}+</p>
            <p className="mt-1 text-sm text-white/75">Universities</p>
          </div>
        </div>
      </div>
    </section>
  );
}
