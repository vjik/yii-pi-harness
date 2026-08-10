/**
 * Exit Command Extension
 *
 * Adds a /exit command that allows cleanly shutting down pi.
 *
 * @see https://github.com/earendil-works/pi/issues/5863
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("exit", {
		description: "Exit Pi (alias for /quit)",
		handler: async (_args, ctx) => {
			ctx.shutdown();
		},
	});
}
