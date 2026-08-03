import Link from "next/link";
import { CONTACT } from "@/lib/site-config";

const FOOTER_COLUMNS = [
  {
    heading: "Explore",
    links: [
      { href: "/countries", label: "Countries" },
      { href: "/colleges", label: "College Directory" },
      { href: "/blog", label: "Blog" },
      { href: "/apply", label: "Apply" },
    ],
  },
  {
    heading: "Company",
    links: [
      { href: "/about", label: "About Us" },
      { href: "/contact", label: "Contact" },
    ],
  },
];

export function SiteFooter() {
  return (
    <footer className="border-t border-border bg-primary text-white">
      <div className="mx-auto max-w-6xl px-4 py-12 sm:px-6">
        <div className="grid gap-10 sm:grid-cols-2 md:grid-cols-4">
          <div className="md:col-span-2">
            <p className="text-lg font-semibold">Sree Consultancy</p>
            <p className="mt-1 text-sm text-white/70">
              MBBS admissions guidance for Indian students, across 25+
              countries and 100+ NMC-approved colleges.
            </p>
            <p className="mt-4 text-sm text-white/70">{CONTACT.addressLine}</p>
            <p className="mt-1 text-sm text-white/70">{CONTACT.email}</p>
          </div>

          {FOOTER_COLUMNS.map((column) => (
            <div key={column.heading}>
              <p className="text-sm font-semibold uppercase tracking-wide text-accent">
                {column.heading}
              </p>
              <ul className="mt-3 space-y-2">
                {column.links.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="text-sm text-white/80 transition-colors hover:text-white"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-10 border-t border-white/15 pt-6 text-xs text-white/60">
          <p>© {new Date().getFullYear()} Sree Consultancy. Your data is handled securely.</p>
        </div>
      </div>
    </footer>
  );
}
