# Design System Strategy: The 8-Bit Botanist

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"Tactile Digital Nostalgia."** 

We are not merely creating a "retro-themed" app; we are designing a high-end, handheld laboratory device that exists in a parallel 1990s timeline. This system rejects the modern "flat" trend in favor of **Lush Pixelation**. We move beyond the "template" look by utilizing intentional asymmetry—think of a physical Pokedex where one side has a heavy mechanical hinge and the other a sleek scanning lens. By using the rigid 0px roundedness scale, we embrace the "Digital Brutalism" of early computing, but elevate it through sophisticated tonal layering and vibrant botanical contrast.

## 2. Colors & Surface Philosophy
The palette balances high-energy "Vibrant Botanical" greens against grounded "Earthy" neutrals. 

*   **Primary (#007523) & Primary Container (#8efe91):** These represent the life force of the flora. Use the `primary_container` for large background areas and `primary` for high-impact 8-bit accents.
*   **Secondary (#9a511e) & Tertiary (#7b6100):** These are your "Field Equipment" colors. Use them for secondary actions that feel like physical buttons or switches.
*   **The "No-Line" Rule:** Standard 1px lines are strictly prohibited for sectioning. In a pixel-art world, boundaries are defined by **Color Blocks**. To separate a plant description from its stats, shift the background from `surface_container` to `surface_container_high`.
*   **Surface Hierarchy & Nesting:** Treat the screen as a physical PCB (Printed Circuit Board). 
    *   **Base:** `surface` (#fdffda) – The "chassis."
    *   **Nested Modules:** Use `surface_container_low` for inset content areas.
    *   **Floating "Glass" Modules:** For a premium feel, use `surface_container_highest` with a 90% opacity and a subtle `backdrop-blur` to simulate a thick, retro LCD screen.
*   **Signature Textures:** For Hero CTAs, use a linear gradient from `primary` (#007523) to `primary_dim` (#00671e) at a 45-degree angle. This adds a "backlit" depth that a flat color cannot achieve.

## 3. Typography
Typography in this system is a tension between "The Machine" and "The Researcher."

*   **The Machine (Display & Headlines):** Use **'Press Start 2P'** (mapped to `display` and `headline` tokens). This font is demanding; use it sparingly. It should feel like the OS is communicating to the user.
*   **The Researcher (Body & Labels):** We pair the pixel font with **'Manrope'** for body text and **'Space Grotesk'** for labels. This ensures that while the "vibe" is retro, the actual data—the scientific plant names and care instructions—is highly legible and editorial.
*   **Scale Hierarchy:**
    *   `display-lg`: The "Species Name" on a scan result.
    *   `title-md`: Sub-headers within a plant's profile (Manrope).
    *   `label-sm`: Metadata like "Sunlight Required" (Space Grotesk).

## 4. Elevation & Depth: Tonal Layering
Since we have a **0px roundedness constraint**, we cannot rely on rounded corners to soften the UI. Depth must be achieved through "Stacking."

*   **The Layering Principle:** To create a card, do not use a shadow. Instead, place a `surface_container_lowest` (#ffffff) box on top of a `surface_container` (#f6f3eb) background. This creates a "Paper on Table" effect.
*   **Ambient Shadows (The "CRT Glow"):** When an element must "float" (like a Modal), use a shadow color tinted with `on_surface` (#383833) at 6% opacity with a massive 32px blur. It should feel like a soft glow from an old monitor, not a drop shadow.
*   **The Ghost Border Fallback:** For high-density data, use a "Ghost Border." Apply `outline_variant` at 20% opacity. This provides a structural hint without breaking the organic feel of the botanical colors.

## 5. Components

### Buttons (The "Tactile Switch")
*   **Primary:** Solid `primary` background. No border. Text is `on_primary` in 'Press Start 2P'. 
*   **Secondary:** `secondary_container` background. 
*   **Interaction:** On "Press," shift the background to the `_dim` variant and use a 2px offset (manual "push" effect) instead of a color change alone.

### Pixel-Cards (The "Data Chip")
*   Forbid divider lines. Use a 1.3rem (`spacing-6`) vertical gap between sections.
*   The card "header" should be a solid block of `tertiary_container`, with the body of the card being `surface_container_lowest`.

### Input Fields (The "Command Line")
*   Background: `surface_container_low`. 
*   Border: Bottom-only "Ghost Border" using `primary` at 40% opacity.
*   Typography: Manrope for user input, 'Press Start 2P' for the Label.

### Botanical Progress Bars
*   Track: `surface_container_highest`.
*   Indicator: A pixelated gradient from `primary_fixed` to `primary`.

### Navigation (The "Menu Bar")
*   Use asymmetric placement. Instead of a centered bottom nav, dock the "Capture" button to the far right with a `secondary` color, creating a "Thumb-Trigger" feel.

## 6. Do's and Don'ts

### Do:
*   **Do** use the Spacing Scale strictly. 8-bit aesthetics rely on "the grid." Use `spacing-4` (0.9rem) as your default padding.
*   **Do** overlap elements. Let a pixelated leaf icon break the boundary of a container to create "Organic Brutalism."
*   **Do** use high-contrast color shifts to indicate state changes (e.g., from `surface` to `primary_container` when a plant is "discovered").

### Don't:
*   **Don't** use any border-radius. Every corner must be a sharp 90-degree angle to maintain the 8-bit integrity.
*   **Don't** use standard "Material" shadows. They feel too modern and "greasy" for a retro-gaming aesthetic.
*   **Don't** use 'Press Start 2P' for blocks of text longer than 5 words. It destroys readability and creates "Visual Noise."