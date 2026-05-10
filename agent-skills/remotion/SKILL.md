---
name: remotion
description: Create, build, and render programmatic videos with React using Remotion. Covers scaffolding, compositions, animations, rendering, and deploying Lambda renders.
---

# Remotion — Programmatic Video with React

Build videos with React components, CSS, and JavaScript. Remotion renders each frame as a React tree.

## Step 0: Bootstrap a New Project (if needed)

```bash
npx create-video@latest
```

Choose a template: Hello World, Blank, React Three Fiber, Still, or Overlay.

## Core Concepts

| Concept | What it is |
|---|---|
| `<Composition>` | Defines a video: id, width, height, fps, durationInFrames, component |
| `useCurrentFrame()` | Returns current frame number (0-based) |
| `useVideoConfig()` | Returns fps, width, height, durationInFrames |
| `interpolate()` | Maps frame range to value range (like Framer Motion's useTransform) |
| `spring()` | Physics-based spring animation tied to frame |
| `<Sequence>` | Offsets children so they start at a specific frame |
| `<Audio>` / `<Video>` / `<Img>` | Media components (use these, not native HTML tags) |
| `<AbsoluteFill>` | Shorthand for position:absolute full-width/height fill |

## Step 1: Create a Composition

In `src/Root.tsx`, register compositions:

```tsx
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot = () => (
  <>
    <Composition
      id="MyVideo"
      component={MyVideo}
      durationInFrames={150}
      fps={30}
      width={1920}
      height={1080}
    />
  </>
);
```

## Step 2: Build the Video Component

```tsx
import { useCurrentFrame, useVideoConfig, interpolate, AbsoluteFill } from 'remotion';

export const MyVideo = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: 'clamp',
  });

  return (
    <AbsoluteFill style={{ backgroundColor: 'white' }}>
      <div style={{ opacity, fontSize: 80 }}>Hello, Remotion!</div>
    </AbsoluteFill>
  );
};
```

## Step 3: Preview in Browser

```bash
npx remotion studio
```

Opens at `http://localhost:3000` — scrub timeline, live-reload on save.

## Step 4: Render to File

```bash
# Render full video
npx remotion render MyVideo output.mp4

# Render a single frame (for testing)
npx remotion still MyVideo --frame=30 frame.png

# Render with custom props
npx remotion render MyVideo output.mp4 --props='{"title":"Hello"}'
```

## Common Animations

### Fade in
```tsx
const opacity = interpolate(frame, [0, 20], [0, 1], { extrapolateRight: 'clamp' });
```

### Slide in from left
```tsx
const x = interpolate(frame, [0, 20], [-200, 0], { extrapolateRight: 'clamp' });
```

### Spring pop
```tsx
import { spring, useVideoConfig } from 'remotion';
const { fps } = useVideoConfig();
const scale = spring({ frame, fps, from: 0, to: 1 });
```

### Stagger children
```tsx
import { Sequence } from 'remotion';
{items.map((item, i) => (
  <Sequence from={i * 10} key={i}>
    <Item data={item} />
  </Sequence>
))}
```

## Using Fonts

```tsx
import { loadFont } from '@remotion/google-fonts/Inter';
const { fontFamily } = loadFont();
// use fontFamily in style prop
```

## Dynamic Props (Schema)

```tsx
import { z } from 'zod';
import { zColor } from '@remotion/zod-types';

export const schema = z.object({
  title: z.string(),
  color: zColor(),
});

// Pass to Composition:
<Composition schema={schema} defaultProps={{ title: 'Hello', color: '#fff' }} ... />
```

## Rendering on AWS Lambda

```bash
# Deploy Lambda function once
npx remotion lambda functions deploy

# Deploy site
npx remotion lambda sites create --site-name=my-video

# Render remotely
npx remotion lambda render <site-url> MyVideo
```

## Troubleshooting

- **Flickering** — avoid `Math.random()` inside components; use `random()` from `remotion` (deterministic by frame)
- **Audio sync** — use `<Audio src={...} startFrom={fps * 2} />` to offset audio in frames
- **Font not loading** — wrap in `continueRender` / `delayRender` pattern
- **Slow render** — use `--concurrency` flag to parallelize frames: `npx remotion render --concurrency=4`
