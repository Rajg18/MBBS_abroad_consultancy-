import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { College } from "@/lib/api";

export function CollegeCard({ college }: { college: College }) {
  return (
    <Link href={`/colleges/${college.id}`}>
      <Card className="h-full transition-shadow hover:shadow-md">
        <CardContent className="flex h-full flex-col p-5">
          <div className="flex items-start justify-between gap-2">
            <p className="font-semibold text-foreground">{college.name}</p>
            <Badge
              variant={college.admissionOpen ? "default" : "outline"}
              className={
                college.admissionOpen
                  ? "shrink-0 bg-accent-tint text-accent-dark"
                  : "shrink-0 text-muted-foreground"
              }
            >
              {college.admissionOpen ? "Open" : "Closed"}
            </Badge>
          </div>
          <p className="mt-1 text-sm text-muted-foreground">
            {college.country} · {college.level}
          </p>
          <p className="mt-1 text-xs text-muted-foreground">{college.program}</p>
          <div className="mt-auto flex items-center justify-between pt-3">
            <p className="text-xs uppercase tracking-wide text-muted-foreground">
              Intake {college.intake}
            </p>
            {college.feesPerYearUsd && (
              <p className="text-xs font-semibold text-foreground">
                ${college.feesPerYearUsd.toLocaleString()}/yr
              </p>
            )}
          </div>
        </CardContent>
      </Card>
    </Link>
  );
}
