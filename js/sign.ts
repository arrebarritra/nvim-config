const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

function get_vs_code_install_dir() {
    try {
        const result = execFileSync("where.exe", ["code"], {
            encoding: "utf8",
            stdio: ["ignore", "pipe", "ignore"],
        });

        const loc = result.trim().split(/\r?\n/)[0];
        return path.normalize(path.join(loc, '..', '..'));
    } catch {
        // "code" not found in PATH
    }
    throw new Error("Could not locate VS Code installation");
}

declare module vsda {
    export class signer {
        sign(arg: string): string;
    }
    export class validator {
        createNewMessage(arg: string): string;
        validate(arg: string): 'ok' | 'error';
    }
}

function find_vsda(root: string) {
    const candidates = [
        path.join(root, "resources", "app", "node_modules", "vsda",
            "build", "Release", "vsda.node"),
    ];

    // Search version/hash-specific subdirectories.
    for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
        if (entry.isDirectory()) {
            candidates.push(
                path.join(root, entry.name, "resources", "app",
                    "node_modules", "vsda", "build", "Release",
                    "vsda.node")
            );
        }
    }

    return candidates.find(fs.existsSync);
}

vsda_location = find_vsda(get_vs_code_install_dir())
if (!vsda_location) {
    throw new Error("Could not find vsda.node");
}

const a: typeof vsda = require(vsda_location);
const signer: vsda.signer = new a.signer();
process.argv.forEach((value, index, array) => {
    if (index >= 2) {
        const r = signer.sign(value);
        console.log(r);
    }
});
