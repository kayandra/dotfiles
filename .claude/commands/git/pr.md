---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Update PR Title and Body
---

## Context

- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Generate a pr title and body.
- Always seek approval before updating the pr title and body.
- Make it an interactive prompt.

## Your task

- Update the open pr title and body
- Do not include any Co-authored-by in the message.
- Do not include generated with Claude Code in the message.
- Do not include anything at all related to claude in the message unless explicitly asked to.
