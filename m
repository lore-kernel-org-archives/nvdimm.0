Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B04AD27
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 23:06:39 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B71TFiwcV3Jrk0G6KJeOA1DyqrTgo5i5rXnWfiajbf5al39adTrRByne96TY/CIvp1x+S8l7jWHF+ei0gvDDKnP6AOO/mXmXe4mNJch5mAiYWWcCxVQa/SNg9R0brWYld/Q3D5LGrWroxdW2+9f+3Lg7HZUwBW9tHLfrUuE2Yty9cnwvFh9FNC7yNQsaMZCvcH7ucCvgTOhtQjoiStOKNUDgyoSIoMEVWYM+omhD/2F0zNGIGf7ANl844tNLjly85CUMnaN5NHffiydkLmf+414FCOIsInfRsm3OJ5faUVtfAVqE5vPZ9ivQDOt4z82eHm39a3CKTUAqPMOtLpMgbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FI13s4lEZxn+RhjfetFvW3uwr3wNUSfzh49867NKQok=;
 b=GpFvna6wu4+QYReDsSDxLSo2DjdwjIrrEx+jjMIGgScBpKr4OI5EqEpne4ZdJAXNTc4UedjdPyTt7275bwFCXNe33rk5EHiK7L9vJme9X0AYqJfy1FvyYafsVVUNeMqSRnT59dAHTT2GNwswVNobkZu7ZZhBJUommCdqXM9hQH8GNzZM6T0Ff7jePK/nra5m119fgamI/kbPxyP/0QjJFCi2LwgE4rieeuVliEKdQ4A5F10x8nU4aVAab1eC++M5zY5Ao/1KIJB2GW/vsmmrDDww0FOBaHZ/KFuDAWpBbuDz+HetCkwYGcZL/SqXK+eEkdhUTjHNHi1DOfp+Z1rqLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FI13s4lEZxn+RhjfetFvW3uwr3wNUSfzh49867NKQok=;
 b=eedKiiFSixkjFTK9/nYwQsVDhKnvYkR8CMJcMqzR/2KNg2PmDGc0OQUQphLTjrUpmdNyLNxOrh5UndjDTUCgnm3cW0XiX2wCSbO6M3yiB1eAol+oc31Eo9GxGrw0f0zBxWW288r7u09JoHjWRPJo2BEv/e4sScRVEqVTToYrwxo=
