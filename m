Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 19 Nov 2015 13:55:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] mm, dax: truncate dax mappings at bdev or fs shutdown
Message-ID: <20151119125541.GC18581@quack.suse.cz>
References: <20151117201551.15053.32709.stgit@dwillia2-desk3.jf.intel.com>
 <20151117201614.15053.62376.stgit@dwillia2-desk3.jf.intel.com>
 <20151118150945.GE6097@quack.suse.cz>
 <1447892533.13153.8.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1447892533.13153.8.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "jack@suse.com" <jack@suse.com>, "david@fromorbit.com" <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

> Subject: mm, dax: unmap dax mappings at bdev or fs shutdown
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Currently dax mappings leak past / survive block_device shutdown.��While
> page cache pages are permitted to be read/written after the block_device
> is torn down this is not acceptable in the dax case as all media access
> must end when the device is disabled.��The pfn backing a dax mapping is
> permitted to be invalidated after bdev shutdown and this is indeed the
> case with brd.
> 
> When a dax capable block_device driver calls del_gendisk() in its
> shutdown path del_gendisk() needs to ensure that all DAX pfns are
> unmapped.��This is different than the pagecache backed case where the
> disk is protected by the queue being torn down which ends I/O to the
> device.��Since dax bypasses the page cache we need to unconditionally
> unmap the inode.
...
> +static void unmap_list(struct list_head *head)
> +{
> +	struct inode *inode, *_i;
> +
> +	list_for_each_entry_safe(inode, _i, head, i_lru) {
> +		list_del_init(&inode->i_lru);
> +		unmap_mapping_range(&inode->i_data, 0, 0, 1);
> +		iput(inode);
> +		cond_resched();
> +	}
> +}
> +
> �/**
> � * evict_inodes	- evict all evictable inodes for a superblock
> � * @sb:		superblock to operate on
> @@ -642,6 +654,7 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
> �	int busy = 0;
> �	struct inode *inode, *next;
> �	LIST_HEAD(dispose);
> +	LIST_HEAD(unmap);
> �
> �	spin_lock(&sb->s_inode_list_lock);
> �	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
> @@ -655,6 +668,19 @@ int invalidate_inodes(struct super_block *sb, bool kill_dirty)
> �			busy = 1;
> �			continue;
> �		}
> +		if (IS_DAX(inode) && atomic_read(&inode->i_count)) {
> +			/*
> +			�* dax mappings can't live past this invalidation event
> +			�* as there is no page cache present to allow the data
> +			�* to remain accessible.
> +			�*/
> +			__iget(inode);
> +			inode_lru_list_del(inode);
> +			spin_unlock(&inode->i_lock);
> +			list_add(&inode->i_lru, &unmap);
> +			busy = 1;
> +			continue;
> +		}

I'm somewhat concerned about the abuse of i_lru list here. The inodes have
i_count > 0 and so the code generally assumes such inodes should be removed
from LRU list if they are there. Now I didn't find a place where this could
really hit you but it is fragile. And when that happens, you have a
corruption of your unmap list (since you access it without any locks) and
also you will not unmap your inode.

Also are you sure that your unmapping cannot race with other process
mapping the pfns again?

BTW what happens when you access a DAX pfn that got removed?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
