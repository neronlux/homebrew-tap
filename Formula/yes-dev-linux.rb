class YesDevLinux < Formula
  desc "Auto-approve Chrome's Allow remote debugging prompt (Linux AT-SPI port of yes-dev)"
  homepage "https://github.com/neronlux/yes-dev-linux"
  url "https://github.com/neronlux/yes-dev-linux/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "5a1814d87c2119c2c3a6f8cafdbc61d15b658e9ee1ccf270cca0d7cb1ee07bd1"
  license "MIT"
  head "https://github.com/neronlux/yes-dev-linux.git", branch: "main"

  depends_on :linux

  def install
    libexec.install "watcher_linux.py", "platform_linux.py", "auto_click.py"
    (bin/"yes-dev-linux").write <<~EOS
      #!/bin/sh
      # System python carries python3-gi (brew python has no AT-SPI typelibs).
      exec /usr/bin/python3 #{libexec}/watcher_linux.py "$@"
    EOS
  end

  service do
    run [opt_bin/"yes-dev-linux", "--enable-click"]
    keep_alive true
    log_path var/"log/yes-dev-linux.log"
    error_log_path var/"log/yes-dev-linux.log"
    working_dir var
  end

  def caveats
    <<~EOS
      Linux-only (AT-SPI). On macOS use the upstream build instead:
        https://github.com/dev-newb/yes-dev

      System packages required (Ubuntu/Debian; python3-dbus is dbus-python,
      needed for the portal screenshot — the plain dbus daemon is not enough):
        sudo apt install python3-gi gir1.2-atspi-2.0 python3-pil python3-evdev python3-dbus
      Auto-click creates its own absolute uinput pointer, so the user needs
      write access to /dev/uinput (e.g. udev rule GROUP="input" + membership).

      Start OBSERVE-ONLY first and capture a live prompt before arming:
        yes-dev-linux --observe
        yes-dev-linux --probe

      Then, armed and persistent (restarts at login):
        brew services start yes-dev-linux
      or armed in the foreground:
        yes-dev-linux --enable-click

      SECURITY: auto-approving lets ANY local process attach to your
      signed-in browser. --observe always wins over --enable-click; the
      burst guard pauses after 60 approvals/min. Approvals are [ACTION]
      lines in ~/.local/share/YesDev/yes-dev.log. Full field record:
        https://github.com/neronlux/yes-dev-linux/blob/main/TESTING.md
      Contributing, tests, and calibration captures:
        https://github.com/neronlux/yes-dev-linux/blob/main/CONTRIBUTING.md
    EOS
  end

  test do
    assert_match "Linux engine", shell_output("#{bin}/yes-dev-linux --help")
    assert_match "enable-click", shell_output("#{bin}/yes-dev-linux --help")
    # Keep bytecode out of the read-only Cellar.
    system "env", "PYTHONPYCACHEPREFIX=#{testpath}/pycache", "/usr/bin/python3",
           "-m", "py_compile", libexec/"watcher_linux.py", libexec/"platform_linux.py",
           libexec/"auto_click.py"
  end
end
