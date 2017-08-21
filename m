Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 924EA2095B9D6
 for <linux-nvdimm@lists.01.org>; Mon, 21 Aug 2017 11:56:11 -0700 (PDT)
Date: Mon, 21 Aug 2017 12:58:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170821185830.GB26220@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-12-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 06:08:13PM +0200, Jan Kara wrote:
> Add a flag to iomap interface informing the caller that inode needs
> fdstasync(2) for returned extent to become persistent and use it in DAX
> fault code so that we map such extents only read only. We propagate the
> information that the page table entry has been inserted write-protected
> from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
> handler is then responsible for calling fdatasync(2) and updating page
> tables to map pfns read-write. dax_iomap_fault() also takes care of
> updating vmf->orig_pte to match the PTE that was inserted so that we can
> safely recheck that PTE did not change while write-enabling it.

This changelog needs a little love.  s/VM_FAULT_RO/VM_FAULT_NEEDDSYNC/, the
new path doesn't do the RO mapping, but instead just does the entire RW
mapping after the fdatasync is complete, the vmf->orig_pte manipulation went
away, etc.

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c              | 31 +++++++++++++++++++++++++++++++
>  include/linux/iomap.h |  2 ++
>  include/linux/mm.h    |  6 +++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index bc040e654cc9..ca88fc356786 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1177,6 +1177,22 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
>  			goto error_finish_iomap;
>  		}
>  
> +		/*
> +		 * If we are doing synchronous page fault and inode needs fsync,
> +		 * we can insert PTE into page tables only after that happens.
> +		 * Skip insertion for now and return the pfn so that caller can
> +		 * insert it after fsync is done.
> +		 */
> +		if (write && (vma->vm_flags & VM_SYNC) &&
> +		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {

Just a small nit, but I don't think we really need to check for 'write' here.
The fact that IOMAP_F_NEEDDSYNC is set tells us that we are doing a write.

	if ((flags & IOMAP_WRITE) &&
	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
					EXT4_I(inode)->i_datasync_tid))
		iomap->flags |= IOMAP_F_NEEDDSYNC;

Ditto for the PMD case.

With that one simplification and a cleaned up changelog, you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> +			if (WARN_ON_ONCE(!pfnp)) {
> +				error = -EIO;
> +				goto error_finish_iomap;
> +			}
> +			*pfnp = pfn;
> +			vmf_ret = VM_FAULT_NEEDDSYNC | major;
> +			goto finish_iomap;
> +		}
>  		trace_dax_insert_mapping(inode, vmf, entry);
>  		if (write)
>  			error = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
