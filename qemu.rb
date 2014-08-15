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
index 80028e8..fc5d290 100644
--- a/hw/arm/stellaris.c
+++ b/hw/arm/stellaris.c
@@ -1199,7 +1199,7 @@ static stellaris_board_info stellaris_boards[] = {
 };
 
 static void stellaris_init(const char *kernel_filename, const char *cpu_model,
-                           stellaris_board_info *board)
+                           int sram_size, stellaris_board_info *board)
 {
     static const int uart_irq[] = {5, 6, 33, 34};
     static const int timer_irq[] = {19, 21, 23, 35};
@@ -1214,7 +1214,6 @@ static void stellaris_init(const char *kernel_filename, const char *cpu_model,
     qemu_irq gpio_in[7][8];
     qemu_irq gpio_out[7][8];
     qemu_irq adc;
-    int sram_size;
     int flash_size;
     I2CBus *i2c;
     DeviceState *dev;
@@ -1222,7 +1221,7 @@ static void stellaris_init(const char *kernel_filename, const char *cpu_model,
     int j;
 
     flash_size = ((board->dc0 & 0xffff) + 1) << 1;
-    sram_size = (board->dc0 >> 18) + 1;
+    if (sram_size > 32*1024*1024 || sram_size < 0) { sram_size = (board->dc0 >> 18) + 1; } else { sram_size /= 1024; }
     pic = armv7m_init(address_space_mem,
                       flash_size, sram_size, kernel_filename, cpu_model);
 
@@ -1338,14 +1337,14 @@ static void lm3s811evb_init(MachineState *machine)
 {
     const char *cpu_model = machine->cpu_model;
     const char *kernel_filename = machine->kernel_filename;
-    stellaris_init(kernel_filename, cpu_model, &stellaris_boards[0]);
+    stellaris_init(kernel_filename, cpu_model, machine->ram_size, &stellaris_boards[0]);
 }
 
 static void lm3s6965evb_init(MachineState *machine)
 {
     const char *cpu_model = machine->cpu_model;
     const char *kernel_filename = machine->kernel_filename;
-    stellaris_init(kernel_filename, cpu_model, &stellaris_boards[1]);
+    stellaris_init(kernel_filename, cpu_model, machine->ram_size, &stellaris_boards[1]);
 }
 
 static QEMUMachine lm3s811evb_machine = {
