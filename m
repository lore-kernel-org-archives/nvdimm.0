Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35B9E2129DBA8
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 01:36:30 -0700 (PDT)
Date: Thu, 20 Jun 2019 10:36:28 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: a few questions about pagevc_lookup_entries
Message-ID: <20190620083628.GH13630@quack2.suse.cz>
References: <CANQeFDCCGED3BR0oTpzQ75gtGpdGCw8FLf+kspBYytw3YteXAw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANQeFDCCGED3BR0oTpzQ75gtGpdGCw8FLf+kspBYytw3YteXAw@mail.gmail.com>
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
To: Liu Bo <obuil.liubo@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, willy@infradead.org, linux-fsdevel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

[added some relevant lists to CC - this can safe some people debugging by
being able to google this discussion]

On Wed 19-06-19 15:57:38, Liu Bo wrote:
> I found a weird dead loop within invalidate_inode_pages2_range, the
> reason being that  pagevec_lookup_entries(index=1) returns an indices
> array which has only one entry storing value 0, and this has led
> invalidate_inode_pages2_range() to a dead loop, something like,
> 
> invalidate_inode_pages2_range()
>   -> while (pagevec_lookup_entries(index=1, indices))
>     ->  for (i = 0; i < pagevec_count(&pvec); i++) {
>       -> index = indices[0]; // index is set to 0
>       -> if (radix_tree_exceptional_entry(page)) {
>           -> if (!invalidate_exceptional_entry2()) //
>                   ->__dax_invalidate_mapping_entry // return 0
>                      -> // entry marked as PAGECACHE_TAG_DIRTY/TOWRITE
>                  ret = -EBUSY;
>           ->continue;
>           } // end of if (radix_tree_exceptional_entry(page))
>     -> index++; // index is set to 1
> 
> The following debug[1] proved the above analysis,  I was wondering if
> this was a corner case that  pagevec_lookup_entries() allows or a
> known bug that has been fixed upstream?
> 
> ps: the kernel in use is 4.19.30 (LTS).

Hum, the above trace suggests you are using DAX. Are you really? Because the
stacktrace below shows we are working on fuse inode so that shouldn't
really be DAX inode...

								Honza

> [1]:
> $git diff
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 71b65aab8077..82bfeeb53135 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -692,6 +692,7 @@ int invalidate_inode_pages2_range(struct
> address_space *mapping,
>                         struct page *page = pvec.pages[i];
> 
>                         /* We rely upon deletion not changing page->index */
> +                       WARN_ONCE(index > indices[i], "index = %d
> indices[%d]=%d\n", index, i, indices[i]);
>                         index = indices[i];
>                         if (index > end)
>                                 break;
> 
> [  129.095383] ------------[ cut here ]------------
> [  129.096164] index = 1 indices[0]=0
> [  129.096786] WARNING: CPU: 0 PID: 3022 at mm/truncate.c:695
> invalidate_inode_pages2_range+0x471/0x500
> [  129.098234] Modules linked in:
> [  129.098717] CPU: 0 PID: 3022 Comm: doio Not tainted 4.19.30+ #4
> ...
> [  129.101288] RIP: 0010:invalidate_inode_pages2_range+0x471/0x500
> ...
> [  129.114162] Call Trace:
> [  129.114623]  ? __schedule+0x2ad/0x860
> [  129.115214]  ? prepare_to_wait_event+0x80/0x140
> [  129.115903]  ? finish_wait+0x3f/0x80
> [  129.116452]  ? request_wait_answer+0x13d/0x210
> [  129.117128]  ? remove_wait_queue+0x60/0x60
> [  129.117757]  ? make_kgid+0x13/0x20
> [  129.118277]  ? fuse_change_attributes_common+0x7d/0x130
> [  129.119057]  ? fuse_change_attributes+0x8d/0x120
> [  129.119754]  fuse_dentry_revalidate+0x2c5/0x300
> [  129.120456]  lookup_fast+0x237/0x2b0
> [  129.121018]  path_openat+0x15f/0x1380
> [  129.121614]  ? generic_update_time+0x6b/0xd0
> [  129.122316]  do_filp_open+0x91/0x100
> [  129.122876]  do_sys_open+0x126/0x210
> [  129.123453]  do_syscall_64+0x55/0x180
> [  129.124036]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  129.124820] RIP: 0033:0x7fbe0cd75e80
> ...
> [  129.134574] ---[ end trace c0fc0bbc5aebf0dc ]---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
