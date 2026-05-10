---
name: app-store-audit
description: Audit an iOS app for App Store rejection risks before submission. Scans permissions, payments, account features, network config, and 2025-2026 Apple requirements.
---

# App Store Submission Auditor

Scan an iOS app project for Apple App Store rejection risks. Output a full report in one pass — no back-and-forth.

## Pre-Scan: Detect Three Things First

1. **User level** — vibe coder (plain English) or technical developer (code diffs + guideline numbers)
2. **Stack** — Flutter, React Native, or native Swift/Xcode
3. **Build state** — if app is mid-build, offer "Build Checklist" mode instead of submission audit

## Activation Triggers

Auto-activate when user says: "audit my app", "is my app ready", "about to submit", "got rejected", "submitting to App Store", or similar.

## What to Scan

### Permissions
- Every `NSUsageDescription` key — check it's clear, honest, and necessary
- `NSLocationAlwaysUsageDescription` — red flag unless it's a location-focused app
- `NSUserTrackingUsageDescription` — flag if no actual tracking SDKs are present

### Account Features
- In-app account deletion (required) — flag if it's an email or web redirect
- User blocking — required in social/messaging apps

### Sign In with Apple
- Required if any third-party login (Google, Facebook, etc.) exists

### Payments
- Digital goods/features → must use IAP, not Stripe/PayPal
- Physical goods → Stripe/PayPal is fine (do NOT flag this)

### Network & Security
- Hardcoded IPs or HTTP in production builds
- Staging URLs in release builds
- `ITSAppUsesNonExemptEncryption` missing from Info.plist

### Tracking
- ATT prompt present without any tracking SDK → flag as unnecessary
- Data-collecting SDKs without privacy manifest disclosure

### 2025–2026 Requirements
- Age rating tier updates
- AI-generated content consent (if applicable)
- Xcode SDK minimum version compliance

## False Positives — Do NOT Flag These
- Stripe/PayPal for physical goods
- WebView for supplemental content (help, legal, terms)
- Firebase Analytics alone (unless undisclosed collection)
- Staging URLs unless confirmed it's a production build
- Location access at startup for location-focused apps
- Missing block feature in non-social apps

## Severity Levels
- 🚨 P0 — Guaranteed rejection
- ⚠️ P1 — Actively checked, likely flagged
- 💡 P2 — Won't necessarily reject, but worth fixing

## Output Format (all at once, no pausing)

1. **Executive Summary** — top 3 risks + quick wins
2. **Risk Register Table** — Priority | Area | Evidence | Fix | Effort
3. **Detailed Findings** — grouped by category with copy-paste fixes
4. **Reviewer Experience Checklist** — simulated Apple reviewer walkthrough
5. **Draft App Store Connect Notes** — ready-to-paste reviewer notes
6. **Manual Checklist + 4 Follow-up Questions** — items requiring human verification

## Language Adaptation
- **Vibe coder mode:** Plain English, reference actual filenames found, suggest Claude Code prompts
- **Technical mode:** Exact code diffs, guideline numbers (e.g. 2.5.1), Info.plist keys

## Re-audit Support
After fixes, run targeted re-scan of only the changed areas. Track previously found issues if `config.json` exists.
