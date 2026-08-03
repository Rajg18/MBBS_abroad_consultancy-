import { Card, CardContent } from "@/components/ui/card";
import { ShieldCheck, FileCheck2, Wallet, HeartHandshake } from "lucide-react";

const REASONS = [
  {
    icon: ShieldCheck,
    title: "NMC-compliance guidance",
    description:
      "Every college we recommend is checked against NMC's approved list, so your degree is valid to practice back in India.",
  },
  {
    icon: FileCheck2,
    title: "Document handling done right",
    description:
      "Marksheets, NEET scores, passport and visa paperwork — reviewed and organized before they ever reach a university.",
  },
  {
    icon: Wallet,
    title: "Transparent fees",
    description:
      "No hidden charges. You see tuition, hostel, and service costs upfront before you commit to anything.",
  },
  {
    icon: HeartHandshake,
    title: "Support after admission",
    description:
      "Visa processing, travel, and settling in abroad — our guidance doesn't stop once you're accepted.",
  },
] as const;

export function TrustSection() {
  return (
    <section className="mx-auto max-w-6xl px-4 py-16 sm:px-6">
      <h2 className="text-2xl font-bold text-foreground sm:text-3xl">
        Why students choose Sree Consultancy
      </h2>

      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {REASONS.map((reason) => (
          <Card key={reason.title} className="h-full border-border">
            <CardContent className="p-5">
              <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-secondary text-primary">
                <reason.icon className="h-5 w-5" />
              </div>
              <p className="mt-4 font-semibold text-foreground">{reason.title}</p>
              <p className="mt-1.5 text-sm leading-relaxed text-muted-foreground">
                {reason.description}
              </p>
            </CardContent>
          </Card>
        ))}
      </div>
    </section>
  );
}
