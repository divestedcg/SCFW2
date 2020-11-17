# Maintainer: Tad <tad@spotco.us>
pkgname=scfw
pkgver=2.0
pkgrel=37
pkgdesc="A better firewall"
arch=('any')
license=('GPL3')
depends=('iptables')
optdepends=('arch-audit: check for insecure packages'
	'brace: hardened configs'
	'extirpater: erase drive freespace'
	'firejail: sandbox programs'
	'linux-hardened: harden against exploits')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service' 'restartscfw' 'iptables46')
sha512sums=('6633dc54d87b8d16f1bba36073da77a53764248540b225e4b9bf1f67ee39abb60a2bcaeb3bb6e814848262b373ecfc978713459681b517b7cb4914417d69f12c'
            '84e46cd8f7249818a55dcd21a35d0260e884e3cbd9fe85e102e6d897fba21eaea26df6c7dcf7790b17832a8a110aafd6f7e4d558c74ffe5b3d5a05f3d41425fe'
            'c16c88d9d47edcb03bc1ba87b59867131f703f9d4f92c9ac91e1788bf2ad531891a3fc275cd1030bf22806161106fe67fec15087b258dc7f2779ad89b068376c'
            '1002d65b71e4b34e61716d7cdd0b776bf55d9ad5d6d154cf437faf3681c642e4ff65c71d3bd4d5545b0e76a0e19aa8ae211e61b86e5c7bd0fee0125130c891de'
            'c460f0e20e05cb26a26254bc4c85f2b0b2c21c223ae49cd6ce60abbdeaeb337402c1c984d0c7e81878181e08cbb1ba3e9905cb87e1ae34006c1ed7a839a664fb')
install=scfw.install
backup=('etc/scfw_config.sh')


package() {
  cd "$srcdir"
  install -Dm700 iptables46 "$pkgdir/usr/bin/iptables46"
  install -Dm700 restartscfw "$pkgdir/usr/bin/restartscfw"
  install -Dm600 scfw.service "$pkgdir/usr/lib/systemd/system/scfw.service"
  install -Dm700 scfw.sh "$pkgdir/usr/lib/scfw.sh"
  install -Dm700 scfw_config.sh "$pkgdir/etc/scfw_config.sh"
}
