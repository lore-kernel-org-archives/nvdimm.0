Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC303FD5
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 13:33:47 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H1JcD5zF2z67crW;
	Fri,  3 Sep 2021 21:31:56 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 3 Sep 2021 15:33:44 +0200
Received: from localhost (10.52.121.127) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 3 Sep 2021
 14:33:44 +0100
Date: Fri, 3 Sep 2021 14:33:45 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, kernel test robot <lkp@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>, <ben.widawsky@intel.com>
Subject: Re: [PATCH v3 28/28] cxl/core: Split decoder setup into alloc + add
Message-ID: <20210903143345.00006c60@Huawei.com>
In-Reply-To: <162982127644.1124374.2704629829686138331.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982127644.1124374.2704629829686138331.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.121.127]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:07:56 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The kbuild robot reports:
> 
>     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
>     limit (1024) in function 'devm_cxl_add_decoder'
> 
> It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> all the different decoder types. Fix the stack usage by splitting the
> creation into alloc and add steps. This also allows for context
> specific construction before adding.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Trivial comment inline - otherwise looks like a nice improvement.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/acpi.c     |   74 ++++++++++++++++++++---------
>  drivers/cxl/core/bus.c |  124 +++++++++++++++---------------------------------
>  drivers/cxl/cxl.h      |   15 ++----
>  3 files changed, 95 insertions(+), 118 deletions(-)
> 

> @@ -268,6 +275,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  	struct cxl_port *port;
>  	struct cxl_dport *dport;
>  	struct cxl_decoder *cxld;
> +	int single_port_map[1], rc;
>  	struct cxl_walk_context ctx;
>  	struct acpi_pci_root *pci_root;
>  	struct cxl_port *root_port = arg;
> @@ -301,22 +309,42 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  		return -ENODEV;
>  	if (ctx.error)
>  		return ctx.error;
> +	if (ctx.count > 1)
> +		return 0;
>  
>  	/* TODO: Scan CHBCR for HDM Decoder resources */
>  
>  	/*
> -	 * In the single-port host-bridge case there are no HDM decoders
> -	 * in the CHBCR and a 1:1 passthrough decode is implied.
> +	 * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> +	 * Structure) single ported host-bridges need not publish a decoder
> +	 * capability when a passthrough decode can be assumed, i.e. all
> +	 * transactions that the uport sees are claimed and passed to the single
> +	 * dport. Default the range a 0-base 0-length until the first CXL region
> +	 * is activated.
>  	 */

Is comment in right place or should it be up with the ctx.count > 1

