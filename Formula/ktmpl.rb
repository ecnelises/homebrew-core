class Ktmpl < Formula
  desc "Parameterized templates for Kubernetes manifests"
  homepage "https://github.com/jimmycuadra/ktmpl"
  url "https://github.com/jimmycuadra/ktmpl/archive/0.9.1.tar.gz"
  sha256 "3377f10477775dd40e78f9b3d65c3db29ecd0553e9ce8a5bdcb8d09414c782e9"
  license "MIT"
  head "https://github.com/jimmycuadra/ktmpl.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, big_sur:  "f6c8b5ae8a73efae24f8cce662e6abe53deff77a9a0f01e4f3ba174e074461b4"
    sha256 cellar: :any_skip_relocation, catalina: "922eb19c9c044634957bf1d9404b2319ae47b5998666ba30b7282728aaf7d3d0"
    sha256 cellar: :any_skip_relocation, mojave:   "9573af681da2ecc9f8299ea83553b6c5728c1cf6f21d6495fa8d118610a3467c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      kind: "Template"
      apiVersion: "v1"
      metadata:
        name: "test"
      objects:
        - kind: "Service"
          apiVersion: "v1"
          metadata:
            name: "test"
          spec:
            ports:
              - name: "test"
                protocol: "TCP"
                targetPort: "$((PORT))"
            selector:
              app: "test"
      parameters:
        - name: "PORT"
          description: "The port the service should run on"
          required: true
          parameterType: "int"
    EOS
    system bin/"ktmpl", "test.yml", "-p", "PORT", "8080"
  end
end
