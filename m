Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3203F5C9D
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 15:01:39 +0000 (UTC)
Received: from frapeml500005.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NJdKm3G2jz6H75t;
	Fri, 25 Nov 2022 22:58:52 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 16:01:30 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 15:01:29 +0000
Date: Fri, 25 Nov 2022 15:01:28 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <rrichter@amd.com>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 03/12] cxl/pmem: Refactor nvdimm device registration,
 delete the workqueue
Message-ID: <20221125150128.00001bf6@Huawei.com>
In-Reply-To: <166931489283.2104015.7355891921648975475.stgit@dwillia2-xfh.jf.intel.com>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
	<166931489283.2104015.7355891921648975475.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 24 Nov 2022 10:34:52 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> The three objects 'struct cxl_nvdimm_bridge', 'struct cxl_nvdimm', and
> 'struct cxl_pmem_region' manage CXL persistent memory resources. The
> bridge represents base platform resources, the nvdimm represents one or
> more endpoints, and the region is a collection of nvdimms that
> contribute to an assembled address range.
> 
> Their relationship is such that a region is torn down if any component
> endpoints are removed. All regions and endpoints are torn down if the
> foundational bridge device goes down.
> 
> A workqueue was deployed to manage these interdependencies, but it is
> difficult to reason about, and fragile. A recent attempt to take the CXL
> root device lock in the cxl_mem driver was reported by lockdep as
> colliding with the flush_work() in the cxl_pmem flows.
> 
> Instead of the workqueue, arrange for all pmem/nvdimm devices to be torn
> down immediately and hierarchically. A similar change is made to both
> the 'cxl_nvdimm' and 'cxl_pmem_region' objects. For bisect-ability both
> changes are made in the same patch which unfortunately makes the patch
> bigger than desired.
> 
> Arrange for cxl_memdev and cxl_region to register a cxl_nvdimm and
> cxl_pmem_region as a devres release action of the bridge device.
> Additionally, include a devres release action of the cxl_memdev or
> cxl_region device that triggers the bridge's release action if an endpoint
> exits before the bridge. I.e. this allows either unplugging the bridge,
> or unplugging and endpoint to result in the same cleanup actions.
> 
> To keep the patch smaller the cleanup of the now defunct workqueue
> infrastructure is saved for a follow-on patch.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Hi Dan,

This is fiddly to follow, but then so was the original. A few minor comments inline.

Jonathan

> ---
>  drivers/cxl/core/pmem.c      |   70 ++++++++++++++++++++----
>  drivers/cxl/core/region.c    |   54 ++++++++++++++++++-
>  drivers/cxl/cxl.h            |    7 ++
>  drivers/cxl/cxlmem.h         |    4 +
>  drivers/cxl/mem.c            |    9 +++
>  drivers/cxl/pci.c            |    3 -
>  drivers/cxl/pmem.c           |  122 ++++++++++++------------------------------
>  tools/testing/cxl/test/mem.c |    3 -
>  8 files changed, 164 insertions(+), 108 deletions(-)
> 
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 1d12a8206444..647b3a30638e 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -219,7 +219,8 @@ EXPORT_SYMBOL_NS_GPL(to_cxl_nvdimm, CXL);
>  
>  static struct lock_class_key cxl_nvdimm_key;
>  
> -static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
> +static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_nvdimm_bridge *cxl_nvb,
> +					   struct cxl_memdev *cxlmd)
>  {
>  	struct cxl_nvdimm *cxl_nvd;
>  	struct device *dev;
> @@ -230,6 +231,7 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  
>  	dev = &cxl_nvd->dev;
>  	cxl_nvd->cxlmd = cxlmd;
> +	cxlmd->cxl_nvd = cxl_nvd;
>  	device_initialize(dev);
>  	lockdep_set_class(&dev->mutex, &cxl_nvdimm_key);
>  	device_set_pm_not_required(dev);
> @@ -240,27 +242,52 @@ static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
>  	return cxl_nvd;
>  }
>  
> -static void cxl_nvd_unregister(void *dev)
> +static void cxl_nvd_unregister(void *_cxl_nvd)
>  {
> -	device_unregister(dev);
> +	struct cxl_nvdimm *cxl_nvd = _cxl_nvd;
> +	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> +
> +	device_lock_assert(&cxlmd->cxl_nvb->dev);

Locally it's not immediately obvious if that is always the same
as 
	device_lock_assert(&cxl_nvb->dev);
If not, a comment, if it is maybe just change to that.

> +	cxl_nvd->cxlmd = NULL;
> +	cxlmd->cxl_nvd = NULL;
> +	device_unregister(&cxl_nvd->dev);
> +}
> +
> +static void cxlmd_release_nvdimm(void *_cxlmd)
> +{
> +	struct cxl_memdev *cxlmd = _cxlmd;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlmd->cxl_nvb;
> +
> +	device_lock(&cxl_nvb->dev);
> +	if (cxlmd->cxl_nvd)
> +		devm_release_action(&cxl_nvb->dev, cxl_nvd_unregister,
> +				    cxlmd->cxl_nvd);
> +	device_unlock(&cxl_nvb->dev);
> +	put_device(&cxl_nvb->dev);
>  }
>  
>  /**
>   * devm_cxl_add_nvdimm() - add a bridge between a cxl_memdev and an nvdimm
> - * @host: same host as @cxlmd
>   * @cxlmd: cxl_memdev instance that will perform LIBNVDIMM operations
>   *
>   * Return: 0 on success negative error code on failure.
>   */
> -int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
> +int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd)
>  {
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);

