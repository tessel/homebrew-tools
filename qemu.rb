require "formula"

class Qemu < Formula
  homepage "http://www.qemu.org/"
  head "git://git.qemu-project.org/qemu.git"
  url "http://wiki.qemu-project.org/download/qemu-2.1.0.tar.bz2"
  sha1 "b2829491e4c2f3d32f7bc2860c3a19fb31f5e989"

  bottle do
    sha1 "52345b6ec0fb3a9a4da93b3adc861e247a9d8702" => :mavericks
    sha1 "2027be04ff3885fe38570e05726949b9b6029abc" => :mountain_lion
    sha1 "d6603f9b5aa3e72c02f9495d287cc4cbd5a5bf22" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "gnutls"
  depends_on "glib"
  depends_on "pixman"
  depends_on "vde" => :optional
  depends_on "sdl" => :optional
  depends_on "gtk+" => :optional

  # Embedded (__END__) patches are declared like so:
  patch :DATA
  patch :p0, :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --enable-cocoa
      --disable-bsd-user
      --disable-guest-agent
    ]
    args << (build.with?("sdl") ? "--enable-sdl" : "--disable-sdl")
    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *args
    system "make", "V=1", "install"
  end
end

__END__
diff --git a/hw/arm/stellaris.c b/hw/arm/stellaris.c
index 80028e8..153d4a6 100644
--- a/hw/arm/stellaris.c
+++ b/hw/arm/stellaris.c
@@ -1221,8 +1221,8 @@ static void stellaris_init(const char *kernel_filename, const char *cpu_model,
     int i;
     int j;
 
-    flash_size = ((board->dc0 & 0xffff) + 1) << 1;
-    sram_size = (board->dc0 >> 18) + 1;
+    flash_size = getenv("STELLARIS_FLASH") ? atoi(getenv("STELLARIS_FLASH")) : ((board->dc0 & 0xffff) + 1) << 1;
+    sram_size = getenv("STELLARIS_SRAM") ? atoi(getenv("STELLARIS_SRAM")) : (board->dc0 >> 18) + 1;
     pic = armv7m_init(address_space_mem,
                       flash_size, sram_size, kernel_filename, cpu_model);
 
