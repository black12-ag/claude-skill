---
name: remotion
description: Create, build, and render programmatic videos with React using Remotion. Covers scaffolding, compositions, frame-driven animation, transitions, fonts, media, dynamic metadata, and rendering (local + Lambda). Aligned with Remotion 4.0.x.
---

# Remotion — Programmatic Video with React

Build real MP4/WebM/ProRes videos with React components. Remotion renders **each frame independently** as a React tree, then stitches them with FFmpeg. Current version: **4.0.472** (`npx create-video@latest` always scaffolds latest).

## ⚠️ The One Rule That Breaks Everyone

**CSS transitions, CSS `@keyframes`, and Tailwind `animate-*` classes DO NOTHING.** Each frame is rendered in isolation with no time continuity, so the browser never "plays" an animation. **All motion must be derived from the current frame number.** Drive every animated value through `useCurrentFrame()` + `interpolate()` / `spring()`.

```tsx
// ❌ WRONG — renders a static frame, no animation
<div className="transition-opacity duration-500" style={{ opacity: 1 }} />

// ✅ RIGHT — value is a pure function of the frame
const opacity = interpolate(frame, [0, 15], [0, 1], { extrapolateRight: 'clamp' });
<div style={{ opacity }} />
```

## Step 0: Bootstrap (if no project yet)

```bash
npx create-video@latest      # pick a template: Blank, Hello World, Three, Still, Overlay, Audiogram
cd <project> && npm i
```

## Core API

| Symbol | What it is |
|---|---|
| `<Composition>` | Registers a renderable video: `id`, `component`, `durationInFrames`, `fps`, `width`, `height` |
| `useCurrentFrame()` | Current frame (0-based). The heartbeat of all animation. |
| `useVideoConfig()` | `{ fps, width, height, durationInFrames }` |
| `interpolate(frame, [inMin,inMax], [outMin,outMax], opts)` | Map a frame range → value range. Pass `extrapolateLeft/Right: 'clamp'` and `easing`. |
| `spring({ frame, fps, config })` | Physics-based spring, returns ~0→1 |
| `Easing` | Curves: `Easing.bezier(.16,1,.3,1)`, `Easing.inOut(Easing.cubic)`, etc. |
| `<Sequence from durationInFrames>` | Time-shifts children; negative `from` trims the start |
| `<Series>` | Plays children back-to-back without manual frame math |
| `<AbsoluteFill>` | `position:absolute` full-bleed container |
| `<Img>` / `<OffthreadVideo>` / `<Audio>` | Media — use these, **never** native `<img>/<video>/<audio>` |
| `staticFile('x.png')` | Resolves an asset in `/public` |
| `random(seed)` | Deterministic RNG — use instead of `Math.random()` (which flickers) |

## Step 1: Register a Composition (`src/Root.tsx`)

```tsx
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot = () => (
  <Composition
    id="MyVideo"
    component={MyVideo}
    durationInFrames={150}
    fps={30}
    width={1920}
    height={1080}
    defaultProps={{ title: 'Hello' } satisfies { title: string }}
  />
);
```

## Step 2: Build the Component (`src/MyVideo.tsx`)

```tsx
import { useCurrentFrame, useVideoConfig, interpolate, spring, Easing, AbsoluteFill } from 'remotion';

export const MyVideo: React.FC<{ title: string }> = ({ title }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const opacity = interpolate(frame, [0, fps], [0, 1], {
    extrapolateRight: 'clamp',
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });
  const scale = spring({ frame, fps, config: { damping: 200 } });

  return (
    <AbsoluteFill style={{ backgroundColor: '#0b0b0f', justifyContent: 'center', alignItems: 'center' }}>
      <div style={{ opacity, transform: `scale(${scale})`, fontSize: 90, color: 'white' }}>{title}</div>
    </AbsoluteFill>
  );
};
```

## Step 3: Preview

```bash
npx remotion studio        # http://localhost:3000 — scrub timeline, live reload
```

## Step 4: Render

```bash
npx remotion render                         # interactive picker
npx remotion render MyVideo out/video.mp4   # explicit composition + output
npx remotion render MyVideo out/video.mp4 --props='{"title":"Hi"}'   # JSON string or path to .json
npx remotion render MyVideo out/video.mp4 --concurrency=4            # parallelize frames
npx remotion still  MyVideo out/frame.png --frame=30 --scale=0.25    # one frame, fast sanity check
```

Audio-only: render to `out/audio.mp3`. Transparent video: `--codec=prores --prores-profile=4444 --pixel-format=yuva444p10le --image-format=png` (`.mov`) or `--codec=vp9 --pixel-format=yuva420p --image-format=png` (`.webm`).

## Timing & Animation Patterns

```tsx
// Fade in
const opacity = interpolate(frame, [0, 20], [0, 1], { extrapolateRight: 'clamp' });

// Slide in from left
const x = interpolate(frame, [0, 20], [-200, 0], { extrapolateRight: 'clamp', easing: Easing.out(Easing.cubic) });

// One progress value → many properties (keeps timing coherent)
const progress = interpolate(frame, [0, 30], [0, 1], { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' });
const overlayX = interpolate(progress, [0, 1], [100, 0]);
const blur     = interpolate(progress, [0, 1], [10, 0]);

// Stagger children
{items.map((item, i) => (
  <Sequence key={i} from={i * 10}><Item data={item} /></Sequence>
))}
```

