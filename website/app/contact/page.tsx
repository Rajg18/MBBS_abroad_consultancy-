import type { Metadata } from "next";
import Link from "next/link";
import { Mail, MapPin, MessageCircle } from "lucide-react";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { APPLY_URL, CONTACT } from "@/lib/site-config";

export const metadata: Metadata = {
  title: "Contact Us",
  description:
    "Get in touch with Sree Consultancy for MBBS-abroad admissions guidance — WhatsApp, email, or start your application directly.",
};

export default function ContactPage() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "Contact" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">Contact Us</h1>
      <p className="mt-3 max-w-2xl text-muted-foreground">
        Have a question before you apply? Reach out directly — or if you already know you want to
        move forward, starting your application is the fastest way to get guidance.
      </p>

      <div className="mt-8 grid gap-4 sm:grid-cols-2">
        <Card>
          <CardContent className="flex items-start gap-4 p-5">
            <MessageCircle className="mt-1 h-5 w-5 shrink-0 text-accent-dark" />
            <div>
              <p className="font-semibold text-foreground">WhatsApp</p>
              <p className="mt-1 text-sm text-muted-foreground">
                Fastest way to reach us for a quick question.
              </p>
              <a
                href={CONTACT.whatsapp}
                target="_blank"
                rel="noopener noreferrer"
                className="mt-2 inline-block text-sm font-semibold text-primary hover:underline"
              >
                Message us on WhatsApp →
              </a>
              <p className="mt-1">
                <a
                  href={`tel:${CONTACT.phoneDial}`}
                  className="text-sm font-semibold text-primary hover:underline"
                >
                  Or call {CONTACT.phone}
                </a>
              </p>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="flex items-start gap-4 p-5">
            <Mail className="mt-1 h-5 w-5 shrink-0 text-accent-dark" />
            <div>
              <p className="font-semibold text-foreground">Email</p>
              <p className="mt-1 text-sm text-muted-foreground">For detailed questions or documents.</p>
              <a
                href={`mailto:${CONTACT.email}`}
                className="mt-2 inline-block text-sm font-semibold text-primary hover:underline"
              >
                {CONTACT.email}
              </a>
            </div>
          </CardContent>
        </Card>

        <Card className="sm:col-span-2">
          <CardContent className="flex items-start gap-4 p-5">
            <MapPin className="mt-1 h-5 w-5 shrink-0 text-accent-dark" />
            <div>
              <p className="font-semibold text-foreground">Office</p>
              <p className="mt-1 text-sm text-muted-foreground">{CONTACT.addressLine}</p>
              {/* PLACEHOLDER — confirm real hours before launch. */}
              <p className="mt-1 text-sm text-muted-foreground">
                Hours: Mon–Sat, 10am–7pm IST [confirm real hours]
              </p>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="mt-10 flex flex-col items-center gap-3 rounded-xl bg-primary p-8 text-center text-white sm:flex-row sm:justify-between sm:text-left">
        <div>
          <p className="text-lg font-semibold">Already know what you&apos;re looking for?</p>
          <p className="mt-1 text-sm text-white/80">Skip the wait and start your application now.</p>
        </div>
        <Button asChild className="bg-accent text-primary-dark hover:bg-accent-dark">
          <Link href={APPLY_URL}>Go to Application</Link>
        </Button>
      </div>
    </div>
  );
}
