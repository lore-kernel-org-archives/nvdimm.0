From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/18] dax: memcpy before zeroing range
Date: Wed, 17 Apr 2019 08:45:04 -0700
Message-ID: <20190417154504.GC4740@magnolia>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-15-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-15-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
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

On Tue, Apr 16, 2019 at 11:41:50AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> 
> However, this needed more iomap fields, so it was easier
> to pass iomap and compute inside the function rather
> than passing a log of arguments.
> 
> Note, there is subtle difference between iomap_sector and
> dax_iomap_sector(). Can we replace dax_iomap_sector with
> iomap_sector()? It would need pos & PAGE_MASK though or else
> bdev_dax_pgoff() return -EINVAL.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/dax.c              | 14 ++++++++++----
>  fs/iomap.c            |  9 +--------
>  include/linux/dax.h   | 11 +++++------
>  include/linux/iomap.h |  6 ++++++
>  4 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index abbe4a79f219..af94909640ea 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1055,11 +1055,15 @@ static bool dax_range_is_aligned(struct block_device *bdev,
>  	return true;
>  }
>  
> -int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int size)
> +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +			  unsigned int offset, unsigned int size)
>  {
> -	if (dax_range_is_aligned(bdev, offset, size)) {
> +	sector_t sector = dax_iomap_sector(iomap, pos & PAGE_MASK);
> +	struct block_device *bdev = iomap->bdev;
> +	struct dax_device *dax_dev = iomap->dax_dev;
> +
> +	if (!(iomap->type == IOMAP_DAX_COW) &&
> +	    dax_range_is_aligned(bdev, offset, size)) {
>  		sector_t start_sector = sector + (offset >> 9);
>  
>  		return blkdev_issue_zeroout(bdev, start_sector,
> @@ -1079,6 +1083,8 @@ int __dax_zero_page_range(struct block_device *bdev,
>  			dax_read_unlock(id);
>  			return rc;
>  		}
> +		if (iomap->type == IOMAP_DAX_COW)
> +			memcpy(iomap->inline_data, kaddr, offset);

I'm confused, why are we copying into the source page before zeroing
some part of the dax device?

>  		memset(kaddr + offset, 0, size);
>  		dax_flush(dax_dev, kaddr + offset, size);
>  		dax_read_unlock(id);
> diff --git a/fs/iomap.c b/fs/iomap.c
> index abdd18e404f8..90698c854883 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -98,12 +98,6 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  	return written ? written : ret;
>  }
>  
> -static sector_t
> -iomap_sector(struct iomap *iomap, loff_t pos)
> -{
> -	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> -}
> -
>  static struct iomap_page *
>  iomap_page_create(struct inode *inode, struct page *page)
>  {
> @@ -990,8 +984,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
>  static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
>  		struct iomap *iomap)
>  {
> -	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
> -			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
> +	return __dax_zero_page_range(iomap, pos, offset, bytes);
>  }
>  
>  static loff_t
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index a11bc7b1f526..892c478d7073 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -9,6 +9,7 @@
>  
>  typedef unsigned long dax_entry_t;
>  
> +struct iomap;
>  struct iomap_ops;
>  struct dax_device;
>  struct dax_operations {
> @@ -161,13 +162,11 @@ int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
>                  loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
>  
>  #ifdef CONFIG_FS_DAX
> -int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length);
> +int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +		unsigned int offset, unsigned int size);
>  #else
> -static inline int __dax_zero_page_range(struct block_device *bdev,
> -		struct dax_device *dax_dev, sector_t sector,
> -		unsigned int offset, unsigned int length)
> +static inline int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
> +		unsigned int offset, unsigned int size)
>  {
>  	return -ENXIO;
>  }
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 6e885c5a38a3..3a803566dea1 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -7,6 +7,7 @@
>  #include <linux/mm.h>
>  #include <linux/types.h>
>  #include <linux/mm_types.h>
> +#include <linux/blkdev.h>
>  
>  struct address_space;
>  struct fiemap_extent_info;
> @@ -120,6 +121,11 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
>  	return NULL;
>  }
>  
> +static inline sector_t iomap_sector(struct iomap *iomap, loff_t pos)
> +{
> +	        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;

Why the double indent?

--D

> +}
> +
>  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
>  		const struct iomap_ops *ops);
>  int iomap_readpage(struct page *page, const struct iomap_ops *ops);
> -- 
> 2.16.4
> 
