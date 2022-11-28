Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B63C32
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 14:32:21 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ec+Fo8haCd/JlWi/UbKhc/iZyfrE8BNkHeZHLVthqw8h6kt7C8Omn+5bNR3H22ixdwn56bKtNxdHYnCbEk7yXJNDRWiG7fuG+ecRTKV+YlpFA2jm2mxaA5wC6+NFsRBkvCytnn+1SDe/YKkOE8e4vc2VGT6QNZ5lIDG0Imwi7bGjSaLnHOipQd2X/Mx5DraKocksnWzQ5Ij3wJDnRfPQvuuEP/gISSExkCRYjpXfDvcaXr6vtxSSd1kBdAuDtjynF6u1NulPQlqs/9FojcyKr4FeiZnIVaLjo5FXzWLdIxoRVdH2Cu3kvZXd2BTmiOuU3zL3M8yqmVamNem00rvZuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RbhsvV7tFb9g0L1QAWWi70POaLZkUfZD1RoqVzqiw8=;
 b=fq4Uuyfuxe2RICgFCfd2C4i7bk26LmH8CtnsHxyLEXNlMjJhkq68iWnfQMx62rWErdA0zl5bdjZy++ZE64r3KwovJFDddijQj1dywES+Nz1ULTV1cy779cweQlvscW5qd/bioSFkbYybhBYV9+ID0AOJwPt5HdhV7fMdaqD3zzUE4VtHWkRZPEtbtDbZY06ZBAZNa3Q5sY1/X7ewsPHmHEUy055p8F9Rr5gZiZCttnFXc7G5TyzTJuPHU2mq2pBiJ+UrCESDkfSh2A58tOlcPBol7lEP/hrna7V6MuoIlYnxO8zzPtxs40HkHFV+8TtqLPL2KQgEGPqgXUowCdO1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/RbhsvV7tFb9g0L1QAWWi70POaLZkUfZD1RoqVzqiw8=;
 b=nVvVgYGqGV+cTsMTLCjxv6yVNVySJyyeOfhKdq0a6EbQo/Wr3gxY4shP5jB1eeuYO65Y6bv++uNKRgFCgyAq3DlxRULxro5HK1g9e8FZuADa/Wg/03f/5Tfl4D59+I1VUkPoyy2DXcSA4BfQD3xAh5mrAQd+1xZzLUcUtW90Ri8=
