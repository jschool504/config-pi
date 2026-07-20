---
title: "UI/UX — Layout States and Progression"
tags: [prototype-web-builder,ui-ux,layout,chat,sidebar,progress-bar,magic-loading]
created: 2026-07-20
hits: 1
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
