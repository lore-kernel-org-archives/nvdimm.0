Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8C934B@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A8C934B@G9W0745.americas.hpqcorp.net>
Date: Tue, 28 Apr 2015 15:15:54 -0700
Message-ID: <CAPcyv4g-M6NPVV4C3nB7DebhwuuzNKbNyYGDPKh_3N54P2b4Cw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 00/20] libnd: non-volatile memory device support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 2:24 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Tuesday, April 28, 2015 1:24 PM
>> To: linux-nvdimm@lists.01.org
>> Cc: Neil Brown; Dave Chinner; H. Peter Anvin; Christoph Hellwig; Rafael J.
>> Wysocki; Robert Moore; Ingo Molnar; linux-acpi@vger.kernel.org; Jens Axboe;
>> Borislav Petkov; Thomas Gleixner; Greg KH; linux-kernel@vger.kernel.org;
>> Andy Lutomirski; Andrew Morton; Linus Torvalds
>> Subject: [Linux-nvdimm] [PATCH v2 00/20] libnd: non-volatile memory device
>> support
>>
>> Changes since v1 [1]: Incorporates feedback received prior to April 24.
>
> Here are some comments on the sysfs properties reported for a pmem device.
> They are based on v1, but I don't think v2 changes anything.
>
> 1. This confuses lsblk (part of util-linux):
> /sys/block/pmem0/device/type:4
>
> lsblk shows:
> NAME                          MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> pmem0                         251:0    0     8G  0 worm
> pmem1                         251:16   0     8G  0 worm
> pmem2                         251:32   0     8G  0 worm
> pmem3                         251:48   0     8G  0 worm
> pmem4                         251:64   0     8G  0 worm
> pmem5                         251:80   0     8G  0 worm
> pmem6                         251:96   0     8G  0 worm
> pmem7                         251:112  0     8G  0 worm
>
> lsblk's blkdev_scsi_type_to_name() considers 4 to mean
> SCSI_TYPE_WORM (write once read many ... used for certain optical
> and tape drives).

Why is lsblk assuming these are scsi devices?  I'll need to go check that out.

> I'm not sure what nd and pmem are doing to result in that value.

That is their libnd specific device type number from
include/uapi/ndctl.h.  4 == ND_DEVICE_NAMESPACE_IO.   lsblk has no
business interpreting this as something SCSI specific.

> 2. To avoid confusing software trying to detect fast storage vs.
> slow storage devices via sysfs, this value should be 0:
> /sys/block/pmem0/queue/rotational:1
>
> That can be done by adding this shortly after the blk_alloc_queue call:
>                 queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);

Yeah, good catch.

> 3. Is there any reason to have a 512 KiB limit on the transfer
> length?
> /sys/block/pmem0/queue/max_hw_sectors_kb:512
>
> That is from:
>        blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);

I'd only change this from the default if performance testing showed it
made a non-trivial difference.

> 4. These are read-writeable, but IOs never reach a queue, so
> the queue size is irrelevant and merging never happens:
> /sys/block/pmem0/queue/nomerges:0
> /sys/block/pmem0/queue/nr_requests:128
>
> Consider making them both read-only with:
> * nomerges set to 2 (no merging happening)
> * nr_requests as small as the block layer allows to avoid
> wasting memory.
>
> 5. No scatter-gather lists are created by the driver, so these
> read-only fields are meaningless:
> /sys/block/pmem0/queue/max_segments:128
> /sys/block/pmem0/queue/max_segment_size:65536
>
> Is there a better way to report them as irrelevant?

Again it comes back to the question of whether these default settings
are actively harmful.

>
> 6. There is no completion processing, so the read-writeable
> cpu affinity is not used:
> /sys/block/pmem0/queue/rq_affinity:0
>
> Consider making it read-only and set to 2, meaning the
> completions always run on the requesting CPU.

There are no completions with pmem, the entire I/O path is
synchronous.  Ideally, this attribute would disappear for a pmem
queue, not be set to 2.

> 7. With mmap() allowing less than logical block sized accesses
> to the device, this could be considered misleading:
> /sys/block/pmem0/queue/physical_block_size:512

I don't see how it is misleading.  If you access it as a block device
the block size is 512.  If the application is mmap() + DAX aware it
knows that the physical_block_size is being bypassed.

>
> Perhaps that needs to be 1 byte or a cacheline size (64 bytes
> on x86) to indicate that direct partial logical block accesses
> are possible.

No, because that breaks the definition of a block device.  Through the
bdev interface it's always accessed a block at a time.

> The btt driver could report 512 as one indication
> it is different.
>
> I wouldn't be surprised if smaller values than the logical block
> size confused some software, though.

Precisely why we shouldn't go there with pmem.
