Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131]) by ml01.01.org (Postfix) with ESMTP id 91E721A1E43
 for <linux-nvdimm@lists.01.org>; Sat, 15 Oct 2016 00:59:10 -0700 (PDT)
Date: Sat, 15 Oct 2016 18:54:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
Message-ID: <20161015075443.GG27872@dastard>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
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

On Fri, Oct 14, 2016 at 11:25:13AM -0600, Toshi Kani wrote:
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
>  fs/dax.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 014defd..3aaaac2 100644
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
> +	part_stat_add(cpu, &disk->part0, sectors[rw], sec);
> +	part_inc_in_flight(&disk->part0, rw);
> +	part_stat_unlock();
> +}

Why reimplement generic_start_io_acct() and generic_end_io_acct()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
