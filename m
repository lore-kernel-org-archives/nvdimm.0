Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF411AD27
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 22:56:46 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUgwPYD5jwclffTKDDg7c5UYZmOL7UsbGcRN9fJIENefVgVA6Qn3fOf8EhCXipe+hCy/5IfgafQAUEVVAUYlODMbXW29RZrDGUTq1HaN18UGZOsNzIbqKxscFtp+IdwzQykSQc4Vkf3R/jtomVmyP4J/W17BDq4TmpLYZ8XiHucstGn2bFvJpDZvyUblTgtdTboSDD83vvf3jlpKYSN09lDNWLw+rqbOGnZYh33XkTkrS6GvXvyJcDxY8QyppKhQEp6qiTyxhH5sjXp66Yef+ZT+WzqTqVPTnJcDdpEsYY1PlFm+ViVkl5mDlGHd0I4Jc1FATkGlKBSTHxfFUm+sxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PB6mbINCUL56sBmm7jKgWhjhTvxGFWM+u3dyoFiH8OA=;
 b=MyxRNGH19fvpFTFO6+r7pp4W5AB5q2AoN2hTLV2aze3pKL/NTKWFMKooDD3qDOEx9/ssDjvgton1RHBXBGT+x04YbFPjnALzC37Xpd+z18rpGo12+Su8UBwrrV4Lz6w2OZRIUnt+dxy2eW0J7n0xfSbj3AomxjI2EfaVeWB/qIOE42oYmdpN24Au+yRmhoOTeTZMd6AEq5zU5VOTdsH1lNouG6SKXsAvf9hjvP3fI4jHD2h7xd8fE5u8Ip/wm4cfs2PKvSSFxa7erEbrXSrpCjtpMqdOQBX0g9ttniwWzCHk6hv6QelK0MIEeXZRHpbYHt7Q/HGMXkurOf21RwEq5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PB6mbINCUL56sBmm7jKgWhjhTvxGFWM+u3dyoFiH8OA=;
 b=htRS2SEYUEJpJlbkdIO7vUUwtYpSPk6Rgs9TEI+4j9WFg6uzPUJVBB2l8hrk8Hwwqa4wZNTMNgQG7lX2dEGfGSQi1G7GvA20l6tVHD/gurUBzMBJDI0x9zKh0dvoCZ9UY3j0m3q+7qaKKNUx5PcBbLirrXJOv0reyOEQ1IfhvjI=
