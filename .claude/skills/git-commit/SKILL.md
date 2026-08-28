---
name: git-commit
description: Create a git commit using conventional commit format. Use when user wants to commit, stage changes, or write a commit message.
---

## Context

- Status: !`git status`
- Branch: !`git branch --show-current`

Read the diff and recent commits before proceeding (`git diff HEAD`, `git log --oneline -10`). If HEAD doesn't exist (new repo), use `git diff --cached` and `git status` instead.

## Rules

- Use AskUserQuestion with options for all interactions — never require typing
- No Claude attribution, co-authored-by, or AI references. Ever.
- No git push
- Conventional commit format: `type: description` (single line)
- Types: feat, fix, chore, refactor, docs, style, test, perf, ci, build
- Plain-English descriptions: no AI vocabulary or promotional fluff (apply the `humanizer` skill's patterns) — e.g. "add upload retry" not "enhance upload with robust retry handling"
- Group changes smartly: distinct features get separate commits, overlapping/small changes get grouped. Avoid micro-commits.
- If multiple commits needed: propose a grouping plan first with [Looks good] [Regroup] [Show files] options
- For each commit: propose 2-3 message options, let user pick
- Seek approval before executing git commit
