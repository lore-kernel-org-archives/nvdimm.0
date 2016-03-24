Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6409E1A1E69
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 05:51:10 -0700 (PDT)
Date: Thu, 24 Mar 2016 13:51:12 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/10] dax: Fix data corruption for written and mmapped
 files
Message-ID: <20160324125112.GH4025@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-5-git-send-email-jack@suse.cz>
 <20160323173945.GC5544@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160323173945.GC5544@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-03-16 11:39:45, Ross Zwisler wrote:
> On Mon, Mar 21, 2016 at 02:22:49PM +0100, Jan Kara wrote:
> > When a fault to a hole races with write filling the hole, it can happen
> > that block zeroing in __dax_fault() overwrites the data copied by write.
> > Since filesystem is supposed to provide pre-zeroed blocks for fault
> > anyway, just remove the racy zeroing from dax code. The only catch is
> > with read-faults over unwritten block where __dax_fault() filled in the
> > block into page tables anyway. For that case we have to fall back to
> > using hole page now.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index d496466652cd..50d81172438b 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -582,11 +582,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> >  		error = PTR_ERR(dax.addr);
> >  		goto out;
> >  	}
> > -
> > -	if (buffer_unwritten(bh) || buffer_new(bh)) {
> > -		clear_pmem(dax.addr, PAGE_SIZE);
> > -		wmb_pmem();
> > -	}
> 
> I agree that we should be dropping these bits of code, but I think they are
> just dead code that could never be executed?  I don't see how we could have
> hit a race?
> 
> For the above, dax_insert_mapping() is only called if we actually have a block
> mapping (holes go through dax_load_hole()), so for ext4 and XFS I think
> buffer_unwritten() and buffer_new() are always false, so this code could never
> be executed, right?
> 
> I suppose that maybe we could get into here via ext2 if BH_New was set?  Is
> that the race?

Yeah, you are right that only ext2 is prone to the race I have described
since for the rest this should be just a dead code. I'll update the changelog
in this sense.

> >  		if (vmf->flags & FAULT_FLAG_WRITE) {
> >  			error = get_block(inode, block, &bh, 1);
> >  			count_vm_event(PGMAJFAULT);
> > @@ -950,8 +945,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> >  		}
> >  
> >  		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
> > -			clear_pmem(dax.addr, PMD_SIZE);
> > -			wmb_pmem();
> >  			count_vm_event(PGMAJFAULT);
> >  			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
> >  			result |= VM_FAULT_MAJOR;
> 
> I think this whole block is just dead code, right?  Can we ever get into here?
> 
> Same argument applies as from dax_insert_mapping() - if we get this far then
> we have a mapped buffer, and in the PMD case we know we're on ext4 of XFS
> since ext2 doesn't do huge page mappings.
> 
> So, buffer_unwritten() and buffer_new() both always return false, right?
> 
> Yea...we really need to clean up our buffer flag handling. :)

Hum, looking at the code now I'm somewhat confused. __dax_pmd_fault does:

if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
	... install zero page ...
}

but what the buffer_update() check is about? That will never be true,
right? So we will fall back to the second branch and there we can actually
hit the

if (buffer_unwritten(&bh) || buffer_new(&bh)) {

because for read fault we can get unwritten buffer. But I guess that is a
mistake in the first branch. After fixing that we can just remove the
second if as you say. Unless you object, I'll update the patch in this
sense.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