Received: from MW4PR03CA0207.namprd03.prod.outlook.com (2603:10b6:303:b8::32)
 by DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 22:56:44 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::4c) by MW4PR03CA0207.outlook.office365.com
 (2603:10b6:303:b8::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 22:56:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Mon, 28 Nov 2022 22:56:43 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 16:56:41 -0600
Date: Mon, 28 Nov 2022 23:56:38 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <Y4U8pqjNtjuaJLqU@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492162.2104015.17972281946627197765.stgit@dwillia2-xfh.jf.intel.com>
 <Y4TGabZ4iqtOyTf8@rric.localdomain>
 <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63852f1fdfadc_3cbe02947b@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|DM4PR12MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: b639cacb-ce02-4786-713e-08dad193d1c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	faB9ehGtx7wNWBMEYP0u+Z229ci90eHuyKnx1S7SahaqemMSBH1eFrdXMdtKuhCT9Nrh1WieYkcVIwJ67gT8gtBY6vKMYIGr9PqqTPncEE8EHd+JXar7yqyM/eN0ryVwMuu4VuXUuNNbh3k9kXx2cGmfSFSsNYCad/tL9fnXHtYlh8ixGxH7RECqQFAtgzrcY2gG7bPjQ3vtW8sQFM+Orckh5Llwp4KnFJzQQj7vmK+AorUirXKYieuymc9/oQlaxXXy+nWt6RIRYvtqpWNaEe9afygD9n42bhFTnL5QdoZ6aopxqZU4leg39bmZ6lLREDps8ZgIjinfBCJxgf41LMKn3yfVo33wzvYfwXisHl4qwrOf66SerHnToY8PCIGMCwtuSAOzj10xuopWJHoG2+elH3YggYUbg4PZdhT6C/G2t+rrDSWsenkWvZ+6CCXCrF37WutMO4wqjdynaDSFiLDSSbDLneL/OPpAKeu6qZn30GwyZy+5YAiISKVHobrGYuq48HX3AZxRLMEIQYTTxyotQX50WUOU1FGNYoM07ioO0fNWEYNhl0X8pa9n1K2gEpIFzIgyQxBVvXscSz0gtwxRoMR+bnMieeS14bjrbqmdWRHbnvvDF/Sr0KXFseLCDqptNWu3Z4nfubbGdGdl7TlT6JUcisTSU+EB+7CkWzlCxs4HdDjqKFRfnXHowhVM8KcctfV0P+5lNMeostt7DzmcJ2+ZwGH627la12vRZWE=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(70586007)(40480700001)(6666004)(53546011)(55016003)(7696005)(186003)(41300700001)(70206006)(82310400005)(54906003)(40460700003)(316002)(356005)(336012)(81166007)(8676002)(26005)(82740400003)(8936002)(9686003)(4326008)(16526019)(5660300002)(30864003)(478600001)(83380400001)(2906002)(6916009)(426003)(47076005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 22:56:43.4756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b639cacb-ce02-4786-713e-08dad193d1c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769

On 28.11.22 13:58:55, Dan Williams wrote:
> Robert Richter wrote:
> > On 24.11.22 10:35:21, Dan Williams wrote:
> > > From: Robert Richter <rrichter@amd.com>
> > > 
> > > A downstream port must be connected to a component register block.
> > > For restricted hosts the base address is determined from the RCRB. The
> > > RCRB is provided by the host's CEDT CHBS entry. Rework CEDT parser to
> > > get the RCRB and add code to extract the component register block from
> > > it.
> > > 
> > > RCRB's BAR[0..1] point to the component block containing CXL subsystem
> > > component registers. MEMBAR extraction follows the PCI base spec here,
> > > esp. 64 bit extraction and memory range alignment (6.0, 7.5.1.2.1). The
> > > RCRB base address is cached in the cxl_dport per-host bridge so that the
> > > upstream port component registers can be retrieved later by an RCD
> > > (RCIEP) associated with the host bridge.
> > > 
> > > Note: Right now the component register block is used for HDM decoder
> > > capability only which is optional for RCDs. If unsupported by the RCD,
> > > the HDM init will fail. It is future work to bypass it in this case.
> > > 
> > > Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> > > Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> > > Signed-off-by: Robert Richter <rrichter@amd.com>
> > > [djbw: introduce devm_cxl_add_rch_dport()]
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  drivers/cxl/acpi.c            |   54 ++++++++++++++++++++++++++++++++--------
> > >  drivers/cxl/core/port.c       |   42 +++++++++++++++++++++++++++----
> > >  drivers/cxl/core/regs.c       |   56 +++++++++++++++++++++++++++++++++++++++++
> > >  drivers/cxl/cxl.h             |   16 ++++++++++++
> > >  tools/testing/cxl/Kbuild      |    1 +
> > >  tools/testing/cxl/test/cxl.c  |   10 +++++++
> > >  tools/testing/cxl/test/mock.c |   19 ++++++++++++++
> > >  tools/testing/cxl/test/mock.h |    3 ++
> > >  8 files changed, 186 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > > index 50d82376097c..1224add13529 100644
> > > --- a/drivers/cxl/acpi.c
> > > +++ b/drivers/cxl/acpi.c
> > > @@ -9,6 +9,8 @@
> > >  #include "cxlpci.h"
> > >  #include "cxl.h"
> > >  
> > > +#define CXL_RCRB_SIZE	SZ_8K
> > > +
> > >  static unsigned long cfmws_to_decoder_flags(int restrictions)
> > >  {
> > >  	unsigned long flags = CXL_DECODER_F_ENABLE;
> > > @@ -215,6 +217,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > >  	if (rc)
> > >  		return rc;
> > >  
> > > +	if (dport->rch) {
> > > +		dev_info(bridge, "host supports CXL (restricted)\n");
> > > +		return 0;
> > > +	}
> > 
> > This change comes after devm_cxl_register_pci_bus() to serve the
> > cxl_port_to_pci_bus() in devm_cxl_port_enumerate_dports() in
> > cxl_port_probe(). A root port is not probed and
> > devm_cxl_port_enumerate_dports() will be never called, so we could
> > jump out before devm_cxl_register_pci_bus().
> 
> Good point.
> 
> > On the other side we might want to be ready to use
> > cxl_port_to_pci_bus() elsewhere in later changes. RCHs would not work
> > then.
> 
> At least cxl_port_to_pci_bus() as is will work fine for the RCD
> endpoint-cxl-port, so I think it is ok to leave this alone for now.

Yes, should work as is.

> 
> > 
> > > +
> > >  	port = devm_cxl_add_port(host, bridge, dport->component_reg_phys,
> > >  				 dport);
> > >  	if (IS_ERR(port))
> > > @@ -228,27 +235,46 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > >  struct cxl_chbs_context {
> > >  	struct device *dev;
> > >  	unsigned long long uid;
> > > -	resource_size_t chbcr;
> > > +	struct acpi_cedt_chbs chbs;
> > >  };
> > >  
> > > -static int cxl_get_chbcr(union acpi_subtable_headers *header, void *arg,
> > > -			 const unsigned long end)
> > > +static int cxl_get_chbs(union acpi_subtable_headers *header, void *arg,
> > > +			const unsigned long end)
> > >  {
> > >  	struct cxl_chbs_context *ctx = arg;
> > >  	struct acpi_cedt_chbs *chbs;
> > >  
> > > -	if (ctx->chbcr)
> > > +	if (ctx->chbs.base)
> > >  		return 0;
> > >  
> > >  	chbs = (struct acpi_cedt_chbs *) header;
> > >  
> > >  	if (ctx->uid != chbs->uid)
> > >  		return 0;
> > > -	ctx->chbcr = chbs->base;
> > > +	ctx->chbs = *chbs;
> > >  
> > >  	return 0;
> > >  }
> > >  
> > > +static resource_size_t cxl_get_chbcr(struct cxl_chbs_context *ctx)
> > > +{
> > > +	struct acpi_cedt_chbs *chbs = &ctx->chbs;
> > > +
> > > +	if (!chbs->base)
> > > +		return CXL_RESOURCE_NONE;
> > > +
> > > +	if (chbs->cxl_version != ACPI_CEDT_CHBS_VERSION_CXL11)
> > > +		return chbs->base;
> > > +
> > > +	if (chbs->length != CXL_RCRB_SIZE)
> > > +		return CXL_RESOURCE_NONE;
> > > +
> > > +	dev_dbg(ctx->dev, "RCRB found for UID %lld: %pa\n", ctx->uid,
> > > +		&chbs->base);
> > > +
> > > +	return cxl_rcrb_to_component(ctx->dev, chbs->base, CXL_RCRB_DOWNSTREAM);
> > > +}
> > > +
> > 
> > I have an improved version of this code which squashes cxl_get_chbcr()
> > into cxl_get_chbs() (basically extends the original cxl_get_chbcr()
> > function).
> 
> Care to send it? If I see it before the next posting I can fold it in,
> otherwise it can be a follow-on cleanup.

Yes, will try to send tomorrow. Need to rework, still doing some
testing.

> 
> > 
> > >  static int add_host_bridge_dport(struct device *match, void *arg)
> > >  {
> > >  	acpi_status status;
> > > @@ -258,6 +284,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > >  	struct cxl_chbs_context ctx;
> > >  	struct acpi_pci_root *pci_root;
> > >  	struct cxl_port *root_port = arg;
> > > +	resource_size_t component_reg_phys;
> > >  	struct device *host = root_port->dev.parent;
> > >  	struct acpi_device *hb = to_cxl_host_bridge(host, match);
> > >  
> > > @@ -274,21 +301,28 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > >  	dev_dbg(match, "UID found: %lld\n", uid);
> > >  
> > >  	ctx = (struct cxl_chbs_context) {
> > > -		.dev = host,
> > > +		.dev = match,
> > >  		.uid = uid,
> > >  	};
> > > -	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> > > +	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbs, &ctx);
> > >  
> > > -	if (ctx.chbcr == 0) {
> > > +	component_reg_phys = cxl_get_chbcr(&ctx);
> > > +	if (component_reg_phys == CXL_RESOURCE_NONE) {
> > >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > >  		return 0;
> > >  	}
> > >  
> > > -	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
> > > +	dev_dbg(match, "CHBCR found: %pa\n", &component_reg_phys);
> > >  
> > >  	pci_root = acpi_pci_find_root(hb->handle);
> > >  	bridge = pci_root->bus->bridge;
> > > -	dport = devm_cxl_add_dport(root_port, bridge, uid, ctx.chbcr);
> > > +	if (ctx.chbs.cxl_version == ACPI_CEDT_CHBS_VERSION_CXL11)
> > > +		dport = devm_cxl_add_rch_dport(root_port, bridge, uid,
> > > +					       component_reg_phys,
> > > +					       ctx.chbs.base);
> > 
> > Yes, this new function makes the rcrb handling much more simpler.
> > 
> > > +	else
> > > +		dport = devm_cxl_add_dport(root_port, bridge, uid,
> > > +					   component_reg_phys);
> > >  	if (IS_ERR(dport))
> > >  		return PTR_ERR(dport);
> > >  
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index d225267c69bb..d9fe06e1462f 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -628,6 +628,8 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
> > >  			iter = to_cxl_port(iter->dev.parent);
> > >  		if (iter->host_bridge)
> > >  			port->host_bridge = iter->host_bridge;
> > > +		else if (parent_dport->rch)
> > > +			port->host_bridge = parent_dport->dport;
> > 
> > Yes, looks good. This makes the endpoint a child of a CXL root port,
> > not the ACPI0017 the root device.
> > 
> > >  		else
> > >  			port->host_bridge = iter->uport;
> > >  		dev_dbg(uport, "host-bridge: %s\n", dev_name(port->host_bridge));
> > > @@ -899,10 +901,15 @@ static void cxl_dport_unlink(void *data)
> > >  	sysfs_remove_link(&port->dev.kobj, link_name);
> > >  }
> > >  
> > > -static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
> > > -					      struct device *dport_dev,
> > > -					      int port_id,
> > > -					      resource_size_t component_reg_phys)
> > > +enum cxl_dport_mode {
> > > +	CXL_DPORT_VH,
> > > +	CXL_DPORT_RCH,
> > > +};
> > > +
> > > +static struct cxl_dport *
> > > +__devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
> > > +		     int port_id, resource_size_t component_reg_phys,
> > > +		     enum cxl_dport_mode mode, resource_size_t rcrb)
> > >  {
> > >  	char link_name[CXL_TARGET_STRLEN];
> > >  	struct cxl_dport *dport;
> > > @@ -932,6 +939,9 @@ static struct cxl_dport *__devm_cxl_add_dport(struct cxl_port *port,
> > >  	dport->port_id = port_id;
> > >  	dport->component_reg_phys = component_reg_phys;
> > >  	dport->port = port;
> > > +	if (mode == CXL_DPORT_RCH)
> > > +		dport->rch = true;
> > 
> > Alternatively an inline function could be added which checks
> > dport->rcrb for a valid address.
> 
> I like it. Especially because a valid RCRB is needed to register the
> dport in the first instance. I think it looks ok without an inline
> function:
> 
> @@ -901,15 +901,10 @@ static void cxl_dport_unlink(void *data)
>         sysfs_remove_link(&port->dev.kobj, link_name);
>  }
>  
> -enum cxl_dport_mode {
> -       CXL_DPORT_VH,
> -       CXL_DPORT_RCH,
> -};
> -
>  static struct cxl_dport *
>  __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
>                      int port_id, resource_size_t component_reg_phys,
> -                    enum cxl_dport_mode mode, resource_size_t rcrb)
> +                    resource_size_t rcrb)
>  {
>         char link_name[CXL_TARGET_STRLEN];
>         struct cxl_dport *dport;
> @@ -939,7 +934,7 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
>         dport->port_id = port_id;
>         dport->component_reg_phys = component_reg_phys;
>         dport->port = port;
> -       if (mode == CXL_DPORT_RCH)
> +       if (rcrb != CXL_RESOURCE_NONE)
>                 dport->rch = true;
>         dport->rcrb = rcrb;

Change looks good.

I was even thinking to even use ->rcrb to check for rch:

static inline bool is_rch(struct cxl_dport *dport)
{
	return (dport->rcrb != CXL_RESOURCE_NONE);
}

But "if (dport->rch) ..." looks nice too, esp. with its counterpart
cxlds->rcd.

>  
> 
> > 
> > > +	dport->rcrb = rcrb;
> > >  
> > >  	cond_cxl_root_lock(port);
> > >  	rc = add_dport(port, dport);
> > > @@ -973,7 +983,8 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
> > >  	struct cxl_dport *dport;
> > >  
> > >  	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> > > -				     component_reg_phys);
> > > +				     component_reg_phys, CXL_DPORT_VH,
> > > +				     CXL_RESOURCE_NONE);
> > >  	if (IS_ERR(dport)) {
> > >  		dev_dbg(dport_dev, "failed to add dport to %s: %ld\n",
> > >  			dev_name(&port->dev), PTR_ERR(dport));
> > > @@ -986,6 +997,27 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
> > >  
> > > +struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
> > > +					 struct device *dport_dev, int port_id,
> > > +					 resource_size_t component_reg_phys,
> > > +					 resource_size_t rcrb)
> > 
> > The documentation header is missing for that.
> 
> Added the following and clarified that @rcrb is mandatory:
> 
> @@ -966,7 +961,7 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
>  }
>  
>  /**
> - * devm_cxl_add_dport - append downstream port data to a cxl_port
> + * devm_cxl_add_dport - append VH downstream port data to a cxl_port
>   * @port: the cxl_port that references this dport
>   * @dport_dev: firmware or PCI device representing the dport
>   * @port_id: identifier for this dport in a decoder's target list
> @@ -997,6 +991,16 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
>  }
>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_dport, CXL);
>  
> +/**
> + * devm_cxl_add_rch_dport - append RCH downstream port data to a cxl_port
> + * @port: the cxl_port that references this dport
> + * @dport_dev: firmware or PCI device representing the dport
> + * @port_id: identifier for this dport in a decoder's target list
> + * @component_reg_phys: optional location of CXL component registers
> + * @rcrb: mandatory location of a Root Complex Register Block
> + *
> + * See CXL 3.0 9.11.8 CXL Devices Attached to an RCH
> + */

