# shared/lib.tcl
#
# Copyright 2018 Bill Zissimopoulos

# This file is part of "Poor Man's CI".
#
# It is licensed under the BSD license. The full license text can be found
# in the License.txt file at the root of this project.

set timeout 600
set force_conservative 1

set rootpass "root"

proc spawn_qemu_installer {installer image {arch x86_64} {size 5G}} {
    global spawn_id

    spawn qemu-img create -f raw $image $size
    expect "Formatting"
    expect eof

    spawn qemu-system-$arch \
        -smp 2 \
        -device virtio-scsi \
        -blockdev driver=file,node-name=diskfile,filename=$image \
        -blockdev driver=raw,node-name=disk,file=diskfile \
        -device scsi-hd,drive=disk \
        -net nic,model=virtio,macaddr=02:00:00:00:00:01 -net user \
        -cdrom $installer \
        -boot once=d \
        -display curses

    return $spawn_id
}

proc spawn_qemu_image {image {arch x86_64}} {
    global spawn_id

    spawn qemu-system-$arch \
        -smp 2 \
        -device virtio-scsi \
        -blockdev driver=file,node-name=diskfile,filename=$image \
        -blockdev driver=raw,node-name=disk,file=diskfile \
        -device scsi-hd,drive=disk \
        -net nic,model=virtio,macaddr=02:00:00:00:00:01 -net user \
        -nographic

    return $spawn_id
}

proc spawn_qemu_sh {image script {arch x86_64}} {
    spawn_qemu_image $image $arch

    global rootpass
    expect "login:"
    send "root\r"
    expect "assword:"
    send "$rootpass\r"

    sh {
        set -e
        PS1="IMGTOOL# "
    }
    sh_prompt "IMGTOOL# " $script
    sh_prompt "IMGTOOL# " {
        shutdown -p now
    }

    expect eof
}

proc sh {script} {
    sh_prompt "# " $script
}

proc sh_prompt {prompt script} {
    foreach line [split $script "\n"] {
        set line [string trim $line]
        if {$line != "" && ![string match "#*" $line]} {
            expect $prompt
            send "$line\r"
        }
    }
}
