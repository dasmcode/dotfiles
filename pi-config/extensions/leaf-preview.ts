import type {
  ExtensionAPI,
  MarkdownTransformContext,
} from "@earendil-works/pi-coding-agent";
import { spawnSync } from "node:child_process";

/**
 * Render one assistant Markdown block with Leaf's renderer, returning ANSI
 * text that Pi's native Markdown component can display in the transcript.
 */
function renderWithLeaf(markdown: string, availableWidth: number): string {
  const args = [`--inline=ansi:${Math.max(20, availableWidth)}`];
  if (process.env.LEAF_THEME) args.unshift("--theme", process.env.LEAF_THEME);

  const result = spawnSync(process.env.LEAF_PATH || "leaf", args, {
    input: markdown,
    encoding: "utf8",
    env: {
      ...process.env,
      TERM: process.env.TERM || "xterm-256color",
    },
  });

  if (result.error || result.status !== 0) {
    // Falling back to Pi's renderer is safer than breaking the transcript if
    // Leaf is unavailable or cannot render a particular Markdown construct.
    return markdown;
  }

  return String(result.stdout).replace(/\n+$/, "");
}

export default function (pi: ExtensionAPI) {
  // Session-local toggle. Assistant messages are still rendered by Pi's normal
  // transcript component; only their Markdown transform is replaced.
  let leafEnabled = process.env.LEAF_PREVIEW_AUTO === "1";

  pi.registerMarkdownTransformer((markdown: string, context: MarkdownTransformContext) => {
    if (!leafEnabled || context.messageType !== "assistant") return markdown;
    return renderWithLeaf(markdown, context.availableWidth);
  });

  pi.registerCommand("leaf-toggle", {
    description: "Toggle Leaf rendering for assistant responses in Pi's chat",
    handler: async (_args, ctx) => {
      leafEnabled = !leafEnabled;

      ctx.ui.setStatus("leaf-markdown", leafEnabled ? "Leaf Markdown: on" : undefined);
      ctx.ui.notify(
        leafEnabled
          ? "Leaf Markdown rendering enabled for the chat."
          : "Leaf Markdown rendering disabled; using Pi's native renderer.",
        "info",
      );

      // Rebuilding assistant components makes the transformer run for messages
      // already in the transcript, so the toggle applies to the whole session
      // immediately instead of waiting for a new turn. Pi exposes this setter
      // as the public way to refresh existing assistant components.
      ctx.ui.setHiddenThinkingLabel();
    },
  });
}
