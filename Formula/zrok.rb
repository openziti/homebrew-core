require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok.git",
    tag: "v0.3.5-rc1", revision: "505b6e65e0718d6efd1506d2aab27ec1ce5e0a40"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd dir/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    cd dir do
      ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
                 "-X github.com/openziti/zrok/build.Hash=#{Utils.git_head}"]
      system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
    end
  end

  test do
    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)
  end
end
