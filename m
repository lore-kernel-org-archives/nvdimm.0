Return-Path: <linux-ext4-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
References: <CAM=YXF-aXxp19=uFDExUswpEfKXNN6LJScxAB-7-u-AgRiXJ2g@mail.gmail.com>
	<CAPcyv4gYHuSWuugnELSO6B1rye+b89io3zJVUXwRt0wE1ZfPrA@mail.gmail.com>
	<94D0CD8314A33A4D9D801C0FE68B40295BEC985F@G9W0745.americas.hpqcorp.net>
	<20151224000021.GU19802@dastard>
	<CAM=YXF9Dt-BuY9yM7d023a16gp=edGHeCDVTCwV-AEotj6sbFg@mail.gmail.com>
Date: Wed, 23 Dec 2015 16:58:14 -0800
Message-ID: <CAPcyv4g1eHgm8oUvxFaJkRD-T7jAyw95FQ-q3_GC2JU_kkU-Kg@mail.gmail.com>
Subject: Re: A blocksize problem about dax and ext4
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-ext4-owner@vger.kernel.org
To: Cholerae Hu <choleraehyq@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Ted Tso <tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 23, 2015 at 4:34 PM, Cholerae Hu <choleraehyq@gmail.com> wrote:
> The block size is 1024.
> # dumpe2fs -h /dev/pmem0 | grep "Block size"
> dumpe2fs 1.42.13 (17-May-2015)
> Block size:               1024
>
> I tried it out on xfs and I succeeded. There are the prompting messages:
> # mkfs.xfs -f -b size=1024 /dev/pmem0
> meta-data=/dev/pmem0             isize=512    agcount=4, agsize=32768 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1
> data     =                       bsize=1024   blocks=131072, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal log           bsize=1024   blocks=2571, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> # mount -o dax /dev/pmem0 /mnt/mem
>
> The mount command doesn't return any message, and I can successfully read or
> write files in /mnt/mem.
>

xfs will silently disable dax when the fs block size is too small,
i.e. your mmap() operations are backed by page cache in this case.
Currently the only indication of whether a mapping is DAX backed or
not is the presence of the VM_MIXEDMAP flag ("mm" in the VmFlags field
of /proc/<pid>/smaps)
