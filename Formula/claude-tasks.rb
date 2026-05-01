class ClaudeTasks < Formula
  desc "Per-project persistent task tracking for Claude Code with cross-project prioritisation"
  homepage "https://github.com/aaronmeza/claude-tasks"
  url "https://github.com/aaronmeza/claude-tasks/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "61dccc34daa1c97124b9b62393a3da45d728b981d504fd8a0c7df3cfe163454c"
  license "MIT"
  head "https://github.com/aaronmeza/claude-tasks.git", branch: "main"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/claude-tasks"
  end

  def caveats
    <<~EOS
      claude-tasks needs to wire its skills, scripts, and hooks into ~/.claude/
      to be useful. brew installed the source and put `claude-tasks` on your
      PATH; finish setup with:

        claude-tasks install

      That step is interactive-safe and idempotent. It symlinks skills into
      ~/.claude/skills/, scripts into ~/.claude/scripts/, adds SessionStart
      and SessionEnd hooks to ~/.claude/settings.json (preserving existing
      hooks), and seeds ~/.claude/active-repos.yaml from the example if you
      don't already have one.

      To check current state:    claude-tasks status
      To remove (keeps tasks):   claude-tasks uninstall

      After upgrading via `brew upgrade claude-tasks`, re-run
      `claude-tasks install` to refresh symlinks pointing at the new cellar
      path.
    EOS
  end

  test do
    assert_match "claude-tasks 0.2.0", shell_output("#{bin}/claude-tasks version")
    assert_match "Usage: claude-tasks", shell_output("#{bin}/claude-tasks help")
  end
end
