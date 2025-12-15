---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Always seek approval before running the git commit command.

## Your task

Based on the above changes, create a single git commit. Do not include any Co-authored-by in the commit message. Do not include generated with Claude Code in the commit message. Do not include anything at all related to claude in the commit message unless explicitly asked to.
