Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1DB021140F33
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 11:48:37 -0700 (PDT)
Subject: Re: [PATCH] libnvdimm, region: Fail badblocks listing for inactive
 regions
References: <153815785702.2023323.12153027860843602654.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <e30e885b-1b4c-59b4-d187-f33c0176c9d2@intel.com>
Date: Fri, 28 Sep 2018 11:47:24 -0700
MIME-Version: 1.0
In-Reply-To: <153815785702.2023323.12153027860843602654.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 09/28/2018 11:04 AM, Dan Williams wrote:
> While experimenting with region driver loading the following backtrace
> was triggered:
> 
>  INFO: trying to register non-static key.
>  the code is fine but needs lockdep annotation.
>  turning off the locking correctness validator.
>  [..]
>  Call Trace:
>   dump_stack+0x85/0xcb
>   register_lock_class+0x571/0x580
>   ? __lock_acquire+0x2ba/0x1310
>   ? kernfs_seq_start+0x2a/0x80
>   __lock_acquire+0xd4/0x1310
>   ? dev_attr_show+0x1c/0x50
>   ? __lock_acquire+0x2ba/0x1310
>   ? kernfs_seq_start+0x2a/0x80
>   ? lock_acquire+0x9e/0x1a0
>   lock_acquire+0x9e/0x1a0
>   ? dev_attr_show+0x1c/0x50
>   badblocks_show+0x70/0x190
>   ? dev_attr_show+0x1c/0x50
>   dev_attr_show+0x1c/0x50
> 
> This results from a missing successful call to devm_init_badblocks()
> from nd_region_probe(). Block attempts to show badblocks while the
> region is not enabled.
> 
> Fixes: 6a6bef90425e ("libnvdimm: add mechanism to publish badblocks...")
> Cc: <stable@vger.kernel.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/region_devs.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index fa37afcd43ff..174a418cb171 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -560,10 +560,17 @@ static ssize_t region_badblocks_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct nd_region *nd_region = to_nd_region(dev);
> +	ssize_t rc;
>  
> -	return badblocks_show(&nd_region->bb, buf, 0);
> -}
> +	device_lock(dev);
> +	if (dev->driver)
> +		rc = badblocks_show(&nd_region->bb, buf, 0);
> +	else
> +		rc = -ENXIO;
> +	device_unlock(dev);
>  
> +	return rc;
> +}
>  static DEVICE_ATTR(badblocks, 0444, region_badblocks_show, NULL);
>  
>  static ssize_t resource_show(struct device *dev,
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
