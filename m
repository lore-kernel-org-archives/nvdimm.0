Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DEFEBB;
	Thu, 30 Jun 2022 09:21:10 +0000 (UTC)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LYXnd075bz686n3;
	Thu, 30 Jun 2022 17:18:45 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 30 Jun 2022 11:21:08 +0200
Received: from localhost (10.81.200.250) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 30 Jun
 2022 10:21:07 +0100
Date: Thu, 30 Jun 2022 10:21:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>, <hch@lst.de>
Subject: Re: [PATCH 29/46] cxl/port: Cache CXL host bridge data
Message-ID: <20220630102105.000060ab@Huawei.com>
In-Reply-To: <20220624041950.559155-4-dan.j.williams@intel.com>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<20220624041950.559155-4-dan.j.williams@intel.com>
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
X-Originating-IP: [10.81.200.250]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 21:19:33 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Region creation has need for checking host-bridge connectivity when
> adding endpoints to regions. Record, at port creation time, the
> host-bridge to provide a useful shortcut from any location in the
> topology to the most-significant ancestor.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Trivial comment inline, but otherwise seems reasonable to me.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/port.c | 16 +++++++++++++++-
>  drivers/cxl/cxl.h       |  2 ++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index d2f6898940fa..c48f217e689a 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -546,6 +546,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	if (rc < 0)
>  		goto err;
>  	port->id = rc;
> +	port->uport = uport;
>  
>  	/*
>  	 * The top-level cxl_port "cxl_root" does not have a cxl_port as
> @@ -556,14 +557,27 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  	dev = &port->dev;
>  	if (parent_dport) {
>  		struct cxl_port *parent_port = parent_dport->port;
> +		struct cxl_port *iter;
>  
>  		port->depth = parent_port->depth + 1;
>  		port->parent_dport = parent_dport;
>  		dev->parent = &parent_port->dev;
> +		/*
> +		 * walk to the host bridge, or the first ancestor that knows
> +		 * the host bridge
> +		 */
> +		iter = port;
> +		while (!iter->host_bridge &&
> +		       !is_cxl_root(to_cxl_port(iter->dev.parent)))
> +			iter = to_cxl_port(iter->dev.parent);
> +		if (iter->host_bridge)
> +			port->host_bridge = iter->host_bridge;
> +		else
> +			port->host_bridge = iter->uport;
> +		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
>  	} else
>  		dev->parent = uport;
>  
> -	port->uport = uport;
>  	port->component_reg_phys = component_reg_phys;
>  	ida_init(&port->decoder_ida);
>  	port->dpa_end = -1;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 8e2c1b393552..0211cf0d3574 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -331,6 +331,7 @@ struct cxl_nvdimm {
>   * @component_reg_phys: component register capability base address (optional)
>   * @dead: last ep has been removed, force port re-creation
>   * @depth: How deep this port is relative to the root. depth 0 is the root.
> + * @host_bridge: Shortcut to the platform attach point for this port
>   */
>  struct cxl_port {
>  	struct device dev;
> @@ -344,6 +345,7 @@ struct cxl_port {
>  	resource_size_t component_reg_phys;
>  	bool dead;
>  	unsigned int depth;
> +	struct device *host_bridge;
Would feel more natural up next to the struct device *uport element of cxl_port.


>  };
>  
>  static inline struct cxl_dport *cxl_dport_load(struct cxl_port *port,

