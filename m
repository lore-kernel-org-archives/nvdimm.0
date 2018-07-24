Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E79A4210C1B79
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 14:39:42 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCHv4 2/2] libnvdimm: Export max available extent
Date: Tue, 24 Jul 2018 21:39:41 +0000
Message-ID: <1532468379.8557.23.camel@intel.com>
References: <20180724210758.14098-1-keith.busch@intel.com>
 <20180724210758.14098-2-keith.busch@intel.com>
In-Reply-To: <20180724210758.14098-2-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <7B0AA2496A9CC144A6966EAC3AC4FC1E@intel.com>
MIME-Version: 1.0
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
To: "Busch, Keith" <keith.busch@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>, "gustavo@embeddedor.com" <gustavo@embeddedor.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-07-24 at 15:07 -0600, Keith Busch wrote:
> The 'available_size' attribute showing the combined total of all
> unallocated space isn't always useful to know how large of a
> namespace
> a user may be able to allocate if the region is fragmented. This
> patch
> will export the largest extent of unallocated space that may be
> allocated
> to create a new namespace.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
> No change since previous version
> 
>  drivers/nvdimm/region_devs.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Looks good to me. Feel free to add:
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/nvdimm/region_devs.c
> b/drivers/nvdimm/region_devs.c
> index c30d5af02cc2..fa37afcd43ff 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -434,6 +434,21 @@ static ssize_t available_size_show(struct device
> *dev,
>  }
>  static DEVICE_ATTR_RO(available_size);
>  
> +static ssize_t max_available_extent_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct nd_region *nd_region = to_nd_region(dev);
> +	unsigned long long available = 0;
> +
> +	nvdimm_bus_lock(dev);
> +	wait_nvdimm_bus_probe_idle(dev);
> +	available = nd_region_allocatable_dpa(nd_region);
> +	nvdimm_bus_unlock(dev);
> +
> +	return sprintf(buf, "%llu\n", available);
> +}
> +static DEVICE_ATTR_RO(max_available_extent);
> +
>  static ssize_t init_namespaces_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -585,6 +600,7 @@ static struct attribute *nd_region_attributes[] =
> {
>  	&dev_attr_read_only.attr,
>  	&dev_attr_set_cookie.attr,
>  	&dev_attr_available_size.attr,
> +	&dev_attr_max_available_extent.attr,
>  	&dev_attr_namespace_seed.attr,
>  	&dev_attr_init_namespaces.attr,
>  	&dev_attr_badblocks.attr,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
