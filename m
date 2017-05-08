Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9416021A0BAA1
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 10:25:30 -0700 (PDT)
Date: Mon, 8 May 2017 11:25:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 4/4] dax: Fix data corruption when fault races with write
Message-ID: <20170508172527.GA18408@linux.intel.com>
References: <20170505072500.25692-1-jack@suse.cz>
 <20170505072500.25692-5-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170505072500.25692-5-jack@suse.cz>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 05, 2017 at 09:25:00AM +0200, Jan Kara wrote:
> Currently DAX read fault can race with write(2) in the following way:
> 
> CPU1 - write(2)			CPU2 - read fault
> 				dax_iomap_pte_fault()
> 				  ->iomap_begin() - sees hole
> dax_iomap_rw()
>   iomap_apply()
>     ->iomap_begin - allocates blocks
>     dax_iomap_actor()
>       invalidate_inode_pages2_range()
>         - there's nothing to invalidate
> 				  grab_mapping_entry()
> 				  - we add zero page in the radix tree
> 				    and map it to page tables
> 
> The result is that hole page is mapped into page tables (and thus zeros
> are seen in mmap) while file has data written in that place.
> 
> Fix the problem by locking exception entry before mapping blocks for the
> fault. That way we are sure invalidate_inode_pages2_range() call for
> racing write will either block on entry lock waiting for the fault to
> finish (and unmap stale page tables after that) or read fault will see
> already allocated blocks by write(2).
> 
> Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, this looks correct to me.  Thanks!

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
