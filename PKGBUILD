# Maintainer: Tad D <tad@spotco.us>
pkgname=scfw
pkgver=2.0
pkgrel=37
pkgdesc="A better firewall"
arch=('any')
license=('custom')
depends=('iptables')
optdepends=('arch-audit: check for insecure packages'
	'brace: hardened configs'
	'extirpater: erase drive freespace'
	'firejail: sandbox programs'
	'linux-hardened: harden against exploits'
	'rkhunter: scan for rootkits')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service' 'restartscfw' 'iptables46')
sha512sums=('1ed389db95e8a4753f2f35d194bc75e2f95b17842ff57614286eb0bc8fa0d7bdc2caaf665fc800440c44275a2eb7688ccb041cbab010f0950a812db44973c20d'
            '84e46cd8f7249818a55dcd21a35d0260e884e3cbd9fe85e102e6d897fba21eaea26df6c7dcf7790b17832a8a110aafd6f7e4d558c74ffe5b3d5a05f3d41425fe'
            'c16c88d9d47edcb03bc1ba87b59867131f703f9d4f92c9ac91e1788bf2ad531891a3fc275cd1030bf22806161106fe67fec15087b258dc7f2779ad89b068376c'
            '7ffbdf3c0905a5a001cfa18a22f982065a606ac800d33aec68bb8969f9613ad8a9eb6d1e288e1f5c9d4e933b174324370be2805868a5ec7394c180c534ed54df'
            '0b3e739f125aeb62aad55f536155ae17440c2542f7f8a3a1afaf2b298e30211db9acb65ab58f45fe235a12e07ad1b74e5b9f6f03a96e7c987384dfe7d3e16c6e')
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
