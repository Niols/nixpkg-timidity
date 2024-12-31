Nix package for TiMidity++
==========================

> [!NOTE]  
> Now that https://github.com/NixOS/nixpkgs/pull/201828 has been merged, this repository stopped being useful. Use nixpkgs with an overlay and `timidity.override { enableVorbis = true; }`.

This repository contains a Nix package for [TiMidity++][timidity-web-page].

[timidity-web-page]: https://timidity.sourceforge.net/

> TiMidity++ is a software synthesizer.
> It can play MIDI files by converting them into PCM waveform data; give it a MIDI data along with digital instrument data files, then it synthesizes them in real-time, and plays.
> It can not only play sounds, but also can save the generated waveforms into hard disks as various audio file formats.
>
> TiMidity++ is a free software, distributed under the terms of GNU general public license.

There is already [a Nix package for TiMidity++ in nixpkgs][timidity-in-nixpkgs], but it does not support some features, and in particular the generation of OGG files, which is of interest to me personally.

[timidity-in-nixpkgs]: https://github.com/NixOS/nixpkgs/tree/8daf69629cfd071d58cbb3b6f54a9321514ec5ba/pkgs/tools/misc/timidity

Building & Running
------------------

The Nix Flake provides multiple targets to build `timidity`:

- `timidityFromNixpkgs` provides TiMidity++ as-is from nixpkgs.
  This is also the default target.

- `timidityFromNixpkgs'` does just the same, except the call to `callPackage` is inlined in the flake.

- `timidityWithVorbis` also goes through `callPackage` but with an additional `enableVorbis = true` argument.
  It provide a variant of TiMidity++ compiled with support for OGG Vorbis.

Building is trivial with Nix.
The `timidity` binary ends up in the directory `result/bin`.

```console
$ nix build .#<target>
$ result/bin/timidity --version
TiMidity++ version 2.15.0
[...]
```

Alternatively, one can run `timidity` directly with:

``` console
$ nix run .#<target> -- --version
TiMidity++ version 2.15.0
[...]
```

A last option is to run the flake immediately from the GitHub repository, with:

``` console
$ nix run github:niols/nixpkg-timidity#<target> -- --version
TiMidity++ version 2.15.0
[...]
```

Testing
-------

Once built, you can try to compile a test MIDI file to WAV and see if things work correctly.

```console
$ nix run .#timidityFromNixpkgs -- -Ow test/the-ashgrove.midi
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

You can then try again, but to compile to OGG this time. At this point, it should fail.

```console
$ nix run .#timidityFromNixpkgs -- -Ov test/the-ashgrove.midi
Playmode `v' is not compiled in.
Try timidity -h for help
```

But if you try with the version supposed to support OGG Vorbis:

```console
$ nix run .#timidityWithVorbis -- -Ov test/the-ashgrove.midi
Playing test/the-ashgrove.midi
MIDI file: test/the-ashgrove.midi
Format: 1  Tracks: 3  Divisions: 384
Sequence:
Text: creator:
Text: GNU LilyPond 2.22.2
Track name: \new:
Output test/the-ashgrove.ogg
Playing time: ~37 seconds
Notes cut: 0
Notes lost totally: 0
```

Fun fact: The difference also shows up in the help where an additional line specifies that Ogg Vorbis is an available output mode.
For instance:

```console
$ diff <(nix run .#timidityFromNixpkgs -- --help) <(nix run .#timidityWithVorbis -- --help)
243a244
>   -Ov          Ogg Vorbis
```
