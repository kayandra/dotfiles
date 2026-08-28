---
name: ian-xiaohei-illustrations
description: Generate Ian-style body illustrations for articles. Use when the user asks to create "bizarre" / "Xiaohei" / "hand-drawn" / "body illustration" / "article illustration" / "illustration suggestions" / "shot list" / "remove title / edit image" assets for an article, post, blog, Notion doc, workflow doc, methodology, process, structure, state, metaphor, or argument. Defaults to the Xiaohei IP, pure-white hand-drawn line art, sparse red/orange/blue annotations, and a clean but wildly imaginative visual style.
---

# Ian Xiaohei Bizarre Body Illustrations

## Core positioning

Design and generate 16:9 landscape body illustrations for articles. The goal is not commercial illustration, PPT infographics, or cute cartoons. It is to turn an article's key judgments, processes, structures, states, or metaphors into a clean, bizarre, creative, readable-but-not-instructional hand-drawn explanatory image.

The default visual IP is "Xiaohei" (小黑): solid black, white-dot eyes, thin legs, blank expression, earnestly doing something absurd but coherent. Xiaohei must take part in the core action of the image — never just stand to the side as decoration.

## Read these references first

Load as the task requires; do not stuff context all at once:

- `references/style-dna.md`: style DNA, color, text, taboos.
- `references/xiaohei-ip.md`: the Xiaohei IP's look, personality, action library, and taboos.
- `references/composition-patterns.md`: structure types, original-metaphor method, and anti-copying rules.
- `references/prompt-template.md`: single-image generation prompt template.
- `references/qa-checklist.md`: post-generation checks and iteration rules.
- `assets/examples/`: low-frequency visual calibration only; not part of the default generation path. Do not copy the composition, objects, or labels of these examples.

## Workflow

### 1. Digest the article

First read the article, link, Notion page, Markdown file, or screenshot content the user provides. Extract:

- What the core argument is
- Which paragraphs carry a cognitive turn
- Which content is suited to being explained with an image
- Which parts only suit text and need no image

Do not illustrate evenly. Prioritize "cognitive anchors", e.g.: the core judgment, two breakpoints, an input/output loop, branching, before/after contrast, one-fish-many-uses, handoff paths, common pitfalls, character state changes.

### 2. Lead with an illustration strategy

If the user only says "analyze how to illustrate / think about where illustrations are needed", lead with a shot list. For each image, spell out:

- Which paragraph it goes after
- The image's theme
- The core meaning
- The structure type
- What Xiaohei is doing in the image
- Suggested elements
- Suggested Chinese label words

Default to 4-8 images. For very short articles, 1-3; even for long articles, don't lightly exceed 9. Enough is enough — avoid turning the article into a picture book.

### 3. Single-image generation

If the user clearly asks to "generate / output / make the image / generate for me", do not stop to wait for confirmation; use the built-in `image_gen` to generate each one separately. Do not combine multiple images into one.

Each image conveys only one core structure. The prompt must include:

- 16:9 landscape Chinese article illustration
- Pure white background
- Black hand-drawn line art
- Sparse red/orange/blue handwritten Chinese annotations
- Lots of white space
- Xiaohei as the subject of the core action
- No PPT, commercial illustration, childish cuteness, complex architecture, or top-left type title

Do not reproduce past examples. The examples only supply style density and the way Xiaohei participates; do not directly reuse existing compositions such as "conveyor breakpoints / Xiaohei pulling a lever / material fish / stamp toolbox / common-pitfalls path" unless the user explicitly asks to reproduce a specific image. Reinvent a strange-but-coherent metaphor from the current article every time.

### 4. Check and iterate

After generating, check `references/qa-checklist.md`. If any of the following occur, prefer regenerating or doing a local edit:

- Xiaohei is just decoration
- The image is too crowded
- It looks too much like a flowchart/PPT
- Too much Chinese text or serious typos
- A top-left title appears, e.g. "Common Pitfalls / Flowchart / System Architecture"
- The art style is too cute, childish, or stiff
- The background is not a clean white base

### 5. Save and deliver

If the user works inside a workspace, copy the final images to:

```text
assets/<article-slug>-illustrations/
```

Name them in order:

```text
01-topic-name.png
02-topic-name.png
```

Keep the original generated files; do not overwrite existing assets unless the user explicitly asks to replace them.

## Output tone

Pre-generation strategy output should be short and precise. Post-generation delivery should include:

- How many images were generated
- The purpose of each image
- The save path
- Which images are most solid, and which are optional

Don't write long explanations of style theory; let the images speak for themselves.

Keep the shot-list and delivery prose plain — apply the `humanizer` skill's patterns (no promotional adjectives, rule-of-three, or filler). Write it the way you'd explain the shots to a colleague.
