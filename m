Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399410790
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 22:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669932055; x=1701468055;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SL4yKkpEyhrzEgaMxrTmqg48nQRbyW3YrBSI8PNgLvI=;
  b=FA8Y9ul+l9CZrz852C03xxaoLYZ6T0H0ic2gFfxIPt0MdlAlHswtsBHK
   yaxZ0nVAxLfU+v2jyiWHz05DrhJl3Ye7Dj3/N0NFkNmwBPii0KkYGr34B
   5sJJGdAa5dDwG4n416mEvg8djdTdcx3DDfcapwq+oeawtw7uRG2ZYOdZW
   1iijhN0RbOKoc4pIeixnt0/DXOGY2Dt9EGQ2yiINsEQ3Yyp/2r3iCIBbP
   mso2BpRjLOBzd7RvDep2mD0kD+C6guqQwCtwkj2jyiDNyY7YZKbj0tBMy
   16Ebhcm4Q6XiAHg2eRxZFedp7wjEJtUHftjZydWMW5un9pQrtHwcb3ILN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="316957974"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="316957974"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:00:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733575674"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="733575674"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.66.184]) ([10.212.66.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 14:00:54 -0800
Message-ID: <342a655d-c197-faae-fa2a-e08ab96a168a@intel.com>
Date: Thu, 1 Dec 2022 15:00:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v6 07/12] cxl/ACPI: Register CXL host ports by bridge
 device
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc: Robert Richter <rrichter@amd.com>, alison.schofield@intel.com,
 terry.bowman@amd.com, bhelgaas@google.com, nvdimm@lists.linux.dev
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993043978.1882361.16238060349889579369.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <166993043978.1882361.16238060349889579369.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/1/2022 2:33 PM, Dan Williams wrote:
> From: Robert Richter <rrichter@amd.com>
> 
> A port of a CXL host bridge links to the bridge's ACPI device
> (&adev->dev) with its corresponding uport/dport device (uport_dev and
> dport_dev respectively). The device is not a direct parent device in
> the PCI topology as pdev->dev.parent points to a PCI bridge's (struct
> pci_host_bridge) device. The following CXL memory device hierarchy
> would be valid for an endpoint once an RCD EP would be enabled (note
> this will be done in a later patch):
> 
> VH mode:
> 
>   cxlmd->dev.parent->parent
>          ^^^\^^^^^^\ ^^^^^^\
>              \      \       pci_dev (Type 1, Downstream Port)
>               \      pci_dev (Type 0, PCI Express Endpoint)
>                cxl mem device
> 
> RCD mode:
> 
>   cxlmd->dev.parent->parent
>          ^^^\^^^^^^\ ^^^^^^\
>              \      \       pci_host_bridge
>               \      pci_dev (Type 0, RCiEP)
>                cxl mem device
> 
> In VH mode a downstream port is created by port enumeration and thus
> always exists.
> 
> Now, in RCD mode the host bridge also already exists but it references
> to an ACPI device. A port lookup by the PCI device's parent device
> will fail as a direct link to the registered port is missing. The ACPI
> device of the bridge must be determined first.
> 
> To prevent this, change port registration of a CXL host to use the
> bridge device instead. Do this also for the VH case as port topology
> will better reflect the PCI topology then.
> 
> Signed-off-by: Robert Richter <rrichter@amd.com>
> [djbw: rebase on brige mocking]
> Reviewed-by: Robert Richter <rrichter@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/acpi.c |   35 +++++++++++++++++++----------------
>   1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index b8407b77aff6..50d82376097c 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -193,35 +193,34 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>   {
>   	struct cxl_port *root_port = arg;
>   	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
>   	struct acpi_pci_root *pci_root;
>   	struct cxl_dport *dport;
>   	struct cxl_port *port;
> +	struct device *bridge;
>   	int rc;
>   
> -	if (!bridge)
> +	if (!hb)
>   		return 0;
>   
> -	dport = cxl_find_dport_by_dev(root_port, match);
> +	pci_root = acpi_pci_find_root(hb->handle);
> +	bridge = pci_root->bus->bridge;
> +	dport = cxl_find_dport_by_dev(root_port, bridge);
>   	if (!dport) {
>   		dev_dbg(host, "host bridge expected and not found\n");
>   		return 0;
>   	}
>   
> -	/*
> -	 * Note that this lookup already succeeded in
> -	 * to_cxl_host_bridge(), so no need to check for failure here
> -	 */
> -	pci_root = acpi_pci_find_root(bridge->handle);
> -	rc = devm_cxl_register_pci_bus(host, match, pci_root->bus);
> +	rc = devm_cxl_register_pci_bus(host, bridge, pci_root->bus);
>   	if (rc)
>   		return rc;
>   
> -	port = devm_cxl_add_port(host, match, dport->component_reg_phys, dport);
> +	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
> +				 dport);
>   	if (IS_ERR(port))
>   		return PTR_ERR(port);
>   
> -	dev_info(pci_root->bus->bridge, "host supports CXL\n");
> +	dev_info(bridge, "host supports CXL\n");
>   
>   	return 0;
>   }
> @@ -253,18 +252,20 @@ static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
>   static int add_host_bridge_dport(struct device *match, void *arg)
>   {
>   	acpi_status status;
> +	struct device *bridge;
>   	unsigned long long uid;
>   	struct cxl_dport *dport;
>   	struct cxl_chbs_context ctx;
> +	struct acpi_pci_root *pci_root;
>   	struct cxl_port *root_port = arg;
>   	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
>   
> -	if (!bridge)
> +	if (!hb)
>   		return 0;
>   
> -	status = acpi_evaluate_integer(bridge->handle, METHOD_NAME__UID, NULL,
> -				       &uid);
> +	status =
> +		acpi_evaluate_integer(hb->handle, METHOD_NAME__UID, NULL, &uid);
>   	if (status != AE_OK) {
>   		dev_err(match, "unable to retrieve _UID\n");
>   		return -ENODEV;
> @@ -285,7 +286,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>   
>   	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
>   
> -	dport = devm_cxl_add_dport(root_port, match, uid, ctx.chbcr);
> +	pci_root = acpi_pci_find_root(hb->handle);
> +	bridge = pci_root->bus->bridge;
> +	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
>   	if (IS_ERR(dport))
>   		return PTR_ERR(dport);
>   
> 
