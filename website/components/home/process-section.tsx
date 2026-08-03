import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";

const STEPS = [
  {
    title: "1. Pick your countries",
    body: "Tell us your top 3 country preferences. We'll show you exactly how many colleges are open in each, right now.",
  },
  {
    title: "2. Pick your colleges",
    body: "Choose preferred universities within those countries, in order of preference. Closed admissions are shown but can't be selected, so you never waste time on a dead end.",
  },
  {
    title: "3. Share your documents",
    body: "Upload your 10th and 12th marksheets, NEET score, and passport securely. This step is optional at first look — you can browse everything before committing.",
  },
  {
    title: "4. Review and submit",
    body: "Check everything once, then submit. Our team gets notified immediately and reaches out to guide your next steps.",
  },
] as const;

export function ProcessSection() {
  return (
    <section className="mx-auto max-w-3xl px-4 py-16 sm:px-6">
      <div className="text-center">
        <h2 className="text-2xl font-bold text-foreground sm:text-3xl">
          How applying works
        </h2>
        <p className="mt-2 text-muted-foreground">
          Four simple steps, from your first look to a submitted application.
        </p>
      </div>

      <Accordion type="single" collapsible defaultValue="1. Pick your countries" className="mt-8">
        {STEPS.map((step) => (
          <AccordionItem key={step.title} value={step.title}>
            <AccordionTrigger className="text-left font-semibold">
              {step.title}
            </AccordionTrigger>
            <AccordionContent className="text-muted-foreground">
              {step.body}
            </AccordionContent>
          </AccordionItem>
        ))}
      </Accordion>
    </section>
  );
}
