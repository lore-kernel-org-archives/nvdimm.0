Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A136FCB
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 15:23:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kww9gz5rY9nbSeUXaivvJ7df5STC312eLSt9HISma958FvbJyRrt5plx1zTpwU3DRbwXEnfS3gBuYiAhgdscMkL5DGr2fErpo6/Iypquoq3bo/iWwELQUjMW+tmJslfkwXzgVpXG9Ih7E4nclk06QZrZUtiuCPi4xrOvwAxGD0AH0rCgz/I5R8e8b1SVU1RnilX907FRZjtCW74IBwxFqTdKVCPTmhSHikY4zCc8OTFV/7iWv/c13fbxr460p5erZSY3UsqntJ4iaG3kt5moktLyCSQFNpARiegp89Wl49iZQ0I7rrwhO/xfiTAyer2jPVhELqHNgKbgs1J5JSD+9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTA5ns9FOeivGcmFfbJEsUp6qAAzg9fCrLYJPXMANKY=;
 b=UpMulcT4NuBnd0YA5ysvwW8dKILAuZAwSncw1dre2C5TNKfNIoiYpZgRVkxOSCvP123ztNrZ2ZLpNsanbKObwEEi8RtXkglViHTRA1F4ggsY8/+ZMTCU1/rsrctpMPeY/ZQTRK7OazHXuI3HuwQ0Qjz2K4yxOGYJ/9imVDrffCozmT6PV98kyGVskJLSzXMLilzLOflOkbynV/j9S7IRvol/qgQu1LlhdVpoXX+0BpGEX6ALC0VVd6/tQGznpV+nYz6UosoBKrsl2kVTmnsG4Mc+IyI17kMDNbUx+ZFNlV0ly9UD5N0FuH7qjRtKppwLRr2F7IUqedIfr2qHciZ93w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTA5ns9FOeivGcmFfbJEsUp6qAAzg9fCrLYJPXMANKY=;
 b=zO66WyfQUzZSd5NfyXT2gyjeDYSX9YS6ueAy1UmVl3TNR+G0vO2FTgIp1JUSCGZGlV9dZReDUJ8Tgexg1lDraf3QHAtumutYtr4rbdPYTUTQsSc7w6Cz5Zotk3LX7DCBxoOT6aKG5iiV+e+Tr31Tjf3DjsP0HN5WwSZ249xcCMs=
