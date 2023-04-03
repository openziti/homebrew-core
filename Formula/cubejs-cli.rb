require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.18.tgz"
  sha256 "78c77669afd94bc3096e42c3353d2f6cf7a92c9abbede381f7ae12ce34447501"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb4d906f29534b3aa220241a378b8f16519d34bed9f1de54198e31f05740796"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb4d906f29534b3aa220241a378b8f16519d34bed9f1de54198e31f05740796"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb4d906f29534b3aa220241a378b8f16519d34bed9f1de54198e31f05740796"
    sha256 cellar: :any_skip_relocation, ventura:        "135735f9d46b424b1269de5694ad1bcff7fe58b915ed0012bc25d16b252d0718"
    sha256 cellar: :any_skip_relocation, monterey:       "135735f9d46b424b1269de5694ad1bcff7fe58b915ed0012bc25d16b252d0718"
    sha256 cellar: :any_skip_relocation, big_sur:        "135735f9d46b424b1269de5694ad1bcff7fe58b915ed0012bc25d16b252d0718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb4d906f29534b3aa220241a378b8f16519d34bed9f1de54198e31f05740796"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
