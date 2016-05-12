Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 233EC1A1E7A
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 12:00:01 -0700 (PDT)
Date: Thu, 12 May 2016 12:59:58 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/7] dax: Make huge page handling depend of CONFIG_BROKEN
Message-ID: <20160512185958.GA32376@linux.intel.com>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463070560-1979-3-git-send-email-jack@suse.cz>
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
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 12, 2016 at 06:29:15PM +0200, Jan Kara wrote:
> Currently the handling of huge pages for DAX is racy. For example the
> following can happen:
> 
> CPU0 (THP write fault)			CPU1 (normal read fault)
> 
> __dax_pmd_fault()			__dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
> 					get_block(inode, block, &bh, 0)
> 					  -> not mapped
>   if (!buffer_mapped(&bh) && write)
>     get_block(inode, block, &bh, 1) -> allocates blocks
>   truncate_pagecache_range(inode, lstart, lend);
> 					dax_load_hole();
> 
> This results in data corruption since process on CPU1 won't see changes
> into the file done by CPU0.
> 
> The race can happen even if two normal faults race however with THP the
> situation is even worse because the two faults don't operate on the same
> entries in the radix tree and we want to use these entries for
> serialization. So make THP support in DAX code depend on CONFIG_BROKEN
> for now.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
