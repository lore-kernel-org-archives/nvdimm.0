Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB948F5D
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669652903; x=1701188903;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GRWBeQCozIXpeMCdz1qRg21oTO6+7frgdRV4wZXZf4E=;
  b=ZlQmqq7VJcT4jkhsmhzQUe4L5jy/tc0dyG9KMS2odN6+VoDwweRikezs
   RxWYCFE4Ovacqo8KRLYsGFz5LInVpy7K9XuQvGEUSO9vcw8pB+EfmXss6
   72MbVmgejunfMV5fXOSYeYUooh60jRtQNu0EAKiMXJZ4z220D5a+IQPBT
   9znjd4+buLmp1QTLdfWAOrO4P/0ew9aMKPew1L8lov9qqRVPrLvyqczsh
   RKxYpq4TEBG9xTcCD3d63plcRo3jGkOIcTIVkRA76fnYbKy5lWy/JIv5d
   t/0/JLhFQRetv/GwoXWQFDmmaK3Z/PHE/Hu2mf5cvIN8s0AQPdWyALwyS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377022397"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="377022397"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:28:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="749452616"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="749452616"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.209.161.118]) ([10.209.161.118])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 08:28:22 -0800
Message-ID: <9f5f2990-3b6a-1d8a-a3f9-0f5d184b85f9@intel.com>
Date: Mon, 28 Nov 2022 09:28:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 nvdimm@lists.linux.dev
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/24/2022 11:35 AM, Dan Williams wrote:
> Unlike a CXL memory expander in a VH topology that has at least one
> intervening 'struct cxl_port' instance between itself and the CXL root
> device, an RCD attaches one-level higher. For example:
> 
>                 VH
>            ┌──────────┐
>            │ ACPI0017 │
>            │  root0   │
>            └─────┬────┘
>                  │
>            ┌─────┴────┐
>            │  dport0  │
>      ┌─────┤ ACPI0016 ├─────┐
>      │     │  port1   │     │
>      │     └────┬─────┘     │
>      │          │           │
>   ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
>   │dport0│   │dport1│   │dport2│
>   │ RP0  │   │ RP1  │   │ RP2  │
>   └──────┘   └──┬───┘   └──────┘
>                 │
>             ┌───┴─────┐
>             │endpoint0│
>             │  port2  │
>             └─────────┘
> 
> ...vs:
> 
>                RCH
>            ┌──────────┐
>            │ ACPI0017 │
>            │  root0   │
>            └────┬─────┘
>                 │
>             ┌───┴────┐
>             │ dport0 │
>             │ACPI0016│
>             └───┬────┘
>                 │
>            ┌────┴─────┐
>            │endpoint0 │
>            │  port1   │
>            └──────────┘
> 
> So arrange for endpoint port in the RCH/RCD case to appear directly
> connected to the host-bridge in its singular role as a dport. Compare
> that to the VH case where the host-bridge serves a dual role as a
> 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> instances in the CXL topology.
> 
> Another deviation from the VH case is that RCDs may need to look up
> their component registers from the Root Complex Register Block (RCRB).
> That platform firmware specified RCRB area is cached by the cxl_acpi
> driver and conveyed via the host-bridge dport to the cxl_mem driver to
> perform the cxl_rcrb_to_component() lookup for the endpoint port
> (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> upstream port component registers).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/cxl/core/port.c |   11 +++++++++--
>   drivers/cxl/cxlmem.h    |    2 ++
>   drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
>   drivers/cxl/pci.c       |   10 ++++++++++
>   4 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index c7f58282b2c1..2385ee00eb9a 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
>   {
>   	struct device *dev = &cxlmd->dev;
>   	struct device *iter;
> +	struct cxl_dport *dport;
> +	struct cxl_port *port;
>   	int rc;
>   
> +	/*
> +	 * Skip intermediate port enumeration in the RCH case, there
> +	 * are no ports in between a host bridge and an endpoint.
> +	 */
> +	if (cxlmd->cxlds->rcd)
> +		return 0;
> +
>   	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
>   	if (rc)
>   		return rc;
> @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
>   	for (iter = dev; iter; iter = grandparent(iter)) {
>   		struct device *dport_dev = grandparent(iter);
>   		struct device *uport_dev;
> -		struct cxl_dport *dport;
> -		struct cxl_port *port;
>   
>   		if (!dport_dev)
>   			return 0;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index e082991bc58c..35d485d041f0 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
>    * @dev: The device associated with this CXL state
>    * @regs: Parsed register blocks
>    * @cxl_dvsec: Offset to the PCIe device DVSEC
> + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
>    * @payload_size: Size of space for payload
>    *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
>    * @lsa_size: Size of Label Storage Area
> @@ -235,6 +236,7 @@ struct cxl_dev_state {
>   	struct cxl_regs regs;
>   	int cxl_dvsec;
>   
> +	bool rcd;
>   	size_t payload_size;
>   	size_t lsa_size;
>   	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index aa63ce8c7ca6..9a655b4b5e52 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
>   	return 0;
>   }
>   
> -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
>   				 struct cxl_dport *parent_dport)
>   {
>   	struct cxl_port *parent_port = parent_dport->port;
>   	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>   	struct cxl_port *endpoint, *iter, *down;
> +	resource_size_t component_reg_phys;
>   	int rc;
>   
>   	/*
> @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
>   		ep->next = down;
>   	}
>   
> -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> -				     cxlds->component_reg_phys, parent_dport);
> +	/*
> +	 * The component registers for an RCD might come from the
> +	 * host-bridge RCRB if they are not already mapped via the
> +	 * typical register locator mechanism.
> +	 */
> +	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> +		component_reg_phys = cxl_rcrb_to_component(
> +			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);

Should this be CXL_RCRB_UPSTREAM?

> +	else
> +		component_reg_phys = cxlds->component_reg_phys;
> +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> +				     parent_dport);
>   	if (IS_ERR(endpoint))
>   		return PTR_ERR(endpoint);
>   
> @@ -87,6 +98,7 @@ static int cxl_mem_probe(struct device *dev)
>   {
>   	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>   	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct device *endpoint_parent;
>   	struct cxl_port *parent_port;
>   	struct cxl_dport *dport;
>   	struct dentry *dentry;
> @@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
>   		return -ENXIO;
>   	}
>   
> -	device_lock(&parent_port->dev);
> -	if (!parent_port->dev.driver) {
> +	if (dport->rch)
> +		endpoint_parent = parent_port->uport;
> +	else
> +		endpoint_parent = &parent_port->dev;
> +
> +	device_lock(endpoint_parent);
> +	if (!endpoint_parent->driver) {
>   		dev_err(dev, "CXL port topology %s not enabled\n",
>   			dev_name(&parent_port->dev));
>   		rc = -ENXIO;
>   		goto unlock;
>   	}
>   
> -	rc = devm_cxl_add_endpoint(cxlmd, dport);
> +	rc = devm_cxl_add_endpoint(endpoint_parent, cxlmd, dport);
>   unlock:
> -	device_unlock(&parent_port->dev);
> +	device_unlock(endpoint_parent);
>   	put_device(&parent_port->dev);
>   	if (rc)
>   		return rc;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e15da405b948..73ff6c33a0c0 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -433,6 +433,15 @@ static void devm_cxl_pci_create_doe(struct cxl_dev_state *cxlds)
>   	}
>   }
>   
> +/*
> + * Assume that any RCIEP that emits the CXL memory expander class code
> + * is an RCD
> + */
> +static bool is_cxl_restricted(struct pci_dev *pdev)
> +{
> +	return pci_pcie_type(pdev) == PCI_EXP_TYPE_RC_END;
> +}
> +
>   static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   {
>   	struct cxl_register_map map;
> @@ -455,6 +464,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	if (IS_ERR(cxlds))
>   		return PTR_ERR(cxlds);
>   
> +	cxlds->rcd = is_cxl_restricted(pdev);
>   	cxlds->serial = pci_get_dsn(pdev);
>   	cxlds->cxl_dvsec = pci_find_dvsec_capability(
>   		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
> 
