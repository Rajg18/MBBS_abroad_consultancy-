import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";
import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { CONTACT, SITE_URL } from "@/lib/site-config";
import { cn } from "@/lib/utils";

const poppins = Poppins({
  variable: "--font-sans",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700", "800"],
});

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "MBBS Abroad Admissions 2026 | Sree Consultancy",
    template: "%s | Sree Consultancy",
  },
  description:
    "Free expert guidance for MBBS admissions abroad — Georgia, Russia, Philippines & more. 100+ NMC-approved colleges across 25+ countries. Start your application today.",
  openGraph: {
    type: "website",
    siteName: "Sree Consultancy",
    locale: "en_IN",
    url: SITE_URL,
    images: ["/images/og-fallback.png"],
  },
  twitter: {
    card: "summary_large_image",
    images: ["/images/og-fallback.png"],
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={cn("h-full", "antialiased", "font-sans", poppins.variable)}>
      <body className="min-h-full flex flex-col font-sans">
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "EducationalOrganization",
              name: "Sree Consultancy",
              alternateName: "Sree Consultancy — MBBS Abroad",
              url: SITE_URL,
              logo: `${SITE_URL}/images/sree-logo.png`,
              description:
                "MBBS abroad admissions consultancy guiding Indian students through NMC-approved medical colleges across 25+ countries.",
              areaServed: "IN",
              knowsAbout: [
                "MBBS Abroad Admissions",
                "NEET Counselling",
                "NMC-Approved Medical Colleges",
                "FMGE Preparation",
              ],
              telephone: CONTACT.phoneDial,
              email: CONTACT.email,
              address: {
                "@type": "PostalAddress",
                ...CONTACT.address,
              },
            }),
          }}
        />
        <SiteHeader />
        <main className="flex-1">{children}</main>
        <SiteFooter />
      </body>
    </html>
  );
}
