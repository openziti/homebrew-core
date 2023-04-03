class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.70",
      revision: "f0d1f948f266b6801d915a0c5f852cf1836bebeb"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61042d31b6c87913d11854560bf924d09c15fd6182e46e6938a9cb90f5dedaa6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61042d31b6c87913d11854560bf924d09c15fd6182e46e6938a9cb90f5dedaa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47383c14ac4f6ad8209e068cb2926095e53bbad0263eec0cee13fad112458c72"
    sha256 cellar: :any_skip_relocation, ventura:        "865b7145aeca13ff91219db920f54794a7505ae99a526ab629fe65bc6dfa047e"
    sha256 cellar: :any_skip_relocation, monterey:       "865b7145aeca13ff91219db920f54794a7505ae99a526ab629fe65bc6dfa047e"
    sha256 cellar: :any_skip_relocation, big_sur:        "865b7145aeca13ff91219db920f54794a7505ae99a526ab629fe65bc6dfa047e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58f623acaf4ad54e17abe853483d7fb8a58a8bf75765466fdb35f1536803c77"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
