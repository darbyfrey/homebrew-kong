# From https://github.com/naartjie/homebrew-luajit
# Lighten (only luajit support) and allowing us to
# always use the version recommended for Kong.

class Luarocks < Formula
  homepage "http://luarocks.org"
  url "http://luarocks.org/releases/luarocks-2.4.0.tar.gz"
  sha256 "44381c9128d036247d428531291d1ff9405ae1daa238581d3c15f96d899497c3"
  head "https://github.com/keplerproject/luarocks.git"

  depends_on "mashape/kong/luajit"

  fails_with :llvm do
    cause "Lua itself compiles with llvm, but may fail when other software tries to link."
  end

  def install
    luajit = Formula["mashape/kong/luajit"]

    # Install to the Cellar, but the tree to install modules is in HOMEBREW_PREFIX
    args = [
      "--prefix=#{prefix}",
      "--with-lua=#{luajit.prefix}",
      "--with-lua-include=#{luajit.include}/luajit-2.1",
      "--lua-suffix=jit",
      "--rocks-tree=#{HOMEBREW_PREFIX}",
      "--sysconfdir=#{etc}/luarocks"
    ]

    system "./configure", *args
    system "make build"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Rocks will be installed to: #{HOMEBREW_PREFIX}/lib/luarocks/rocks
    EOS
  end

  test do
    system "#{bin}/luarocks", "install", "say"
  end
end
