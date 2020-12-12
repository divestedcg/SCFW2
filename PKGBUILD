# Maintainer: Tad <tad@spotco.us>
pkgname=scfw
pkgver=2.0
pkgrel=39
pkgdesc="A better firewall?"
arch=('any')
license=('GPL3')
depends=('iptables')
source=('scfw.sh' 'scfw_config.sh' 'scfw.service' 'restartscfw' 'iptables46')
sha512sums=('cf8c3a84fe3069d57f7e3b23d580e4476d0b24d3bc99f4a55d08e255c085d4b6fd10fc25afb09105a6507157f1b37914d60bef3eb82f024c111c8633f7d47caf'
            '84e46cd8f7249818a55dcd21a35d0260e884e3cbd9fe85e102e6d897fba21eaea26df6c7dcf7790b17832a8a110aafd6f7e4d558c74ffe5b3d5a05f3d41425fe'
            'c16c88d9d47edcb03bc1ba87b59867131f703f9d4f92c9ac91e1788bf2ad531891a3fc275cd1030bf22806161106fe67fec15087b258dc7f2779ad89b068376c'
            '49d95adcfb5f1973eb689573518fd09a37a3cb24b8ca7fcc7920b5ed509f311749770e7ca3a78a106705e2aa3233e5b5552b46189744e5b60d523b1332a32157'
            '953db04a270f2697ee0db3b62946aa215973a65d5f168ec2b977c65c44ff7d229eadf6042c9de8f195ebdfbffffcc916764a132cbcbad6d2052353a1d09ee876')
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
