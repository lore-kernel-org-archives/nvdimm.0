From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/18] dax: Introduce IOMAP_DAX_COW to CoW edges during
 writes
Date: Wed, 17 Apr 2019 09:46:59 -0700
Message-ID: <20190417164659.GD4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-5-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-5-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Cc: kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, nborisov-IBi9RG/b67k@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, dsterba-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 16, 2019 at 11:41:40AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> The IOMAP_DAX_COW is a iomap type which performs copy of
> edges of data while performing a write if start/end are
> not page aligned. The source address is expected in
> iomap->inline_data.
> 
> dax_copy_edges() is a helper functions performs a copy from
> one part of the device to another for data not page aligned.
> If iomap->inline_data is NULL, it memset's the area to zero.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/dax.c              | 41 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/iomap.h |  1 +
>  2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ca0671d55aa6..4b4ac51fbd16 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1083,6 +1083,40 @@ int __dax_zero_page_range(struct block_device *bdev,
>  }
>  EXPORT_SYMBOL_GPL(__dax_zero_page_range);
>  
> +/*
> + * dax_copy_edges - Copies the part of the pages not included in
> + * 		    the write, but required for CoW because
> + * 		    offset/offset+length are not page aligned.
> + */
> +static void dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
> +			   struct iomap *iomap, void *daddr)
> +{
> +	unsigned offset = pos & (PAGE_SIZE - 1);
> +	loff_t end = pos + length;
> +	loff_t pg_end = round_up(end, PAGE_SIZE);
> +	void *saddr = iomap->inline_data;
> +	/*
> +	 * Copy the first part of the page
> +	 * Note: we pass offset as length
> +	 */
> +	if (offset) {
> +		if (saddr)
> +			memcpy(daddr, saddr, offset);

I've been wondering, do we need memcpy_mcsafe here?

> +		else
> +			memset(daddr, 0, offset);

Or here?

(Or any of the other places we call memcpy/memset in this series...)

Because I think we'd prefer to return EIO on bad pmem over a machine
check.

--D

> +	}
> +
> +	/* Copy the last part of the range */
> +	if (end < pg_end) {
> +		if (saddr)
> +			memcpy(daddr + offset + length,
> +			       saddr + offset + length,	pg_end - end);
> +		else
> +			memset(daddr + offset + length, 0,
> +					pg_end - end);
> +	}
> +}
> +
>  static loff_t
>  dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct iomap *iomap)
> @@ -1104,9 +1138,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			return iov_iter_zero(min(length, end - pos), iter);
>  	}
>  
> -	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
> +	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED
> +			 && iomap->type != IOMAP_DAX_COW))

Usually the '&&' goes on the first line, right?

>  		return -EIO;
>  
> +
>  	/*
>  	 * Write can allocate block for an area which has a hole page mapped
>  	 * into page tables. We have to tear down these mappings so that data
> @@ -1143,6 +1179,9 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  			break;
>  		}
>  
> +		if (iomap->type == IOMAP_DAX_COW)
> +			dax_copy_edges(inode, pos, length, iomap, kaddr);

No return value?  So the pmem copy never fails?

--D

> +
>  		map_len = PFN_PHYS(map_len);
>  		kaddr += offset;
>  		map_len -= offset;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 0fefb5455bda..6e885c5a38a3 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -25,6 +25,7 @@ struct vm_fault;
>  #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
>  #define IOMAP_INLINE	0x05	/* data inline in the inode */
> +#define IOMAP_DAX_COW	0x06	/* Copy data pointed by inline_data before write*/
>  
>  /*
>   * Flags for all iomap mappings:
> -- 
> 2.16.4
> 
