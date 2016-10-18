Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12A5B1A1E10
 for <linux-nvdimm@lists.01.org>; Tue, 18 Oct 2016 03:32:52 -0700 (PDT)
Date: Tue, 18 Oct 2016 12:32:48 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/20] mm: Move handling of COW faults into DAX code
Message-ID: <20161018103248.GO3359@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-11-git-send-email-jack@suse.cz>
 <20161017192949.GA21002@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161017192949.GA21002@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 17-10-16 13:29:49, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:14PM +0200, Jan Kara wrote:
> > Move final handling of COW faults from generic code into DAX fault
> > handler. That way generic code doesn't have to be aware of peculiarities
> > of DAX locking so remove that knowledge.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/dax.c            | 22 ++++++++++++++++------
> >  include/linux/dax.h |  7 -------
> >  include/linux/mm.h  |  9 +--------
> >  mm/memory.c         | 14 ++++----------
> >  4 files changed, 21 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 0dc251ca77b8..b1c503930d1d 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -876,10 +876,15 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> >  			goto unlock_entry;
> >  		if (!radix_tree_exceptional_entry(entry)) {
> >  			vmf->page = entry;
> > -			return VM_FAULT_LOCKED;
> > +			if (unlikely(PageHWPoison(entry))) {
> > +				put_locked_mapping_entry(mapping, vmf->pgoff,
> > +							 entry);
> > +				return VM_FAULT_HWPOISON;
> > +			}
> >  		}
> > -		vmf->entry = entry;
> > -		return VM_FAULT_DAX_LOCKED;
> > +		error = finish_fault(vmf);
> > +		put_locked_mapping_entry(mapping, vmf->pgoff, entry);
> > +		return error ? error : VM_FAULT_DONE_COW;
> >  	}
> >  
> >  	if (!buffer_mapped(&bh)) {
> > @@ -1430,10 +1435,15 @@ int iomap_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
> >  			goto unlock_entry;
> >  		if (!radix_tree_exceptional_entry(entry)) {
> >  			vmf->page = entry;
> 
> In __do_fault() we explicitly clear vmf->page in the case where PageHWPoison()
> is set.  I think we can get the same behavior here by moving the call that
> sets vmf->page after the PageHWPoison() check.

Actually, the whole HWPoison checking was non-sensical for DAX. We want to
check for HWPoison to avoid reading from poisoned pages. However for DAX we
either use copy_user_dax() which takes care of IO errors / poisoning itself
or we use clear_user_highpage() which doesn't touch the source page. So we
don't have to check for HWPoison at all. Fixed.

> > -			return VM_FAULT_LOCKED;
> > +			if (unlikely(PageHWPoison(entry))) {
> > +				put_locked_mapping_entry(mapping, vmf->pgoff,
> > +							 entry);
> > +				return VM_FAULT_HWPOISON;
> > +			}
> >  		}
> > -		vmf->entry = entry;
> > -		return VM_FAULT_DAX_LOCKED;
> 
> I think we're missing a call to 
> 
> 	__SetPageUptodate(new_page);

> before finish_fault()?  This call currently lives in do_cow_fault(), and
> is part of the path that we don't skip as part of the VM_FAULT_DAX_LOCKED
> logic.

Ah, great catch. I wonder how the DAX COW test could have passed with this?
Maybe PageUptodate is not used much for anon pages... Anyway thanks for
spotting this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
