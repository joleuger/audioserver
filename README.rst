=====
Audioserver
===== 

Audioserver distribution with

- `Mopidy <https://www.mopidy.com>`,
- `Shairport sync`,
- `Snapcast <https://github.com/badaix/snapcast>`, and
- `Icecast <http://icecast.org>`.

The distribution is based on a minimal Ubuntu system.
The distribution itself is intended to be run as systemd/nspawn container.
Docker and rkt support will follow.

To create the distribution, run ``sh create-systemd-container.sh``.

Icecast is accessible at http://hostname:8000, and Mopidy at http://hostname:6680

Please consult ``create-systemd-container.sh`` for more information.
