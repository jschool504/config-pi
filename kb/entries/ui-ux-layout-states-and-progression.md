---
title: "UI/UX — Layout States and Progression"
tags: [prototype-web-builder,ui-ux,layout,chat,sidebar,progress-bar,magic-loading]
created: 2026-07-20
updated: 2026-07-21
hits: 2
---
## Layout States
- **Phase 1: Full-Screen Chat** — On session start, the entire viewport is a chat interface. User describes their project freely.
- **Phase 2: Sidebar View** — After Discovery stage completes, the layout transitions to a sidebar (chat) + main area (live preview). This is triggered by the `next_stage` tool call from Discovery → Layout.

## Magic Loading State
- During layout transitions (e.g., chat → sidebar swap), a "magic loading state" is displayed
- Uses animated placeholder/ghost elements to mask the transition smoothly
- Prevents jarring visual shifts between layout modes

## Visual Progress Bar
- Located in the header, reflects current stage progression (5 stages total)
- Updates atomically when LLM triggers a `next_stage` tool call
- Visual feedback: filled segments for completed stages, animated segment for current stage, outline for remaining
- Users can see how far along the design process is at a glance

## Chat UI Enhancements
- Tool calls (apply_mockup, update_section, next_stage) rendered as structured action cards within the chat stream
- Users can see what the LLM is doing, not just the final result
- Silent validation errors are invisible to the user — corrections happen backend-side

### Update: 2026-07-21 (corrected)

## Three-State UI System

### View States
- **Landing** — Full-screen centered prompt. Minimalist entry point with a single input field centered on screen.
- **Discovery** — Full-screen minimalist chat. User describes their project freely; input anchored at bottom, disabled during preview generation.
- **Sidebar** — Split-pane layout: chat on one side, live preview on the other. Activated after Discovery stage completes via LLM-triggered stage transition.

### Transitions
- **Landing → Discovery**: On initial submit, snaps into full-screen chat view.
- **Discovery → Sidebar**: Triggered by `next_stage` tool call from LLM at end of Discovery stage.

### State Enums
- `AppState`: `'Landing' | 'Discovery' | 'Sidebar'` — controls which view is rendered
- `PreviewState`: `'Idle' | 'Loading' | 'Ready'` — controls preview panel behavior

### Preview Loading UX
- Skeleton loader with `animate-pulse` blocks displayed during preview generation
- Prevents jarring blank-space during loading transitions
- Input field disabled while preview is in `Loading` state
