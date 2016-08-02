require "formula"

class GccArm < Formula
  homepage "https://launchpad.net/gcc-arm-embedded"
  url "https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q1-update/+download/gcc-arm-none-eabi-4_8-2014q1-20140314-mac.tar.bz2"
  sha256 "d8d037d56e37c513f13f3b8864265489dca9ffaca616f679d45dff6e500c47af"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "arm-none-eabi-gcc -v"
  end
end