Received: from DM6PR08CA0031.namprd08.prod.outlook.com (2603:10b6:5:80::44) by
 CH0PR12MB5386.namprd12.prod.outlook.com (2603:10b6:610:d5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 23:06:36 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::13) by DM6PR08CA0031.outlook.office365.com
 (2603:10b6:5:80::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22 via Frontend
 Transport; Mon, 28 Nov 2022 23:06:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Mon, 28 Nov 2022 23:06:35 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 17:06:33 -0600
Date: Tue, 29 Nov 2022 00:06:31 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <Y4U+92BzA+O7fjNE@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|CH0PR12MB5386:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c39d599-08d8-4226-97f1-08dad19532cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tPZU4cM0R6OuQbt3SHJm88VyYLfoGCGWGw5+5IlTsWqbCx8Af6WY3BZOMbZ/8QfKu+ICbLCT+iOBZNmUt0Ldk4g/9Awv4CmsEOiwEdBQ+E53OlO6Nnd1ngkWZ7+ukJW7dapKE53fEVhsHHoIfqtrE86cXOihYb+yaZL8+adzvOkdRTwMIRubAiA8ZSWqGQ/BEz0jpDffVudBTWlO0tOpo+7oQgeTHsvywE5MMydNGiNDRWDJwA+o6Gy5Z/Ltf82FFCeYbN3Y6JBIZCFY8yxfChJ8pUkc380UgU5EZ1KKqS5NSaXuaaa8nndQJgGRVJqCON/jTxd6e5kPvbj4ZKUPXiP8iogAmKvhwtYsn0u2PtMmOY3w3+IDbsY58xiEn9znqSZkZAdZgn0h53vL7hvnV4ATHXwUwc2lsr/7uyR6YPMO3MH1/J92rM5+TJb0PfSN4BuR1ri+tkxsC4ClP19GItR0wrS+INKhkoBmjMjKYcEKCkfyBu+OIgCN9YltSV+DZe0bU0EjbmGAm2B3jfxjWvVcwr1OcyduSQ+QGX5ro1GfS0EXMQH9djKy2cgCC7huqkL9KMtlrhD5vffPFYyOHYp1nWrNnJkHQozAXV+c9wnywjyn65YkZQtaubKqThh1eTBsIFCbWF8GCYKiwsVumtO3Jt0oL2gWp2FM2NJr4P6QO62IJvvEleQsx2y0qSREhuD5jXJZHfNFbvDlfUFyMRWzUqHZmV0Yn0yx9AxYxSk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(426003)(47076005)(83380400001)(336012)(54906003)(9686003)(7696005)(81166007)(356005)(55016003)(40480700001)(26005)(82740400003)(82310400005)(16526019)(40460700003)(36860700001)(186003)(41300700001)(8936002)(478600001)(5660300002)(53546011)(6916009)(4326008)(2906002)(316002)(70586007)(8676002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:06:35.8166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c39d599-08d8-4226-97f1-08dad19532cc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5386

On 24.11.22 10:35:32, Dan Williams wrote:
> Unlike a CXL memory expander in a VH topology that has at least one
> intervening 'struct cxl_port' instance between itself and the CXL root
> device, an RCD attaches one-level higher. For example:
> 
>                VH
>           ┌──────────┐
>           │ ACPI0017 │
>           │  root0   │
>           └─────┬────┘
>                 │
>           ┌─────┴────┐
>           │  dport0  │
>     ┌─────┤ ACPI0016 ├─────┐
>     │     │  port1   │     │
>     │     └────┬─────┘     │
>     │          │           │
>  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
>  │dport0│   │dport1│   │dport2│
>  │ RP0  │   │ RP1  │   │ RP2  │
>  └──────┘   └──┬───┘   └──────┘
>                │
>            ┌───┴─────┐
>            │endpoint0│
>            │  port2  │
>            └─────────┘
> 
> ...vs:
> 
>               RCH
>           ┌──────────┐
>           │ ACPI0017 │
>           │  root0   │
>           └────┬─────┘
>                │
>            ┌───┴────┐
>            │ dport0 │
>            │ACPI0016│
>            └───┬────┘
>                │
>           ┌────┴─────┐
>           │endpoint0 │
>           │  port1   │
>           └──────────┘
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
>  drivers/cxl/core/port.c |   11 +++++++++--
>  drivers/cxl/cxlmem.h    |    2 ++
>  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
>  drivers/cxl/pci.c       |   10 ++++++++++
>  4 files changed, 45 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index c7f58282b2c1..2385ee00eb9a 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
>  {
>  	struct device *dev = &cxlmd->dev;
>  	struct device *iter;
> +	struct cxl_dport *dport;
> +	struct cxl_port *port;

There is no direct need to move that code here.

If you want to clean that up in this patch too, then leave a comment
in the change log?

>  	int rc;
>  
> +	/*
> +	 * Skip intermediate port enumeration in the RCH case, there
> +	 * are no ports in between a host bridge and an endpoint.
> +	 */
> +	if (cxlmd->cxlds->rcd)
> +		return 0;
> +
>  	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
>  	if (rc)
>  		return rc;
> @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
>  	for (iter = dev; iter; iter = grandparent(iter)) {
>  		struct device *dport_dev = grandparent(iter);
>  		struct device *uport_dev;
> -		struct cxl_dport *dport;
> -		struct cxl_port *port;
>  
>  		if (!dport_dev)
>  			return 0;
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index e082991bc58c..35d485d041f0 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
>   * @dev: The device associated with this CXL state
>   * @regs: Parsed register blocks
>   * @cxl_dvsec: Offset to the PCIe device DVSEC
> + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
>   * @payload_size: Size of space for payload
>   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
>   * @lsa_size: Size of Label Storage Area
> @@ -235,6 +236,7 @@ struct cxl_dev_state {
>  	struct cxl_regs regs;
>  	int cxl_dvsec;
>  
> +	bool rcd;
>  	size_t payload_size;
>  	size_t lsa_size;
>  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index aa63ce8c7ca6..9a655b4b5e52 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
>  	return 0;
>  }
>  
> -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
>  				 struct cxl_dport *parent_dport)
>  {
>  	struct cxl_port *parent_port = parent_dport->port;
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  	struct cxl_port *endpoint, *iter, *down;
> +	resource_size_t component_reg_phys;
>  	int rc;
>  
>  	/*
> @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
>  		ep->next = down;
>  	}
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

As already commented: this must be the upstream RCRB here.

> +	else
> +		component_reg_phys = cxlds->component_reg_phys;
> +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> +				     parent_dport);

Looking at CXL 3.0 spec, table 8-22, there are the various sources of
component registers listed. For RCD we need: D1, DP1, UP1 (optional
R).

	D1:	endpoint->component_reg_phys;
	UP1:	parent_port-component_reg_phys; (missing in RCH topology)
	DP1:	parent_dport->component_reg_phys;

I don't see how all of them could be stored in this data layout as the
cxl host port is missing.

>  	if (IS_ERR(endpoint))
>  		return PTR_ERR(endpoint);
>  
> @@ -87,6 +98,7 @@ static int cxl_mem_probe(struct device *dev)
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	struct device *endpoint_parent;
>  	struct cxl_port *parent_port;
>  	struct cxl_dport *dport;
>  	struct dentry *dentry;
> @@ -119,17 +131,22 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
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
>  		dev_err(dev, "CXL port topology %s not enabled\n",
>  			dev_name(&parent_port->dev));
>  		rc = -ENXIO;
>  		goto unlock;
>  	}
>  
> -	rc = devm_cxl_add_endpoint(cxlmd, dport);
> +	rc = devm_cxl_add_endpoint(endpoint_parent, cxlmd, dport);
>  unlock:
> -	device_unlock(&parent_port->dev);
> +	device_unlock(endpoint_parent);
>  	put_device(&parent_port->dev);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e15da405b948..73ff6c33a0c0 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -433,6 +433,15 @@ static void devm_cxl_pci_create_doe(struct cxl_dev_state *cxlds)
>  	}
>  }
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
>  static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct cxl_register_map map;
> @@ -455,6 +464,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (IS_ERR(cxlds))
>  		return PTR_ERR(cxlds);
>  
> +	cxlds->rcd = is_cxl_restricted(pdev);
>  	cxlds->serial = pci_get_dsn(pdev);
>  	cxlds->cxl_dvsec = pci_find_dvsec_capability(
>  		pdev, PCI_DVSEC_VENDOR_ID_CXL, CXL_DVSEC_PCIE_DEVICE);
> 
