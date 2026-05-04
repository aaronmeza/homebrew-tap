class ClaudeTasks < Formula
  desc "Per-project persistent task tracking for Claude Code with cross-project prioritisation"
  homepage "https://github.com/aaronmeza/claude-tasks"
  url "https://github.com/aaronmeza/claude-tasks/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3308c3a2c37cf7a9f1abfdeef98a09f5c1874d2dffb110c210b1c6ca42616fe2"
  license "MIT"
  head "https://github.com/aaronmeza/claude-tasks.git", branch: "main"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/claude-tasks"
  end

  # Runs after `brew install` AND on every version-changing `brew upgrade`.
  # Idempotent: install.sh removes any existing symlinks before re-creating
  # them, so an upgrade refreshes pointers to the new cellar path. We do
  # this here so users don't have to remember a follow-up command.
  def post_install
    system libexec/"install.sh"
  end

  # When `brew uninstall claude-tasks` removes the cellar, the symlinks at
  # ~/.claude/skills/* and ~/.claude/scripts/* would dangle. Tear them down
  # cleanly. tasks.json files in user repos and ~/.claude/active-repos.yaml
  # are preserved (uninstall.sh only touches symlinks and hook entries).
  def post_uninstall
    if (libexec/"uninstall.sh").exist?
      system libexec/"uninstall.sh"
    end
  end

  def caveats
    <<~EOS
      claude-tasks is wired in:
        - skills      ~/.claude/skills/{tasks-sync,standup}
        - scripts     ~/.claude/scripts/
        - hooks       SessionStart + SessionEnd in ~/.claude/settings.json
        - config      ~/.claude/active-repos.yaml (stub created on first install)

      Open a Claude Code session in any git repo and the SessionStart hook
      will prompt to track that repo. End-of-session, run /tasks-sync to
      capture work.

      Useful commands:
        claude-tasks status        what's installed
        claude-tasks uninstall     remove symlinks + hook entries (keeps tasks.json)
    EOS
  end

  test do
    assert_match "claude-tasks 0.2.1", shell_output("#{bin}/claude-tasks version")
    assert_match "Usage: claude-tasks", shell_output("#{bin}/claude-tasks help")
  end
end
