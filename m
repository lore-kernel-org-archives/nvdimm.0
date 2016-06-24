From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm stripe: add DAX support
Date: Fri, 24 Jun 2016 14:29:00 -0400
Message-ID: <20160624182859.GD13898@redhat.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Alasdair Kergon <agk@redhat.com>
List-Id: linux-nvdimm@lists.01.org

On Fri, Jun 24 2016 at  2:23pm -0400,
Toshi Kani <toshi.kani@hpe.com> wrote:

> Change dm-stripe to implement direct_access function,
> stripe_direct_access(), which maps bdev and sector and
> calls direct_access function of its physical target device.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  drivers/md/dm-stripe.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 48f1c01..8925f6a 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -308,6 +308,30 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
>  	return DM_MAPIO_REMAPPED;
>  }
>  
> +static long stripe_direct_access(struct dm_target *ti, sector_t sector,
> +		void __pmem **kaddr, pfn_t *pfn, long size)
> +{
> +	struct stripe_c *sc;
> +	struct block_device *bdev;
> +	uint32_t stripe;
> +	struct blk_dax_ctl dax = {
> +		.size = size,
> +	};
> +	long ret;
> +
> +	sc = ti->private;
> +	stripe_map_sector(sc, sector, &stripe, &dax.sector);
> +
> +	dax.sector += sc->stripe[stripe].physical_start;
> +	bdev = sc->stripe[stripe].dev->bdev;
> +
> +	ret = bdev_direct_access(bdev, &dax);
> +	*kaddr = dax.addr;
> +	*pfn = dax.pfn;
> +
> +	return ret;
> +}
> +
>  /*
>   * Stripe status:
>   *
> @@ -425,6 +449,7 @@ static struct target_type stripe_target = {
>  	.status = stripe_status,
>  	.iterate_devices = stripe_iterate_devices,
>  	.io_hints = stripe_io_hints,
> +	.direct_access = stripe_direct_access,
>  };
>  
>  int __init dm_stripe_init(void)

Thanks, once jens queues the block changes I'll be able to pull this in
to linux-dm.git

BTW, if in your testing you could evaluate/quantify any extra overhead
from DM that'd be useful to share.  It could be there are bottlenecks
that need to be fixed, etc.

Mike
