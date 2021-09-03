Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DEE3FCD
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 11:15:06 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H1FXD13dQz67MLx;
	Fri,  3 Sep 2021 19:13:16 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Fri, 3 Sep 2021 13:15:03 +0200
Received: from localhost (10.52.121.127) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 3 Sep 2021
 12:15:03 +0100
Date: Fri, 3 Sep 2021 12:15:03 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>,
	<nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 22/28] cxl/pmem: Add support for multiple
 nvdimm-bridge objects
Message-ID: <20210903121503.00005e57@Huawei.com>
In-Reply-To: <162982124325.1124374.4356765162960141442.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982124325.1124374.4356765162960141442.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Tue, 24 Aug 2021 09:07:23 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for a mocked unit test environment for CXL objects, allow
> for multiple unique nvdimm-bridge objects.
> 
> For now, just allow multiple bridges to be registered. Later, when there
> are multiple present, further updates are needed to
> cxl_find_nvdimm_bridge() to identify which bridge is associated with
> which CXL hierarchy for nvdimm registration.
> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

If being extremely fussy, the change of dev_name is I think going
to result in userspace ABI changes.  Should call that out even though
I can't imagine it would break anything yet.

Otherwise this is fine

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/pmem.c |   32 +++++++++++++++++++++++++++++++-
>  drivers/cxl/cxl.h       |    2 ++
>  drivers/cxl/pmem.c      |   15 ---------------
>  3 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> index 69c97cc0d945..ec3e4c642fca 100644
> --- a/drivers/cxl/core/pmem.c
> +++ b/drivers/cxl/core/pmem.c
> @@ -3,15 +3,19 @@
>  
>  #include <linux/device.h>
>  #include <linux/slab.h>
> +#include <linux/idr.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
>  
>  #include "core.h"
>  
> +static DEFINE_IDA(cxl_nvdimm_bridge_ida);
> +
>  static void cxl_nvdimm_bridge_release(struct device *dev)
>  {
>  	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
>  
> +	ida_free(&cxl_nvdimm_bridge_ida, cxl_nvb->id);
>  	kfree(cxl_nvb);
>  }
>  
> @@ -35,16 +39,38 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
>  
> +static int match_nvdimm_bridge(struct device *dev, const void *data)
> +{
> +	return dev->type == &cxl_nvdimm_bridge_type;
> +}
> +
> +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> +{
> +	struct device *dev;
> +
> +	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
> +	if (!dev)
> +		return NULL;
> +	return to_cxl_nvdimm_bridge(dev);
> +}
> +EXPORT_SYMBOL_GPL(cxl_find_nvdimm_bridge);
> +
>  static struct cxl_nvdimm_bridge *
>  cxl_nvdimm_bridge_alloc(struct cxl_port *port)
>  {
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct device *dev;
> +	int rc;
>  
>  	cxl_nvb = kzalloc(sizeof(*cxl_nvb), GFP_KERNEL);
>  	if (!cxl_nvb)
>  		return ERR_PTR(-ENOMEM);
>  
> +	rc = ida_alloc(&cxl_nvdimm_bridge_ida, GFP_KERNEL);
> +	if (rc < 0)
> +		goto err;
> +	cxl_nvb->id = rc;
> +
>  	dev = &cxl_nvb->dev;
>  	cxl_nvb->port = port;
>  	cxl_nvb->state = CXL_NVB_NEW;
> @@ -55,6 +81,10 @@ cxl_nvdimm_bridge_alloc(struct cxl_port *port)
>  	dev->type = &cxl_nvdimm_bridge_type;
>  
>  	return cxl_nvb;
> +
> +err:
> +	kfree(cxl_nvb);
> +	return ERR_PTR(rc);
>  }
>  
>  static void unregister_nvb(void *_cxl_nvb)
> @@ -100,7 +130,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
>  		return cxl_nvb;
>  
>  	dev = &cxl_nvb->dev;
> -	rc = dev_set_name(dev, "nvdimm-bridge");
> +	rc = dev_set_name(dev, "nvdimm-bridge%d", cxl_nvb->id);
>  	if (rc)
>  		goto err;
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 53927f9fa77e..1b2e816e061e 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -211,6 +211,7 @@ enum cxl_nvdimm_brige_state {
>  };
>  
>  struct cxl_nvdimm_bridge {
> +	int id;
>  	struct device dev;
>  	struct cxl_port *port;
>  	struct nvdimm_bus *nvdimm_bus;
> @@ -323,4 +324,5 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
>  struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
>  bool is_cxl_nvdimm(struct device *dev);
>  int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
> +struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void);
>  #endif /* __CXL_H__ */
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 6cc76302c8f8..743e2d2fdbb5 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -33,21 +33,6 @@ static void unregister_nvdimm(void *_cxl_nvd)
>  	clear_exclusive_cxl_commands(cxlm, exclusive_cmds);
>  }
>  
> -static int match_nvdimm_bridge(struct device *dev, const void *data)
> -{
> -	return strcmp(dev_name(dev), "nvdimm-bridge") == 0;
> -}
> -
> -static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
> -{
> -	struct device *dev;
> -
> -	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
> -	if (!dev)
> -		return NULL;
> -	return to_cxl_nvdimm_bridge(dev);
> -}
> -
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> 

