class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.4.4",
      revision: "258ea5df3b3200df5f928b3f326cec7a1257433d"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f24d2e4434dccfbfb713f622d5b9611696b360842eed681fc53df0b85bf29d8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61b21372c2b924ea4f804f43c0bd4342d1f12ffdfd2ddffba61535ccec9a33ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa1f7165b46622bff9605e84bd76b43379226b64828524c48a33b0c5fedc0a88"
    sha256 cellar: :any_skip_relocation, ventura:        "3404a14096433ad3ee32f01f9698e983ca2ed2f9c711be7ed47b3b6b5745e3a8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4e96cb06150ab88d9f9e73e435fcfd82999d5fbb9756308411255a8e5c3d95"
    sha256 cellar: :any_skip_relocation, big_sur:        "224896af2b1bb95631c9eb8c2e17a6d4f34e9a56e8d5f3d13cde74c14bd533a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a014cda1d8f83f83680f5e45664c991ddc0297db36bfbdd57e69f38ee83da5"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish", "ArchiSteamFarm",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec

    (bin/"asf").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/ArchiSteamFarm.dll" "$@"
    EOS

    etc.install libexec/"config" => "asf"
    rm_rf libexec/"config"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}/asf/.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
