#!/bin/sh

currentSnapshot=$(vim-cmd vmsvc/get.snapshotinfo 14 | grep currrentSnapshot | sed “s/.*snapshot-\(.*\)’,/\1)
vim-cmd vmsvc/snapshot.revert 14 $currentSnapshot 0
