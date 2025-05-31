Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B070182B7;
	Sat, 31 May 2025 20:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748722663; cv=none; b=eCBTiKzBl5k8WTnxNg6DCTWe5oWyyvRQc7j9Q3IsRtvRb5ak6bvM62NU9ZtATtqdCkm2p7mwEgQ6Nff8oXQ63LT0AcpWGXhVJQoP9x3maQRKjGVI/Da8WIKbl8eYjZqjmOU2v2mfi3tsxr7M8Tkv1K0kj9gDpwTzs6YOGHBLpCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748722663; c=relaxed/simple;
	bh=VJA8cepSAx8a/24HjjDvLzNnXghHImEo+X+AVZrO3HI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXMdq/8kNYGiB35xx4szzBXsGGTcXs6+ujAh8mym/JeJsd7dHpS+LUACR47uNhb9a58o5W9plqx/GmewduLHPYI51pJzEq0uK2cYxarnoTkzAvlQ5hMvt3H9mUBaqUDVPbWQH4XoaL46CRO+5zFqOdL1q8hRcOHYJClL4ePdscs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DE5C4CEEF;
	Sat, 31 May 2025 20:17:42 +0000 (UTC)
Date: Sat, 31 May 2025 16:18:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>, Shiyang Ruan 
 <ruansy.fnst@fujitsu.com>, "Darrick J. Wong" <djwong@kernel.org>, Ross 
 Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] fsdax: Remove unused trace events for dax insert
 mapping
Message-ID: <20250531161849.3a5598d4@gandalf.local.home>
In-Reply-To: <20250529152211.688800c9@gandalf.local.home>
References: <20250529152211.688800c9@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[ Ignore the request to the v1 version of of this patch ]

Can I get an acked-by, and I'll pull this in through my tree (with the
other patches that remove unused events)?

Thanks,

-- Steve

On Thu, 29 May 2025 15:22:11 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> When the dax_fault_actor() helper was factored out, it removed the calls
> to the dax_pmd_insert_mapping and dax_insert_mapping events but never
> removed the events themselves. As each event created takes up memory
> (roughly 5K each), this is a waste as it is never used.
> 
> Remove the unused dax_pmd_insert_mapping and dax_insert_mapping trace
> events.
> 
> Link: https://lore.kernel.org/all/20250529130138.544ffec4@gandalf.local.home/
> 
> Fixes: c2436190e492 ("fsdax: factor out a dax_fault_actor() helper")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20250529150722.19e04332@gandalf.local.home/
> 
> - Removed dax_insert_mapping too
> 
>  include/trace/events/fs_dax.h | 78 -----------------------------------
>  1 file changed, 78 deletions(-)
> 
> diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
> index 86fe6aecff1e..76b56f78abb0 100644
> --- a/include/trace/events/fs_dax.h
> +++ b/include/trace/events/fs_dax.h
> @@ -102,54 +102,6 @@ DEFINE_EVENT(dax_pmd_load_hole_class, name, \
>  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
>  DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
>  
> -DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
> -	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
> -		long length, pfn_t pfn, void *radix_entry),
> -	TP_ARGS(inode, vmf, length, pfn, radix_entry),
> -	TP_STRUCT__entry(
> -		__field(unsigned long, ino)
> -		__field(unsigned long, vm_flags)
> -		__field(unsigned long, address)
> -		__field(long, length)
> -		__field(u64, pfn_val)
> -		__field(void *, radix_entry)
> -		__field(dev_t, dev)
> -		__field(int, write)
> -	),
> -	TP_fast_assign(
> -		__entry->dev = inode->i_sb->s_dev;
> -		__entry->ino = inode->i_ino;
> -		__entry->vm_flags = vmf->vma->vm_flags;
> -		__entry->address = vmf->address;
> -		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
> -		__entry->length = length;
> -		__entry->pfn_val = pfn.val;
> -		__entry->radix_entry = radix_entry;
> -	),
> -	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
> -			"pfn %#llx %s radix_entry %#lx",
> -		MAJOR(__entry->dev),
> -		MINOR(__entry->dev),
> -		__entry->ino,
> -		__entry->vm_flags & VM_SHARED ? "shared" : "private",
> -		__entry->write ? "write" : "read",
> -		__entry->address,
> -		__entry->length,
> -		__entry->pfn_val & ~PFN_FLAGS_MASK,
> -		__print_flags_u64(__entry->pfn_val & PFN_FLAGS_MASK, "|",
> -			PFN_FLAGS_TRACE),
> -		(unsigned long)__entry->radix_entry
> -	)
> -)
> -
> -#define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
> -DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
> -	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
> -		long length, pfn_t pfn, void *radix_entry), \
> -	TP_ARGS(inode, vmf, length, pfn, radix_entry))
> -
> -DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
> -
>  DECLARE_EVENT_CLASS(dax_pte_fault_class,
>  	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
>  	TP_ARGS(inode, vmf, result),
> @@ -194,36 +146,6 @@ DEFINE_PTE_FAULT_EVENT(dax_load_hole);
>  DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite_no_entry);
>  DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite);
>  
> -TRACE_EVENT(dax_insert_mapping,
> -	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
> -	TP_ARGS(inode, vmf, radix_entry),
> -	TP_STRUCT__entry(
> -		__field(unsigned long, ino)
> -		__field(unsigned long, vm_flags)
> -		__field(unsigned long, address)
> -		__field(void *, radix_entry)
> -		__field(dev_t, dev)
> -		__field(int, write)
> -	),
> -	TP_fast_assign(
> -		__entry->dev = inode->i_sb->s_dev;
> -		__entry->ino = inode->i_ino;
> -		__entry->vm_flags = vmf->vma->vm_flags;
> -		__entry->address = vmf->address;
> -		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
> -		__entry->radix_entry = radix_entry;
> -	),
> -	TP_printk("dev %d:%d ino %#lx %s %s address %#lx radix_entry %#lx",
> -		MAJOR(__entry->dev),
> -		MINOR(__entry->dev),
> -		__entry->ino,
> -		__entry->vm_flags & VM_SHARED ? "shared" : "private",
> -		__entry->write ? "write" : "read",
> -		__entry->address,
> -		(unsigned long)__entry->radix_entry
> -	)
> -)
> -
>  DECLARE_EVENT_CLASS(dax_writeback_range_class,
>  	TP_PROTO(struct inode *inode, pgoff_t start_index, pgoff_t end_index),
>  	TP_ARGS(inode, start_index, end_index),

