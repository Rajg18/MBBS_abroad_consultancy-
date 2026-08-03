"use client";

import { useMemo, useState } from "react";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { Button } from "@/components/ui/button";
import { CollegeCard } from "@/components/colleges/college-card";
import type { College } from "@/lib/api";

const PAGE_SIZE = 24;
const ALL = "__all__";

export function CollegeDirectory({
  colleges,
  countries,
  initialCountry,
  showCountryFilter = true,
}: {
  colleges: College[];
  countries: string[];
  initialCountry?: string;
  showCountryFilter?: boolean;
}) {
  const [search, setSearch] = useState("");
  const [country, setCountry] = useState(initialCountry ?? ALL);
  const [level, setLevel] = useState(ALL);
  const [openOnly, setOpenOnly] = useState(false);
  const [visible, setVisible] = useState(PAGE_SIZE);

  const levels = useMemo(
    () => Array.from(new Set(colleges.map((c) => c.level))).sort(),
    [colleges],
  );

  const filtered = useMemo(() => {
    const q = search.trim().toLowerCase();
    return colleges.filter((c) => {
      if (country !== ALL && c.country !== country) return false;
      if (level !== ALL && c.level !== level) return false;
      if (openOnly && !c.admissionOpen) return false;
      if (q && !c.name.toLowerCase().includes(q)) return false;
      return true;
    });
  }, [colleges, search, country, level, openOnly]);

  const shown = filtered.slice(0, visible);
  const hasMore = visible < filtered.length;

  return (
    <div>
      <div className="grid gap-3 rounded-xl border border-border bg-card p-4 sm:grid-cols-2 lg:grid-cols-4">
        <Input
          placeholder="Search college name…"
          value={search}
          onChange={(e) => {
            setSearch(e.target.value);
            setVisible(PAGE_SIZE);
          }}
          aria-label="Search colleges by name"
        />
        {showCountryFilter && (
          <Select
            value={country}
            onValueChange={(v) => {
              setCountry(v);
              setVisible(PAGE_SIZE);
            }}
          >
            <SelectTrigger aria-label="Filter by country">
              <SelectValue placeholder="All countries" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value={ALL}>All countries</SelectItem>
              {countries.map((c) => (
                <SelectItem key={c} value={c}>
                  {c}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        )}
        <Select
          value={level}
          onValueChange={(v) => {
            setLevel(v);
            setVisible(PAGE_SIZE);
          }}
        >
          <SelectTrigger aria-label="Filter by level">
            <SelectValue placeholder="All levels" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>All levels</SelectItem>
            {levels.map((l) => (
              <SelectItem key={l} value={l}>
                {l}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <label className="flex items-center gap-3 rounded-md border border-input px-3">
          <Switch
            checked={openOnly}
            onCheckedChange={(v) => {
              setOpenOnly(v);
              setVisible(PAGE_SIZE);
            }}
            aria-label="Show only open admissions"
          />
          <span className="text-sm text-foreground">Open admissions only</span>
        </label>
      </div>

      <p className="mt-4 text-sm text-muted-foreground">
        {filtered.length} college{filtered.length === 1 ? "" : "s"} found
      </p>

      {shown.length === 0 ? (
        <div className="mt-8 rounded-xl border border-dashed border-border p-12 text-center text-muted-foreground">
          No colleges match these filters. Try clearing the search or picking a different country.
        </div>
      ) : (
        <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {shown.map((c) => (
            <CollegeCard key={c.id} college={c} />
          ))}
        </div>
      )}

      {hasMore && (
        <div className="mt-8 flex justify-center">
          <Button variant="outline" onClick={() => setVisible((v) => v + PAGE_SIZE)}>
            Load more colleges
          </Button>
        </div>
      )}
    </div>
  );
}
