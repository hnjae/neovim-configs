#!/usr/bin/env -S just --justfile

hostname := `hostname`

_:
    @just --list

commit:
    git add --all
    git commit --no-verify -m '{{ hostname }}: {{ datetime("%Y-%m-%dT%H:%M:%S%Z") }}'
    git push