Received: from MW4PR04CA0201.namprd04.prod.outlook.com (2603:10b6:303:86::26)
 by CH0PR12MB5299.namprd12.prod.outlook.com (2603:10b6:610:d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 14:32:19 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::14) by MW4PR04CA0201.outlook.office365.com
 (2603:10b6:303:86::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 14:32:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.18 via Frontend Transport; Mon, 28 Nov 2022 14:32:19 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 08:32:12 -0600
Date: Mon, 28 Nov 2022 15:32:09 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <Y4TGabZ4iqtOyTf8@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT013:EE_|CH0PR12MB5299:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b2120e4-0327-4e86-8fc5-08dad14d5ad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wA5bEbdr1DAkFWgyTpvKjGeo7kF8qC/5rkhyYA7qGV1VN/X9iuM+uM+QTA3x3eaA4P9529lrB4DQmndL3aaWRDO7Qsjae8Dl2xtacdOAdD6ZpbVpea9qMGRstlGyujDWWja80dkaRA24xEqwTgEdKregDuj67RJK+sUH2/0erVNyLAGH83qyNNO+rAFD/o2CYW1GDT4pcWUwsKfoTJIkJ+zjYQHZD9b4Wk0HYkTZ9r2cNmLf3ozsKA2sqGyWBjYSXUMMvxp1Esxvqk+F9g198KO1/stge07HCmCEKNCXwxZ8UENk7fBkabSqVbyCStIyWB+CrRrUJkQsbgnSdC2XiK5MYsa4g4MeblyJefidxLg/3xQLO3+2se044QGiQoz7Ss2QjH0zDp8an3rGcIed/m3ApV0RzZ3ds/JuPYTL3Sy1+H3TBPW9vANMwPixiF+93t9ZRlU5jiiz2QjaQUjZ0uGHnaVgd0HUgbOXZkBKlpuhqou5w574GpKv6XWowz/SWqTgAVNkYl14+YYUqoudKHf6Rtz4QrW+/+Mtn4szp6z9SGwTjEd9nX9c8HRQoyc0RDOYve56ZyMsejBEUPqgwi4CvcV2Jt5gggPCeUnwtrtnFQvTr8TCdDIsWgUHMfe7pZxqOORXuxpYAwMn4mjSmknhqyYEifcBVkpvIwUnJfcLnnNUjbCev/+atmma3/vaH2bw3xxsVcU9vI/W/RmG9sDRTmZewGX0Ufbu8s6bafY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(5660300002)(30864003)(47076005)(426003)(40480700001)(55016003)(9686003)(6916009)(54906003)(26005)(316002)(41300700001)(40460700003)(16526019)(186003)(8676002)(70586007)(336012)(4326008)(82310400005)(70206006)(356005)(81166007)(82740400003)(8936002)(2906002)(83380400001)(36860700001)(7696005)(6666004)(478600001)(53546011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 14:32:19.1129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2120e4-0327-4e86-8fc5-08dad14d5ad3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5299

On 24.11.22 10:35:21, Dan Williams wrote:
> From: Robert Richter <rrichter@amd.com>
> 
> A downstream port must be connected to a component register block.
> For restricted hosts the base address is determined from the RCRB. The
> RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> get the RCRB and add code to extract the component register block from
> it.
> 
> RCRB's BAR[0..1] point to the component block containing CXL subsystem
> component registers. MEMBAR extraction follows the PCI base spec here,
> esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> RCRB base address is cached in the cxl_dport per-host bridge so that the
> upstream port component registers can be retrieved later by an RCD
> (RCIEP) associated with the host bridge.
> 
> Note: Right now the component register block is used for HDM decoder
> capability only which is optional for RCDs. If unsupported by the RCD,
> the HDM init will fail. It is future work to bypass it in this case.
> 
> Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Robert Richter <rrichter@amd.com>
> [djbw: introduce devm_cxl_add_rch_dport()]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/acpi.c            |   54 ++++++++++++++++++++++++++++++++--------
>  drivers/cxl/core/port.c       |   42 +++++++++++++++++++++++++++----
>  drivers/cxl/core/regs.c       |   56 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h             |   16 ++++++++++++
>  tools/testing/cxl/Kbuild      |    1 +
>  tools/testing/cxl/test/cxl.c  |   10 +++++++
>  tools/testing/cxl/test/mock.c |   19 ++++++++++++++
>  tools/testing/cxl/test/mock.h |    3 ++
>  8 files changed, 186 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index 50d82376097c..1224add13529 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -9,6 +9,8 @@
>  #include "cxlpci.h"
>  #include "cxl.h"
>  
> +#define CXL_RCRB_SIZE	SZ_8K
> +
>  static unsigned long cfmws_to_decoder_flags(int restrictions)
>  {
>  	unsigned long flags = CXL_DECODER_F_ENABLE;
> @@ -215,6 +217,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  	if (rc)
>  		return rc;
>  
> +	if (dport->rch) {
> +		dev_info(bridge, "host supports CXL (restricted)\n");
> +		return 0;
> +	}

This change comes after devm_cxl_register_pci_bus() to serve the
cxl_port_to_pci_bus() in devm_cxl_port_enumerate_dports() in
cxl_port_probe(). A root port is not probed and
devm_cxl_port_enumerate_dports() will be never called, so we could
jump out before devm_cxl_register_pci_bus().

On the other side we might want to be ready to use
cxl_port_to_pci_bus() elsewhere in later changes. RCHs would not work
then.

> +
>  	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
>  				 dport);
>  	if (IS_ERR(port))
> @@ -228,27 +235,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
>  struct cxl_chbs_context {
>  	struct device *dev;
>  	unsigned long long uid;
> -	resource_size_t chbcr;
> +	struct acpi_cedt_chbs chbs;
>  };
>  
> -static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
> -			 const unsigned long end)
> +static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
> +			const unsigned long end)
>  {
>  	struct cxl_chbs_context *ctx = arg;
>  	struct acpi_cedt_chbs *chbs;
>  
> -	if (ctx->chbcr)
> +	if (ctx->chbs.base)
>  		return 0;
>  
>  	chbs = (struct acpi_cedt_chbs *) header;
>  
>  	if (ctx->uid != chbs->uid)
>  		return 0;
> -	ctx->chbcr = chbs->base;
> +	ctx->chbs = *chbs;
>  
>  	return 0;
>  }
>  
> +static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
> +{
> +	struct acpi_cedt_chbs *chbs = &ctx->chbs;
> +
> +	if (!chbs->base)
> +		return CXL_RESOURCE_NONE;
> +
> +	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
> +		return chbs->base;
> +
> +	if (chbs->length != CXL_RCRB_SIZE)
> +		return CXL_RESOURCE_NONE;
> +
> +	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
> +		&chbs->base);
> +
> +	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
> +}
> +

