Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B4E2F56
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 16:03:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDDACIrMq0RuLSCSAN1UMwrKCwF7dntfz6FHTBm6uIdtNWXQ8PvRpTyT6CGlcceRp74vTSZ9BaCnLhrR7Z39G8DJZEtjqCn7IBmkN00lNqaCNy2eHMdcNGAbQZPVs06M8qjJns3PseORTKP5XT0YSWNwxj79jWrptcc08UQg/iMwrgBOmogUx7bw8NopTWfaxZvHkyIIIioHgqABHIA88OsFWJv0EmKFofDnu8hl4PBJL9+HT8I9Ojc5CEWsybpEEko9ayY8wOIIR1yt5HfEgvn35Je2nfVN7kTzRrib0Lo9g9dmDldPM3u2k+NErVCfr10Cxy+i3lRO3GXwboZrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhZb4Q2tXFgKD3ZsE5Ub/fb0eV0Mt/3+6eYdvGZmcT4=;
 b=nHBIpIHwROTcfz9lWib2qsR/pthrgF1vO3EXd9wAfpU8apwWiIypLNK8ROPCPqV07s+xltSIOm0YapW1597c5jIZNb8k4Clm+shmuP34sLYdu9+DvdMFVbIKKbon4R+vSGGUJfkufIkVdMtnuoYUMUviH8hz71dREjn6jAqb4O4ABhAAIvuWJCtb9gkcf1kQwixT4WFP0Yoz8xnLshFhZbNestpHW5vsAiwKs3Z8YZxZf1e0/jOerJ+wt2h6baaG7K/v19j2pxGXfR1ocoZXWn+CBmu2KjkDOIDCIRXo/3p8IcW+wvHMe6rFIGqMZ3C0z3FRHT1ykzHmeK+UdhwLkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhZb4Q2tXFgKD3ZsE5Ub/fb0eV0Mt/3+6eYdvGZmcT4=;
 b=s9Tdc0NuY/tvHmyAVXUAf9fzKF2t9+epFQYpJE7wRt92sFEbiic/ieZ8s46h2cenaDrEk8nLkc9ndtY5j0rgxfljw5DM83Wr2yFIMrdkQxZ/ctqMQHVZrvaMb9kEza9FgikxHqzg5kIEaUalc5EysnqC5+Z6xg8GGLWc6i+oXDE=
Received: from CY5PR22CA0001.namprd22.prod.outlook.com (2603:10b6:930:16::15)
 by DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sat, 3 Dec
 2022 16:03:21 +0000
