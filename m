Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 2 Jan 2016 11:43:09 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 7/8] xfs: Support for transparent PUD pages
Message-ID: <20160102164309.GK2457@linux.intel.com>
References: <1450974037-24775-1-git-send-email-matthew.r.wilcox@intel.com>
 <1450974037-24775-8-git-send-email-matthew.r.wilcox@intel.com>
 <20151230233007.GA6682@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151230233007.GA6682@dastard>
Sender: owner-linux-mm@kvack.org
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 31, 2015 at 10:30:27AM +1100, Dave Chinner wrote:
> > @@ -1637,6 +1669,7 @@ xfs_filemap_pfn_mkwrite(
> >  static const struct vm_operations_struct xfs_file_vm_ops = {
> >  	.fault		= xfs_filemap_fault,
> >  	.pmd_fault	= xfs_filemap_pmd_fault,
> > +	.pud_fault	= xfs_filemap_pud_fault,
> 
> This is getting silly - we now have 3 different page fault handlers
> that all do exactly the same thing. Please abstract this so that the
> page/pmd/pud is transparent and gets passed through to the generic
> handler code that then handles the differences between page/pmd/pud
> internally.
> 
> This, after all, is the original reason that the ->fault handler was
> introduced....

I agree that it's silly, but this is the direction I was asked to go in by
the MM people at the last MM summit.  There was agreement that this needs
to be abstracted, but that should be left for a separate cleanup round.
I did prototype something I called a vpte (virtual pte), but that's very
much on the back burner for now.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