I have an improved version of this code which squashes cxl_get_chbcr()
into cxl_get_chbs() (basically extends the original cxl_get_chbcr()
function).

>  static int add_host_bridge_dport(struct device *match, void *arg)
>  {
>  	acpi_status status;
> @@ -258,6 +284,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	struct cxl_chbs_context ctx;
>  	struct acpi_pci_root *pci_root;
>  	struct cxl_port *root_port = arg;
> +	resource_size_t component_reg_phys;
>  	struct device *host = root_port->dev.parent;
>  	struct acpi_device *hb = to_cxl_host_bridge(host, match);
>  
> @@ -274,21 +301,28 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	dev_dbg(match, "UID found: %lld\n", uid);
>  
>  	ctx = (struct cxl_chbs_context) {
> -		.dev = host,
> +		.dev = match,
>  		.uid = uid,
>  	};
> -	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> +	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbs, &ctx);
>  
> -	if (ctx.chbcr == 0) {
> +	component_reg_phys = cxl_get_chbcr(&ctx);
> +	if (component_reg_phys == CXL_RESOURCE_NONE) {
>  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
>  		return 0;
>  	}
>  
> -	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
> +	dev_dbg(match, "CHBCR found: %pa\n", &component_reg_phys);
>  
>  	pci_root = acpi_pci_find_root(hb->handle);
>  	bridge = pci_root->bus->bridge;
> -	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
> +	if (ctx.chbs.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
> +		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
> +					       component_reg_phys,
> +					       ctx.chbs.base);

Yes, this new function makes the rcrb handling much more simpler.

> +	else
> +		dport = devm_cxl_add_dport(root_port, bridge, uid,
> +					   component_reg_phys);
>  	if (IS_ERR(dport))
>  		return PTR_ERR(dport);
>  
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index d225267c69bb..d9fe06e1462f 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -628,6 +628,8 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
>  			iter = to_cxl_port(iter->dev.parent);
>  		if (iter->host_bridge)
>  			port->host_bridge = iter->host_bridge;
> +		else if (parent_dport->rch)
> +			port->host_bridge = parent_dport->dport;

Yes, looks good. This makes the endpoint a child of a CXL root port,
not the ACPI0017 the root device.

>  		else
>  			port->host_bridge = iter->uport;
>  		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
> @@ -899,10 +901,15 @@ static void cxl_dport_unlink(void *data)
>  	sysfs_remove_link(&port->dev.kobj, link_name);
>  }
>  
> -static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
> -					      struct device *dport_dev,
> -					      int port_id,
> -					      resource_size_t component_reg_phys)
> +enum cxl_dport_mode {
> +	CXL_DPORT_VH,
> +	CXL_DPORT_RCH,
> +};
> +
> +static struct cxl_dport *
> +__devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
> +		     int port_id, resource_size_t component_reg_phys,
> +		     enum cxl_dport_mode mode, resource_size_t rcrb)
>  {
>  	char link_name[CXL_TARGET_STRLEN];
>  	struct cxl_dport *dport;
> @@ -932,6 +939,9 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
>  	dport->port_id = port_id;
>  	dport->component_reg_phys = component_reg_phys;
>  	dport->port = port;
> +	if (mode == CXL_DPORT_RCH)
> +		dport->rch = true;

Alternatively an inline function could be added which checks
dport->rcrb for a valid address.

> +	dport->rcrb = rcrb;
>  
>  	cond_cxl_root_lock(port);
>  	rc = add_dport(port, dport);
> @@ -973,7 +983,8 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
>  	struct cxl_dport *dport;
>  
>  	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> -				     component_reg_phys);
> +				     component_reg_phys, CXL_DPORT_VH,
> +				     CXL_RESOURCE_NONE);
>  	if (IS_ERR(dport)) {
>  		dev_dbg(dport_dev, "failed to add dport to %s: %ld\n",
>  			dev_name(&port->dev), PTR_ERR(dport));
> @@ -986,6 +997,27 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
>  }
>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
>  
> +struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
> +					 struct device *dport_dev, int port_id,
> +					 resource_size_t component_reg_phys,
> +					 resource_size_t rcrb)

The documentation header is missing for that.

