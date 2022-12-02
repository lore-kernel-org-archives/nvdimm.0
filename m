Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE61C03
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 08:17:14 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxdrEamWuWTqtlEiNDr2kuGheoCLuDe6gx3hWU7nrXBBcWjeO1Bv5qk9+A2zORI8AVA+CPUvPrNxeMfzo/3fmn/3uGWYZ+wjNl+QguXi3LiidovvtKvEM4UAB4nm3VcZ0crzrYSdBN5xVn7A7xXbjJejd1qEmEsnRekG8Xx2wGux1esgUarm8N1W8VFiWC9R5iXwD+nAMN0f+JyP7lQr7+oAz+DcgcgTAhDvj/trHlE3CczJ5yXDnA1zlIS6x1VMDWEbuzJG5wlW/NH27D+V4W2OCIaqPzS7IveriXGifUMzgDW7BfCDYeTTHCOiPMVS6qHDu4NvAAXEjxTSMVcp2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PfEZxAfUKOk3GwmK8Q+QKj1laiPACTkwK60Th+6JXM=;
 b=A9ppi1mst6kJ8zTBCWH3OAgRkqPLphxCUC69pHv3YAkXjs5zns98geXj4MEJTCN5HRKZLcsxcxkO2Ns6LAArmWaLNixusPrLED1nZBNL/z1/iS1hGF3GBwdN6ShsVV0pwWwGn9FCSaMcT42HWhb8PnqiSl9K3druG2iv95fvo0yWK+0FQnshZiM44j/diAqnfmEEW8oebTZPtzRhdOfGBsJijdZSnz67CDKp1Dx1pFY5pVSSNygWawVwp396iKOcKVuGHaqcnisOmlcOd4/UlibqpOAbA0H0g77ZhbSxoQ0/Y5k0R0CaidxwmZx7Rw0Gwtzd9RTNpIkfVQRu6cdRvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PfEZxAfUKOk3GwmK8Q+QKj1laiPACTkwK60Th+6JXM=;
 b=Ivta726lFV/FiW4mZDX+6eJEMfuiNt9GuXCBk5/mJZzP5WNNDKy70jwTpJ3qdYyVPSLEpZLEsG3Zr8t02FAxjxXmKY1SpjPDGweagRCYaw1cdn4L456ZC+vUjec5R2MeSfevLSBAc5lkM13ifKTbtRdOSM9ab+/Rf0HwSQEN/QI=
Received: from DM5PR07CA0063.namprd07.prod.outlook.com (2603:10b6:4:ad::28) by
 LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:17:11 +0000
