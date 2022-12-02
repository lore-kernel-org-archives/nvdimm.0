Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE194C89
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 16:40:56 +0000 (UTC)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNzC21tYZz6H735;
	Sat,  3 Dec 2022 00:38:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 17:40:53 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 16:40:53 +0000
Date: Fri, 2 Dec 2022 16:40:52 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 09/12] cxl/mem: Move devm_cxl_add_endpoint() from
 cxl_core to cxl_mem
Message-ID: <20221202164052.00007b5c@Huawei.com>
In-Reply-To: <166993045072.1882361.13944923741276843683.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993045072.1882361.13944923741276843683.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:34:10 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> tl;dr: Clean up an unnecessary export and enable cxl_test.
> 
> An RCD (Restricted CXL Device), in contrast to a typical CXL device in
> a VH topology, obtains its component registers from the bottom half of
> the associated CXL host bridge RCRB (Root Complex Register Block). In
> turn this means that cxl_rcrb_to_component() needs to be called from
> devm_cxl_add_endpoint().
> 
> Presently devm_cxl_add_endpoint() is part of the CXL core, but the only
> user is the CXL mem module. Move it from cxl_core to cxl_mem to not only
> get rid of an unnecessary export, but to also enable its call out to
> cxl_rcrb_to_component(), in a subsequent patch, to be mocked by
> cxl_test. Recall that cxl_test can only mock exported symbols, and since
> cxl_rcrb_to_component() is itself inside the core, all callers must be
> outside of cxl_core to allow cxl_test to mock it.
> 
> Reviewed-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reasoning for the move is sound and patch is clearly just a move so
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/core/core.h |    8 --------
>  drivers/cxl/core/port.c |   39 ---------------------------------------
>  drivers/cxl/cxl.h       |    2 --
>  drivers/cxl/cxlmem.h    |    9 +++++++++
>  drivers/cxl/mem.c       |   38 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 47 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 1d8f87be283f..8c04672dca56 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -58,14 +58,6 @@ extern struct rw_semaphore cxl_dpa_rwsem;
>  
>  bool is_switch_decoder(struct device *dev);
>  struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev);
> -static inline struct cxl_ep *cxl_ep_load(struct cxl_port *port,
> -					 struct cxl_memdev *cxlmd)
> -{
> -	if (!port)
> -		return NULL;
> -
> -	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
> -}
>  
>  int cxl_memdev_init(void);
>  void cxl_memdev_exit(void);
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index dae2ca31885e..4982b6902ef5 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1212,45 +1212,6 @@ static void reap_dports(struct cxl_port *port)
>  	}
>  }
>  
> -int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> -			  struct cxl_dport *parent_dport)
> -{
> -	struct cxl_port *parent_port = parent_dport->port;
> -	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> -	struct cxl_port *endpoint, *iter, *down;
> -	int rc;
> -
> -	/*
> -	 * Now that the path to the root is established record all the
> -	 * intervening ports in the chain.
> -	 */
> -	for (iter = parent_port, down = NULL; !is_cxl_root(iter);
> -	     down = iter, iter = to_cxl_port(iter->dev.parent)) {
> -		struct cxl_ep *ep;
> -
> -		ep = cxl_ep_load(iter, cxlmd);
> -		ep->next = down;
> -	}
> -
> -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> -				     cxlds->component_reg_phys, parent_dport);
> -	if (IS_ERR(endpoint))
> -		return PTR_ERR(endpoint);
> -
> -	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
> -	if (rc)
> -		return rc;
> -
> -	if (!endpoint->dev.driver) {
> -		dev_err(&cxlmd->dev, "%s failed probe\n",
> -			dev_name(&endpoint->dev));
> -		return -ENXIO;
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_NS_GPL(devm_cxl_add_endpoint, CXL);
> -
>  static void cxl_detach_ep(void *data)
>  {
>  	struct cxl_memdev *cxlmd = data;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 1342e4e61537..9a212ab3cae4 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -560,8 +560,6 @@ struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port);
>  struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
>  				   resource_size_t component_reg_phys,
>  				   struct cxl_dport *parent_dport);
> -int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> -			  struct cxl_dport *parent_dport);
>  struct cxl_port *find_cxl_root(struct device *dev);
>  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
>  void cxl_bus_rescan(void);
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index c1c9960ab05f..e082991bc58c 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -80,6 +80,15 @@ static inline bool is_cxl_endpoint(struct cxl_port *port)
>  
>  struct cxl_memdev *devm_cxl_add_memdev(struct cxl_dev_state *cxlds);
>  
> +static inline struct cxl_ep *cxl_ep_load(struct cxl_port *port,
> +					 struct cxl_memdev *cxlmd)
> +{
> +	if (!port)
> +		return NULL;
> +
> +	return xa_load(&port->endpoints, (unsigned long)&cxlmd->dev);
> +}
> +
>  /**
>   * struct cxl_mbox_cmd - A command to be submitted to hardware.
>   * @opcode: (input) The command set and command submitted to hardware.
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 549b6b499bae..aa63ce8c7ca6 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -45,6 +45,44 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
>  	return 0;
>  }
>  
> +static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> +				 struct cxl_dport *parent_dport)
> +{
> +	struct cxl_port *parent_port = parent_dport->port;
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct cxl_port *endpoint, *iter, *down;
> +	int rc;
> +
> +	/*
> +	 * Now that the path to the root is established record all the
> +	 * intervening ports in the chain.
> +	 */
> +	for (iter = parent_port, down = NULL; !is_cxl_root(iter);
> +	     down = iter, iter = to_cxl_port(iter->dev.parent)) {
> +		struct cxl_ep *ep;
> +
> +		ep = cxl_ep_load(iter, cxlmd);
> +		ep->next = down;
> +	}
> +
> +	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> +				     cxlds->component_reg_phys, parent_dport);
> +	if (IS_ERR(endpoint))
> +		return PTR_ERR(endpoint);
> +
> +	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
> +	if (rc)
> +		return rc;
> +
> +	if (!endpoint->dev.driver) {
> +		dev_err(&cxlmd->dev, "%s failed probe\n",
> +			dev_name(&endpoint->dev));
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
>  static int cxl_mem_probe(struct device *dev)
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> 

