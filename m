Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E986421E49BB2
 for <linux-nvdimm@lists.01.org>; Tue, 22 Aug 2017 03:05:30 -0700 (PDT)
Date: Tue, 22 Aug 2017 12:08:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170822100801.GF4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
 <20170821210916.GF26220@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170821210916.GF26220@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-08-17 15:09:16, Ross Zwisler wrote:
> On Thu, Aug 17, 2017 at 06:08:13PM +0200, Jan Kara wrote:
> > Add a flag to iomap interface informing the caller that inode needs
> > fdstasync(2) for returned extent to become persistent and use it in DAX
> > fault code so that we map such extents only read only. We propagate the
> > information that the page table entry has been inserted write-protected
> > from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
> > handler is then responsible for calling fdatasync(2) and updating page
> > tables to map pfns read-write. dax_iomap_fault() also takes care of
> > updating vmf->orig_pte to match the PTE that was inserted so that we can
> > safely recheck that PTE did not change while write-enabling it.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c              | 31 +++++++++++++++++++++++++++++++
> >  include/linux/iomap.h |  2 ++
> >  include/linux/mm.h    |  6 +++++-
> >  3 files changed, 38 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index bc040e654cc9..ca88fc356786 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1177,6 +1177,22 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
> >  			goto error_finish_iomap;
> >  		}
> >  
> > +		/*
> > +		 * If we are doing synchronous page fault and inode needs fsync,
> > +		 * we can insert PTE into page tables only after that happens.
> > +		 * Skip insertion for now and return the pfn so that caller can
> > +		 * insert it after fsync is done.
> > +		 */
> > +		if (write && (vma->vm_flags & VM_SYNC) &&
> > +		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {
> > +			if (WARN_ON_ONCE(!pfnp)) {
> > +				error = -EIO;
> > +				goto error_finish_iomap;
> > +			}
> > +			*pfnp = pfn;
> > +			vmf_ret = VM_FAULT_NEEDDSYNC | major;
> > +			goto finish_iomap;
> > +		}
> 
> Sorry for the second reply, but I spotted this during my testing.
> 
> The radix tree entry is inserted and marked as dirty by the
> dax_insert_mapping_entry() call a few lines above this newly added block.

Yes I know and this is actually deliberate. My original thinking was that
we *want* following vfs_fsync_range() to flush out any changes that are
possibly lingering in CPU caches for the block. Now thinking about this
again, changes through write(2) or pre-zeroing of block are non-temporal
anyway and changes through mmap(2) will already dirty the radix tree entry
so it seems you are right that we don't need the dirtying here. I'll change
this. Thanks for asking.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
