Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B344D81C48
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 07:01:34 -0800 (PST)
Date: Wed, 14 Dec 2016 16:01:30 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/8] dax: refactor locking out of size calculation routines
Message-ID: <20161214150130.GE6279@linux-x5ow.site>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148143773119.10950.13840765929901351011.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148143773119.10950.13840765929901351011.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Sat, Dec 10, 2016 at 10:28:51PM -0800, Dan Williams wrote:
> In preparation for other callers of these routines make the locking the
> responsibility of the caller.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/dax.c |   30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
> index d878a56cf3e3..5b65eaff6ace 100644
> --- a/drivers/dax/dax.c
> +++ b/drivers/dax/dax.c
> @@ -90,11 +90,11 @@ static unsigned long long dax_region_avail_size(
>  	unsigned long long size;
>  	struct resource *res;
>  
> -	mutex_lock(&dax_region->lock);
> +	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));

I'd prefer it a lockdep_assert_held(&dex_region->lock). This of cause has the
drawback that it won't trigger w/o lockdep but enabled, but I don't think it's
the responibility of a production kernel to have this warnings anyway. On the
flip side you get all the lockdep beauty for free with it.

> +
>  	size = resource_size(&dax_region->res);
>  	for_each_dax_region_resource(dax_region, res)
>  		size -= resource_size(res);
> -	mutex_unlock(&dax_region->lock);
>  
>  	return size;
>  }

[...]

> +static unsigned long long dax_dev_size(struct dax_dev *dax_dev)
>  {
> -	struct dax_dev *dax_dev = to_dax_dev(dev);
> +	struct dax_region *dax_region = dax_dev->region;
>  	unsigned long long size = 0;
>  	int i;
>  
> +	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
> +

See above

>  	for (i = 0; i < dax_dev->num_resources; i++)
>  		size += resource_size(dax_dev->res[i]);
>  
> +	return size;
> +}
> +

Byte,
	Johannes
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