## Scene Transitions — `@remotion/transitions`

```tsx
import { TransitionSeries, linearTiming } from '@remotion/transitions';
import { fade } from '@remotion/transitions/fade';
// also: slide, wipe, flip, clockWipe, cross-zoom

<TransitionSeries>
  <TransitionSeries.Sequence durationInFrames={60}><SceneA /></TransitionSeries.Sequence>
  <TransitionSeries.Transition presentation={fade()} timing={linearTiming({ durationInFrames: 15 })} />
  <TransitionSeries.Sequence durationInFrames={60}><SceneB /></TransitionSeries.Sequence>
</TransitionSeries>
```

## Media

```tsx
import { OffthreadVideo, Img, Audio, staticFile } from 'remotion';

// Video — OffthreadVideo is render-accurate. Trim with frames (NOT deprecated startFrom/endAt)
<OffthreadVideo src={staticFile('clip.mp4')} trimBefore={60} trimAfter={120} />

// Image
<Img src={staticFile('logo.png')} />

// Audio offset by 2s
<Audio src={staticFile('music.mp3')} trimBefore={2 * fps} />
```

## Fonts

```tsx
// Google font — blocks render until ready automatically
import { loadFont } from '@remotion/google-fonts/Inter';
const { fontFamily } = loadFont('normal', { weights: ['400', '700'], subsets: ['latin'] });

// Local font
import { loadFont } from 'remotion';
loadFont({ family: 'Brand', url: staticFile('Brand.woff2'), format: 'woff2' });
```

## Dynamic Duration / Props — `calculateMetadata`

Runs **once before render**; perfect for "make the video as long as this audio/data".

```tsx
import { Composition, CalculateMetadataFunction } from 'remotion';

const calculateMetadata: CalculateMetadataFunction<{ videoId: string }> = async ({ props, abortSignal }) => {
  const data = await fetch(`/api/${props.videoId}`, { signal: abortSignal }).then(r => r.json());
  return { durationInFrames: Math.ceil(data.seconds * 30), props: { ...props, url: data.url } };
};

<Composition id="Dyn" component={Dyn} fps={30} width={1080} height={1080}
  defaultProps={{ videoId: 'abc' }} calculateMetadata={calculateMetadata} />
```

## Schema-Validated Props (editable in Studio)

```tsx
import { z } from 'zod';
import { zColor } from '@remotion/zod-types';
export const schema = z.object({ title: z.string(), color: zColor() });
<Composition schema={schema} defaultProps={{ title: 'Hi', color: '#fff' }} ... />
```

## Async Loading (data, Lottie, maps) — `delayRender`

Block the frame until your async work resolves, or the render captures an empty frame.

```tsx
import { useDelayRender, cancelRender } from 'remotion';
const { delayRender, continueRender } = useDelayRender();
const [handle] = useState(() => delayRender('loading data'));
useEffect(() => { fetchData().then(() => continueRender(handle)).catch(cancelRender); }, [handle]);
```

## Config (`remotion.config.ts`)

```ts
import { Config } from '@remotion/cli/config';
Config.setVideoImageFormat('jpeg');
Config.setConcurrency(4);
Config.setChromiumOpenGlRenderer('angle'); // required for WebGL / Three.js / maps
```

## Rendering on AWS Lambda

```bash
npx remotion lambda functions deploy
npx remotion lambda sites create src/index.ts --site-name=my-video
npx remotion lambda render <serve-url> MyVideo --delete-after="1-day"
```

## Ecosystem packages

`@remotion/transitions` · `@remotion/google-fonts` · `@remotion/three` (`<ThreeCanvas>`, drive with `useCurrentFrame()` not `useFrame()`) · `@remotion/gif` (`<AnimatedImage>`, `getGifDurationInSeconds`) · `@remotion/lottie` · `@remotion/media-utils` (`visualizeAudio`, `getAudioData`) · `@remotion/captions` · `@remotion/zod-types` · `@remotion/media` (next-gen `<Video>`/`<Audio>`).

## Troubleshooting

- **Nothing animates** → you used CSS transitions/Tailwind animation. Drive it from `useCurrentFrame()`.
- **Flicker / non-determinism** → replace `Math.random()`/`Date.now()` with `random(seed)` from `remotion`.
- **Blank frames for images/data** → wrap async work in `delayRender()` / `continueRender()`.
- **Font not applied at render** → use `@remotion/google-fonts` `loadFont()` (auto-blocks) or `WaitForFonts` HOC.
- **Video out of sync / wrong frame** → use `<OffthreadVideo>` (not `<Video>`) and `trimBefore`/`trimAfter`.
- **Slow render** → `--concurrency=<n>`; lower `--scale` for drafts; prefer `jpeg` image format.
- **WebGL2 unavailable** → render with `--gl=angle` or `Config.setChromiumOpenGlRenderer('angle')`.
