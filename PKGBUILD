# Maintainer: Tad D <tad@spotco.us>
pkgname=scfw
pkgver=2.1
pkgrel=1
pkgdesc="A better firewall"
arch=('any')
license=('custom')
depends=('iptables')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service' 'restartscfw')
md5sums=('SKIP' 'SKIP' '00c47c3e2191cfae9bb0da6b756375f6' 'e3b58cb6c2c4e63bc052dfae79431f9e')
install=scfw.install

build() {
  /bin/true
}

package() {
  cd "$srcdir"
  install -Dm700 restartscfw "$pkgdir/usr/bin/restartscfw"
  install -Dm600 scfw.service "$pkgdir/usr/lib/systemd/system/scfw.service"
  install -Dm700 scfw.sh "$pkgdir/usr/lib/scfw.sh"
  install -Dm700 scfw_config.sh "$pkgdir/etc/scfw_config.sh"
}
