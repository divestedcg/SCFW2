# Maintainer: Tad D <tad@spotco.us>
pkgname=scfw
pkgver=2.0
pkgrel=19
pkgdesc="A better firewall"
arch=('any')
license=('custom')
depends=('iptables')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service' 'restartscfw' 'iptables46')
md5sums=('SKIP' 'SKIP' '6238a17c6646d50277a949fb6f71ac99' 'a832d60f0356dd82e1d8ff8f3ce60e2f' '52d0ef037469f05af57ae41946c53840')
install=scfw.install
backup=('etc/scfw_config.sh')

build() {
  /bin/true
}

package() {
  cd "$srcdir"
  install -Dm700 iptables46 "$pkgdir/usr/bin/iptables46"
  install -Dm700 restartscfw "$pkgdir/usr/bin/restartscfw"
  install -Dm600 scfw.service "$pkgdir/usr/lib/systemd/system/scfw.service"
  install -Dm700 scfw.sh "$pkgdir/usr/lib/scfw.sh"
  install -Dm700 scfw_config.sh "$pkgdir/etc/scfw_config.sh"
}
