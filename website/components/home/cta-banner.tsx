import Link from "next/link";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";
import { APPLY_URL } from "@/lib/site-config";

export function CtaBanner() {
  return (
    <section className="mx-auto max-w-6xl px-4 pb-16 sm:px-6">
      <div className="flex flex-col items-center gap-5 rounded-3xl border border-border bg-card px-6 py-12 text-center sm:px-10">
        <h2 className="max-w-xl text-balance text-2xl font-bold text-foreground sm:text-3xl">
          Ready to see which colleges are open for you?
        </h2>
        <p className="max-w-md text-muted-foreground">
          It takes a few minutes to start, and there&apos;s no cost to explore
          your options.
        </p>
        <Button asChild size="lg" className="bg-accent text-primary-dark hover:bg-accent-dark">
          <Link href={APPLY_URL}>
            Go to Application <ArrowRight className="ml-1 h-4 w-4" />
          </Link>
        </Button>
      </div>
    </section>
  );
}
