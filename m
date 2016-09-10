From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v2 2/9] ext2: tell DAX the size of allocation holes
Date: Sat, 10 Sep 2016 08:15:06 +0000
Message-ID: <DM2PR21MB00899C835BC0AF476B6683CDCBFD0@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-3-ross.zwisler@linux.intel.com>
 <20160825075728.GA11235@infradead.org>
 <20160826212934.GA11265@linux.intel.com>
 <20160829074116.GA16491@infradead.org>
 <20160829125741.cdnbb2uaditcmnw2@thunk.org>
 <20160909164808.GC18554@linux.intel.com>
 <DM2PR21MB0089BCA980B67D8C53B25A1BCBFA0@DM2PR21MB0089.namprd21.prod.outlook.com>
 <CAPcyv4hjna08+Yw23w_V2f-RbBE6ar220+YGCuBVA-TACKWNug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hjna08+Yw23w_V2f-RbBE6ar220+YGCuBVA-TACKWNug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

From: Dan Williams [mailto:dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> /me grumbles about top-posting...

Let's see if this does any better .. there's lots of new features, but I don't see a 'wrap lines at 80 columns' option.  Unfortunately.

> On Fri, Sep 9, 2016 at 1:35 PM, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> wrote:
> > I thought after Storage Summit, we had broad agreement that we were
> > moving to a primary DAX API that was not BH (nor indeed iomap) based.  We
> > would still have DAX helpers for block based filesystems (because duplicating
> > all that code between filesystems is pointless), but I now know of three
> > filesystems which are not block based that are interested in using DAX.  Jared
> > Hulbert's AXFS is a nice public example.
> >
> > I posted a prototype of this here:
> >
> >
> https://groups.google.com/d/msg/linux.kernel/xFFHVCQM7Go/ZQeDVYTnFgAJ
> >
> > It is, of course, woefully out of date, but some of the principles in it are still
> good (and I'm working to split it into digestible chunks).
> >
> > The essence:
> >
> > 1. VFS or VM calls filesystem (eg ->fault()) 2. Filesystem calls DAX
> > (eg dax_fault()) 3. DAX looks in radix tree, finds no information.
> > 4. DAX calls (NEW!) mapping->a_ops->populate_pfns 5a. Filesystem (if
> > not block based) does its own thing to find out the PFNs corresponding
> > to the requested range, then inserts them into the radix tree (possible helper
> in DAX code) 5b. Filesystem (if block based) looks up its internal data structure
> (eg extent tree) and
> >    calls dax_create_pfns() (see giant patch from yesterday, only instead of
> >    passing a get_block_t, the filesystem has already filled in a bh which
> >    describes the entire extent that this access happens to land in).
> > 6b. DAX takes care of calling bdev_direct_access() from dax_create_pfns().
> >
> > Now, notice that there's no interaction with the rest of the filesystem here.
> We can swap out BHs and iomaps relatively trivially; there's no call for making
> grand changes, like converting ext2 over to iomap.  The BH or iomap is only
> used for communicating the extent from the filesystem to DAX.
> >
> > Do we have agreement that this is the right way to go?
> 
> My $0.02...
> 
> So the current dax implementation is still struggling to get right (pmd faulting,
> dirty entry cleaning, etc) and this seems like a rewrite that sets us up for future
> features without addressing the current bugs and todo items.  In comparison
> the iomap conversion work seems incremental and conserving of current
> development momentum.

I believe your assessment is incorrect.  If converting the current DAX code to
use iomap forces converting ext2, then it's time to get rid of all the half-measures
currently in place.  You left off one todo item that this does get us a step closer to
fixing -- support for DMA to mmaped DAX files.  I think it also puts us in a better
position to fix the 2MB support, locking, and dirtiness tracking.  Oh, and it does
fix the multivolume support (because the sectors in the radix tree could be
interpreted as being from the wrong volume).

> I agree with you that continuing to touch ext2 is not a good idea, but I'm not
> yet convinced that now is the time to go do dax-2.0 when we haven't finished
> shipping dax-1.0.

dax-1.0 died long ago ... I think we're up to at least DAX version 4 by now.