Received: from DM6PR12CA0029.namprd12.prod.outlook.com (2603:10b6:5:1c0::42)
 by IA1PR12MB6308.namprd12.prod.outlook.com (2603:10b6:208:3e4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 15:23:48 +0000
Received: from DS1PEPF0000E656.namprd02.prod.outlook.com
 (2603:10b6:5:1c0:cafe::60) by DM6PR12CA0029.outlook.office365.com
 (2603:10b6:5:1c0::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 15:23:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E656.mail.protection.outlook.com (10.167.18.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 15:23:47 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 1 Dec
 2022 09:23:44 -0600
Date: Thu, 1 Dec 2022 16:23:41 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <Y4jG/WElCcO3wYD5@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <Y4U+92BzA+O7fjNE@rric.localdomain>
 <6385516eaa45a_3cbe02944d@dwillia2-xfh.jf.intel.com.notmuch>
 <Y4Z4I4madYxKNT7g@rric.localdomain>
 <6387bf64519d1_3cbe0294de@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6387bf64519d1_3cbe0294de@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E656:EE_|IA1PR12MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f3e44a-b9cf-4072-086d-08dad3b00afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b18y6B5rHvTzABpcN1w6/RacVS4k6bco314+8MWQiuCxYd79zkx419AMVcC5im0RGCQ6m8S7RgbjRkL6yYjGzzEuwHYVafSMCfWtor6tJS/Nh5aAlmeZL+sGnrDrqkSY2MkBzdWJThJluluXzBXDi3CYrrCiiz81Hp8Ramzh0mOS1ef1C7MYhxdMN8dYDGwpGErTdSEasnfZot7LLV4MdYdMQ3HD6uBZQLoy0BhPujDhmwb6idrgVn7P2hW5OLI11fWm9evhoA6Yh0jkUGdM2UPgdtI1aiY9wAJdXHcd0AwKElUOUu4WiVkfi/TvkOmK1NMRel4k70oAiLI+C4twb0rwBE8Ss3+bDO1dF58hiUJBZHrIfs83sQ7iZaKe/av+cGZX7JsYCURl9qmWB68oDuaZ1JH1gOwV/U396Dk7m12YJ7wjvgQKI0C96jsTiNVi2MEQsMtMKHscWsnqQHvLqszzChEgh4nnvFAYYEZc27yVndelVsJLxf8QYyxvg0p59tQ4bZZtBpgObt76Eby1qm6cv4t7xxsFv8EcSR1WHZq69UkzAJYo459UCZDHNBDcer84tN1bIA63NMA7fr1tFfeX9OF5oGdwqTmSsq1UQkPhi+fdk7L+TsMKnjsOuh2Fexv4p1INv/LcHmFGM57PgTRrmJuNb0EQqeA5alDHOw6BEwuqBNNavHG2vZUsVQV09vC3xy50AHh6Dvf8zbT6kGEoQLOwNazJHyPWnJc9Zqo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(426003)(47076005)(9686003)(81166007)(7696005)(478600001)(16526019)(356005)(55016003)(6666004)(40460700003)(40480700001)(2906002)(186003)(82740400003)(82310400005)(53546011)(83380400001)(336012)(70586007)(5660300002)(26005)(316002)(36860700001)(8676002)(8936002)(54906003)(4326008)(41300700001)(70206006)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 15:23:47.7625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f3e44a-b9cf-4072-086d-08dad3b00afd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0000E656.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6308

On 30.11.22 12:39:00, Dan Williams wrote:
> Robert Richter wrote:
> > On 28.11.22 16:25:18, Dan Williams wrote:
> > > Robert Richter wrote:
> > > > On 24.11.22 10:35:32, Dan Williams wrote:
> > > > > Unlike a CXL memory expander in a VH topology that has at least one
> > > > > intervening 'struct cxl_port' instance between itself and the CXL root
> > > > > device, an RCD attaches one-level higher. For example:
> > > > > 
> > > > >                VH
> > > > >           ┌──────────┐
> > > > >           │ ACPI0017 │
> > > > >           │  root0   │
> > > > >           └─────┬────┘
> > > > >                 │
> > > > >           ┌─────┴────┐
> > > > >           │  dport0  │
> > > > >     ┌─────┤ ACPI0016 ├─────┐
> > > > >     │     │  port1   │     │
> > > > >     │     └────┬─────┘     │
> > > > >     │          │           │
> > > > >  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
> > > > >  │dport0│   │dport1│   │dport2│
> > > > >  │ RP0  │   │ RP1  │   │ RP2  │
> > > > >  └──────┘   └──┬───┘   └──────┘
> > > > >                │
> > > > >            ┌───┴─────┐
> > > > >            │endpoint0│
> > > > >            │  port2  │
> > > > >            └─────────┘
> > > > > 
> > > > > ...vs:
> > > > > 
> > > > >               RCH
> > > > >           ┌──────────┐
> > > > >           │ ACPI0017 │
> > > > >           │  root0   │
> > > > >           └────┬─────┘
> > > > >                │
> > > > >            ┌───┴────┐
> > > > >            │ dport0 │
> > > > >            │ACPI0016│
> > > > >            └───┬────┘
> > > > >                │
> > > > >           ┌────┴─────┐
> > > > >           │endpoint0 │
> > > > >           │  port1   │
> > > > >           └──────────┘
> > > > > 
> > > > > So arrange for endpoint port in the RCH/RCD case to appear directly
> > > > > connected to the host-bridge in its singular role as a dport. Compare
> > > > > that to the VH case where the host-bridge serves a dual role as a
> > > > > 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> > > > > the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> > > > > instances in the CXL topology.
> > > > > 
> > > > > Another deviation from the VH case is that RCDs may need to look up
> > > > > their component registers from the Root Complex Register Block (RCRB).
> > > > > That platform firmware specified RCRB area is cached by the cxl_acpi
> > > > > driver and conveyed via the host-bridge dport to the cxl_mem driver to
> > > > > perform the cxl_rcrb_to_component() lookup for the endpoint port
> > > > > (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> > > > > upstream port component registers).
> > > > > 
> > > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > > ---
> > > > >  drivers/cxl/core/port.c |   11 +++++++++--
> > > > >  drivers/cxl/cxlmem.h    |    2 ++
> > > > >  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> > > > >  drivers/cxl/pci.c       |   10 ++++++++++
> > > > >  4 files changed, 45 insertions(+), 9 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > > > index c7f58282b2c1..2385ee00eb9a 100644
> > > > > --- a/drivers/cxl/core/port.c
> > > > > +++ b/drivers/cxl/core/port.c
> > > > > @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > > > >  {
> > > > >  	struct device *dev = &cxlmd->dev;
> > > > >  	struct device *iter;
> > > > > +	struct cxl_dport *dport;
> > > > > +	struct cxl_port *port;
> > > > 
> > > > There is no direct need to move that code here.
> > > > 
> > > > If you want to clean that up in this patch too, then leave a comment
> > > > in the change log?
> > > 
> > > Oh, good point, must have been left over from an earlier revision of the
> > > patch, dropped it.
> > > 
> > > > 
> > > > >  	int rc;
> > > > >  
> > > > > +	/*
> > > > > +	 * Skip intermediate port enumeration in the RCH case, there
> > > > > +	 * are no ports in between a host bridge and an endpoint.
> > > > > +	 */
> > > > > +	if (cxlmd->cxlds->rcd)
> > > > > +		return 0;
> > > > > +
> > > > >  	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
> > > > >  	if (rc)
> > > > >  		return rc;
> > > > > @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > > > >  	for (iter = dev; iter; iter = grandparent(iter)) {
> > > > >  		struct device *dport_dev = grandparent(iter);
> > > > >  		struct device *uport_dev;
> > > > > -		struct cxl_dport *dport;
> > > > > -		struct cxl_port *port;
> > > > >  
> > > > >  		if (!dport_dev)
> > > > >  			return 0;
> > > > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > > > index e082991bc58c..35d485d041f0 100644
> > > > > --- a/drivers/cxl/cxlmem.h
> > > > > +++ b/drivers/cxl/cxlmem.h
> > > > > @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
> > > > >   * @dev: The device associated with this CXL state
> > > > >   * @regs: Parsed register blocks
> > > > >   * @cxl_dvsec: Offset to the PCIe device DVSEC
> > > > > + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
> > > > >   * @payload_size: Size of space for payload
> > > > >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> > > > >   * @lsa_size: Size of Label Storage Area
> > > > > @@ -235,6 +236,7 @@ struct cxl_dev_state {
> > > > >  	struct cxl_regs regs;
> > > > >  	int cxl_dvsec;
> > > > >  
> > > > > +	bool rcd;
> > > > >  	size_t payload_size;
> > > > >  	size_t lsa_size;
> > > > >  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > > > > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > > > > index aa63ce8c7ca6..9a655b4b5e52 100644
> > > > > --- a/drivers/cxl/mem.c
> > > > > +++ b/drivers/cxl/mem.c
> > > > > @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > > -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > > > > +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
> > > > >  				 struct cxl_dport *parent_dport)
> > > > >  {
> > > > >  	struct cxl_port *parent_port = parent_dport->port;
> > > > >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > > > >  	struct cxl_port *endpoint, *iter, *down;
> > > > > +	resource_size_t component_reg_phys;
> > > > >  	int rc;
> > > > >  
> > > > >  	/*
> > > > > @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > > > >  		ep->next = down;
> > > > >  	}
> > > > >  
> > > > > -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> > > > > -				     cxlds->component_reg_phys, parent_dport);
> > > > > +	/*
> > > > > +	 * The component registers for an RCD might come from the
> > > > > +	 * host-bridge RCRB if they are not already mapped via the
> > > > > +	 * typical register locator mechanism.
> > > > > +	 */
> > > > > +	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > > > > +		component_reg_phys = cxl_rcrb_to_component(
> > > > > +			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);
> > > > 
> > > > As already commented: this must be the upstream RCRB here.
> > > > 
> > > > > +	else
> > > > > +		component_reg_phys = cxlds->component_reg_phys;
> > > > > +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> > > > > +				     parent_dport);
> > > > 
> > > > Looking at CXL 3.0 spec, table 8-22, there are the various sources of
> > > > component registers listed. For RCD we need: D1, DP1, UP1 (optional
> > > > R).
> > > > 
> > > > 	D1:	endpoint->component_reg_phys;
> > > > 	UP1:	parent_port-component_reg_phys; (missing in RCH topology)
> > > > 	DP1:	parent_dport->component_reg_phys;
> > > > 
> > > > I don't see how all of them could be stored in this data layout as the
> > > > cxl host port is missing.
> > > 
> > > If I am understanding your concern correctly, that's handled here:
> > > 
> > >     if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > > 
> > > In the D1 case cxlds->component_reg_phys will be valid since the
> > > component registers were visible via the register locator DVSEC and
> > > retrieved by cxl_pci. In the UP1 case cxlds->component_reg_phys is
> > > invalid and the driver falls back to the RCRB. DP1 is handled in
> > > cxl_acpi. I.e. the D1 and UP1 cases do not co-exist.
> > 
> > What I mean is we must store all 3 component reg base addresses for
> > later access. E.g., if there is an AER error of a pci dev or the host,
> > we must (depending on the error details) access CXL RAS status of
> > either D1, UP1 or DP1. So for all 3 of them there must be a way to
> > determine this walking through the port hierarchy. In the above list
> > of locations I don't where UP1's component reg base address is stored.
> 
> So I think we are reading the specification differently. I am comparing
> Figure 9-7 "CXL Device Remaps Upstream Port and Component Registers" and
> Figure Figure 9-8 "CXL Device that Does Not Remap Upstream Port and
> Component Registers" and noting that there is never a case where three
> sets of component registers are visible. It is either DP1 connected to
> UP1 (Figure 9-7) or DP1 connected to D1 (Figure 9-8). There is never a
> case where the code needs to consider UP1 and D1 component registers at
> the same time because those things are identical just enumerated
> differently depending on how the endpoint is implemented.

Yes, the spec is ambiguous here. Looking at CXL 3.0, Figure 12-3 I
also tend to agree the RCiEP's CXL RAS cap is used for that ("UP Z
sends an error message to all CXL.io Functions that are affected by
this error."). Unfortunately 12.2.1.2 does not state where the CXL RAS
Capability that logs the error resides.

-Robert