Another cosmetic change, but I'd prefer the actual
	cxl_nvb = cxl_find_nvdimm_bridge();

to be just above the error check rather than up here.

>  	struct cxl_nvdimm *cxl_nvd;
>  	struct device *dev;
>  	int rc;
>  
> -	cxl_nvd = cxl_nvdimm_alloc(cxlmd);
> -	if (IS_ERR(cxl_nvd))
> -		return PTR_ERR(cxl_nvd);
> +	if (!cxl_nvb)
> +		return -ENODEV;
> +
> +	cxl_nvd = cxl_nvdimm_alloc(cxl_nvb, cxlmd);
> +	if (IS_ERR(cxl_nvd)) {
> +		rc = PTR_ERR(cxl_nvd);
> +		goto err_alloc;
> +	}
> +	cxlmd->cxl_nvb = cxl_nvb;
>  
>  	dev = &cxl_nvd->dev;
>  	rc = dev_set_name(dev, "pmem%d", cxlmd->id);
> @@ -271,13 +298,34 @@ int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
>  	if (rc)
>  		goto err;
>  
> -	dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
> -		dev_name(dev));
> +	dev_dbg(&cxlmd->dev, "register %s\n", dev_name(dev));
>  
> -	return devm_add_action_or_reset(host, cxl_nvd_unregister, dev);
> +	/*
> +	 * Remove this nvdimm connection if either the top-level PMEM
> +	 * bridge goes down, or the endpoint device goes through
> +	 * ->remove().
> +	 */

Perhaps move this comment down to inside the if (cxl_nvb->dev.driver)
block as it only refers (I think) to the devm_add_action_or_reset(),
not the surrounding driver binding checks.

> +	device_lock(&cxl_nvb->dev);
> +	if (cxl_nvb->dev.driver)
> +		rc = devm_add_action_or_reset(&cxl_nvb->dev, cxl_nvd_unregister,
> +					      cxl_nvd);
> +	else
> +		rc = -ENXIO;
> +	device_unlock(&cxl_nvb->dev);
> +
> +	if (rc)
> +		goto err_alloc;
> +
> +	/* @cxlmd carries a reference on @cxl_nvb until cxlmd_release_nvdimm */
> +	return devm_add_action_or_reset(&cxlmd->dev, cxlmd_release_nvdimm, cxlmd);
>  
>  err:
>  	put_device(dev);
> +err_alloc:
> +	put_device(&cxl_nvb->dev);

Is this ordering necessary? It's not reverse of the setup above, so if we can reordering
to be so, that is probably a good thing. (move these NULL setting above the put_device(&cxl_nvb->dev)).

