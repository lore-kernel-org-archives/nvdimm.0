Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99F8821F833A7
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 01:34:05 -0800 (PST)
Date: Thu, 4 Jan 2018 10:39:06 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 15/18] mm, fs, dax: use page->mapping to warn if dma
 collides with truncate
Message-ID: <20180104093906.GC29010@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat 23-12-17 16:57:20, Dan Williams wrote:
> Catch cases where truncate encounters pages that are still under active
> dma. This warning is a canary for potential data corruption as truncated
> blocks could be allocated to a new file while the device is still
> perform i/o.
> 
> Here is an example of a collision that this implementation catches:
> 
>  WARNING: CPU: 2 PID: 1286 at fs/dax.c:343 dax_disassociate_entry+0x55/0x80
>  [..]
>  Call Trace:
>   __dax_invalidate_mapping_entry+0x6c/0xf0
>   dax_delete_mapping_entry+0xf/0x20
>   truncate_exceptional_pvec_entries.part.12+0x1af/0x200
>   truncate_inode_pages_range+0x268/0x970
>   ? tlb_gather_mmu+0x10/0x20
>   ? up_write+0x1c/0x40
>   ? unmap_mapping_range+0x73/0x140
>   xfs_free_file_space+0x1b6/0x5b0 [xfs]
>   ? xfs_file_fallocate+0x7f/0x320 [xfs]
>   ? down_write_nested+0x40/0x70
>   ? xfs_ilock+0x21d/0x2f0 [xfs]
>   xfs_file_fallocate+0x162/0x320 [xfs]
>   ? rcu_read_lock_sched_held+0x3f/0x70
>   ? rcu_sync_lockdep_assert+0x2a/0x50
>   ? __sb_start_write+0xd0/0x1b0
>   ? vfs_fallocate+0x20c/0x270
>   vfs_fallocate+0x154/0x270
>   SyS_fallocate+0x43/0x80
>   entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
