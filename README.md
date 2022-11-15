nixpkg for timidity
===================

Building
--------

Because of the wrapping in a Nix Flake, building should be trivial, although it might take some time.

```console
$ nix build
```

Testing
-------

Once built, you can just try if it works.
Try asking for the `--version` number.

```console
$ result/bin/timidity --version
TiMidity++ version 2.15.0

Copyright (C) 1999-2018 Masanao Izumo <iz@onicos.co.jp>
Copyright (C) 1995 Tuukka Toivonen <tt@cgs.fi>

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```

You can then try to compile a test MIDI file to WAV and see if things work correctly.

```console
$ result/bin/timidity -Ow test/the-ashgrove.midi
Playing test/the-ashgrove.midi
MIDI file: test/the-ashgrove.midi
Format: 1  Tracks: 3  Divisions: 384
Sequence:
Text: creator:
Text: GNU LilyPond 2.22.2
Track name: \new:
Output test/the-ashgrove.wav
Playing time: ~37 seconds
Notes cut: 0
Notes lost totally: 0
```

You can then try again, but to compile to OGG this time.
At this point, it should fail.

```console
$ result/bin/timidity -Ov test/the-ashgrove.midi
Playmode `v' is not compiled in.
Try timidity -h for help
```
