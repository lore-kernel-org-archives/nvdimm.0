Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE00A21E47D54
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 09:36:22 -0700 (PDT)
Date: Wed, 23 Aug 2017 10:38:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170823163826.GB25999@linux.intel.com>
References: <20170822222434.146233-1-dodgen@google.com>
 <bea6897723e5bf09d893b2ca40263a894a284a5a.1503459187.git.dodgen@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bea6897723e5bf09d893b2ca40263a894a284a5a.1503459187.git.dodgen@google.com>
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
To: rdodgen@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 22, 2017 at 08:37:04PM -0700, rdodgen@gmail.com wrote:
> From: Randy Dodgen <dodgen@google.com>
> 
> If an ext4 filesystem is mounted with both the DAX and read-only
> options, executables on that filesystem will fail to start (claiming
> 'Segmentation fault') due to the fault handler returning
> VM_FAULT_SIGBUS.
> 
> This is due to the DAX fault handler (see ext4_dax_huge_fault)
> attempting to write to the journal when FAULT_FLAG_WRITE is set. This is
> the wrong behavior for write faults which will lead to a COW page; in
> particular, this fails for readonly mounts.
> 
> This changes replicates some check from dax_iomap_fault to more
> precisely reason about when a journal-write is needed.
> 
> It might be the case that this could be better handled in
> ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
> dax_iomap_fault). These is some overlap already (e.g. grabbing journal
> handles).
> 
> Signed-off-by: Randy Dodgen <dodgen@google.com>
> ---
> 
> I'm resending for some DMARC-proofing (thanks Ted for the explanation), a
> missing Signed-off-by, and some extra cc's. Oops!
> 
>  fs/ext4/file.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0d7cf0cc9b87..d512fb85a3e3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -279,7 +279,31 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  	handle_t *handle = NULL;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct super_block *sb = inode->i_sb;
> -	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	bool write;
> +
> +	/*
> +	 * We have to distinguish real writes from writes which will result in a
> +	 * COW page
> +	 * - COW writes need to fall-back to installing PTEs. See
> +	 *   dax_iomap_pmd_fault.
> +	 * - COW writes should *not* poke the journal (the file will not be
> +	 *   changed). Doing so would cause unintended failures when mounted
> +	 *   read-only.
> +	 */
> +	if (pe_size == PE_SIZE_PTE) {
> +		/* See dax_iomap_pte_fault. */
> +		write = (vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page;
> +	} else if (pe_size == PE_SIZE_PMD) {
> +		/* See dax_iomap_pmd_fault. */
> +		write = vmf->flags & FAULT_FLAG_WRITE;
> +		if (write && !(vmf->vma->vm_flags & VM_SHARED)) {
> +			split_huge_pmd(vmf->vma, vmf->pmd, vmf->address);
> +			count_vm_event(THP_FAULT_FALLBACK);
> +			return VM_FAULT_FALLBACK;
> +		}
> +	} else {
> +		return VM_FAULT_FALLBACK;
> +	}

This works in my setup, though the logic could be simpler.

For all fault sizes you can rely on the fact that a COW write will happen when
we have FAULT_FLAG_WRITE but not VM_SHARED.  This is the logic that we use to
know to set up vmf->cow_page() in do_fault() by calling do_cow_fault(), and in
finish_fault().

I think your test can then just become:

	write = (vmf->flags & FAULT_FLAG_WRITE) && 
		(vmf->vma->vm_flags & VM_SHARED);

With some appropriate commenting.

You can then let the DAX fault handlers worry about validating the fault size
and splitting the PMD on fallback.

I'll let someone with more ext4-fu comment on whether it is okay to skip the
journal entry when doing a COW fault.  This must be handled in ext4 for the
non-DAX case, but I don't see any more checks for VM_SHARED or
FAULT_FLAG_WRITE in fs/ext4, so maybe there is a better way?

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
