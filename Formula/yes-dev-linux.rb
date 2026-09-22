class YesDevLinux < Formula
  desc "Auto-approve Chrome's Allow remote debugging prompt (Linux AT-SPI port of yes-dev)"
  homepage "https://github.com/neronlux/yes-dev-linux"
  url "https://github.com/neronlux/yes-dev-linux/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "4008e07b808003f96d34e5a3c0e1cf31251fd0fbf9a53d6f8103aadcc516179c"
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

      System packages required (Ubuntu/Debian):
        sudo apt install python3-gi gir1.2-atspi-2.0
      The experimental keyboard fallback additionally needs ydotoold running.

      Start OBSERVE-ONLY first and capture a live prompt before arming clicks:
        yes-dev-linux --observe
        yes-dev-linux --probe

      Then, to run persistently (restarts at login):
        brew services start yes-dev-linux
      or run armed in the foreground:
        yes-dev-linux --enable-click

      NOTE: --observe always wins over --enable-click. Logs live at
      ~/.local/share/YesDev/yes-dev.log (approvals are [ACTION] lines).
      Auto-approving lets ANY local process attach to your signed-in
      browser - see the README before arming the clicker:
        https://github.com/neronlux/yes-dev-linux
    EOS
  end

  test do
    assert_match "Linux engine", shell_output("#{bin}/yes-dev-linux --help")
    # Keep bytecode out of the read-only Cellar.
    system "env", "PYTHONPYCACHEPREFIX=#{testpath}/pycache", "/usr/bin/python3",
           "-m", "py_compile", libexec/"watcher_linux.py", libexec/"platform_linux.py"
  end
end
