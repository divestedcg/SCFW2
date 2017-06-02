# Maintainer: Tad D <tad@spotco.us>
pkgname=scfw
pkgver=2.0
pkgrel=1
pkgdesc="A better firewall"
arch=('any')
license=('custom')
depends=('iptables')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service')
md5sums=('SKIP' 'SKIP' 'SKIP')
install=scfw.install

build() {
  /bin/true
}

package() {
  cd "$srcdir"
  install -Dm600 scfw.service "$pkgdir/usr/lib/systemd/system/scfw.service"
  install -Dm700 scfw.sh "$pkgdir/usr/lib/scfw.sh"
  install -Dm700 scfw_config.sh "$pkgdir/etc/scfw_config.sh"
}
