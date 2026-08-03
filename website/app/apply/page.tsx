import type { Metadata } from "next";
import Link from "next/link";
import { CheckCircle2, ShieldCheck } from "lucide-react";
import { PageBreadcrumb } from "@/components/shared/page-breadcrumb";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { APPLY_URL } from "@/lib/site-config";

export const metadata: Metadata = {
  title: "Apply for MBBS Abroad Admission",
  description:
    "Here's exactly what happens when you apply — the steps, the documents to have ready, and what to expect next.",
};

const STEPS = [
  {
    title: "Pick your countries",
    body: "Choose up to 3 country preferences, in order. You'll see live college counts and open-admission status for each.",
  },
  {
    title: "Pick your colleges",
    body: "Select preferred universities within those countries, ranked in your order of preference. Closed admissions are shown but can't be selected.",
  },
  {
    title: "Share your details and documents",
    body: "Your name, phone, email, and NEET score, plus your marksheets, passport, and ID — uploaded securely. This step can be completed later if you want to browse first.",
  },
  {
    title: "Review and submit",
    body: "Check everything on one screen, then submit. Our team is notified immediately and follows up directly.",
  },
];

const DOCUMENTS = [
  "10th marksheet",
  "12th marksheet",
  "Passport",
  "Aadhaar (or equivalent government ID)",
  "NEET scorecard",
];

export default function ApplyPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-10 sm:px-6">
      <PageBreadcrumb items={[{ label: "Apply" }]} />

      <h1 className="mt-4 text-3xl font-bold text-foreground sm:text-4xl">
        Ready to Apply?
      </h1>
      <p className="mt-4 text-lg text-muted-foreground">
        Here&apos;s exactly what happens next — four steps, roughly 10 minutes if you have your
        documents ready, less if you just want to browse first and come back.
      </p>

      <div className="mt-10 space-y-5">
        {STEPS.map((step, i) => (
          <div key={step.title} className="flex gap-4">
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-primary-tint font-bold text-primary">
              {i + 1}
            </div>
            <div>
              <p className="font-semibold text-foreground">{step.title}</p>
              <p className="mt-1 text-muted-foreground">{step.body}</p>
            </div>
          </div>
        ))}
      </div>

      <Card className="mt-10">
        <CardContent className="p-6">
          <p className="font-semibold text-foreground">Documents to have ready</p>
          <p className="mt-1 text-sm text-muted-foreground">
            Not required to start — you can browse countries and colleges first — but having these
            ready speeds up your application.
          </p>
          <ul className="mt-4 grid gap-2 sm:grid-cols-2">
            {DOCUMENTS.map((doc) => (
              <li key={doc} className="flex items-center gap-2 text-sm text-foreground">
                <CheckCircle2 className="h-4 w-4 shrink-0 text-accent-dark" />
                {doc}
              </li>
            ))}
          </ul>
        </CardContent>
      </Card>

      <div className="mt-8 flex items-start gap-3 rounded-xl border border-border bg-secondary/60 p-4 text-sm text-muted-foreground">
        <ShieldCheck className="mt-0.5 h-5 w-5 shrink-0 text-primary" />
        <p>
          You&apos;ll be taken to our secure application portal to complete these steps. Your
          documents are handled through an encrypted upload flow — never sent over WhatsApp or
          email.
        </p>
      </div>

      <div className="mt-8 flex justify-center">
        <Button
          asChild
          size="lg"
          className="bg-accent px-10 text-primary-dark hover:bg-accent-dark"
        >
          <Link href={APPLY_URL}>Go to Application</Link>
        </Button>
      </div>
    </div>
  );
}
