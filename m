Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E198F2095D8E4
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 15:40:54 -0700 (PDT)
Date: Thu, 27 Jul 2017 16:42:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 5/7] dax, iomap: Add support for synchronous faults
Message-ID: <20170727224245.GF22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-6-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-6-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 03:12:43PM +0200, Jan Kara wrote:
> Add a flag to iomap interface informing the caller that inode needs
> fdstasync(2) for returned extent to become persistent and use it in DAX
> fault code so that we map such extents only read only. We propagate the
> information that the page table entry has been inserted write-protected
> from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
> handler is then responsible for calling fdatasync(2) and updating page
> tables to map pfns read-write. dax_iomap_fault() also takes care of
> updating vmf->orig_pte to match the PTE that was inserted so that we can
> safely recheck that PTE did not change while write-enabling it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
<>
> @@ -1385,9 +1409,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, bool sync,
>  	if (iomap.offset + iomap.length < pos + PMD_SIZE)
>  		goto finish_iomap;
>  
> +	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
> +			(iomap.flags & IOMAP_F_NEEDDSYNC);

I already mentioned this in my response to your cover letter, but I think that
we can just lean really heavily on IOMAP_F_NEEDDSYNC and have that let us know
that we are doing sync faults and that the fault is a write.  That simplifies
a few things in this patch, with the above just becoming:

	force_ro = (iomap.flags & IOMAP_F_NEEDDSYNC);

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index fa036093e76c..5085647d9f2f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1142,6 +1142,8 @@ static inline void clear_page_pfmemalloc(struct page *page)
>  #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
>  #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
>  #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
> +#define VM_FAULT_RO	0x2000		/* Write fault was handled just by
> +					 * inserting RO page table entry for DAX */

I wonder if we should name this flag something a little stronger and more
specific to its usage with respect to DAX and sync faults?  Maybe
"VM_FAULT_NEEDDSYNC" for consistency with the iomap flag?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
