Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D58C211CBD03
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 10:45:38 -0800 (PST)
Date: Fri, 22 Feb 2019 10:45:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222184525.GA21626@magnolia>
References: <20190222182008.GT6503@magnolia>
 <CAPcyv4jz5wS4tZV0HrNkADpQ_-EQoxbHi7LHi8RcsTHHFdUaew@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jz5wS4tZV0HrNkADpQ_-EQoxbHi7LHi8RcsTHHFdUaew@mail.gmail.com>
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
Cc: xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 22, 2019 at 10:28:15AM -0800, Dan Williams wrote:
> On Fri, Feb 22, 2019 at 10:21 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > Hi all!
> >
> > Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
> > on pmem, and they've observed that one has to do a fair amount of
> > legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
> > 2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
> > so the PMD mappings are much more efficient.
> >
> > I started poking around w.r.t. what mkfs.xfs was doing and realized that
> > if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
> > set up all the parameters automatically.  Below is my ham-handed attempt
> > to teach the kernel to do this.
> >
> > Comments, flames, "WTF is this guy smoking?" are all welcome. :)
> >
> > --D
> >
> > ---
> > Configure pmem devices to advertise the default page alignment when said
> > block device supports fsdax.  Certain filesystems use these iomin/ioopt
> > hints to try to create aligned file extents, which makes it much easier
> > for mmaps to take advantage of huge page table entries.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  drivers/nvdimm/pmem.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index bc2f700feef8..3eeb9dd117d5 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -441,8 +441,11 @@ static int pmem_attach_disk(struct device *dev,
> >         blk_queue_logical_block_size(q, pmem_sector_size(ndns));
> >         blk_queue_max_hw_sectors(q, UINT_MAX);
> >         blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> > -       if (pmem->pfn_flags & PFN_MAP)
> > +       if (pmem->pfn_flags & PFN_MAP) {
> >                 blk_queue_flag_set(QUEUE_FLAG_DAX, q);
> > +               blk_queue_io_min(q, PFN_DEFAULT_ALIGNMENT);
> > +               blk_queue_io_opt(q, PFN_DEFAULT_ALIGNMENT);
> 
> The device alignment might sometimes be bigger than this default.
> Would there be any detrimental effects for filesystems if io_min and
> io_opt were set to 1GB?

Hmmm, that's going to be a struggle on ext4 and the xfs data device
because we'd be preferentially skipping the 1023.8MB immediately after
each allocation group's metadata.  It already does this now with a 2MB
io hint, but losing 1.8MB here and there isn't so bad.

We'd have to study it further, though; filesystems historically have
interpreted the iomin/ioopt hints as RAID striping geometry, and I don't
think very many people set up 1GB raid stripe units.

(I doubt very many people have done 2M raid stripes either, but it seems
to work easily where we've tried it...)

> I'm thinking and xfs-realtime configuration might be able to support
> 1GB mappings in the future.

The xfs realtime device ought to be able to support 1g alignment pretty
easily though. :)

--D
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
