Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x232.google.com (mail-ob0-x232.google.com
 [IPv6:2607:f8b0:4003:c01::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71C7E1A1E9F
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 16:34:45 -0700 (PDT)
Received: by mail-ob0-x232.google.com with SMTP id kf9so106122294obc.1
 for <linux-nvdimm@lists.01.org>; Mon, 28 Mar 2016 16:34:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459195288.15523.3.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
 <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
 <1458939796.5501.8.camel@intel.com>
 <CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
 <1459195288.15523.3.camel@intel.com>
Date: Mon, 28 Mar 2016 16:34:16 -0700
Message-ID: <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 28, 2016 at 1:01 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Fri, 2016-03-25 at 14:20 -0700, Dan Williams wrote:
>> On Fri, Mar 25, 2016 at 2:03 PM, Verma, Vishal L
>> <vishal.l.verma@intel.com> wrote:
>> >
>> > On Fri, 2016-03-25 at 11:47 -0700, Dan Williams wrote:
>> > >
>> > > On Thu, Mar 24, 2016 at 4:17 PM, Vishal Verma <vishal.l.verma@int
>> > > el.c
>> > > om> wrote:
>> > > >
>> > > >
>> > > > From: Matthew Wilcox <matthew.r.wilcox@intel.com>
>> > > >
>> > > > dax_clear_sectors() cannot handle poisoned blocks.  These must
>> > > > be
>> > > > zeroed using the BIO interface instead.  Convert ext2 and XFS
>> > > > to
>> > > > use
>> > > > only sb_issue_zerout().
>> > > >
>> > > > Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
>> > > > [vishal: Also remove the dax_clear_sectors function entirely]
>> > > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > > > ---
>> > > >  fs/dax.c               | 32 --------------------------------
>> > > >  fs/ext2/inode.c        |  7 +++----
>> > > >  fs/xfs/xfs_bmap_util.c |  9 ---------
>> > > >  include/linux/dax.h    |  1 -
>> > > >  4 files changed, 3 insertions(+), 46 deletions(-)
>> > > >
>> > > > diff --git a/fs/dax.c b/fs/dax.c
>> > > > index bb7e9f8..a30481e 100644
>> > > > --- a/fs/dax.c
>> > > > +++ b/fs/dax.c
>> > > > @@ -78,38 +78,6 @@ struct page *read_dax_sector(struct
>> > > > block_device
>> > > > *bdev, sector_t n)
>> > > >         return page;
>> > > >  }
>> > > >
>> > > > -/*
>> > > > - * dax_clear_sectors() is called from within transaction
>> > > > context
>> > > > from XFS,
>> > > > - * and hence this means the stack from this point must follow
>> > > > GFP_NOFS
>> > > > - * semantics for all operations.
>> > > > - */
>> > > > -int dax_clear_sectors(struct block_device *bdev, sector_t
>> > > > _sector,
>> > > > long _size)
>> > > > -{
>> > > > -       struct blk_dax_ctl dax = {
>> > > > -               .sector = _sector,
>> > > > -               .size = _size,
>> > > > -       };
>> > > > -
>> > > > -       might_sleep();
>> > > > -       do {
>> > > > -               long count, sz;
>> > > > -
>> > > > -               count = dax_map_atomic(bdev, &dax);
>> > > > -               if (count < 0)
>> > > > -                       return count;
>> > > > -               sz = min_t(long, count, SZ_128K);
>> > > > -               clear_pmem(dax.addr, sz);
>> > > > -               dax.size -= sz;
>> > > > -               dax.sector += sz / 512;
>> > > > -               dax_unmap_atomic(bdev, &dax);
>> > > > -               cond_resched();
>> > > > -       } while (dax.size);
>> > > > -
>> > > > -       wmb_pmem();
>> > > > -       return 0;
>> > > > -}
>> > > > -EXPORT_SYMBOL_GPL(dax_clear_sectors);
>> > > What about the other unwritten extent conversions in the dax
>> > > path?
>> > > Shouldn't those be converted to block-layer zero-outs as well?
>> > Could you point me to where these might be? I thought once we've
>> > converted all the zeroout type callers (by removing
>> > dax_clear_sectors),
>> > and fixed up dax_do_io to try a driver fallback, we've handled all
>> > the
>> > media error cases in dax..
>> grep for usages of clear_pmem()... which I was hoping to eliminate
>> after this change to push zeroing down to the driver.
>
> Ok, so I looked at these, and it looks like the majority of callers of
> clear_pmem are from the fault path (either pmd or regular), and in
> those cases we should be 'protected', as we would have failed at a
> prior step (dax_map_atomic).

Seems kind of sad to fail the fault due to a bad block when we were
going to zero it anyway, right?  I'm not seeing a compelling reason to
keep any zeroing in fs/dax.c.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
