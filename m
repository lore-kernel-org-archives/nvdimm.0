Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD49B2126D83F
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 21:02:40 -0700 (PDT)
Date: Wed, 22 May 2019 21:02:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/18] dax: memcpy page in case of IOMAP_DAX_COW for mmap
 faults
Message-ID: <20190523040202.GH5125@magnolia>
References: <20190429172649.8288-1-rgoldwyn@suse.de>
 <20190429172649.8288-9-rgoldwyn@suse.de>
 <20190521174625.GF5125@magnolia>
 <20190522191139.62v2rgby5ptjhzcd@fiona>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190522191139.62v2rgby5ptjhzcd@fiona>
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
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: kilobyte@angband.pl, jack@suse.cz, linux-nvdimm@lists.01.org, nborisov@suse.com, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 22, 2019 at 02:11:39PM -0500, Goldwyn Rodrigues wrote:
> On 10:46 21/05, Darrick J. Wong wrote:
> > On Mon, Apr 29, 2019 at 12:26:39PM -0500, Goldwyn Rodrigues wrote:
> > > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > 
> > > Change dax_iomap_pfn to return the address as well in order to
> > > use it for performing a memcpy in case the type is IOMAP_DAX_COW.
> > > We don't handle PMD because btrfs does not support hugepages.
> > > 
> > > Question:
> > > The sequence of bdev_dax_pgoff() and dax_direct_access() is
> > > used multiple times to calculate address and pfn's. Would it make
> > > sense to call it while calculating address as well to reduce code?
> > > 
> > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > ---
> > >  fs/dax.c | 19 +++++++++++++++----
> > >  1 file changed, 15 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/dax.c b/fs/dax.c
> > > index 610bfa861a28..718b1632a39d 100644
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -984,7 +984,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
> > >  }
> > >  
> > >  static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
> > > -			 pfn_t *pfnp)
> > > +			 pfn_t *pfnp, void **addr)
> > >  {
> > >  	const sector_t sector = dax_iomap_sector(iomap, pos);
> > >  	pgoff_t pgoff;
> > > @@ -996,7 +996,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
> > >  		return rc;
> > >  	id = dax_read_lock();
> > >  	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
> > > -				   NULL, pfnp);
> > > +				   addr, pfnp);
> > >  	if (length < 0) {
> > >  		rc = length;
> > >  		goto out;
> > > @@ -1286,6 +1286,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
> > >  	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
> > >  	struct inode *inode = mapping->host;
> > >  	unsigned long vaddr = vmf->address;
> > > +	void *addr;
> > >  	loff_t pos = (loff_t)vmf->pgoff << PAGE_SHIFT;
> > >  	struct iomap iomap = { 0 };
> > 
> > Ugh, I had forgotten that fs/dax.c open-codes iomap_apply, probably
> > because the actor returns vm_fault_t, not bytes copied.  I guess that
> > makes it a tiny bit more complicated to pass in two (struct iomap *) to
> > the iomap_begin function...
> 
> I am not sure I understand this. We do not use iomap_apply() in
> the fault path: dax_iomap_pte_fault(). We just use iomap_begin()
> and iomap_end(). So, why can we not implement your idea of using two
> iomaps?

Oh, sorry, I wasn't trying to say that calling ->iomap_begin made it
*impossible* to implement.  I was merely complaining about the increased
maintenance burden that results from open coding -- now there are three
places where we have to change a struct iomap declaration, not one
(iomap_apply) as I had originally thought.

> What does open-coding iomap-apply mean?

Any function that calls (1) ->iomap_begin; (2) performs an action on the
returned iomap; and (3) then calls calling ->iomap_end.  That's what
iomap_apply() does.

Really I'm just being maintainer-cranky.  Ignore me for now. :)

--D

> 
> -- 
> Goldwyn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
