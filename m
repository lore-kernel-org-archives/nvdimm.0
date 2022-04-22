Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6233EA
	for <nvdimm@lists.linux.dev>; Fri, 22 Apr 2022 23:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650671008; x=1682207008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ASHdrpAbSJCy+N0s8pyAlX4cmut4IvMHTlcPEKObaEI=;
  b=K3oWnqoiCBh7qs2s2eLbjLUjvyCBlM5ekrp8OYaktalrastScwMjDu+R
   v48xMBoaOI0trtCSpkKN33yoeYGiFRwQP3+HmZr8d4++RjAvu63G5rs/c
   jaUGC68+1iZf4FaGoRRvsL2uQRdJ4cA2G8/deFvd2zKUI+8OSbcpSbfmK
   Deb5X7nujImn59CtJeDgnvA+86nMYgsKsxZ/sRU/k8XD4iaZrnCEfoFJQ
   m4Ho5IIau6mpUNF+VHXx3ZxMWxQ24jy6XT7/ILjIwzFGoKO2nKgW1GIBI
   dh6drinkpzf9AN7rYt6bgwZWTmR3eV2j0DGy1yglHlewu8QMNLHz5slSP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="246720600"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="246720600"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 16:43:28 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="703752041"
Received: from hltravis-mobl1.amr.corp.intel.com (HELO localhost) ([10.213.166.215])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 16:43:28 -0700
Date: Fri, 22 Apr 2022 16:43:27 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] cxl: Replace lockdep_mutex with local lock classes
Message-ID: <YmM9n3QDDGhsZb5b@iweiny-desk3>
References: <165055518776.3745911.9346998911322224736.stgit@dwillia2-desk3.amr.corp.intel.com>
 <165055519317.3745911.7342499516839702840.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165055519317.3745911.7342499516839702840.stgit@dwillia2-desk3.amr.corp.intel.com>

On Thu, Apr 21, 2022 at 08:33:13AM -0700, Dan Williams wrote:
> In response to an attempt to expand dev->lockdep_mutex for device_lock()
> validation [1], Peter points out [2] that the lockdep API already has
> the ability to assign a dedicated lock class per subsystem device-type.
> 
> Use lockdep_set_class() to override the default device_lock()
> '__lockdep_no_validate__' class for each CXL subsystem device-type. This
> enables lockdep to detect deadlocks and recursive locking within the
> device-driver core and the subsystem. The
> lockdep_set_class_and_subclass() API is used for port objects that
> recursively lock the 'cxl_port_key' class by hierarchical topology
> depth.
> 
> Link: https://lore.kernel.org/r/164982968798.684294.15817853329823976469.stgit@dwillia2-desk3.amr.corp.intel.com [1]
> Link: https://lore.kernel.org/r/Ylf0dewci8myLvoW@hirez.programming.kicks-ass.net [2]
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/cxl/core/memdev.c |    3 +++
>  drivers/cxl/core/pmem.c   |    6 ++++++
>  drivers/cxl/core/port.c   |   13 +++++++++----
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 1f76b28f9826..f7cdcd33504a 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -228,6 +228,8 @@ static void detach_memdev(struct work_struct *work)
>  	put_device(&cxlmd->dev);
>  }
>  
> +static struct lock_class_key cxl_memdev_key;
> +
>  static struct cxl_memdev *cxl_memdev_alloc(struct cxl_dev_state *cxlds,
>  					   const struct file_operations *fops)
>  {
> @@ -247,6 +249,7 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_dev_state *cxlds,
>  
>  	dev = &cxlmd->dev;
>  	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_memdev_key);
>  	dev->parent = cxlds->dev;
>  	dev->bus = &cxl_bus_type;
>  	dev->devt = MKDEV(cxl_mem_major, cxlmd->id);
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 8de240c4d96b..e825e261278d 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -80,6 +80,8 @@ struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cxl_nvd)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_find_nvdimm_bridge, CXL);
>  
> +static struct lock_class_key cxl_nvdimm_bridge_key;
> +
>  static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_port *port)
>  {
>  	struct cxl_nvdimm_bridge *cxl_nvb;
> @@ -99,6 +101,7 @@ static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_port *port)
>  	cxl_nvb->port = port;
>  	cxl_nvb->state = CXL_NVB_NEW;
>  	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_nvdimm_bridge_key);
>  	device_set_pm_not_required(dev);
>  	dev->parent = &port->dev;
>  	dev->bus = &cxl_bus_type;
> @@ -214,6 +217,8 @@ struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm, CXL);
>  
> +static struct lock_class_key cxl_nvdimm_key;
> +
>  static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  {
>  	struct cxl_nvdimm *cxl_nvd;
> @@ -226,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  	dev = &cxl_nvd->dev;
>  	cxl_nvd->cxlmd = cxlmd;
>  	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
>  	device_set_pm_not_required(dev);
>  	dev->parent = &cxlmd->dev;
>  	dev->bus = &cxl_bus_type;
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 2ab1ba4499b3..750aac95ed5f 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -391,6 +391,8 @@ static int devm_cxl_link_uport(struct device *host, struct cxl_port *port)
>  	return devm_add_action_or_reset(host, cxl_unlink_uport, port);
>  }
>  
> +static struct lock_class_key cxl_port_key;
> +
>  static struct cxl_port *cxl_port_alloc(struct device *uport,
>  				       resource_size_t component_reg_phys,
>  				       struct cxl_port *parent_port)
> @@ -415,9 +417,10 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	 * description.
>  	 */
>  	dev = &port->dev;
> -	if (parent_port)
> +	if (parent_port) {
>  		dev->parent = &parent_port->dev;
> -	else
> +		port->depth = parent_port->depth + 1;
> +	} else
>  		dev->parent = uport;
>  
>  	port->uport = uport;
> @@ -427,6 +430,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	INIT_LIST_HEAD(&port->endpoints);
>  
>  	device_initialize(dev);
> +	lockdep_set_class_and_subclass(&dev->mutex, &cxl_port_key, port->depth);
>  	device_set_pm_not_required(dev);
>  	dev->bus = &cxl_bus_type;
>  	dev->type = &cxl_port_type;
> @@ -457,8 +461,6 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  	if (IS_ERR(port))
>  		return port;
>  
> -	if (parent_port)
> -		port->depth = parent_port->depth + 1;
>  	dev = &port->dev;
>  	if (is_cxl_memdev(uport))
>  		rc = dev_set_name(dev, "endpoint%d", port->id);
> @@ -1173,6 +1175,8 @@ static int decoder_populate_targets(struct cxl_decoder *cxld,
>  	return rc;
>  }
>  
> +static struct lock_class_key cxl_decoder_key;
> +
>  /**
>   * cxl_decoder_alloc - Allocate a new CXL decoder
>   * @port: owning port of this decoder
> @@ -1214,6 +1218,7 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
>  	seqlock_init(&cxld->target_lock);
>  	dev = &cxld->dev;
>  	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_decoder_key);
>  	device_set_pm_not_required(dev);
>  	dev->parent = &port->dev;
>  	dev->bus = &cxl_bus_type;
> 