Received: from DS1PEPF0000E656.namprd02.prod.outlook.com
 (2603:10b6:4:ad:cafe::67) by DM5PR07CA0063.outlook.office365.com
 (2603:10b6:4:ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Fri, 2 Dec 2022 08:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E656.mail.protection.outlook.com (10.167.18.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 08:17:10 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 02:17:08 -0600
Date: Fri, 2 Dec 2022 09:16:25 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Terry Bowman <terry.bowman@amd.com>,
	<alison.schofield@intel.com>, <bhelgaas@google.com>, <dave.jiang@intel.com>,
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH v6 08/12] cxl/acpi: Extract component registers of
 restricted hosts from RCRB
Message-ID: <Y4m0WbVSWjkeF+7x@rric.localdomain>
References: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
 <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166993044524.1882361.2539922887413208807.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E656:EE_|LV2PR12MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f15997e-2858-494f-0a92-08dad43d9c88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+XzWMCxi1tKYmKsbgBk2i4FcxcGDjKQh5hVoVck7rt0I9Kn7tM9Vzg6nCUY6vuFx6FC3qH818QIIV4wgATzME8nb4ekEqDmJgr09cVNpKT7onhS56qRGB3vIY7cHIEgvepJl3HM5KoKpX2CEIC5DD2bftZ/7UctfdNjpJBIkjdJ8HooScm8jSpPq/f248gKS5a+gjHHponAF1TlJkezBNEXIcKbLpHC5FDz2F0dKKjBE12dl79g5E02m7p6FZH3UWcuHB5gdz8t00denOcth4LJwfTBrHdZEjlLv7ec+xc7+swlXijqiaByjEoLvCzKBQ2DLVs/H4mYjZfo29mFfS8KkyWZHNjehiDZPu1Ibv4phPNdbUmDafa1yMowW32hltG8M/A9kAYm9Uh8mZiiJMoAKW5DhJjjJcDBBW5npi9wo5vA7uwbtd5nvVS0qs93+2lV8sSQ9lkx5kg3OCnLhfkv4leZE9wbK0hukDQlDmZf/pbgdJNFcNsfY7EkSNThqjFDRHCt20shHq/j4LrMK9P6XziZAVNtd5qRLClHTSAZV03SMPsvJX7jIDa+VhvAwJz/NyM8O4IXh/eunWRUHvZH9710GKD2Eik9rUt6qOsJ3NbY8G7h94Sy88scVnpXwOAI7doTf5G5To3uOKaMZnmx7SlzlTTEZbBzDZVc3QOjock5gHjTD5n/QYtwCnmBrp9aMm66KmfMPuky86A9+RSznzs0B/Icx3QmGu1ESHQXQuO/tr62rOh3+ltjMSa2B4zGAn3HV5gBnh/xpABnkWyA4MihcQX/d7+hGmmgLwAA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(81166007)(356005)(40480700001)(55016003)(426003)(54906003)(40460700003)(316002)(966005)(82740400003)(6916009)(41300700001)(478600001)(8936002)(70206006)(8676002)(70586007)(5660300002)(9686003)(2906002)(6666004)(7696005)(36860700001)(83380400001)(53546011)(82310400005)(4326008)(26005)(47076005)(186003)(16526019)(336012)(67856001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:17:10.9820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f15997e-2858-494f-0a92-08dad43d9c88
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0000E656.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845

On 01.12.22 13:34:05, Dan Williams wrote:
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
> Link: https://lore.kernel.org/r/Y4dsGZ24aJlxSfI1@rric.localdomain
> [djbw: introduce devm_cxl_add_rch_dport()]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Found an issue below. Patch looks good to me otherwise.

> ---
>  drivers/cxl/acpi.c            |   51 ++++++++++++++++++++++++++++-----
>  drivers/cxl/core/port.c       |   53 ++++++++++++++++++++++++++++++----
>  drivers/cxl/core/regs.c       |   64 +++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h             |   16 ++++++++++
>  tools/testing/cxl/Kbuild      |    1 +
>  tools/testing/cxl/test/cxl.c  |   10 ++++++
>  tools/testing/cxl/test/mock.c |   19 ++++++++++++
>  tools/testing/cxl/test/mock.h |    3 ++
>  8 files changed, 203 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c

> @@ -274,21 +301,29 @@ static int add_host_bridge_dport(struct device *match, void *arg)
>  	dev_dbg(match, "UID found: %lld\n", uid);
>  
>  	ctx = (struct cxl_chbs_context) {
> -		.dev = host,
> +		.dev = match,
>  		.uid = uid,
>  	};
>  	acpi_table_parse_cedt(ACPI_CEDT_TYPE_CHBS, cxl_get_chbcr, &ctx);
>  
> -	if (ctx.chbcr == 0) {
> +	if (ctx.rcrb != CXL_RESOURCE_NONE)
> +		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);
> +
> +	if (ctx.chbcr == CXL_RESOURCE_NONE) {
>  		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
>  		return 0;
>  	}

The logic must be changed to handle the case where the chbs entry is
missing:

	if (!ctx.chbcr) {
		dev_warn(match, "No CHBS found for Host Bridge (UID %lld)\n", uid);
		return 0;
	}

	if (ctx.rcrb != CXL_RESOURCE_NONE)
		dev_dbg(match, "RCRB found for UID %lld: %pa\n", uid, &ctx.rcrb);

	if (ctx.chbcr == CXL_RESOURCE_NONE) {
		dev_warn(match, "CHBCR missing for Host Bridge (UID %lld)\n", uid);
		return 0;
	}

>  
> -	dev_dbg(match, "CHBCR found: 0x%08llx\n", (u64)ctx.chbcr);
> +	dev_dbg(match, "CHBCR found: %pa\n", &ctx.chbcr);
