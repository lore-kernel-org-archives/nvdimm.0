Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD8951A206B
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 13:47:15 -0700 (PDT)
Date: Mon, 18 Apr 2016 22:47:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 1/2] dax: add dax_get_unmapped_area for pmd mappings
Message-ID: <20160418204708.GB17889@quack2.suse.cz>
References: <1460652511-19636-1-git-send-email-toshi.kani@hpe.com>
 <1460652511-19636-2-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460652511-19636-2-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: tytso@mit.edu, jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu 14-04-16 10:48:30, Toshi Kani wrote:
> +
> +/**
> + * dax_get_unmapped_area - handle get_unmapped_area for a DAX file
> + * @filp: The file being mmap'd, if not NULL
> + * @addr: The mmap address. If NULL, the kernel assigns the address
> + * @len: The mmap size in bytes
> + * @pgoff: The page offset in the file where the mapping starts from.
> + * @flags: The mmap flags
> + *
> + * This function can be called by a filesystem for get_unmapped_area().
> + * When a target file is a DAX file, it aligns the mmap address at the
> + * beginning of the file by the pmd size.
> + */
> +unsigned long dax_get_unmapped_area(struct file *filp, unsigned long addr,
> +		unsigned long len, unsigned long pgoff, unsigned long flags)
> +{
> +	unsigned long off, off_end, off_pmd, len_pmd, addr_pmd;

I think we need to use 'loff_t' for the offsets for things to work on
32-bits.

> +	if (!IS_ENABLED(CONFIG_FS_DAX_PMD) ||
> +	    !filp || addr || !IS_DAX(filp->f_mapping->host))
> +		goto out;
> +
> +	off = pgoff << PAGE_SHIFT;

And here we need to type to loff_t before the shift...

> +	off_end = off + len;
> +	off_pmd = round_up(off, PMD_SIZE);  /* pmd-aligned offset */
> +
> +	if ((off_end <= off_pmd) || ((off_end - off_pmd) < PMD_SIZE))

None of these parenthesis is actually needed (and IMHO they make the code
less readable, not more).

> +		goto out;
> +
> +	len_pmd = len + PMD_SIZE;
> +	if ((off + len_pmd) < off)
> +		goto out;
> +
> +	addr_pmd = current->mm->get_unmapped_area(filp, addr, len_pmd,
> +						  pgoff, flags);
> +	if (!IS_ERR_VALUE(addr_pmd)) {
> +		addr_pmd += (off - addr_pmd) & (PMD_SIZE - 1);
> +		return addr_pmd;

Otherwise the patch looks good to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
