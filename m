Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DFABA28
	for <nvdimm@lists.linux.dev>; Tue, 29 Nov 2022 21:22:51 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpVlucsvpVyM/gFUJ5JvRXPDWnWzUzqc449/ZhrF4xGOQ8xBG9isylEO1AMy4RccZLKcSUTpYgpGa+4MN9CbLa3+m1IeItlAndqV53Vdc2A4Nt1uTeDdm30P7VcaIQydmDjk0LSEeYjk0k4sYF0wVtzJzWts3rQ01CqmlFzMEaEp1QvxaXjPk8VScsiTMn9Vj18EZ3F1hz+6w/Lj8jg1HZmY1ySRCYZTjxewL2AxhEg5/etScxy8to6g4iBckvIz+ceYcdUuHrG3sRpnNcCGvxD3i94CO4P9l94y40IProLxM1kGzuc5ZrqLoUpqbNr6AZ9DtDPaYiq3PggyT3AAZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RciHtU+S/rt5+m4dzG4xOejiDKTiVRs9JgKrlP6fwDo=;
 b=iOxKkF2TNyED3rLxMaGvcfJK0rUdRBmoqdvykF/nMuOtPcq+ekDNNsOf2BMZK/tnFDU+xeWwie4HX0MVe7ec6kNO5gdPfLk0CzDFA+aK+CCfmOO5uLjjdMFVGcy0/w7p8Kop84jEFst30hP32yz5mxrTokTA7mGh7UdcPeWl+JCO13hsMNUnaLiAPi0G1SK9n9deIukLfQKn5NJkivq+srGZ3tz6Kg8ttnmYLquYX1lD/Ra1NF5IRPDcR2EFQH+q2rZWvquflzc4djREfL62TH8HZ3B1x6tEEx7BICwSqpejv7bXu3IAl7+dINNqeqUT4XZlW1IcGXtc0TDb2xyZmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RciHtU+S/rt5+m4dzG4xOejiDKTiVRs9JgKrlP6fwDo=;
 b=5hDEVbCuz0YD3Q8/3+xaWsh96r1d+fL0282V0Y2sumEgf38RlTXdKZAnOtL1DJxBMVP9Lr4VMsKHSZqED/sEIOcUosOcQaS5ggKpYPWPEf+lDc8ywrHhScFg/O0dDbIoTAFxVYwTeINBm/40fsz3fmA7vJHa7GbClYCpg6PB6qw=
