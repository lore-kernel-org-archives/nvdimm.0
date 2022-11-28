Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4271EA461
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 19:50:19 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQITTK0qR9L5dwdMLge/CAME8ISQWa89WZKaShiGa6iVwwUzs3VYWH1/ERpPPJNwqEOlG4jMSQ5ZV3UqWLMSO5rszo0Ch6GdFy200hlqmrrEAMMBUCv4p9kSskyC3Pi0OXKwm3fWXO0ZT4NmbBo+fBkTZdPa9FhufqScxhcBP58l2jm9D1p02akmXVLnUHLhK+9urGJDFDJeUyB++7R5wLWWHH3QYD7eiLvl+O7WXDTU+TOB+0H021VQ5hBWkcX6k7EeGYE4CagHkUiaHkF+ouaMmIA0hkIc96rcQUHvVbFDzoQq7I9abI29RASlnUsUIAlQ7oooccjwm7cZZgE2sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuXhTz2oZcG0M/ikqmPPgFH/zQtP1EdiDcS89Rd9cdE=;
 b=LRWMYC1M69Wjch9RsbT4LfoAoN2ZXP8msAZCnh2zOv4u1CEFutGAuvTuqs6Z064wUxKJkZWYnCv4srPC875gTahyBFkSl2z4mEVipK0hqxZrxNuoznGH3ooUmZdjVLnLBoHl4xJNweZfEICCPNtPr5zqsRnAK5u7c+GXTuTQ4KF1V2GPKGBkBQAj2TAhPIpJypXnpyd5vgO7HKXCnn77PYeH6aTFX0ivkoeBWGgsEMn++34p6G2TI7m1Zi3bH14WpMufi59RUZfGhmPjemyVgoo6wFPw53+FAFgWDX7fHFwcOba/yoyvhtqM5xTBIn3Ns+oRBC2pFOYLVdtgq0fefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuXhTz2oZcG0M/ikqmPPgFH/zQtP1EdiDcS89Rd9cdE=;
 b=BHJW7jsu6Mdpw5XrQKND18yx/wCdXChNJDp9Ditqv08jXHxAj9l/RAYtlbrt6YpKYK8vfpXEDkkxH1h9Aczeojm0ow4y8gn9DBjyCifpTwTq1cZEM6MWzplgax19OSfcVuLPB9cv+gMGiY+7lA23rzUt/HtYQbYxQ4rMCBpj1CI=
Received: from BN0PR04CA0057.namprd04.prod.outlook.com (2603:10b6:408:e8::32)
 by PH7PR12MB7163.namprd12.prod.outlook.com (2603:10b6:510:202::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 19:50:16 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::21) by BN0PR04CA0057.outlook.office365.com
 (2603:10b6:408:e8::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Mon, 28 Nov 2022 19:50:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Mon, 28 Nov 2022 19:50:16 +0000
Received: from rric.localdomain (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 13:50:14 -0600
Date: Mon, 28 Nov 2022 20:50:11 +0100
From: Robert Richter <rrichter@amd.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>,
	<bhelgaas@google.com>, <dave.jiang@intel.com>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 09/12] cxl/mem: Move devm_cxl_add_endpoint() from
 cxl_core to cxl_mem
Message-ID: <Y4UQ85/KAmuaZXFq@rric.localdomain>
References: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
 <166931492718.2104015.1866183528350401708.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <166931492718.2104015.1866183528350401708.stgit@dwillia2-xfh.jf.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT019:EE_|PH7PR12MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: 85faefbd-ba71-4e73-3a7d-08dad179c5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CNck3wbl1vuN+wgotdSTXS+HsJdHkc+zyiDUwI2qJ7pcd6QGzsG+hOzWGVSm0oR6/c9oP9NBr7i5Qk5YUTgsKnZruMsG9j1VtNBXfcFquC6M85Fa5iahwuDdrcwAkcYldqvh5qKChJTrcxGIpF8Q4CKfMU1RM390TfsSF0IrXIKhodoemd0rSU+mjlfrqPUbS/Eg0uoTrh0aqFvhe6gyhZ9rqK3keFPySUW25i3HI6ku5h64Kwa5E9KUVybhx04wfs/pY5Ha+hg51u6IluWay9yqZr3caEMSj0qszlk6Q03xxDQeyCwxgnrd7aKCVbn6XUQpEE8dbvt76p5aH953XtG73TGB6gzsgcsp5T8k8jsDP+R5DVIuNrxjR9ORZVyanW1te8e9EDoeoJARn4Bdnv5yS+Xo/Gciist9Mp3EmgerInStUfJ7DoPuR6nDc4I9SDLslyv/j1nD88FxrBF8yXQ/Tw0jlnc70QLeuOkppEwpFBX0j6TmLB6+sWeqc5HjR9gUyRnHvBCo4gy135U2MJNzp8V8/ZLzSWu0DJaW8Z0QUAOrQWQb2AC3SE8/VRsDYZw0V9efMXXV7goxa0HoeYsg71pfMcgOapKxuKRl6Ey9tWUooj2poyyUwly/9F2ngE1fsJynFEhhyuS0FUguzoxi66yPlkjGBpT6ilqpKOm3j0noLPXrakaGvKKbdODhiXScLyxwZXGaUXM2nKWoIjH+FMeJ6uCaCRfea7bG8zw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(5660300002)(4326008)(8936002)(8676002)(41300700001)(54906003)(6916009)(356005)(40460700003)(81166007)(478600001)(2906002)(316002)(70206006)(70586007)(9686003)(53546011)(7696005)(26005)(186003)(16526019)(336012)(36860700001)(83380400001)(82310400005)(426003)(47076005)(6666004)(82740400003)(55016003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:50:16.4139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85faefbd-ba71-4e73-3a7d-08dad179c5b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7163

On 24.11.22 10:35:27, Dan Williams wrote:
> In preparation for devm_cxl_add_endpoint() to call out to
> cxl_rcrb_to_component() to map the upstream port component registers,
> move devm_cxl_add_endpoint() from the cxl_core to the cxl_mem driver.
> This is due to the organization of cxl_test that mandates that the
> cxl_core not call out to any mocked symbols. It also cleans up the
> export of devm_cxl_add_endpoint() which is just a wrapper around
> devm_cxl_add_port().

The last sentense is unclear to me? I see you just make it static as
there is only a single user, do you mean that here? The change itself
looks good.

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Robert Richter <rrichter@amd.com>

> ---
>  drivers/cxl/core/core.h |    8 --------
>  drivers/cxl/core/port.c |   39 ---------------------------------------
>  drivers/cxl/cxl.h       |    2 --
>  drivers/cxl/cxlmem.h    |    9 +++++++++
>  drivers/cxl/mem.c       |   38 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 47 insertions(+), 49 deletions(-)
