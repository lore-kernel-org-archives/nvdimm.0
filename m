Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129])
 by ml01.01.org (Postfix) with ESMTP id 5576B209605AE
 for <linux-nvdimm@lists.01.org>; Sun,  3 Jun 2018 15:20:41 -0700 (PDT)
Date: Mon, 4 Jun 2018 08:20:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180603222038.GS10363@dastard>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia> <20180601012657.GQ10363@dastard>
 <CAPcyv4g6dv9sG9dR-iY+aEfSi2r3ey1dXGbX-nexKsN72t0QMw@mail.gmail.com>
 <20180601022418.GR10363@dastard>
 <CAPcyv4iXTsxmQgjoLs2E_8QrLHrFOV_58T7UYf0zPJuB2744qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iXTsxmQgjoLs2E_8QrLHrFOV_58T7UYf0zPJuB2744qQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
> On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
> >> > FWIW, XFS+DAX used to just work on this setup (I hadn't even
> >> > installed ndctl until this morning!) but after changing the kernel
> >> > it no longer works. That would make it a regression, yes?

[....]

> >> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
> >> has the following dependencies:
> >>
> >>         depends on MEMORY_HOTPLUG
> >>         depends on MEMORY_HOTREMOVE
> >>         depends on SPARSEMEM_VMEMMAP
> >
> > Filesystem DAX now has a dependency on memory hotplug?

[....]

> > OK, works now I've found the magic config incantantions to turn
> > everything I now need on.

By enabling these options, my test VM now has a ~30s pause in the
boot very soon after the nvdimm subsystem is initialised.

[    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.552175] Non-volatile memory driver v1.3
[    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
[    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
[   37.217453] brd: module loaded
[   37.225423] loop: module loaded
[   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
[   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
[   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
[   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
[   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes

The system does not appear to be consuming CPU, but it is blocking
NMIs so I can't get a CPU trace. For a VM that I rely on booting in
a few seconds because I reboot it tens of times a day, this is a
problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
