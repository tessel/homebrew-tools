require 'formula'

class Gyp < Formula

      url "https://chromium.googlesource.com/external/gyp", :using => :git
      version "1.0"

      depends_on :python

     # initialize the installation of this
     def install
             # use the brew python to install the tools needed
	     system 'python', 'setup.py', 'install', "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"


             # install the gyp executable
             bin.install("gyp")
             bin.install("gyp_main.py")
     end
end
