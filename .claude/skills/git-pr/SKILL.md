---
name: git-pr
description: Update PR title and body. Use when user wants to update, create, or edit a pull request title or description.
---

## Context

- Branch: !`git branch --show-current`
- Commits: !`git log --oneline -20`

Before generating the PR, detect the default branch (`git remote show origin | grep 'HEAD branch'`) and read the diff against it (`git diff <default-branch>...HEAD`).

## Rules

- Use AskUserQuestion with options for all interactions — never require typing
- No Claude attribution, co-authored-by, or AI references. Ever.
- Title: short, clear, plain English. Must fit one line on GitHub.
- Body: brief and scannable:
  - Summary: what changed (2-4 bullets max), why (one line if not obvious)
  - How to test: brief steps or commands to verify the change
  - If the change involves different behaviors across environments, modes, or flags — add a behavior matrix table. Only when it genuinely helps, not as boilerplate.
- Present title + body with options: [Approve] [Edit title] [Edit body] [Regenerate]
- Update via `gh pr edit` on approval

## Humanize the output

The title and body are read by people. Before presenting, do a silent pass to strip AI-sounding patterns (the `humanizer` skill has the full list). Watch for:

- AI vocabulary and promotional words: leverage, robust, seamless, comprehensive, streamline, crucial, vibrant
- Em-dash overuse, rule-of-three lists, and superficial "-ing" tails ("...improving performance, ensuring reliability")
- Filler: "in order to", "it's important to note that", "this PR aims to"
- Copula avoidance: "serves as" / "enables" where "is" / "lets you" is plainer

Keep it plain, specific, and short. Do not show the humanizer's draft/audit steps — just present the cleaned result.
