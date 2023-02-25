# baddump
A very bad way to dump a memory from a process. Written to work with relatively minimal shells

## Don't use this script
This script is a very good way to ruin a harddrive. It writes a lot of files to disk, and all of them will be pretty large.

## If you do use this script, make a ramdisk
```
sudo mount -t ramfs -o size=1024MB ramfs /mnt/ramdisk
```

## Output
This script outputs a bunch of dump files, one per region of memory. Some will be empty if the contents couldn't be retrieved.

```
632420.5587690bd000-5587690bf000.dump  632420.7f30f624d000-7f30f629b000.dump  632420.7f30f62fe000-7f30f62ff000.dump
632420.5587690bf000-5587690c4000.dump  632420.7f30f629b000-7f30f629f000.dump  632420.7f30f62ff000-7f30f6300000.dump
632420.5587690c4000-5587690c7000.dump  632420.7f30f629f000-7f30f62a1000.dump  632420.7ffe6188a000-7ffe618ab000.dump
632420.5587690c7000-5587690c8000.dump  632420.7f30f62a1000-7f30f62a7000.dump  632420.7ffe6197c000-7ffe61980000.dump
632420.5587690c8000-5587690c9000.dump  632420.7f30f62ae000-7f30f62d0000.dump  632420.7ffe61980000-7ffe61982000.dump
632420.55876ac38000-55876ac59000.dump  632420.7f30f62d0000-7f30f62d1000.dump  632420.ffffffffff600000-ffffffffff601000.dump
632420.7f30f5b43000-7f30f60b3000.dump  632420.7f30f62d1000-7f30f62f4000.dump  632420.maps
632420.7f30f60b3000-7f30f60d5000.dump  632420.7f30f62f4000-7f30f62fc000.dump
632420.7f30f60d5000-7f30f624d000.dump  632420.7f30f62fd000-7f30f62fe000.dump
```

The script also does not stop the target process, so register state isn't retrieved.


