---
name: career-ops
description: Use for job-search operations, including scanning job portals, evaluating job postings, generating tailored ATS-friendly CVs, tracking applications, and opening the Career-Ops dashboard.
---

# Career-Ops (/job)

This skill enables the Career-Ops multi-agent job search system. It provides tools to evaluate job postings, generate tailored ATS-friendly CVs, and track your applications.

## Usage

When the user invokes `/job`, you should use the scripts in `~/.agents/skills/career-ops` to assist them.

Commands you can run for the user:
- **Scan for jobs:** `node ~/.agents/skills/career-ops/scan.mjs`
- **Generate Tailored CV:** `node ~/.agents/skills/career-ops/generate-pdf.mjs`
- **Dashboard:** `node ~/.agents/skills/career-ops/dashboard/index.mjs`
- **Run Pipeline:** Evaluate a job using Claude/Gemini based on the URL provided.

**IMPORTANT:** The Career-Ops system is strictly "Human-in-the-Loop". You can find jobs, evaluate them, score them (from A to F), and generate a tailored CV for the specific job description, but **you cannot auto-submit the application**. The user must review the evaluation and manually submit the application themselves.

## How to use `/job`
1. `/job scan` -> Run the portal scanner to find new jobs.
2. `/job evaluate <URL>` -> Evaluate a specific job listing.
3. `/job generate <URL>` -> Generate a tailored CV for a job.
4. `/job dashboard` -> Open the TUI dashboard to view the pipeline.