Received: from DS7PR03CA0166.namprd03.prod.outlook.com (2603:10b6:5:3b2::21)
 by PH7PR12MB8040.namprd12.prod.outlook.com (2603:10b6:510:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 21:22:48 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::8c) by DS7PR03CA0166.outlook.office365.com
 (2603:10b6:5:3b2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 21:22:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Tue, 29 Nov 2022 21:22:48 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 15:22:46 -0600
Date: Tue, 29 Nov 2022 22:22:43 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration
Message-ID: <Y4Z4I4madYxKNT7g@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931493266.2104015.8062923429837042172.stgit@dwillia2-xfh.jf.intel.com>
 <Y4U+92BzA+O7fjNE@rric.localdomain>
 <6385516eaa45a_3cbe02944d@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6385516eaa45a_3cbe02944d@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|PH7PR12MB8040:EE_
X-MS-Office365-Filtering-Correlation-Id: 931557e0-5bd5-4e3e-419f-08dad24fdd25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tQIp4sznodZ4HqPMI0MB62e2OwebzvtVou58wb/eZHphfdwz4iqqDlA0dckFr9UoPXKQ0ShrVGFrdc7xCXONEt3VGFv/ikAr7UlSwTRUTzZUndH4ZLx9l7+Lj0YVvonCXe6CxFKpXTEbjMsFz9/bjX/BrKwePVp0105oGXsXcNkTM+TOzcxGuMURFTuRq3OR0MaqKqMKz/mCmiBBykdJGan5cKQEsZYW2MbikUAjanl59sPRXUM+fXK/j4QierqK9xZPjx40bSui38m2JXDx84jmGLf6tpncNQQ7GINeplIDjZP1hOyFpwZk2o6fI2bHW2234a0MqLcLlbjAnIi+SoHo1mWSKoIkMMn40/RMlpVjV8m1xxTeUOjSRjrq5exopGJMWDEP2zIHPSjkZJTAthYkaFQtnHWzJUq706Un1ZKcbO5QaUrraCVtFJwLtQdAMo33vj8bovDUxLy0AYb/Ixe1+Gxz0YV31Ep9RtSbqnwjx/35nj4GnwmvMDaRcN/GnYRBVOY2bKpaNn3evaKKq5IisdPlLwRuGM51JmUjczEK9FtbgGII7vz2zKEo6l0QRngciydz7y+/+ZoRm0YIneja/UHx3F2TJmpR7qi1ozanXF4sdxl6DhD+S9hZAN61b7UlZ8xgeFTjhxBTX1YBHDqRJr9ZNBOwURIIMaAzxtGqan2JRztn/PJ7L651pGM7iW0BewTdNpJG51C3nF2euiO2eMdy2y1RNcTuKuFDkwc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(316002)(2906002)(478600001)(70206006)(70586007)(6916009)(54906003)(40460700003)(356005)(81166007)(82740400003)(426003)(6666004)(47076005)(36860700001)(82310400005)(83380400001)(55016003)(40480700001)(26005)(336012)(9686003)(53546011)(16526019)(186003)(7696005)(5660300002)(41300700001)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 21:22:48.0021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 931557e0-5bd5-4e3e-419f-08dad24fdd25
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8040

On 28.11.22 16:25:18, Dan Williams wrote:
> Robert Richter wrote:
> > On 24.11.22 10:35:32, Dan Williams wrote:
> > > Unlike a CXL memory expander in a VH topology that has at least one
> > > intervening 'struct cxl_port' instance between itself and the CXL root
> > > device, an RCD attaches one-level higher. For example:
> > > 
> > >                VH
> > >           ┌──────────┐
> > >           │ ACPI0017 │
> > >           │  root0   │
> > >           └─────┬────┘
> > >                 │
> > >           ┌─────┴────┐
> > >           │  dport0  │
> > >     ┌─────┤ ACPI0016 ├─────┐
> > >     │     │  port1   │     │
> > >     │     └────┬─────┘     │
> > >     │          │           │
> > >  ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
> > >  │dport0│   │dport1│   │dport2│
> > >  │ RP0  │   │ RP1  │   │ RP2  │
> > >  └──────┘   └──┬───┘   └──────┘
> > >                │
> > >            ┌───┴─────┐
> > >            │endpoint0│
> > >            │  port2  │
> > >            └─────────┘
> > > 
> > > ...vs:
> > > 
> > >               RCH
> > >           ┌──────────┐
> > >           │ ACPI0017 │
> > >           │  root0   │
> > >           └────┬─────┘
> > >                │
> > >            ┌───┴────┐
> > >            │ dport0 │
> > >            │ACPI0016│
> > >            └───┬────┘
> > >                │
> > >           ┌────┴─────┐
> > >           │endpoint0 │
> > >           │  port1   │
> > >           └──────────┘
> > > 
> > > So arrange for endpoint port in the RCH/RCD case to appear directly
> > > connected to the host-bridge in its singular role as a dport. Compare
> > > that to the VH case where the host-bridge serves a dual role as a
> > > 'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
> > > the Root Ports in the Root Complex that are modeled as 'cxl_dport'
> > > instances in the CXL topology.
> > > 
> > > Another deviation from the VH case is that RCDs may need to look up
> > > their component registers from the Root Complex Register Block (RCRB).
> > > That platform firmware specified RCRB area is cached by the cxl_acpi
> > > driver and conveyed via the host-bridge dport to the cxl_mem driver to
> > > perform the cxl_rcrb_to_component() lookup for the endpoint port
> > > (See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
> > > upstream port component registers).
> > > 
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > ---
> > >  drivers/cxl/core/port.c |   11 +++++++++--
> > >  drivers/cxl/cxlmem.h    |    2 ++
> > >  drivers/cxl/mem.c       |   31 ++++++++++++++++++++++++-------
> > >  drivers/cxl/pci.c       |   10 ++++++++++
> > >  4 files changed, 45 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index c7f58282b2c1..2385ee00eb9a 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -1358,8 +1358,17 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > >  {
> > >  	struct device *dev = &cxlmd->dev;
> > >  	struct device *iter;
> > > +	struct cxl_dport *dport;
> > > +	struct cxl_port *port;
> > 
> > There is no direct need to move that code here.
> > 
> > If you want to clean that up in this patch too, then leave a comment
> > in the change log?
> 
> Oh, good point, must have been left over from an earlier revision of the
> patch, dropped it.
> 
> > 
> > >  	int rc;
> > >  
> > > +	/*
> > > +	 * Skip intermediate port enumeration in the RCH case, there
> > > +	 * are no ports in between a host bridge and an endpoint.
> > > +	 */
> > > +	if (cxlmd->cxlds->rcd)
> > > +		return 0;
> > > +
> > >  	rc = devm_add_action_or_reset(&cxlmd->dev, cxl_detach_ep, cxlmd);
> > >  	if (rc)
> > >  		return rc;
> > > @@ -1373,8 +1382,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
> > >  	for (iter = dev; iter; iter = grandparent(iter)) {
> > >  		struct device *dport_dev = grandparent(iter);
> > >  		struct device *uport_dev;
> > > -		struct cxl_dport *dport;
> > > -		struct cxl_port *port;
> > >  
> > >  		if (!dport_dev)
> > >  			return 0;
> > > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > > index e082991bc58c..35d485d041f0 100644
> > > --- a/drivers/cxl/cxlmem.h
> > > +++ b/drivers/cxl/cxlmem.h
> > > @@ -201,6 +201,7 @@ struct cxl_endpoint_dvsec_info {
> > >   * @dev: The device associated with this CXL state
> > >   * @regs: Parsed register blocks
> > >   * @cxl_dvsec: Offset to the PCIe device DVSEC
> > > + * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
> > >   * @payload_size: Size of space for payload
> > >   *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
> > >   * @lsa_size: Size of Label Storage Area
> > > @@ -235,6 +236,7 @@ struct cxl_dev_state {
> > >  	struct cxl_regs regs;
> > >  	int cxl_dvsec;
> > >  
> > > +	bool rcd;
> > >  	size_t payload_size;
> > >  	size_t lsa_size;
> > >  	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
> > > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > > index aa63ce8c7ca6..9a655b4b5e52 100644
> > > --- a/drivers/cxl/mem.c
> > > +++ b/drivers/cxl/mem.c
> > > @@ -45,12 +45,13 @@ static int cxl_mem_dpa_show(struct seq_file *file, void *data)
> > >  	return 0;
> > >  }
> > >  
> > > -static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > > +static int devm_cxl_add_endpoint(struct device *host, struct cxl_memdev *cxlmd,
> > >  				 struct cxl_dport *parent_dport)
> > >  {
> > >  	struct cxl_port *parent_port = parent_dport->port;
> > >  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> > >  	struct cxl_port *endpoint, *iter, *down;
> > > +	resource_size_t component_reg_phys;
> > >  	int rc;
> > >  
> > >  	/*
> > > @@ -65,8 +66,18 @@ static int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
> > >  		ep->next = down;
> > >  	}
> > >  
> > > -	endpoint = devm_cxl_add_port(&parent_port->dev, &cxlmd->dev,
> > > -				     cxlds->component_reg_phys, parent_dport);
> > > +	/*
> > > +	 * The component registers for an RCD might come from the
> > > +	 * host-bridge RCRB if they are not already mapped via the
> > > +	 * typical register locator mechanism.
> > > +	 */
> > > +	if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> > > +		component_reg_phys = cxl_rcrb_to_component(
> > > +			&cxlmd->dev, parent_dport->rcrb, CXL_RCRB_DOWNSTREAM);
> > 
> > As already commented: this must be the upstream RCRB here.
> > 
> > > +	else
> > > +		component_reg_phys = cxlds->component_reg_phys;
> > > +	endpoint = devm_cxl_add_port(host, &cxlmd->dev, component_reg_phys,
> > > +				     parent_dport);
> > 
> > Looking at CXL 3.0 spec, table 8-22, there are the various sources of
> > component registers listed. For RCD we need: D1, DP1, UP1 (optional
> > R).
> > 
> > 	D1:	endpoint->component_reg_phys;
> > 	UP1:	parent_port-component_reg_phys; (missing in RCH topology)
> > 	DP1:	parent_dport->component_reg_phys;
> > 
> > I don't see how all of them could be stored in this data layout as the
> > cxl host port is missing.
> 
> If I am understanding your concern correctly, that's handled here:
> 
>     if (parent_dport->rch && cxlds->component_reg_phys == CXL_RESOURCE_NONE)
> 
> In the D1 case cxlds->component_reg_phys will be valid since the
> component registers were visible via the register locator DVSEC and
> retrieved by cxl_pci. In the UP1 case cxlds->component_reg_phys is
> invalid and the driver falls back to the RCRB. DP1 is handled in
> cxl_acpi. I.e. the D1 and UP1 cases do not co-exist.

What I mean is we must store all 3 component reg base addresses for
later access. E.g., if there is an AER error of a pci dev or the host,
we must (depending on the error details) access CXL RAS status of
either D1, UP1 or DP1. So for all 3 of them there must be a way to
determine this walking through the port hierarchy. In the above list
of locations I don't where UP1's component reg base address is stored.

-Robert
