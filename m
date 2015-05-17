Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A9097E5@G9W0745.americas.hpqcorp.net>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182557.35812.38292.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A9097E5@G9W0745.americas.hpqcorp.net>
Date: Sat, 16 May 2015 20:22:03 -0700
Message-ID: <CAA9_cmfzm=u+OH6FicfMBQ_0p_BGNh6A49fEm8-QV3vnmrsYdQ@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 19/20] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 16, 2015 at 6:19 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Tuesday, April 28, 2015 1:26 PM
>> To: linux-nvdimm@lists.01.org
>> Cc: Ingo Molnar; Neil Brown; Greg KH; Dave Chinner; linux-
>> kernel@vger.kernel.org; Andy Lutomirski; Jens Axboe; H. Peter Anvin;
>> Christoph Hellwig
>> Subject: [Linux-nvdimm] [PATCH v2 19/20] nd_btt: atomic sector updates
>>
>> From: Vishal Verma <vishal.l.verma@linux.intel.com>
>>
>> BTT stands for Block Translation Table, and is a way to provide power
>> fail sector atomicity semantics for block devices that have the ability
>> to perform byte granularity IO. It relies on the ->rw_bytes() capability
>> of provided nd namespace devices.
>>
>> The BTT works as a stacked blocked device, and reserves a chunk of space
>> from the backing device for its accounting metadata.  BLK namespaces may
>> mandate use of a BTT and expect the bus to initialize a BTT if not
>> already present.  Otherwise if a BTT is desired for other namespaces (or
>> partitions of a namespace) a BTT may be manually configured.
> ...
>
> Running btt above pmem with a variety of workloads, I see an awful lot
> of time spent in two places:
> * _raw_spin_lock
> * btt_make_request
>
> This occurs for fio to raw /dev/ndN devices, ddpt over ext4 or xfs,
> cp -R of large directories, and running make on the linux kernel.
>
> Some specific results:
>
> fio 4 KiB random reads, WC cache type, memcpy:
> * 43175 MB/s,   8 M IOPS  pmem0 and pmem1
> * 18500 MB/s, 1.5 M IOPS  nd0 and nd1
>
> fio 4 KiB random reads, WC cache type, memcpy with non-temporal
> loads (when everything is 64-byte aligned):
> * 33814 MB/s, 4.3 M IOPS  nd0 and nd1
>
> Zeroing out 32 MiB with ddpt:
> * 19 s, 1800 MiB/s      pmem
> * 55 s,  625 MiB/s      btt
>
> If btt_make_request needs to stall this much, maybe it'd be better
> to utilize the blk-mq request queues, keeping requests in per-CPU
> queues while they're waiting, and using IPIs for completion
> interrupts when they're finally done.

2 items to check:

1/ make sure you have a your btt sector size set to 4k which cuts down
the overhead by a factor of 8.

2/ boot with nr_cpus=256 or lower.

Ross noticed that CONFIG_NR_CPUS is set quite high on distro kernels
which revealed that we should have been using nr_cpu_ids and percpu
variables for nd_region_acquire_lane() from the outset.  This fix is
coming in v3.
