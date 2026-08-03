// Central place for cross-page constants. Swap APPLY_URL and SITE_URL once
// the real domain is live (same placeholder-swap noted for the Flutter app).

/** Canonical origin for this site. Drives canonical tags, OG URLs, JSON-LD
 * and sitemap entries — so it MUST match where the site actually serves from,
 * or search engines will canonicalise to a dead domain and skip indexing.
 * Override via NEXT_PUBLIC_SITE_URL in .env.production once a real domain
 * is live. */
export const SITE_URL =
  process.env.NEXT_PUBLIC_SITE_URL ?? "https://sreeconsultancy-site.sreeeduu.workers.dev";

/** The existing Flutter application flow — this site's Apply CTAs link out to it. */
export const APPLY_URL = "https://sreeconsultancy.sreeeduu.workers.dev/";

export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8080/api";

export const NAV_LINKS = [
  { href: "/countries", label: "Countries" },
  { href: "/colleges", label: "Colleges" },
  { href: "/blog", label: "Blog" },
  { href: "/about", label: "About" },
  { href: "/contact", label: "Contact" },
] as const;

export const CONTACT = {
  phone: "+91 86681 13242",
  phoneDial: "+918668113242",
  whatsapp: "https://wa.me/918668113242",
  email: "thesreeconsultancy@gmail.com",
  addressLine: "23/10 Kottai Vinayagar Street, Rayagiri, Tenkasi 627764, Tamil Nadu, India",
  address: {
    streetAddress: "23/10 Kottai Vinayagar Street, Rayagiri",
    addressLocality: "Tenkasi",
    postalCode: "627764",
    addressRegion: "Tamil Nadu",
    addressCountry: "IN",
  },
};
