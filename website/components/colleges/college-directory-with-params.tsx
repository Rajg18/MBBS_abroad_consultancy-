"use client";

import { useSearchParams } from "next/navigation";
import { CollegeDirectory } from "@/components/colleges/college-directory";
import type { College } from "@/lib/api";

/** Reads ?country= from the URL client-side and seeds the directory's
 * initial filter — kept separate from CollegeDirectory so useSearchParams
 * (which requires a Suspense boundary) doesn't force the whole filter UI
 * into that boundary too. */
export function CollegeDirectoryWithParams({
  colleges,
  countries,
}: {
  colleges: College[];
  countries: string[];
}) {
  const searchParams = useSearchParams();
  const initialCountry = searchParams.get("country") ?? undefined;

  return (
    <CollegeDirectory colleges={colleges} countries={countries} initialCountry={initialCountry} />
  );
}