> +	cxlmd->cxl_nvb = NULL;
> +	cxlmd->cxl_nvd = NULL;
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_nvdimm, CXL);
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index f9ae5ad284ff..e73bec828032 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -1812,6 +1812,7 @@ static struct lock_class_key cxl_pmem_region_key;
>  static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
>  {
>  	struct cxl_region_params *p = &cxlr->params;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct cxl_pmem_region *cxlr_pmem;
>  	struct device *dev;
>  	int i;
> @@ -1839,6 +1840,14 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
>  		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
>  		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
>  
> +		if (i == 0) {

Whilst kind of obvious, maybe a comment in here that for end points in the region the
cxl_nvb will be the same hence we just look it up for the first one?

> +			cxl_nvb = cxl_find_nvdimm_bridge(&cxlmd->dev);
> +			if (!cxl_nvb) {
> +				cxlr_pmem = ERR_PTR(-ENODEV);
> +				goto out;
> +			}
> +			cxlr->cxl_nvb = cxl_nvb;
> +		}
>  		m->cxlmd = cxlmd;
>  		get_device(&cxlmd->dev);
>  		m->start = cxled->dpa_res->start;
> @@ -1848,6 +1857,7 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
>  
>  	dev = &cxlr_pmem->dev;
>  	cxlr_pmem->cxlr = cxlr;
> +	cxlr->cxlr_pmem = cxlr_pmem;
>  	device_initialize(dev);
>  	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
>  	device_set_pm_not_required(dev);
> @@ -1860,9 +1870,30 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
>  	return cxlr_pmem;
>  }
>  
> -static void cxlr_pmem_unregister(void *dev)
> +static void cxlr_pmem_unregister(void *_cxlr_pmem)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> +
> +	device_lock_assert(&cxl_nvb->dev);

This scheme is obvious in this patch, but probably less so when just
looking at the resulting code. Perhaps worth a comment
here on why we care about that particular lock?

