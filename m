Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 883FB21DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 09:21:37 -0700 (PDT)
Date: Tue, 28 Mar 2017 10:21:35 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 08/13] x86, libnvdimm, dax: stop abusing
 __copy_user_nocache
Message-ID: <20170328162135.GA27993@linux.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148488425640.37913.8286479292337338357.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148488425640.37913.8286479292337338357.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 19, 2017 at 07:50:56PM -0800, Dan Williams wrote:
<>
> diff --git a/drivers/nvdimm/x86-asm.S b/drivers/nvdimm/x86-asm.S
> new file mode 100644
> index 000000000000..23c5ec94e896
> --- /dev/null
> +++ b/drivers/nvdimm/x86-asm.S
> @@ -0,0 +1,71 @@
> +/*
> + * Copyright (c) 2017, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +#include <linux/linkage.h>
> +
> +/*
> + * __arch_memcpy_to_pmem - non-temporal + unordered memory copy
> + *
> + * 8-byte alignment for destination, source, and len. The results of
> + * this transfer are not persistent or globally visible until a
> + * sub-sequent sfence (REQ_FLUSH) to the pmem driver.
> + *
> + * Derived from __copy_user_nocache.
> + */
> +ENTRY(__arch_memcpy_to_pmem)
> +	/* Set 4x8-byte copy count and remainder */
> +	movl %edx,%ecx
> +	andl $63,%edx
> +	shrl $6,%ecx
> +	jz .L_8b_pmem_copy_entry	/* jump if count is 0 */
> +
> +	/* Perform 4x8-byte pmem loop-copy */
> +.L_4x8b_pmem_copy_loop:
> +	movq (%rsi),%r8
> +	movq 1*8(%rsi),%r9
> +	movq 2*8(%rsi),%r10
> +	movq 3*8(%rsi),%r11
> +	movnti %r8,(%rdi)
> +	movnti %r9,1*8(%rdi)
> +	movnti %r10,2*8(%rdi)
> +	movnti %r11,3*8(%rdi)
> +	movq 4*8(%rsi),%r8
> +	movq 5*8(%rsi),%r9
> +	movq 6*8(%rsi),%r10
> +	movq 7*8(%rsi),%r11
> +	movnti %r8,4*8(%rdi)
> +	movnti %r9,5*8(%rdi)
> +	movnti %r10,6*8(%rdi)
> +	movnti %r11,7*8(%rdi)
> +	leaq 64(%rsi),%rsi
> +	leaq 64(%rdi),%rdi
> +	decl %ecx
> +	jnz .L_4x8b_pmem_copy_loop
> +
> +	/* Set 8-byte copy count and remainder */
> +.L_8b_pmem_copy_entry:
> +	movl %edx,%ecx
> +	andl $7,%edx

I don't think you need to andl %edx here - in __copy_user_nocache() %edx was
used to keep the remaining count that couldn't be handled with the size of
transfers we were doing in a given loop, so in .L_8b_nocache_copy_entry we
mask with 7 so we can use the remaining count in .L_4b_nocache_copy_entry
and/or .L_1b_cache_copy_entry.

In the PMEM case, though, the 8 byte loop is the end of the line, so we just
ignore any trailing data that isn't 8 byte aligned.

I'm not sure if it's important to use %ecx as your local loop variable - is
this a widely held convention?  If not, you could just leave %ecx out of it
and use %edx directly in the 8 byte copy, i.e.:

        /* Set 8-byte copy count and remainder */
.L_8b_pmem_copy_entry:
        shrl $3,%edx
        jnz .L_8b_pmem_copy_loop /* continue if count non-zero */
        ret

        /* Perform 8-byte pmem loop-copy */
.L_8b_pmem_copy_loop:
        movq (%rsi),%r8
        movnti %r8,(%rdi)
        leaq 8(%rsi),%rsi
        leaq 8(%rdi),%rdi
        decl %edx
        jnz .L_8b_pmem_copy_loop
        ret
ENDPROC(__arch_memcpy_to_pmem)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