> +{
> +	struct cxl_dport *dport;
> +
> +	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> +				     component_reg_phys, CXL_DPORT_RCH, rcrb);
> +	if (IS_ERR(dport)) {
> +		dev_dbg(dport_dev, "failed to add RCH dport to %s: %ld\n",
> +			dev_name(&port->dev), PTR_ERR(dport));
> +	} else {
> +		dev_dbg(dport_dev, "RCH dport added to %s\n",
> +			dev_name(&port->dev));
> +	}
> +
> +	return dport;
> +}
> +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_rch_dport, CXL);
> +
>  static int add_ep(struct cxl_ep *new)
>  {
>  	struct cxl_port *port = new->dport->port;
> diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> index ec178e69b18f..7c2a85dc4125 100644
> --- a/drivers/cxl/core/regs.c
> +++ b/drivers/cxl/core/regs.c
> @@ -307,3 +307,59 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
>  	return -ENODEV;
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
> +
> +resource_size_t cxl_rcrb_to_component(struct device *dev,
> +				      resource_size_t rcrb,
> +				      enum cxl_rcrb which)
> +{
> +	resource_size_t component_reg_phys;
> +	u32 bar0, bar1;
> +	void *addr;
> +	u16 cmd;
> +
> +	if (which == CXL_RCRB_UPSTREAM)
> +		rcrb += SZ_4K;
> +
> +	/*
> +	 * RCRB's BAR[0..1] point to component block containing CXL
> +	 * subsystem component registers. MEMBAR extraction follows
> +	 * the PCI Base spec here, esp. 64 bit extraction and memory
> +	 * ranges alignment (6.0, 7.5.1.2.1).
> +	 */
> +	if (!request_mem_region(rcrb, SZ_4K, "CXL RCRB"))
> +		return CXL_RESOURCE_NONE;
> +	addr = ioremap(rcrb, SZ_4K);
> +	if (!addr) {
> +		dev_err(dev, "Failed to map region %pr\n", addr);
> +		release_mem_region(rcrb, SZ_4K);
> +		return CXL_RESOURCE_NONE;
> +	}
> +
> +	cmd = readw(addr + PCI_COMMAND);
> +	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> +	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> +	iounmap(addr);
> +	release_mem_region(rcrb, SZ_4K);
> +
> +	/* sanity check */
> +	if (cmd == 0xffff)
> +		return CXL_RESOURCE_NONE;

The spec says offset 0 should be checked (32 bit) which is always
non-FF if implemented. This requires another read.

cmd is most of the cases also non-zero, so probably checking cmd
instead will have the same effect. Still worth changing that.

If the downstream port's rcrb is all FFs, it is a FW bug. Could be
worth a message.

> +	if ((cmd & PCI_COMMAND_MEMORY) == 0)

I like the following more, but that's a flavor:

	if (!(cmd & PCI_COMMAND_MEMORY))

> +		return CXL_RESOURCE_NONE;
> +	if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
> +		return CXL_RESOURCE_NONE;
> +
> +	component_reg_phys = bar0 & PCI_BASE_ADDRESS_MEM_MASK;
> +	if (bar0 & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +		component_reg_phys |= ((u64)bar1) << 32;
> +
> +	if (!component_reg_phys)
> +		return CXL_RESOURCE_NONE;
> +
> +	/* MEMBAR is block size (64k) aligned. */
> +	if (!IS_ALIGNED(component_reg_phys, CXL_COMPONENT_REG_BLOCK_SIZE))
> +		return CXL_RESOURCE_NONE;
> +
> +	return component_reg_phys;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_rcrb_to_component, CXL);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 9b33ae4b2aec..43c43d1ec069 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -223,6 +223,14 @@ enum cxl_regloc_type;
>  int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
>  		      struct cxl_register_map *map);
>  
> +enum cxl_rcrb {
> +	CXL_RCRB_DOWNSTREAM,
> +	CXL_RCRB_UPSTREAM,
> +};
> +resource_size_t cxl_rcrb_to_component(struct device *dev,
> +				      resource_size_t rcrb,
> +				      enum cxl_rcrb which);
> +
>  #define CXL_RESOURCE_NONE ((resource_size_t) -1)
>  #define CXL_TARGET_STRLEN 20
>  
> @@ -486,12 +494,16 @@ cxl_find_dport_by_dev(struct cxl_port *port, const struct device *dport_dev)
>   * @dport: PCI bridge or firmware device representing the downstream link
>   * @port_id: unique hardware identifier for dport in decoder target list
>   * @component_reg_phys: downstream port component registers
> + * @rcrb: base address for the Root Complex Register Block
> + * @rch: Indicate whether this dport was enumerated in RCH or VH mode
>   * @port: reference to cxl_port that contains this downstream port
>   */
>  struct cxl_dport {
>  	struct device *dport;
>  	int port_id;
>  	resource_size_t component_reg_phys;
> +	resource_size_t rcrb;
> +	bool rch;
>  	struct cxl_port *port;
>  };
>  
> @@ -561,6 +573,10 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd);
>  struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
>  				     struct device *dport, int port_id,
>  				     resource_size_t component_reg_phys);
> +struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
> +					 struct device *dport_dev, int port_id,
> +					 resource_size_t component_reg_phys,
> +					 resource_size_t rcrb);
>  
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
>  struct cxl_root_decoder *to_cxl_root_decoder(struct device *dev);
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 500be85729cc..9e4d94e81723 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -10,6 +10,7 @@ ldflags-y += --wrap=devm_cxl_add_passthrough_decoder
>  ldflags-y += --wrap=devm_cxl_enumerate_decoders
>  ldflags-y += --wrap=cxl_await_media_ready
>  ldflags-y += --wrap=cxl_hdm_decode_init
> +ldflags-y += --wrap=cxl_rcrb_to_component
>  
>  DRIVERS := ../../../drivers
>  CXL_SRC := $(DRIVERS)/cxl
> diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
> index 42a34650dd2f..1823c61d7ba3 100644
> --- a/tools/testing/cxl/test/cxl.c
> +++ b/tools/testing/cxl/test/cxl.c
> @@ -694,6 +694,15 @@ static int mock_cxl_port_enumerate_dports(struct cxl_port *port)
>  	return 0;
>  }
>  
> +resource_size_t mock_cxl_rcrb_to_component(struct device *dev,
> +					   resource_size_t rcrb,
> +					   enum cxl_rcrb which)
> +{
> +	dev_dbg(dev, "rcrb: %pa which: %d\n", &rcrb, which);
> +
> +	return 0;
> +}
> +
>  static struct cxl_mock_ops cxl_mock_ops = {
>  	.is_mock_adev = is_mock_adev,
>  	.is_mock_bridge = is_mock_bridge,
> @@ -702,6 +711,7 @@ static struct cxl_mock_ops cxl_mock_ops = {
>  	.is_mock_dev = is_mock_dev,
>  	.acpi_table_parse_cedt = mock_acpi_table_parse_cedt,
>  	.acpi_evaluate_integer = mock_acpi_evaluate_integer,
> +	.cxl_rcrb_to_component = mock_cxl_rcrb_to_component,
>  	.acpi_pci_find_root = mock_acpi_pci_find_root,
>  	.devm_cxl_port_enumerate_dports = mock_cxl_port_enumerate_dports,
>  	.devm_cxl_setup_hdm = mock_cxl_setup_hdm,
> diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
> index bce6a21df0d5..5dface08e0de 100644
> --- a/tools/testing/cxl/test/mock.c
> +++ b/tools/testing/cxl/test/mock.c
> @@ -224,6 +224,25 @@ int __wrap_cxl_hdm_decode_init(struct cxl_dev_state *cxlds,
>  }
>  EXPORT_SYMBOL_NS_GPL(__wrap_cxl_hdm_decode_init, CXL);
>  
> +resource_size_t __wrap_cxl_rcrb_to_component(struct device *dev,
> +					     resource_size_t rcrb,
> +					     enum cxl_rcrb which)
> +{
> +	int index;
> +	resource_size_t component_reg_phys;
> +	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
> +
> +	if (ops && ops->is_mock_port(dev))
> +		component_reg_phys =
> +			ops->cxl_rcrb_to_component(dev, rcrb, which);
> +	else
> +		component_reg_phys = cxl_rcrb_to_component(dev, rcrb, which);
> +	put_cxl_mock_ops(index);
> +
> +	return component_reg_phys;
> +}
> +EXPORT_SYMBOL_NS_GPL(__wrap_cxl_rcrb_to_component, CXL);
> +
>  MODULE_LICENSE("GPL v2");
>  MODULE_IMPORT_NS(ACPI);
>  MODULE_IMPORT_NS(CXL);
> diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
> index 738f24e3988a..ef33f159375e 100644
> --- a/tools/testing/cxl/test/mock.h
> +++ b/tools/testing/cxl/test/mock.h
> @@ -15,6 +15,9 @@ struct cxl_mock_ops {
>  					     acpi_string pathname,
>  					     struct acpi_object_list *arguments,
>  					     unsigned long long *data);
> +	resource_size_t (*cxl_rcrb_to_component)(struct device *dev,
> +						 resource_size_t rcrb,
> +						 enum cxl_rcrb which);
>  	struct acpi_pci_root *(*acpi_pci_find_root)(acpi_handle handle);
>  	bool (*is_mock_bus)(struct pci_bus *bus);
>  	bool (*is_mock_port)(struct device *dev);
> 

The mock part looks good to me.

-Robert