Looks good. The component_reg_phys arg could be used for Register
Locator DVSEC in case of a VH device layout (9.11.8).

>  struct cxl_dport *devm_cxl_add_rch_dport(struct cxl_port *port,
>                                          struct device *dport_dev, int port_id,
>                                          resource_size_t component_reg_phys,
> 
> > 
> > > +{
> > > +	struct cxl_dport *dport;
> > > +
> > > +	dport = __devm_cxl_add_dport(port, dport_dev, port_id,
> > > +				     component_reg_phys, CXL_DPORT_RCH, rcrb);
> > > +	if (IS_ERR(dport)) {
> > > +		dev_dbg(dport_dev, "failed to add RCH dport to %s: %ld\n",
> > > +			dev_name(&port->dev), PTR_ERR(dport));
> > > +	} else {
> > > +		dev_dbg(dport_dev, "RCH dport added to %s\n",
> > > +			dev_name(&port->dev));
> > > +	}
> > > +
> > > +	return dport;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_rch_dport, CXL);
> > > +
> > >  static int add_ep(struct cxl_ep *new)
> > >  {
> > >  	struct cxl_port *port = new->dport->port;
> > > diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
> > > index ec178e69b18f..7c2a85dc4125 100644
> > > --- a/drivers/cxl/core/regs.c
> > > +++ b/drivers/cxl/core/regs.c
> > > @@ -307,3 +307,59 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
> > >  	return -ENODEV;
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
> > > +
> > > +resource_size_t cxl_rcrb_to_component(struct device *dev,
> > > +				      resource_size_t rcrb,
> > > +				      enum cxl_rcrb which)
> > > +{
> > > +	resource_size_t component_reg_phys;
> > > +	u32 bar0, bar1;
> > > +	void *addr;
> > > +	u16 cmd;
> > > +
> > > +	if (which == CXL_RCRB_UPSTREAM)
> > > +		rcrb += SZ_4K;
> > > +
> > > +	/*
> > > +	 * RCRB's BAR[0..1] point to component block containing CXL
> > > +	 * subsystem component registers. MEMBAR extraction follows
> > > +	 * the PCI Base spec here, esp. 64 bit extraction and memory
> > > +	 * ranges alignment (6.0, 7.5.1.2.1).
> > > +	 */
> > > +	if (!request_mem_region(rcrb, SZ_4K, "CXL RCRB"))
> > > +		return CXL_RESOURCE_NONE;
> > > +	addr = ioremap(rcrb, SZ_4K);
> > > +	if (!addr) {
> > > +		dev_err(dev, "Failed to map region %pr\n", addr);
> > > +		release_mem_region(rcrb, SZ_4K);
> > > +		return CXL_RESOURCE_NONE;
> > > +	}
> > > +
> > > +	cmd = readw(addr + PCI_COMMAND);
> > > +	bar0 = readl(addr + PCI_BASE_ADDRESS_0);
> > > +	bar1 = readl(addr + PCI_BASE_ADDRESS_1);
> > > +	iounmap(addr);
> > > +	release_mem_region(rcrb, SZ_4K);
> > > +
> > > +	/* sanity check */
> > > +	if (cmd == 0xffff)
> > > +		return CXL_RESOURCE_NONE;
> > 
> > The spec says offset 0 should be checked (32 bit) which is always
> > non-FF if implemented. This requires another read.
> > 
> > cmd is most of the cases also non-zero, so probably checking cmd
> > instead will have the same effect. Still worth changing that.
> > 
> > If the downstream port's rcrb is all FFs, it is a FW bug. Could be
> > worth a message.
> 
> Ok, makes sense, added:
> 
> @@ -335,15 +336,22 @@ resource_size_t cxl_rcrb_to_component(struct device *dev,
>                 return CXL_RESOURCE_NONE;
>         }
>  
> +       id = readl(addr + PCI_VENDOR_ID);
>         cmd = readw(addr + PCI_COMMAND);
>         bar0 = readl(addr + PCI_BASE_ADDRESS_0);
>         bar1 = readl(addr + PCI_BASE_ADDRESS_1);
>         iounmap(addr);
>         release_mem_region(rcrb, SZ_4K);
>  
> -       /* sanity check */
> -       if (cmd == 0xffff)
> +       /*
> +        * Sanity check, see CXL 3.0 Figure 9-8 CXL Device that Does Not
> +        * Remap Upstream Port and Component Registers
> +        */
> +       if (id == (u32) -1) {

U32_MAX? Or, cheating there: ((u32)~0U).

> +               if (which == CXL_RCRB_DOWNSTREAM)
> +                       dev_err(dev, "Failed to access Downstream Port RCRB\n");
>                 return CXL_RESOURCE_NONE;
> +       }
>         if ((cmd & PCI_COMMAND_MEMORY) == 0)
>                 return CXL_RESOURCE_NONE;
>         if (bar0 & (PCI_BASE_ADDRESS_MEM_TYPE_1M | PCI_BASE_ADDRESS_SPACE_IO))
> 
