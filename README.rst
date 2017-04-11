=====
Audioserver
===== 

Audioserver distribution with
- `Mopidy <https://www.mopidy.com>`,
- `Snapcast <https://github.com/badaix/snapcast>`, and
- `Icecast <http://icecast.org>`.

The distribution is based on a minimal Ubuntu system.
The distribution itself is intended to be run as systemd/nspawn container.
Docker and rkt support will follow.

To create the distribution, run ``sh create-systemd-container.sh``.

Please consult ``create-systemd-container.sh`` for more information.
