Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC4198206A
 for <linux-nvdimm@lists.01.org>; Fri, 16 Dec 2016 08:19:18 -0800 (PST)
Date: Fri, 16 Dec 2016 09:19:16 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 1/3] dax: masking off __GFP_FS in fs DAX handlers
Message-ID: <20161216161916.GA2410@linux.intel.com>
References: <148184524161.184728.14005697153880489871.stgit@djiang5-desk3.ch.intel.com>
 <20161216010730.GY4219@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161216010730.GY4219@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-mm@kvack.org, tytso@mit.edu, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 16, 2016 at 12:07:30PM +1100, Dave Chinner wrote:
> On Thu, Dec 15, 2016 at 04:40:41PM -0700, Dave Jiang wrote:
> > The caller into dax needs to clear __GFP_FS mask bit since it's
> > responsible for acquiring locks / transactions that blocks __GFP_FS
> > allocation.  The caller will restore the original mask when dax function
> > returns.
> 
> What's the allocation problem you're working around here? Can you
> please describe the call chain that is the problem?
> 
> >  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> >  
> >  	if (IS_DAX(inode)) {
> > +		gfp_t old_gfp = vmf->gfp_mask;
> > +
> > +		vmf->gfp_mask &= ~__GFP_FS;
> >  		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
> > +		vmf->gfp_mask = old_gfp;
> 
> I really have to say that I hate code that clears and restores flags
> without any explanation of why the code needs to play flag tricks. I
> take one look at the XFS fault handling code and ask myself now "why
> the hell do we need to clear those flags?" Especially as the other
> paths into generic fault handlers /don't/ require us to do this.
> What does DAX do that require us to treat memory allocation contexts
> differently to the filemap_fault() path?

This was done in response to Jan Kara's concern:

  The gfp_mask that propagates from __do_fault() or do_page_mkwrite() is fine
  because at that point it is correct. But once we grab filesystem locks which
  are not reclaim safe, we should update vmf->gfp_mask we pass further down
  into DAX code to not contain __GFP_FS (that's a bug we apparently have
  there). And inside DAX code, we definitely are not generally safe to add
  __GFP_FS to mapping_gfp_mask(). Maybe we'd be better off propagating struct
  vm_fault into this function, using passed gfp_mask there and make sure
  callers update gfp_mask as appropriate.

https://lkml.org/lkml/2016/10/4/37

IIUC I think the concern is that, for example, in xfs_filemap_page_mkwrite()
we take a read lock on the struct inode.i_rwsem before we call
dax_iomap_fault().

dax_iomap_fault() then calls find_or_create_page(), etc. with the
vfm->gfp_mask we were given.

I believe the concern is that if that memory allocation tries to do FS
operations to free memory because __GFP_FS is part of the gfp mask, then we
could end up deadlocking because we are already holding FS locks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
