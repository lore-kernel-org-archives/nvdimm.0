Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5276481C63
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 06:38:07 -0800 (PST)
Date: Wed, 14 Dec 2016 15:38:02 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/8] dax: add region-available-size attribute
Message-ID: <20161214143802.GD6279@linux-x5ow.site>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148143771052.10950.7622110904173815243.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148143771052.10950.7622110904173815243.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Sat, Dec 10, 2016 at 10:28:30PM -0800, Dan Williams wrote:
> In preparation for a facility that enables dax regions to be
> sub-divided, introduce a 'dax/available_size' attribute.  This attribute
> appears under the parent device that registered the device-dax region,
> and it assumes that the device-dax-core owns the driver-data for that
> device.
> 
> 'dax/available_size' adjusts dynamically as dax-device instances are
> registered and unregistered.
> 
> As a side effect of using __request_region() to reserve capacity from
> the dax_region we now track pointers to those returned resources rather
> than duplicating the passed in resource array.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[...]

> +static const struct attribute_group *dax_region_attribute_groups[] = {
> +	&dax_region_attribute_group,
> +	NULL,
>  };
>  
>  static struct inode *dax_alloc_inode(struct super_block *sb)
> @@ -200,12 +251,27 @@ void dax_region_put(struct dax_region *dax_region)
>  }
>  EXPORT_SYMBOL_GPL(dax_region_put);
>  
> +

Stray extra newline?

[...]

>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct resource *res, unsigned int align, void *addr,
>  		unsigned long pfn_flags)
>  {
>  	struct dax_region *dax_region;
>  
> +	if (dev_get_drvdata(parent)) {
> +		dev_WARN(parent, "dax core found drvdata already in use\n");
> +		return NULL;
> +	}
> +

My first thought was, it might be interesting to see who already claimed
the drvdata. Then I figured, how are multiple sub-regions of a dax-device
supposed to work? What am I missing here?

>  	if (!IS_ALIGNED(res->start, align)
>  			|| !IS_ALIGNED(resource_size(res), align))
>  		return NULL;
> @@ -213,16 +279,26 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
>  	if (!dax_region)
>  		return NULL;
> -
> -	memcpy(&dax_region->res, res, sizeof(*res));
> +	dev_set_drvdata(parent, dax_region);
> +	dax_region->res.name = dev_name(parent);
> +	dax_region->res.start = res->start;
> +	dax_region->res.end = res->end;
>  	dax_region->pfn_flags = pfn_flags;
> +	mutex_init(&dax_region->lock);
>  	kref_init(&dax_region->kref);
>  	dax_region->id = region_id;
>  	ida_init(&dax_region->ida);
>  	dax_region->align = align;
>  	dax_region->dev = parent;
>  	dax_region->base = addr;
> +	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> +		kfree(dax_region);
> +		return NULL;;
> +	}
>  
> +	kref_get(&dax_region->kref);
> +	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
> +		return NULL;
>  	return dax_region;
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax_region);

[...]

> @@ -568,28 +654,42 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>  	struct cdev *cdev;
>  	dev_t dev_t;
>  
> -	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
> +	dax_dev = kzalloc(sizeof(*dax_dev), GFP_KERNEL);
>  	if (!dax_dev)
>  		return ERR_PTR(-ENOMEM);
>  
> +	dax_dev->res = kzalloc(sizeof(res) * count, GFP_KERNEL);

	dax_dev->res = kcalloc(sizeof(res), count, GFP_KERNEL); ?

> +	if (!dax_dev->res)
> +		goto err_res;
> +

Byte,
	Johannes
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