> -	if (ctx.count == 1) {
> -		cxld = devm_cxl_add_passthrough_decoder(host, port);
> -		if (IS_ERR(cxld))
> -			return PTR_ERR(cxld);
> +	cxld = cxl_decoder_alloc(port, 1);
> +	if (IS_ERR(cxld))
> +		return PTR_ERR(cxld);
> +
> +	cxld->interleave_ways = 1;
> +	cxld->interleave_granularity = PAGE_SIZE;
> +	cxld->target_type = CXL_DECODER_EXPANDER;
> +	cxld->range = (struct range) {
> +		.start = 0,
> +		.end = -1,
> +	};
>  
> +	device_lock(&port->dev);
> +	dport = list_first_entry(&port->dports, typeof(*dport), list);
> +	device_unlock(&port->dev);
> +
> +	single_port_map[0] = dport->port_id;
> +
> +	rc = devm_cxl_add_decoder(host, cxld, single_port_map);
> +	if (rc == 0)
>  		dev_dbg(host, "add: %s\n", dev_name(&cxld->dev));
> -	}
>  
> -	return 0;
> +	return rc;
>  }
>  
>  static int add_host_bridge_dport(struct device *match, void *arg)
> diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> index 9a755a37eadf..1320a996220a 100644
> --- a/drivers/cxl/core/bus.c
> +++ b/drivers/cxl/core/bus.c
> @@ -453,27 +453,15 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport_dev, int port_id,
>  }
>  EXPORT_SYMBOL_GPL(cxl_add_dport);
>  
> -static struct cxl_decoder *
> -cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
> -		  resource_size_t base, resource_size_t len,
> -		  int interleave_ways, int interleave_granularity,
> -		  enum cxl_decoder_type type, unsigned long flags,
> -		  int *target_map)
> +struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets)
>  {
>  	struct cxl_decoder *cxld;
>  	struct device *dev;
> -	int rc = 0, i;
> +	int rc = 0;
>  
> -	if (interleave_ways < 1)
> +	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE || nr_targets < 1)
>  		return ERR_PTR(-EINVAL);
>  
> -	device_lock(&port->dev);
> -	if (list_empty(&port->dports))
> -		rc = -EINVAL;
> -	device_unlock(&port->dev);
> -	if (rc)
> -		return ERR_PTR(rc);
> -
>  	cxld = kzalloc(struct_size(cxld, target, nr_targets), GFP_KERNEL);
>  	if (!cxld)
>  		return ERR_PTR(-ENOMEM);
> @@ -482,31 +470,8 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
>  	if (rc < 0)
>  		goto err;
>  
> -	*cxld = (struct cxl_decoder) {
> -		.id = rc,
> -		.range = {
> -			.start = base,
> -			.end = base + len - 1,
> -		},
> -		.flags = flags,
> -		.interleave_ways = interleave_ways,
> -		.interleave_granularity = interleave_granularity,
> -		.target_type = type,
> -	};
> -
> -	device_lock(&port->dev);
> -	for (i = 0; target_map && i < nr_targets; i++) {
> -		struct cxl_dport *dport = find_dport(port, target_map[i]);
> -
> -		if (!dport) {
> -			rc = -ENXIO;
> -			goto err;
> -		}
> -		dev_dbg(host, "%s: target: %d\n", dev_name(dport->dport), i);
> -		cxld->target[i] = dport;
> -	}
> -	device_unlock(&port->dev);
> -
> +	cxld->id = rc;
> +	cxld->nr_targets = nr_targets;
>  	dev = &cxld->dev;
>  	device_initialize(dev);
>  	device_set_pm_not_required(dev);
> @@ -524,26 +489,43 @@ cxl_decoder_alloc(struct device *host, struct cxl_port *port, int nr_targets,
>  	kfree(cxld);
>  	return ERR_PTR(rc);
>  }
> +EXPORT_SYMBOL_GPL(cxl_decoder_alloc);
>  
> -struct cxl_decoder *
> -devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
> -		     resource_size_t base, resource_size_t len,
> -		     int interleave_ways, int interleave_granularity,
> -		     enum cxl_decoder_type type, unsigned long flags,
> -		     int *target_map)
> +int devm_cxl_add_decoder(struct device *host, struct cxl_decoder *cxld,
> +			 int *target_map)
>  {
> -	struct cxl_decoder *cxld;
> +	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
>  	struct device *dev;
> -	int rc;
> +	int rc = 0, i;
>  
> -	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
> -		return ERR_PTR(-EINVAL);
> +	if (!cxld)
> +		return -EINVAL;
>  
> -	cxld = cxl_decoder_alloc(host, port, nr_targets, base, len,
> -				 interleave_ways, interleave_granularity, type,
> -				 flags, target_map);
>  	if (IS_ERR(cxld))
> -		return cxld;
> +		return PTR_ERR(cxld);
> +
> +	if (cxld->interleave_ways < 1) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	device_lock(&port->dev);
> +	if (list_empty(&port->dports))
> +		rc = -EINVAL;
> +
> +	for (i = 0; rc == 0 && target_map && i < cxld->nr_targets; i++) {
> +		struct cxl_dport *dport = find_dport(port, target_map[i]);
> +
> +		if (!dport) {
> +			rc = -ENXIO;
> +			break;
> +		}
> +		dev_dbg(host, "%s: target: %d\n", dev_name(dport->dport), i);
> +		cxld->target[i] = dport;
> +	}
> +	device_unlock(&port->dev);
> +	if (rc)
> +		goto err;
>  
>  	dev = &cxld->dev;
>  	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
> @@ -554,43 +536,13 @@ devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
>  	if (rc)
>  		goto err;
>  
> -	rc = devm_add_action_or_reset(host, unregister_cxl_dev, dev);
> -	if (rc)
> -		return ERR_PTR(rc);
> -	return cxld;
> -
> +	return devm_add_action_or_reset(host, unregister_cxl_dev, dev);
>  err:
>  	put_device(dev);
> -	return ERR_PTR(rc);
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(devm_cxl_add_decoder);
>  
> -/*
> - * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability Structure)
> - * single ported host-bridges need not publish a decoder capability when a
> - * passthrough decode can be assumed, i.e. all transactions that the uport sees
> - * are claimed and passed to the single dport. Default the range a 0-base
> - * 0-length until the first CXL region is activated.
> - */
> -struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> -						     struct cxl_port *port)
> -{
> -	struct cxl_dport *dport;
> -	int target_map[1];
> -
> -	device_lock(&port->dev);
> -	dport = list_first_entry_or_null(&port->dports, typeof(*dport), list);
> -	device_unlock(&port->dev);
> -
> -	if (!dport)
> -		return ERR_PTR(-ENXIO);
> -
> -	target_map[0] = dport->port_id;
> -	return devm_cxl_add_decoder(host, port, 1, 0, 0, 1, PAGE_SIZE,
> -				    CXL_DECODER_EXPANDER, 0, target_map);
> -}
> -EXPORT_SYMBOL_GPL(devm_cxl_add_passthrough_decoder);
> -
>  /**
>   * __cxl_driver_register - register a driver for the cxl bus
>   * @cxl_drv: cxl driver structure to attach
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 13e02528ddd3..3705b2454b66 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -195,6 +195,7 @@ enum cxl_decoder_type {
>   * @interleave_granularity: data stride per dport
>   * @target_type: accelerator vs expander (type2 vs type3) selector
>   * @flags: memory type capabilities and locking
> + * @nr_targets: number of elements in @target
>   * @target: active ordered target list in current decoder configuration
>   */
>  struct cxl_decoder {
> @@ -205,6 +206,7 @@ struct cxl_decoder {
>  	int interleave_granularity;
>  	enum cxl_decoder_type target_type;
>  	unsigned long flags;
> +	int nr_targets;
>  	struct cxl_dport *target[];
>  };
>  
> @@ -286,15 +288,10 @@ int cxl_add_dport(struct cxl_port *port, struct device *dport, int port_id,
>  
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
>  bool is_root_decoder(struct device *dev);
> -struct cxl_decoder *
> -devm_cxl_add_decoder(struct device *host, struct cxl_port *port, int nr_targets,
> -		     resource_size_t base, resource_size_t len,
> -		     int interleave_ways, int interleave_granularity,
> -		     enum cxl_decoder_type type, unsigned long flags,
> -		     int *target_map);
> -
> -struct cxl_decoder *devm_cxl_add_passthrough_decoder(struct device *host,
> -						     struct cxl_port *port);
> +struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port, int nr_targets);
> +int devm_cxl_add_decoder(struct device *host, struct cxl_decoder *cxld,
> +			 int *target_map);
> +
>  extern struct bus_type cxl_bus_type;
>  
>  struct cxl_driver {
> 

