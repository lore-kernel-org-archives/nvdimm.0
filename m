Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0BEB21D2E656
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 07:43:11 -0700 (PDT)
Date: Thu, 24 Aug 2017 16:45:44 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170824144544.GE8969@quack2.suse.cz>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
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

On Wed 23-08-17 14:26:52, rdodgen@gmail.com wrote:
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
> This change avoids journal writes for faults that are expected to COW.
> 
> It might be the case that this could be better handled in
> ext4_iomap_begin / ext4_iomap_end (called via iomap_ops inside
> dax_iomap_fault). These is some overlap already (e.g. grabbing journal
> handles).
> 
> Signed-off-by: Randy Dodgen <dodgen@google.com>

Thanks for the verbose comment :). The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> This version is simplified as suggested by Ross; all fault sizes and fallbacks
> are handled by dax_iomap_fault.
> 
>  fs/ext4/file.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 0d7cf0cc9b87..dc1e1fb6b54c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -279,7 +279,20 @@ static int ext4_dax_huge_fault(struct vm_fault *vmf,
>  	handle_t *handle = NULL;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct super_block *sb = inode->i_sb;
> -	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +
> +	/*
> +	 * We have to distinguish real writes from writes which will result in a
> +	 * COW page; COW writes should *not* poke the journal (the file will not
> +	 * be changed). Doing so would cause unintended failures when mounted
> +	 * read-only.
> +	 *
> +	 * We check for VM_SHARED rather than vmf->cow_page since the latter is
> +	 * unset for pe_size != PE_SIZE_PTE (i.e. only in do_cow_fault); for
> +	 * other sizes, dax_iomap_fault will handle splitting / fallback so that
> +	 * we eventually come back with a COW page.
> +	 */
> +	bool write = (vmf->flags & FAULT_FLAG_WRITE) &&
> +		(vmf->vma->vm_flags & VM_SHARED);
>  
>  	if (write) {
>  		sb_start_pagefault(sb);
> -- 
> 2.14.1.342.g6490525c54-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
