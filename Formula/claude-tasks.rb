class ClaudeTasks < Formula
  desc "Per-project persistent task tracking for Claude Code with cross-project prioritisation"
  homepage "https://github.com/aaronmeza/claude-tasks"
  url "https://github.com/aaronmeza/claude-tasks/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "743bb94fbb342a65e9d08806269ba8b8c585280d943764a088390a2f5a8c3de4"
  license "MIT"
  head "https://github.com/aaronmeza/claude-tasks.git", branch: "main"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/claude-tasks"
  end

  # No post_install: Homebrew's macOS sandbox forbids writes to ~/.claude
  # during install/upgrade. The claude-tasks binary auto-wires on its
  # next invocation if symlinks don't point at the current cellar - so
  # `claude-tasks status` (or any other command) right after install
  # finishes the setup. Ditto on `brew upgrade`.

  def caveats
    <<~EOS
      claude-tasks auto-wires its skills, scripts, and hooks into
      ~/.claude/ on its first invocation. To trigger now and verify:

        claude-tasks status

      The same auto-wire fires after `brew upgrade claude-tasks` on the
      next claude-tasks command (or the next Claude Code session) -
      symlinks always point at the current cellar.

      Useful commands:
        claude-tasks status        what's installed
        claude-tasks install       force-rewire (rare; auto handles it)
        claude-tasks uninstall     remove symlinks + hook entries (keeps tasks.json)
    EOS
  end

  test do
    assert_match "claude-tasks 0.5.2", shell_output("#{bin}/claude-tasks version")
    assert_match "Usage: claude-tasks", shell_output("#{bin}/claude-tasks help")
  end
end
