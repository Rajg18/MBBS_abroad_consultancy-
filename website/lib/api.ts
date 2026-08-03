import { API_BASE_URL } from "@/lib/site-config";

export type Country = {
  name: string;
  flag: string;
  collegeCount: number;
  openCount: number;
};

export type College = {
  id: string;
  name: string;
  country: string;
  program: string;
  level: string;
  intake: string;
  admissionOpen: boolean;
  description: string | null;
  feesPerYearUsd: number | null;
  durationYears: number | null;
  highlights: string[];
};

/** Build-time fetch only (Server Components / generateStaticParams) — never
 * called from the client, so the Spring Boot API's CORS config doesn't need
 * to know about this site. */
async function apiFetch<T>(path: string): Promise<T> {
  const res = await fetch(`${API_BASE_URL}${path}`, {
    // Static export: resolve once at build time, not per-request.
    cache: "force-cache",
  });
  if (!res.ok) {
    throw new Error(`API ${path} failed: ${res.status} ${res.statusText}`);
  }
  return res.json() as Promise<T>;
}

export function getCountries(): Promise<Country[]> {
  return apiFetch<Country[]>("/countries");
}

/** Raw shape as it may arrive from an older backend deploy, before the
 * description/fees/duration/highlights fields existed. */
type RawCollege = Omit<College, "description" | "feesPerYearUsd" | "durationYears" | "highlights"> &
  Partial<Pick<College, "description" | "feesPerYearUsd" | "durationYears" | "highlights">>;

/** Guarantees every optional content field is present, so a backend running
 * an older version can never crash the static build (an absent `highlights`
 * would otherwise throw on `.length`). */
function normalize(c: RawCollege): College {
  return {
    ...c,
    description: c.description ?? null,
    feesPerYearUsd: c.feesPerYearUsd ?? null,
    durationYears: c.durationYears ?? null,
    highlights: c.highlights ?? [],
  };
}

export async function getColleges(country?: string): Promise<College[]> {
  const query = country ? `?country=${encodeURIComponent(country)}` : "";
  const raw = await apiFetch<RawCollege[]>(`/colleges${query}`);
  return raw.map(normalize);
}
