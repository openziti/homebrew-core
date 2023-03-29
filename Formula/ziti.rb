class Ziti < Formula
  desc "Fully zero trust, application embedded, programmable network"
  homepage "https://openziti.io"
  url "https://github.com/openziti/ziti.git",
    tag: "v0.27.5", revision: "722181191f5852a9d2c253838bcaaaeedb7acc0a"
  license "Apache-2.0"
  head "https://github.com/openziti/ziit.git", branch: "main"

  depends_on "go" => :build

  def install
    build_info = File.new(buildpath/"common/version/info_generated.go", "w")
    build_info.puts("/*")
    build_info.puts(" * Copyright NetFoundry, Inc.")
    build_info.puts(" *")
    build_info.puts(" * Licensed under the Apache License, Version 2.0 (the \"License\");")
    build_info.puts(" * you may not use this file except in compliance with the License.")
    build_info.puts(" * You may obtain a copy of the License at")
    build_info.puts(" *")
    build_info.puts(" * https://www.apache.org/licenses/LICENSE-2.0")
    build_info.puts(" *")
    build_info.puts(" * Unless required by applicable law or agreed to in writing, software")
    build_info.puts(" * distributed under the License is distributed on an \"AS IS\" BASIS,")
    build_info.puts(" * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.")
    build_info.puts(" * See the License for the specific language governing permissions and")
    build_info.puts(" * limitations under the License.")
    build_info.puts(" *")
    build_info.puts(" */")
    build_info.puts("")
    build_info.puts("package version")
    build_info.puts("")
    build_info.puts("const (")
    build_info.puts("	Version   = \"v0.27.5\"")
    build_info.puts("	Revision  = \"722181191f58\"")
    build_info.puts("	Branch    = \"main\"")
    build_info.puts("	BuildUser = \"Homebrew\"")
    build_info.puts("	BuildDate = \"#{Time.now.strftime("%Y/%m/%d %H:%M:%S")}\"")
    build_info.puts(")")
    build_info.close
    system "go", "build", *std_go_args, "github.com/openziti/ziti/ziti"
  end

  test do
    version_output = shell_output("#{bin}/ziti --version")
    assert_match(version.to_s, version_output)
  end
end
