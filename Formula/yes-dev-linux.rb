class YesDevLinux < Formula
  desc "Watch for Chrome's Allow remote debugging prompt (Linux AT-SPI port of yes-dev)"
  homepage "https://github.com/neronlux/yes-dev-linux"
  url "https://github.com/neronlux/yes-dev-linux/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3a0ceb2310555f6e42a61ba1b3fc1b84986cb00d68baf8063226cd8b902c086c"
  license "MIT"
  head "https://github.com/neronlux/yes-dev-linux.git", branch: "main"

  depends_on :linux

  def install
    libexec.install "watcher_linux.py", "platform_linux.py"
    (bin/"yes-dev-linux").write <<~EOS
      #!/bin/sh
      # System python carries python3-gi (brew python has no AT-SPI typelibs).
      exec /usr/bin/python3 #{libexec}/watcher_linux.py "$@"
    EOS
  end

  service do
    run [opt_bin/"yes-dev-linux", "--observe"]
    keep_alive true
    log_path var/"log/yes-dev-linux.log"
    error_log_path var/"log/yes-dev-linux.log"
    working_dir var
  end

  def caveats
    <<~EOS
      Linux-only watchdog (AT-SPI). On macOS use the upstream build instead:
        https://github.com/dev-newb/yes-dev

      System packages required (Ubuntu/Debian):
        sudo apt install python3-gi gir1.2-atspi-2.0

      v0.6 status: the engine DETECTS the consent dialog (proven live) but
      does not click it - field work proved no synthetic input reaches
      Chrome's secure Views bubble on Wayland, so auto-approve is blocked
      by the platform. It logs candidates with window geometry for a
      human to click. If your stack exposes the button (e.g. X11), the
      AT-SPI Action path still approves it.

      Start in observe mode and capture a live prompt before anything else:
        yes-dev-linux --observe
        yes-dev-linux --probe

      Then, to watch persistently (restarts at login):
        brew services start yes-dev-linux

      NOTE: approvals would appear as [ACTION] lines; candidate sightings
      are WARN lines. Logs also live at ~/.local/share/YesDev/yes-dev.log.
      Full findings: https://github.com/neronlux/yes-dev-linux/blob/main/TESTING.md
    EOS
  end

  test do
    assert_match "Linux engine", shell_output("#{bin}/yes-dev-linux --help")
    # Keep bytecode out of the read-only Cellar.
    system "env", "PYTHONPYCACHEPREFIX=#{testpath}/pycache", "/usr/bin/python3",
           "-m", "py_compile", libexec/"watcher_linux.py", libexec/"platform_linux.py"
  end
end
