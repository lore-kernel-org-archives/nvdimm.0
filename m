Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 18 Nov 2015 16:09:45 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
Message-ID: <20151118150945.GE6097@quack.suse.cz>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
 <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, stable@vger.kernel.org, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 17-11-15 12:16:14, Dan Williams wrote:
> Currently dax mappings survive block_device shutdown.  While page cache
> pages are permitted to be read/written after the block_device is torn
> down this is not acceptable in the dax case as all media access must end
> when the device is disabled.  The pfn backing a dax mapping is permitted
> to be invalidated after bdev shutdown and this is indeed the case with
> brd.
> 
> When a dax capable block_device driver calls del_gendisk() in its
> shutdown path, or a filesystem evicts an inode it needs to ensure that
> all the pfns that had been mapped via bdev_direct_access() are unmapped.
> This is different than the pagecache backed case where
> truncate_inode_pages() is sufficient to end I/O to pages mapped to a
> dying inode.
> 
> Since dax bypasses the page cache we need to unmap in addition to
> truncating pages.  Also, since dax mappings are not accounted in the
> mapping radix we uncoditionally truncate all inodes with the S_DAX flag.
> Likely when we add support for dynamic dax enable/disable control we'll
> have infrastructure to detect if the inode is unmapped and can skip the
> truncate.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/inode.c    |   27 +++++++++++++++++++++++++++
>  mm/truncate.c |   13 +++++++++++--
>  2 files changed, 38 insertions(+), 2 deletions(-)
...
> @@ -433,7 +434,15 @@ void truncate_inode_pages_final(struct address_space *mapping)
>  		spin_lock_irq(&mapping->tree_lock);
>  		spin_unlock_irq(&mapping->tree_lock);
>  
> -		truncate_inode_pages(mapping, 0);
> +		/*
> +		 * In the case of DAX we also need to unmap the inode
> +		 * since the pfn backing the mapping may be invalidated
> +		 * after this returns
> +		 */
> +		if (IS_DAX(inode))
> +			truncate_pagecache(inode, 0);
> +		else
> +			truncate_inode_pages(mapping, 0);
>  	}

Hum, I don't get this. truncate_inode_pages_final() gets called when inode
has no more users. So there are no mappings of the inode. So how could
truncate_pagecache() possibly make a difference?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
