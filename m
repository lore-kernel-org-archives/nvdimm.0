Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8CA2264A1F7
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 03:06:59 -0700 (PDT)
Date: Wed, 4 Apr 2018 12:06:57 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v8 15/18] mm, fs, dax: handle layout changes to pinned
 dax mappings
Message-ID: <20180404100657.qpodshwzmh4djwej@quack2.suse.cz>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152246901060.36038.4487158506830998280.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180404094656.dssixqvvdcp5jff2@quack2.suse.cz>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, snitzer@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 04-04-18 11:46:56, Jan Kara wrote:
> On Fri 30-03-18 21:03:30, Dan Williams wrote:
> > Background:
> > 
> > get_user_pages() in the filesystem pins file backed memory pages for
> > access by devices performing dma. However, it only pins the memory pages
> > not the page-to-file offset association. If a file is truncated the
> > pages are mapped out of the file and dma may continue indefinitely into
> > a page that is owned by a device driver. This breaks coherency of the
> > file vs dma, but the assumption is that if userspace wants the
> > file-space truncated it does not matter what data is inbound from the
> > device, it is not relevant anymore. The only expectation is that dma can
> > safely continue while the filesystem reallocates the block(s).
> > 
> > Problem:
> > 
> > This expectation that dma can safely continue while the filesystem
> > changes the block map is broken by dax. With dax the target dma page
> > *is* the filesystem block. The model of leaving the page pinned for dma,
> > but truncating the file block out of the file, means that the filesytem
> > is free to reallocate a block under active dma to another file and now
> > the expected data-incoherency situation has turned into active
> > data-corruption.
> > 
> > Solution:
> > 
> > Defer all filesystem operations (fallocate(), truncate()) on a dax mode
> > file while any page/block in the file is under active dma. This solution
> > assumes that dma is transient. Cases where dma operations are known to
> > not be transient, like RDMA, have been explicitly disabled via
> > commits like 5f1d43de5416 "IB/core: disable memory registration of
> > filesystem-dax vmas".
> > 
> > The dax_layout_busy_page() routine is called by filesystems with a lock
> > held against mm faults (i_mmap_lock) to find pinned / busy dax pages.
> > The process of looking up a busy page invalidates all mappings
> > to trigger any subsequent get_user_pages() to block on i_mmap_lock.
> > The filesystem continues to call dax_layout_busy_page() until it finally
> > returns no more active pages. This approach assumes that the page
> > pinning is transient, if that assumption is violated the system would
> > have likely hung from the uncompleted I/O.
> > 
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> > Cc: Dave Chinner <david@fromorbit.com>
> > Cc: Matthew Wilcox <mawilcox@microsoft.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Reported-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/dax/super.c |    2 +
> >  fs/dax.c            |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dax.h |   25 ++++++++++++++
> >  mm/gup.c            |    5 +++
> >  4 files changed, 123 insertions(+), 1 deletion(-)
> 
> ...
> 
> > +/**
> > + * dax_layout_busy_page - find first pinned page in @mapping
> > + * @mapping: address space to scan for a page with ref count > 1
> > + *
> > + * DAX requires ZONE_DEVICE mapped pages. These pages are never
> > + * 'onlined' to the page allocator so they are considered idle when
> > + * page->count == 1. A filesystem uses this interface to determine if
> > + * any page in the mapping is busy, i.e. for DMA, or other
> > + * get_user_pages() usages.
> > + *
> > + * It is expected that the filesystem is holding locks to block the
> > + * establishment of new mappings in this address_space. I.e. it expects
> > + * to be able to run unmap_mapping_range() and subsequently not race
> > + * mapping_mapped() becoming true. It expects that get_user_pages() pte
> > + * walks are performed under rcu_read_lock().
> > + */
> > +struct page *dax_layout_busy_page(struct address_space *mapping)
> > +{
> > +	pgoff_t	indices[PAGEVEC_SIZE];
> > +	struct page *page = NULL;
> > +	struct pagevec pvec;
> > +	pgoff_t	index, end;
> > +	unsigned i;
> > +
> > +	/*
> > +	 * In the 'limited' case get_user_pages() for dax is disabled.
> > +	 */
> > +	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
> > +		return NULL;
> > +
> > +	if (!dax_mapping(mapping) || !mapping_mapped(mapping))
> > +		return NULL;
> > +
> > +	pagevec_init(&pvec);
> > +	index = 0;
> > +	end = -1;
> > +	/*
> > +	 * Flush dax_layout_lock() sections to ensure all possible page
> > +	 * references have been taken, or otherwise arrange for faults
> > +	 * to block on the filesystem lock that is taken for
> > +	 * establishing new mappings.
> > +	 */
> > +	unmap_mapping_range(mapping, 0, 0, 1);
> > +	synchronize_rcu();
> 
> So I still don't like the use of RCU for this. It just seems as an abuse to
> use RCU like that. Furthermore it has a hefty latency cost for the truncate
> path. A trivial test to truncate 100 times the last page of a 16k file that
> is mmaped (only the first page):
> 
> DAX+your patches	3.899s
> non-DAX			0.015s
> 
> So you can see synchronize_rcu() increased time to run truncate(2) more
> than 200 times (the process is indeed sitting in __wait_rcu_gp all the
> time). IMHO that's just too costly.

Forgot to add some more thoughts: Maybe we could use global percpu rwsem
for this instead of RCU? That would cut down the truncate latency and the
cost on GUP path should be very small. Or I'm still not convinced that my
PageTruncateInProgress() idea cannot be made to work - that would be free
on the GUP side for the non-DAX case, relatively cheap for the DAX case,
and also reasonably cheap for the truncate side. But I admit it requires
more work on the fs side to propagate offsets that are going to be
truncated into the DAX helper.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