Received: from CY4PEPF0000B8EA.namprd05.prod.outlook.com
 (2603:10b6:930:16:cafe::68) by CY5PR22CA0001.outlook.office365.com
 (2603:10b6:930:16::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Sat, 3 Dec 2022 16:03:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EA.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Sat, 3 Dec 2022 16:03:21 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 3 Dec
 2022 10:03:17 -0600
Date: Sat, 3 Dec 2022 17:03:14 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<alison.schofield@intel.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <Y4tyxE3Q7EIvMpVG@rric.localdomain>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
 <Y4m0WbVSWjkeF+7x@rric.localdomain>
 <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <638af5119969_3cbe0294cb@dwillia2-xfh.jf.intel.com.notmuch>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EA:EE_|DM6PR12MB4283:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5574ab-2ae2-4d68-efa2-08dad547e697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4LVFtHhBJn66Z4fd/ha/jRpa/+davH8kIHTtfYfFmlhPCdvGzbCxdpER/GmXkUYD2dzf3dIQEc87ibycEiGPXU5VggXq68mIBa/1eI/aGjU8t7zBRorpzrdW0Xc0qx+9V7TEekOgabHwSPdijfIvuCQXF+Qt3raluwXyVjK955gbFnj/sX72lgPimL39Vrwd27/09MbMadNDL+zO6jlTwWyOF4qdkRoykG6/77dc2Sl8FAM9LbN1en/zFE68k36CFav6HT+4VTTX/VvysbcCRCJhzqN5bSQ+JLEve0lHEeD24j0yuWT9sb3L+6sR2FWajRjbvbPeI6xj/KhPhwm+6zjCcm1Q1zyjGDW9BMyU/FvABAt0fOXm4EtD4CrBTeo1u8UTE7wY70wDzRxLtmNDBMjiLpVOKNYZ5uTfHBv1MpcCtuT4/RrvwwobqNreayQEEMfx9P2xcUYSjIeUsYeaUSv9wjNUjUhOduGFow1Sym7QimwaP00GphjFlIoPEsjtTZMguw9HDVzrPoieIeAhnA2XgY9d0U9AtMEKBhKuH30tx8z0xDmR2/JXh/y+3htq5VwsupNDfu6BEq1KBmhx/2fvtcBchpwmNAFb5FacEqAQzFSEYSYEgDzaVcwUBWEspv+2uoGjKv0lpgePcziSjjkY2Mown5fOoOdLjOKpr1/Qt0U8fL+G0PAkYkbOr1T01NTDRo/qgINdj62NEuJmyyke8bILfxaC5Do78foUV2uALLiQdZSrTi0ATB3ix5c+OnLvhzZ90BhoddRKrTfHow==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(7696005)(53546011)(6666004)(9686003)(26005)(8936002)(40460700003)(966005)(478600001)(2906002)(70586007)(70206006)(83380400001)(8676002)(4326008)(82740400003)(316002)(6916009)(36860700001)(54906003)(55016003)(5660300002)(336012)(81166007)(356005)(82310400005)(186003)(16526019)(41300700001)(426003)(40480700001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 16:03:21.3051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5574ab-2ae2-4d68-efa2-08dad547e697
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000B8EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283

On 02.12.22 23:04:49, Dan Williams wrote:
> Robert Richter wrote:
> > On 01.12.22 13:34:05, Dan Williams wrote:
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
> > > Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> > > [djbw: introduce devm_cxl_add_rch_dport()]
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > 
> > Found an issue below. Patch looks good to me otherwise.
> > 
> > > ---
> > >  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
> > >  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
> > >  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
> > >  drivers/cxl/cxl.h             |   16 ++++++++++
> > >  tools/testing/cxl/Kbuild      |    1 +
> > >  tools/testing/cxl/test/cxl.c  |   10 ++++++
> > >  tools/testing/cxl/test/mock.c |   19 ++++++++++++
> > >  tools/testing/cxl/test/mock.h |    3 ++
> > >  8 files changed, 203 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > 
> > > @@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > >  	dev_dbg(match, "UID found: %lld\n", uid);
> > >  
> > >  	ctx = (struct cxl_chbs_context) {
> > > -		.dev = host,
> > > +		.dev = match,
> > >  		.uid = uid,
> > >  	};
> > >  	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
> > >  
> > > -	if (ctx.chbcr == 0) {
> > > +	if (ctx.rcrb != CXL_RESOURCE_NONE)
> > > +		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
> > > +
> > > +	if (ctx.chbcr == CXL_RESOURCE_NONE) {
> > >  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > >  		return 0;
> > >  	}
> > 
> > The logic must be changed to handle the case where the chbs entry is
> > missing:
> > 
> > 	if (!ctx.chbcr) {
> > 		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
> > 		return 0;
> > 	}
> 
> Noted, and folded into the patch.

In the (ctx.chbcr == CXL_RESOURCE_NONE) case there is a slighly
different error reason. The CHBS was found but the CHBCR was invalid
or something else failed to determine it. That's why a different
message should be reported, e.g.:

	dev_warn(match, "CHBCR invalid for Host Bridge (UID %lld)\n", uid);

(Note I originally used "missing", but "invalid" is more reasonable
as there is something but it's not correct.)

-Robert
