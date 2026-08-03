/** Generic, factually-safe FAQ/intro copy shared across every country page.
 * Deliberately country-agnostic where we don't hold verified per-country
 * data (fees, exact visa steps) — swap in real specifics as they're
 * confirmed, rather than inventing numbers. */

export function countryIntro(country: string, collegeCount: number, openCount: number): string {
  return `${country} is one of the destinations we actively place students in for MBBS admissions. We currently track ${collegeCount} college${collegeCount === 1 ? "" : "s"} there, with ${openCount} accepting applications for the current intake. Every college listed is one our team screens for NMC-recognition status before it's added to the directory.`;
}

export function countryFaqs(country: string): { question: string; answer: string }[] {
  return [
    {
      question: `Is an MBBS degree from ${country} recognised in India?`,
      answer: `Only medical colleges that appear on the National Medical Commission's approved list count toward practising in India. We only list colleges we've screened for NMC-recognition status — always confirm current status directly with NMC before applying, since approvals are reviewed periodically.`,
    },
    {
      question: `What exams do I need to clear to study MBBS in ${country}?`,
      answer: `A qualifying NEET score is required to study MBBS abroad and register with NMC on return. After graduating, you'll also need to clear the Foreign Medical Graduate Examination (FMGE) to practise in India.`,
    },
    {
      question: `How long does the visa process usually take?`,
      answer: `Timelines vary by college and intake, and change over time — we guide each applicant through the specific document and visa requirements for their chosen college once they've applied, rather than quoting a single fixed timeline here.`,
    },
    {
      question: `What documents do I need to apply?`,
      answer: `Typically your 10th and 12th marksheets, NEET scorecard, passport, and a few identity documents. The exact list depends on the college — our application flow tells you precisely what's needed once you've picked one.`,
    },
  ];
}
