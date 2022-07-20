Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFBE602F
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 16:45:45 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp1ft0gKnz67gYW;
	Thu, 21 Jul 2022 00:41:10 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 18:45:43 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 17:45:42 +0100
Date: Wed, 20 Jul 2022 17:45:40 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 08/28] cxl/hdm: Track next decoder to allocate
Message-ID: <20220720174540.00005050@Huawei.com>
In-Reply-To: <165784328827.1758207.9627538529944559954.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784328827.1758207.9627538529944559954.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 14 Jul 2022 17:01:28 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The CXL specification enforces that endpoint decoders are committed in
> hw instance id order. In preparation for adding dynamic DPA allocation,
> record the hw instance id in endpoint decoders, and enforce allocations
> to occur in hw instance id order.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Lifting from v1 thread to ease picking it up.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/hdm.c  |   15 +++++++++++++++
>  drivers/cxl/core/port.c |    1 +
>  drivers/cxl/cxl.h       |    2 ++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index acd46b0d69c6..582f48141767 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -160,6 +160,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_dpa_debug, CXL);
>  static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
>  {
>  	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_port *port = cxled_to_port(cxled);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  	struct resource *res = cxled->dpa_res;
>  
> @@ -171,6 +172,7 @@ static void __cxl_dpa_release(struct cxl_endpoint_decoder *cxled)
>  	cxled->skip = 0;
>  	__release_region(&cxlds->dpa_res, res->start, resource_size(res));
>  	cxled->dpa_res = NULL;
> +	port->hdm_end--;
>  }
>  
>  static void cxl_dpa_release(void *cxled)
> @@ -201,6 +203,18 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>  		return -EBUSY;
>  	}
>  
> +	if (port->hdm_end + 1 != cxled->cxld.id) {
> +		/*
> +		 * Assumes alloc and commit order is always in hardware instance
> +		 * order per expectations from 8.2.5.12.20 Committing Decoder
> +		 * Programming that enforce decoder[m] committed before
> +		 * decoder[m+1] commit start.
> +		 */
> +		dev_dbg(dev, "decoder%d.%d: expected decoder%d.%d\n", port->id,
> +			cxled->cxld.id, port->id, port->hdm_end + 1);
> +		return -EBUSY;
> +	}
> +
>  	if (skipped) {
>  		res = __request_region(&cxlds->dpa_res, base - skipped, skipped,
>  				       dev_name(&cxled->cxld.dev), 0);
> @@ -233,6 +247,7 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>  			cxled->cxld.id, cxled->dpa_res);
>  		cxled->mode = CXL_DECODER_MIXED;
>  	}
> +	port->hdm_end++;
>  
>  	return 0;
>  }
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 0ac5dcd612e0..109611318760 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -502,6 +502,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  
>  	port->component_reg_phys = component_reg_phys;
>  	ida_init(&port->decoder_ida);
> +	port->hdm_end = -1;
>  	INIT_LIST_HEAD(&port->dports);
>  	INIT_LIST_HEAD(&port->endpoints);
>  
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 3e7363dde80f..70cd24e4f3ce 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -333,6 +333,7 @@ struct cxl_nvdimm {
>   * @dports: cxl_dport instances referenced by decoders
>   * @endpoints: cxl_ep instances, endpoints that are a descendant of this port
>   * @decoder_ida: allocator for decoder ids
> + * @hdm_end: track last allocated HDM decoder instance for allocation ordering
>   * @component_reg_phys: component register capability base address (optional)
>   * @dead: last ep has been removed, force port re-creation
>   * @depth: How deep this port is relative to the root. depth 0 is the root.
> @@ -345,6 +346,7 @@ struct cxl_port {
>  	struct list_head dports;
>  	struct list_head endpoints;
>  	struct ida decoder_ida;
> +	int hdm_end;
>  	resource_size_t component_reg_phys;
>  	bool dead;
>  	unsigned int depth;
> 

