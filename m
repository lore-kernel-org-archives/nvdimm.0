Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9314C71
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 16:11:24 +0000 (UTC)
Received: from frapeml500006.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNyXW6vm0z687L9;
	Sat,  3 Dec 2022 00:08:11 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 17:11:21 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 16:11:21 +0000
Date: Fri, 2 Dec 2022 16:11:20 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Robert Richter <rrichter@amd.com>,
	<alison.schofield@intel.com>, <terry.bowman@amd.com>, <bhelgaas@google.com>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 07/12] cxl/ACPI: Register CXL host ports by bridge
 device
Message-ID: <20221202161120.00005be9@Huawei.com>
In-Reply-To: <166993043978.1882361.16238060349889579369.stgit@dwillia2-xfh.jf.intel.com>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
	<166993043978.1882361.16238060349889579369.stgit@dwillia2-xfh.jf.intel.com>
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
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 01 Dec 2022 13:33:59 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

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
>  cxlmd->dev.parent->parent
>         ^^^\^^^^^^\ ^^^^^^\
>             \      \       pci_dev (Type 1, Downstream Port)
>              \      pci_dev (Type 0, PCI Express Endpoint)
>               cxl mem device
> 
> RCD mode:
> 
>  cxlmd->dev.parent->parent
>         ^^^\^^^^^^\ ^^^^^^\
>             \      \       pci_host_bridge
>              \      pci_dev (Type 0, RCiEP)
>               cxl mem device
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
Trivial comment inline. Looks fine to me otherwise...

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
>  drivers/cxl/acpi.c |   35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index b8407b77aff6..50d82376097c 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -193,35 +193,34 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  {
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
>  	struct acpi_pci_root *pci_root;
>  	struct cxl_dport *dport;
>  	struct cxl_port *port;
> +	struct device *bridge;
>  	int rc;
>  
> -	if (!bridge)
> +	if (!hb)
>  		return 0;
>  
> -	dport = cxl_find_dport_by_dev(root_port, match);
> +	pci_root = acpi_pci_find_root(hb->handle);
> +	bridge = pci_root->bus->bridge;
> +	dport = cxl_find_dport_by_dev(root_port, bridge);
>  	if (!dport) {
>  		dev_dbg(host, "host bridge expected and not found\n");
>  		return 0;
>  	}
>  
> -	/*
> -	 * Note that this lookup already succeeded in
> -	 * to_cxl_host_bridge(), so no need to check for failure here
> -	 */
> -	pci_root = acpi_pci_find_root(bridge->handle);
> -	rc = devm_cxl_register_pci_bus(host, match, pci_root->bus);
> +	rc = devm_cxl_register_pci_bus(host, bridge, pci_root->bus);
>  	if (rc)
>  		return rc;
>  
> -	port = devm_cxl_add_port(host, match, dport->component_reg_phys, dport);
> +	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
> +				 dport);
>  	if (IS_ERR(port))
>  		return PTR_ERR(port);
>  
> -	dev_info(pci_root->bus->bridge, "host supports CXL\n");
> +	dev_info(bridge, "host supports CXL\n");
>  
>  	return 0;
>  }
> @@ -253,18 +252,20 @@ static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
>  static int add_host_bridge_dport(struct device *match, void *arg)
>  {
>  	acpi_status status;
> +	struct device *bridge;
>  	unsigned long long uid;
>  	struct cxl_dport *dport;
>  	struct cxl_chbs_context ctx;
> +	struct acpi_pci_root *pci_root;
>  	struct cxl_port *root_port = arg;
>  	struct device *host = root_port->dev.parent;
> -	struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> +	struct acpi_device *hb = to_cxl_host_bridge(host, match);
>  
> -	if (!bridge)
> +	if (!hb)
>  		return 0;
>  
> -	status = acpi_evaluate_integer(bridge->handle, METHOD_NAME__UID, NULL,
> -				       &uid);
> +	status =
> +		acpi_evaluate_integer(hb->handle, METHOD_NAME__UID, NULL, &uid);

Bit ugly.  Maybe a good case for a slightly longer line!

>  	if (status != AE_OK) {
>  		dev_err(match, "unable to retrieve _UID\n");
>  		return -ENODEV;
> @@ -285,7 +286,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  
>  	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
>  
> -	dport = devm_cxl_add_dport(root_port, match, uid, ctx.chbcr);
> +	pci_root = acpi_pci_find_root(hb->handle);
> +	bridge = pci_root->bus->bridge;
> +	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
>  	if (IS_ERR(dport))
>  		return PTR_ERR(dport);
>  
> 

