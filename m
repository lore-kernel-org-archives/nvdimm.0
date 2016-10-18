Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 18 Oct 2016 13:20:13 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 18/20] dax: Make cache flushing protected by entry lock
Message-ID: <20161018192013.GE7796@linux.intel.com>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-19-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474992504-20133-19-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 27, 2016 at 06:08:22PM +0200, Jan Kara wrote:
> Currently, flushing of caches for DAX mappings was ignoring entry lock.
> So far this was ok (modulo a bug that a difference in entry lock could
> cause cache flushing to be mistakenly skipped) but in the following
> patches we will write-protect PTEs on cache flushing and clear dirty
> tags. For that we will need more exclusion. So do cache flushing under
> an entry lock. This allows us to remove one lock-unlock pair of
> mapping->tree_lock as a bonus.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

> @@ -716,15 +736,13 @@ static int dax_writeback_one(struct block_device *bdev,
>  	}
>  
>  	wb_cache_pmem(dax.addr, dax.size);
> -
> -	spin_lock_irq(&mapping->tree_lock);
> -	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_TOWRITE);
> -	spin_unlock_irq(&mapping->tree_lock);
> - unmap:
> +unmap:
>  	dax_unmap_atomic(bdev, &dax);
> +	put_locked_mapping_entry(mapping, index, entry);
>  	return ret;
>  
> - unlock:
> +put_unlock:

I know there's an ongoing debate about this, but can you please stick a space
in front of the labels to make the patches pretty & to be consistent with the
rest of the DAX code?

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
