Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 942BD20082EEE
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 06:23:19 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id x184so50818283oia.1
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 06:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACTTzNaOc2K5tgfbp-zfr=C9Xd2s1g-9y6rXiNbjPH9iK-HsWw@mail.gmail.com>
References: <CACTTzNaOc2K5tgfbp-zfr=C9Xd2s1g-9y6rXiNbjPH9iK-HsWw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 06:23:18 -0700
Message-ID: <CAPcyv4hi2DicbTR3-m735jhP=mdMU+QMZY-9FP+eXU7VFuV79A@mail.gmail.com>
Subject: Re: qemu-kvm hangs with DAX
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Yigal Korman <yigal@plexistor.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 20, 2017 at 2:19 AM, Yigal Korman <yigal@plexistor.com> wrote:
> Hi everyone,
>
> I have an interesting issue with DAX and KVM - I'm trying to boot a VM
> with its memory mapped to a DAX-mounted file (kernel 4.9).
>
> The use case is a bit wacky but I'm trying to recreate something
> similar to what clearlinux[1] described (although they don't use this
> method anymore).
>
> When mapping the memory to a regular ext4 file, the VM boots fine.
> But when mapping to ext4+dax, the VM won't boot or perhaps boots
> extremely slowly.
> In both cases the FS is on a memory pmem device.
>
> Here's a snippet of how I load things:
>
> mkfs.ext4 /dev/pmem0
> mount /dev/pmem0 /mnt
> fallocate -l 512M /mnt/mem

I wonder if you replace this with "dd if=/dev/zero of=/mnt/mem
bs=1024k count=512" if it changes the behavior. DAX forces synchronous
block allocations and unwritten-extent-zeroing that get skipped in the
page cache case.

> qemu-system-x86_64 -nodefconfig -nodefaults \
>  -drive if=virtio,file=centos7.qcow2,index=0,media=disk \
>  --enable-kvm -serial telnet:localhost:4443,server,nowait \
>  -device sga -m 512 -smp 1,sockets=1,cores=1,threads=1 \
>  -object memory-backend-file,prealloc=yes,mem-path=/mnt/mem,share=on,size=512M,id=ram
> \
>  -numa node,nodeid=0,cpus=0,memdev=ram \
>  -net nic,model=virtio,vlan=0 \
>  -net user,vlan=0,hostname=vm,hostfwd=tcp:127.0.0.1:8001-:22 \
>  -name test -monitor telnet:localhost:4444,server,nowait
>
> I use a headless host so I usually connect to the VM with 'telnet
> localhost 4443'.
>
> The above works and the VM boots in seconds.
> When adding '-o dax' to the mount command, I can catch the grub menu
> during boot but it gets stuck.
> Sometimes if I wait about 20 minutes, I see some kernel boot messages
> appear, but no errors.
>
> Any thoughts?
>
> Regards,
> Yigal
>
> [1] https://lwn.net/Articles/644675/
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
