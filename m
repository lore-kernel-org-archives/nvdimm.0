Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5589E70
	for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 11:47:10 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G1f3B5Sp3z6L7Hp;
	Fri, 11 Jun 2021 19:37:42 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 11 Jun 2021 13:47:07 +0200
Received: from localhost (10.52.120.251) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 12:47:07 +0100
Date: Fri, 11 Jun 2021 12:47:03 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] libnvdimm: Drop unused device power management
 support
Message-ID: <20210611124703.000033af@Huawei.com>
In-Reply-To: <162336397948.2462439.5230237265829121099.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162336397948.2462439.5230237265829121099.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.120.251]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 10 Jun 2021 15:26:19 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> LIBNVDIMM device objects register sysfs power attributes despite nothing
> requiring that support. Clean up sysfs remove the power/ attribute
> group. This requires a device_create() and a device_register() usage to
> be converted to the device_initialize() + device_add() pattern.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Trivial comment below. Looks good.

> ---
>  drivers/nvdimm/bus.c |   45 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index a11821df83b5..e6aa87043a95 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -363,8 +363,13 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
>  	nvdimm_bus->dev.groups = nd_desc->attr_groups;
>  	nvdimm_bus->dev.bus = &nvdimm_bus_type;
>  	nvdimm_bus->dev.of_node = nd_desc->of_node;
> -	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
> -	rc = device_register(&nvdimm_bus->dev);
> +	device_initialize(&nvdimm_bus->dev);
> +	device_set_pm_not_required(&nvdimm_bus->dev);
> +	rc = dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
> +	if (rc)
> +		goto err;

Maybe mention in patch description that you also now handle errors in
dev_set_name()?

> +
> +	rc = device_add(&nvdimm_bus->dev);
>  	if (rc) {
>  		dev_dbg(&nvdimm_bus->dev, "registration failed: %d\n", rc);
>  		goto err;
> @@ -525,6 +530,7 @@ void __nd_device_register(struct device *dev)
>  		set_dev_node(dev, to_nd_region(dev)->numa_node);
>  
>  	dev->bus = &nvdimm_bus_type;
> +	device_set_pm_not_required(dev);
>  	if (dev->parent) {
>  		get_device(dev->parent);
>  		if (dev_to_node(dev) == NUMA_NO_NODE)
> @@ -717,18 +723,41 @@ const struct attribute_group nd_numa_attribute_group = {
>  	.is_visible = nd_numa_attr_visible,
>  };
>  
> +static void ndctl_release(struct device *dev)
> +{
> +	kfree(dev);
> +}
> +
>  int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
>  {
>  	dev_t devt = MKDEV(nvdimm_bus_major, nvdimm_bus->id);
>  	struct device *dev;
> +	int rc;
>  
> -	dev = device_create(nd_class, &nvdimm_bus->dev, devt, nvdimm_bus,
> -			"ndctl%d", nvdimm_bus->id);
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +	device_initialize(dev);
> +	device_set_pm_not_required(dev);
> +	dev->class = nd_class;
> +	dev->parent = &nvdimm_bus->dev;
> +	dev->devt = devt;
> +	dev->release = ndctl_release;
> +	rc = dev_set_name(dev, "ndctl%d", nvdimm_bus->id);
> +	if (rc)
> +		goto err;
>  
> -	if (IS_ERR(dev))
> -		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %ld\n",
> -				nvdimm_bus->id, PTR_ERR(dev));
> -	return PTR_ERR_OR_ZERO(dev);
> +	rc = device_add(dev);
> +	if (rc) {
> +		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %d\n",
> +				nvdimm_bus->id, rc);
> +		goto err;
> +	}
> +	return 0;
> +
> +err:
> +	put_device(dev);
> +	return rc;
>  }
>  
>  void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
> 

