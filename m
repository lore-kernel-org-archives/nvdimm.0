Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15DD01A1DFF
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 10:29:58 -0700 (PDT)
Date: Mon, 17 Oct 2016 11:29:57 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] DAX: enable iostat for read/write
Message-ID: <20161017172957.GC25175@linux.intel.com>
References: <1476724738-19133-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1476724738-19133-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 17, 2016 at 11:18:58AM -0600, Toshi Kani wrote:
> DAX IO path does not support iostat, but its metadata IO path does.
> Therefore, iostat shows metadata IO statistics only, which has been
> confusing to users.
> 
> Add iostat support to the DAX read/write path.
> 
> Note, iostat still does not support the DAX mmap path as it allows
> user applications to access directly.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
> v2:
> - Set a minimum of one sector (Dan Williams)

What about Dave's feedback that this code just reimplements 
generic_start_io_acct() and generic_end_io_acct()?

> ---
>  fs/dax.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 014defd..43e5e7a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -144,6 +144,34 @@ static sector_t to_sector(const struct buffer_head *bh,
>  	return sector;
>  }
>  
> +static void dax_iostat_start(struct gendisk *disk, struct iov_iter *iter,
> +			     unsigned long *start)
> +{
> +	int rw = iov_iter_rw(iter);
> +	int sec = iov_iter_count(iter) >> 9;
> +	int cpu = part_stat_lock();
> +
> +	*start = jiffies;
> +	part_round_stats(cpu, &disk->part0);
> +	part_stat_inc(cpu, &disk->part0, ios[rw]);
> +	part_stat_add(cpu, &disk->part0, sectors[rw], ((!sec) ? 1 : sec));
> +	part_inc_in_flight(&disk->part0, rw);
> +	part_stat_unlock();
> +}
> +
> +static void dax_iostat_end(struct gendisk *disk, struct iov_iter *iter,
> +			   unsigned long start)
> +{
> +	unsigned long duration = jiffies - start;
> +	int rw = iov_iter_rw(iter);
> +	int cpu = part_stat_lock();
> +
> +	part_stat_add(cpu, &disk->part0, ticks[rw], duration);
> +	part_round_stats(cpu, &disk->part0);
> +	part_dec_in_flight(&disk->part0, rw);
> +	part_stat_unlock();
> +}
> +
>  static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>  		      loff_t start, loff_t end, get_block_t get_block,
>  		      struct buffer_head *bh)
> @@ -265,9 +293,12 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
>  	ssize_t retval = -EINVAL;
>  	loff_t pos = iocb->ki_pos;
>  	loff_t end = pos + iov_iter_count(iter);
> +	struct gendisk *disk;
> +	unsigned long start = 0;
>  
>  	memset(&bh, 0, sizeof(bh));
>  	bh.b_bdev = inode->i_sb->s_bdev;
> +	disk = bh.b_bdev->bd_disk;
>  
>  	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
>  		inode_lock(inode);
> @@ -276,8 +307,14 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
>  	if (!(flags & DIO_SKIP_DIO_COUNT))
>  		inode_dio_begin(inode);
>  
> +	if (blk_queue_io_stat(disk->queue))
> +		dax_iostat_start(disk, iter, &start);
> +
>  	retval = dax_io(inode, iter, pos, end, get_block, &bh);
>  
> +	if (start)
> +		dax_iostat_end(disk, iter, start);
> +
>  	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
>  		inode_unlock(inode);
>  
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