> +	cxlr->cxlr_pmem = NULL;
> +	cxlr_pmem->cxlr = NULL;
> +	device_unregister(&cxlr_pmem->dev);
> +}
> +
> +static void cxlr_release_nvdimm(void *_cxlr)
>  {
> -	device_unregister(dev);
> +	struct cxl_region *cxlr = _cxlr;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> +
> +	device_lock(&cxl_nvb->dev);
> +	if (cxlr->cxlr_pmem)
> +		devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
> +				    cxlr->cxlr_pmem);
> +	device_unlock(&cxl_nvb->dev);
> +	cxlr->cxl_nvb = NULL;
> +	put_device(&cxl_nvb->dev);
>  }
>  
>  /**
> @@ -1874,12 +1905,14 @@ static void cxlr_pmem_unregister(void *dev)
>  static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  {
>  	struct cxl_pmem_region *cxlr_pmem;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct device *dev;
>  	int rc;
>  
>  	cxlr_pmem = cxl_pmem_region_alloc(cxlr);
>  	if (IS_ERR(cxlr_pmem))
>  		return PTR_ERR(cxlr_pmem);
> +	cxl_nvb = cxlr->cxl_nvb;
>  
>  	dev = &cxlr_pmem->dev;
>  	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
> @@ -1893,10 +1926,25 @@ static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
>  		dev_name(dev));
>  
> -	return devm_add_action_or_reset(&cxlr->dev, cxlr_pmem_unregister, dev);
> +	device_lock(&cxl_nvb->dev);
> +	if (cxl_nvb->dev.driver)
> +		rc = devm_add_action_or_reset(&cxl_nvb->dev,
> +					      cxlr_pmem_unregister, cxlr_pmem);
> +	else
> +		rc = -ENXIO;
> +	device_unlock(&cxl_nvb->dev);
> +
> +	if (rc)
> +		goto err_bridge;
> +
> +	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> +	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
>  
>  err:
>  	put_device(dev);
> +err_bridge:
> +	put_device(&cxl_nvb->dev);
> +	cxlr->cxl_nvb = NULL;
>  	return rc;
>  }
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 4ac7938eaf6c..9b5ba9626636 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -386,6 +386,8 @@ struct cxl_region_params {
>   * @id: This region's id. Id is globally unique across all regions
>   * @mode: Endpoint decoder allocation / access mode
>   * @type: Endpoint decoder target type
> + * @cxl_nvb: nvdimm bridge for coordinating @cxlr_pmem shutdown

I was going to suggest just carrying the struct device around, but this
comment isn't quite true.  I think cxl_region->cxl_nvb is also used in
cxl_pmem_region_probe() to get the nvdimm_buss for nvdimm_pmem_region_create()


> + * @cxlr_pmem: (for pmem regions) cached copy of the nvdimm bridge
>   * @params: active + config params for the region
>   */
>  struct cxl_region {
> @@ -393,6 +395,8 @@ struct cxl_region {
>  	int id;
>  	enum cxl_decoder_mode mode;
>  	enum cxl_decoder_type type;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct cxl_pmem_region *cxlr_pmem;
>  	struct cxl_region_params params;
>  };
>  
> @@ -438,7 +442,6 @@ struct cxl_pmem_region {
>  	struct device dev;
>  	struct cxl_region *cxlr;
>  	struct nd_region *nd_region;
> -	struct cxl_nvdimm_bridge *bridge;
>  	struct range hpa_range;
>  	int nr_mappings;
>  	struct cxl_pmem_region_mapping mapping[];
> @@ -637,7 +640,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
>  struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
>  bool is_cxl_nvdimm(struct device *dev);
>  bool is_cxl_nvdimm_bridge(struct device *dev);
> -int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> +int devm_cxl_add_nvdimm(struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct device *dev);
>  
>  #ifdef CONFIG_CXL_REGION
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 88e3a8e54b6a..c1c9960ab05f 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -35,6 +35,8 @@
>   * @cdev: char dev core object for ioctl operations
>   * @cxlds: The device state backing this device
>   * @detach_work: active memdev lost a port in its ancestry
> + * @cxl_nvb: coordinate removal of @cxl_nvd if present
> + * @cxl_nvd: optional bridge to an nvdimm if the device supports pmem
>   * @id: id number of this memdev instance.
>   */
>  struct cxl_memdev {
> @@ -42,6 +44,8 @@ struct cxl_memdev {
>  	struct cdev cdev;
>  	struct cxl_dev_state *cxlds;
>  	struct work_struct detach_work;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct cxl_nvdimm *cxl_nvd;
>  	int id;
>  };
>  

> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 652f00fc68ca..73357d0c3f25 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c


>  static struct cxl_driver cxl_nvdimm_driver = {
> @@ -200,6 +182,16 @@ static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
>  	return cxl_pmem_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
>  }
>  
> +static void unregister_nvdimm_bus(void *_cxl_nvb)
> +{
> +	struct cxl_nvdimm_bridge *cxl_nvb = _cxl_nvb;
> +	struct nvdimm_bus *nvdimm_bus = cxl_nvb->nvdimm_bus;
> +
> +	cxl_nvb->nvdimm_bus = NULL;
> +	nvdimm_bus_unregister(nvdimm_bus);
> +}
> +

Single blank line.

> +
>  static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
>  {
>  	if (cxl_nvb->nvdimm_bus)
> @@ -303,23 +295,21 @@ static int cxl_nvdimm_bridge_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
>  
> -	if (cxl_nvb->state == CXL_NVB_DEAD)
> -		return -ENXIO;
> +	cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor){
) {
matches existing style in this file.

> +		.provider_name = "CXL",
> +		.module = THIS_MODULE,
> +		.ndctl = cxl_pmem_ctl,
> +	};
>  
> -	if (cxl_nvb->state == CXL_NVB_NEW) {
> -		cxl_nvb->nd_desc = (struct nvdimm_bus_descriptor) {
> -			.provider_name = "CXL",
> -			.module = THIS_MODULE,
> -			.ndctl = cxl_pmem_ctl,
> -		};
> +	cxl_nvb->nvdimm_bus =
> +		nvdimm_bus_register(&cxl_nvb->dev, &cxl_nvb->nd_desc);
>  
> -		INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
> -	}
> +	if (!cxl_nvb->nvdimm_bus)
> +		return -ENOMEM;
>  
> -	cxl_nvb->state = CXL_NVB_ONLINE;
> -	cxl_nvdimm_bridge_state_work(cxl_nvb);
> +	INIT_WORK(&cxl_nvb->state_work, cxl_nvb_update_state);
>  
> -	return 0;
> +	return devm_add_action_or_reset(dev, unregister_nvdimm_bus, cxl_nvb);
