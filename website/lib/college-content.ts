import type { College } from "@/lib/api";

/** Generated fallback so no college page is ever empty before an admin
 * fills in a real description via the admin panel. */
export function collegeDescription(college: College): string {
  if (college.description && college.description.trim().length > 0) {
    return college.description;
  }
  return `${college.name} is an NMC-listed medical college in ${college.country}, offering ${college.program} (${college.level}) with a ${college.intake} intake. Our team screens admission status and requirements for this college before it's listed here — reach out for the latest details.`;
}
