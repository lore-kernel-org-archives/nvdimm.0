Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685122FB8
	for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 17:47:40 +0000 (UTC)
IronPort-SDR: shliRt2C42BBw1dx/gJvHn19sc7YZJr0x3oX9EoBEJbZain4S6jJ18m/c2bvvEQ24faOUUmp1u
 W3iKtce59NEA==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="192684034"
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="192684034"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 10:47:38 -0700
IronPort-SDR: 0mTW6WPCqIp7pjzfsIK+utzJm2IXyzBYiCc2/K75E7sZZvJF489+kp3pRpM88R+1Bl6MsBRfnA
 8xkABb+u/fHg==
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="552756908"
Received: from chtanaka-mobl2.amr.corp.intel.com (HELO intel.com) ([10.252.138.239])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 10:47:38 -0700
Date: Fri, 11 Jun 2021 10:47:36 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] cxl/core: Add cxl-bus driver infrastructure
Message-ID: <20210611174736.ttzpk5uniyoyd4vw@intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336396329.2462439.16556923116284874437.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162336396329.2462439.16556923116284874437.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-06-10 15:26:03, Dan Williams wrote:
> Enable devices on the 'cxl' bus to be attached to drivers. The initial
> user of this functionality is a driver for an 'nvdimm-bridge' device
> that anchors a libnvdimm hierarchy attached to CXL persistent memory
> resources. Other device types that will leverage this include:
> 
> cxl_port: map and use component register functionality (HDM Decoders)

Since I'm looking at this now, perhaps I can open the discussion here. Have you
thought about how this works yet? Right now I'm thinking there are two "drivers":
cxl_port: Switches (and ACPI0016)
cxl_mem: The memory device's HDM decoders

For port, probe() will figure out that the thing is an upstream port, call
cxl_probe_component_regs and then call devm_cxl_add_port(). I think that's
straight forward.

For the memory device we've already probed the thing via class code so there is
no need to use this driver registration, however, I think it would be nice to do
so. Is there a clean way to do that?

Also, I'd like to make sure we're on the same page about struct cxl_decoder.
Right now they are only created for active HDM decoders. Going forward, we can
either maintain a count of unused decoders on the given CXL component, or we can
instantiate a struct cxl_decoder that isn't active, ie. no interleave ways
granularit, base, etc. What's your thinking there?

> 
> cxl_nvdimm: translate CXL memory expander endpoints to libnvdimm
> 	    'nvdimm' objects
> 
> cxl_region: translate CXL interleave sets to libnvdimm 'region' objects
> 
> The pairing of devices to drivers is handled through the cxl_device_id()
> matching to cxl_driver.id values. A cxl_device_id() of '0' indicates no
> driver support.
> 
> In addition to ->match(), ->probe(), and ->remove() support for the
> 'cxl' bus introduce MODULE_ALIAS_CXL() to autoload modules containing
> cxl-drivers. Drivers are added in follow-on changes.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h  |   22 ++++++++++++++++
>  2 files changed, 95 insertions(+)
> 
> diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
> index 1b9ee0b08384..959cecc1f6bf 100644
> --- a/drivers/cxl/core.c
> +++ b/drivers/cxl/core.c
> @@ -767,8 +767,81 @@ int cxl_map_device_regs(struct pci_dev *pdev,
>  }
>  EXPORT_SYMBOL_GPL(cxl_map_device_regs);
>  
> +/**
> + * __cxl_driver_register - register a driver for the cxl bus
> + * @cxl_drv: cxl driver structure to attach
> + * @owner: owning module/driver
> + * @modname: KBUILD_MODNAME for parent driver
> + */
> +int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
> +			  const char *modname)
> +{
> +	if (!cxl_drv->probe) {
> +		pr_debug("%s ->probe() must be specified\n", modname);
> +		return -EINVAL;
> +	}
> +
> +	if (!cxl_drv->name) {
> +		pr_debug("%s ->name must be specified\n", modname);
> +		return -EINVAL;
> +	}
> +
> +	if (!cxl_drv->id) {
> +		pr_debug("%s ->id must be specified\n", modname);
> +		return -EINVAL;
> +	}
> +
> +	cxl_drv->drv.bus = &cxl_bus_type;
> +	cxl_drv->drv.owner = owner;
> +	cxl_drv->drv.mod_name = modname;
> +	cxl_drv->drv.name = cxl_drv->name;
> +
> +	return driver_register(&cxl_drv->drv);
> +}
> +EXPORT_SYMBOL_GPL(__cxl_driver_register);
> +
> +void cxl_driver_unregister(struct cxl_driver *cxl_drv)
> +{
> +	driver_unregister(&cxl_drv->drv);
> +}
> +EXPORT_SYMBOL_GPL(cxl_driver_unregister);
> +
> +static int cxl_device_id(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int cxl_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	return add_uevent_var(env, "MODALIAS=" CXL_MODALIAS_FMT,
> +			      cxl_device_id(dev));
> +}
> +
> +static int cxl_bus_match(struct device *dev, struct device_driver *drv)
> +{
> +	return cxl_device_id(dev) == to_cxl_drv(drv)->id;
> +}
> +
> +static int cxl_bus_probe(struct device *dev)
> +{
> +	return to_cxl_drv(dev->driver)->probe(dev);
> +}
> +
> +static int cxl_bus_remove(struct device *dev)
> +{
> +	struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
> +
> +	if (cxl_drv->remove)
> +		cxl_drv->remove(dev);
> +	return 0;
> +}
> +
>  struct bus_type cxl_bus_type = {
>  	.name = "cxl",
> +	.uevent = cxl_bus_uevent,
> +	.match = cxl_bus_match,
> +	.probe = cxl_bus_probe,
> +	.remove = cxl_bus_remove,
>  };
>  EXPORT_SYMBOL_GPL(cxl_bus_type);
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index b988ea288f53..af2237d1c761 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -261,4 +261,26 @@ devm_cxl_add_passthrough_decoder(struct device *host, struct cxl_port *port)
>  }
>  
>  extern struct bus_type cxl_bus_type;
> +
> +struct cxl_driver {
> +	const char *name;
> +	int (*probe)(struct device *dev);
> +	void (*remove)(struct device *dev);
> +	struct device_driver drv;
> +	int id;
> +};
> +
> +static inline struct cxl_driver *to_cxl_drv(struct device_driver *drv)
> +{
> +	return container_of(drv, struct cxl_driver, drv);
> +}
> +
> +int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
> +			  const char *modname);
> +#define cxl_driver_register(x) __cxl_driver_register(x, THIS_MODULE, KBUILD_MODNAME)
> +void cxl_driver_unregister(struct cxl_driver *cxl_drv);
> +
> +#define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
> +#define CXL_MODALIAS_FMT "cxl:t%d"
> +
>  #endif /* __CXL_H__ */
> 
