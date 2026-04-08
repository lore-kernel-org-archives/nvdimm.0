Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A7B3537DE
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 21:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684361; cv=fail; b=XUiBCE8lGwoZ1ZZroONPDiTkYLh8yByJcGJxgAO2Gr9T3i+kgvPfX5z7GAbYg19Vq860uzal/z+OfDO+GxxdkRPaKiarl7yLzGO2JYofsCduFMNN4VROVvF7duzdRYAGpeow0zoIuO1FfRvhN8vDA7TRCQ1mDjCDcfWFOl4OW74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684361; c=relaxed/simple;
	bh=Hi7hZV3eS/r9jUJmzbxtlizT1lrebhF2ZoqC6N8oq80=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=EPLbN6T8uzEnAZ0awE8ei+tpGdW49kJkdc0PW5/BvO0PkHj+3L2gu1sDk3BQOzYWowRQDlcsEWwyo/bbtoUH7VqbqsrBISZM/6HcnW0uKfI5EMD1SjLotMUyfxrKp6nM55B3QuJXkryMrUmGs3ywaINrDW7LTPMQtFAQIsDEOGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kO9VqjGz; arc=fail smtp.client-ip=52.101.193.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kO9VqjGz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+ZXph670x6ST9BglXQnOM2AzD7lixGuAi3+j0GXQMwAOjuO0kR4ovOuNU+u0yHWsA7yy317b3doESAbssEI93msIx9AY5d5h12t+AxEQsO/moafVuH9vUEFfolsOjOE/n5Rj0uTmTZ/Rdiva2BD0PRZ1F8fDJanGAeG+IXPW8nKwNH8mrzU8g4ZCkeWOAJJ8fVAR8krDym/361sgCPkcS3FMULp2Q1Vkid8BOKC6XR6tLC1JzeqZ8CzdMCBg4RhFbkl941VWMt2T1HOLA7Bbl5bpdKMwVquW3roztOUpN3nDjRs09BYhTjc2hG5iz9tkRdY6ZR7Ip6X7Z6SGyJyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Zz9f7422V/gdbxgVnzFcom+uAD5SNubncY4ijkQ1rE=;
 b=yXjQaYNDbMr56eckDbta1w3xmuM5t2bz53zIZtDOGLbdBMj/TIC8Eg9Xmuy3cxuUjZdmRboO/m0gwwgERKgP3rP6RlxB2Qn1xlL0677oMCjS5ayFzM1J5Cm3buro71DRYIUPJ/DY13+1zoxt5Ea5bVJKATAYJz68qtx6szwB/u71v72U9wdpOUOem630Tsfdpn6VUtbmNG+M5L+b8A/3Dwvh1TvwCb/IqiO0ZDvzx6eYZ2jcsCKNXkU4d706BNU7E/6fuDhk1eWOUZvuvJA/EcufseFAv3LasTCTCwmDY6RniE91S0PBMHgTH+xPBr6B7GZWYYP5e6BNTSswkiBP/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Zz9f7422V/gdbxgVnzFcom+uAD5SNubncY4ijkQ1rE=;
 b=kO9VqjGzyXPugm82bDSPVMZO4S05CLmINiQ3M5ohGDWW5uSkGCCQSuLv9GwTDurILe78HARpHZFoOBwAGMleLWXamlj4+5g57Xhb8Oa6J9SD02BAFX4WUOkOWGof2SIYcTd/Ip4B+jbIRxW/UsgdvVPfI4p2u6ltaqtKrjx6WUk=
Received: from MW4PR03CA0126.namprd03.prod.outlook.com (2603:10b6:303:8c::11)
 by MW5PR12MB5597.namprd12.prod.outlook.com (2603:10b6:303:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 21:39:15 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:303:8c:cafe::da) by MW4PR03CA0126.outlook.office365.com
 (2603:10b6:303:8c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 21:39:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Wed, 8 Apr 2026 21:39:15 +0000
Received: from [10.236.182.193] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 16:39:13 -0500
Message-ID: <bd2f87e6-2ea5-4165-8c4b-63b445492c93@amd.com>
Date: Wed, 8 Apr 2026 16:39:12 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH 3/3] test/cxl: Force RAS status in
 cxl_handle_cor_ras() and cxl_handle_ras()
To: Terry Bowman <terry.bowman@amd.com>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<nvdimm@lists.linux.dev>, <alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>
References: <20260408203231.962206-1-terry.bowman@amd.com>
 <20260408203231.962206-4-terry.bowman@amd.com>
Content-Language: en-US
In-Reply-To: <20260408203231.962206-4-terry.bowman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|MW5PR12MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: ac988202-ead6-4926-9db7-08de95b747ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700016|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xA+/z4WmrNlLo0cAMOMVKia1l+H92hxJosxlXGXdvKc6epAZaC4bTPFE6/56lU/9ADnxt7WQBslPeMTm9DahEhRIeuJYEv1UC9Wkm9Za+Tnkkjv4AhVK3ijHHqLAh00gZt12hibSrwn/spCi+qxXpjDGx9Ca0XP6l/QGcRn8Dl8rfiDzDrOyjCKArMTUINEjze5cS34ASvCCheGv2Arz46whSgJRU3UMi6zzyb2F+55s7EW6TX6Z/BnhfsFKUkxMS0VQQh8M2+r7PubYhHo/hIULn47Zoxz6z7Q6zwm+E+nXhKfAoaWjcqyw+1n21YBziLxh7OqRXKksz1qlCZ2BKHnkzjL3D4yttcmRIVnLxpiptbUiExS4agajbaSvqVYS3PNrAgLiDVPbFb1eRciUlff1S+OG85XB2gs+Ip7/UkCx10DhEJrLqU9H2ylBLfz3DjG+hF91bleCoJBAa1NIcaNPuLy4sG8sRuTurvYP6s6Qw1x+8SzXhTbCD3BePtSQxbOaOFly8mvq/1BXiURGA+8GeG9kgViGh0sK8aveLIzfkqvm7WPhJIiQ134h2jD6X7Zu/x0Byve8QahUIFfbhgxx8DLKYilp29TMfeXnBUFo+y7w+wGpbRf5Nvt715KzXyqmabZpotZu94XTmt3PAcrhv4x7B4jtF1+cSxC0Rgogu+/XZ5JvFvb9Te5ZHC7uPKYVM49FD8BKUIH/gjz6gkaqStZQGwHuqT7Mu/zyxJLjLk4TSBjJ3QbZcTnhOlTilYJKHUPgXHF7ub8bFhoIzkNt3FlHX9o0qhkFKJjEkwuH7FK89/TrSEEqyxpjEzke
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700016)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xFYSrYFqOUwPPdVe/kroqKs+1BOUKxYaY2pY/mKCn8tv+9p+eeh0ycB6uGmXTLIL1iV5LLMk9Fe2BzkdLvBBX3G+zL3PoO+6cTKUswIZzdCUzNVAEJyRMyS0iGYIuJQFt87RzjyaR+bHo6xKYgQxHffd07o3uURhRFJ56R7wVRpUhef6YQzcLpFFQ4Tgall7xGPN+5iMst7vBwygbh2e56fBn3Ld1N6aA7b/aGQ9z2TQKM3a3WT/KEffaWjUoblAXCPKT1D3Xppoor7VIDCxI+h339r1zQA8q86P9MtCQtQDpXoDiyoW1Scz5H6SVOAu2ju0yE13ntGdgjGpPKVeORaHoh2SaWlhk8rFuM4AMLBoLMJn61BJ46AmWCoyMMtf5xxAiZ4REJzOaDIiapVt4pUT4pOpvvpBEGF+vCKTLyiAy5gZ21W8m6D+MyJLhfvy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 21:39:15.0514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac988202-ead6-4926-9db7-08de95b747ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5597

On 4/8/2026 3:32 PM, Terry Bowman wrote:
> CXL RAS error injection (EINJ) is present for Root Ports but not for other CXL
> devices. Provide the means to test protocol errors for all CXL devices
> in a testing environment. Use 'aer-inject' userspace tool to deliver AER
> internal error notification which will trigger the CXL driver's RAS
> handling. Hardcode the status for CE and UCE errors in cxl_handle_ras()
> and cxl_handle_cor_ras().
> 
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> ---
>  ...AS-status-in-cxl_handle_cor_ras-and-.patch | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
> 

The below patch should just be sent to the kernel list. I'm not sure you can create a cxl_test wrapper for cxl_handle_cor_ras()/cxl_handle_ras()
since they're in the core, but that would be the ideal situation. Otherwise, you could create a Kconfig symbol that's explicitly for testing
and create stub functions to force the values as needed. Basically something like:

cxl/core/core.h:
#ifdef CONFIG_CXL_RAS_TEST
#define CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC 0x1
#define CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC 0x1

u32 cxl_ras_uncor_readl(void *addr) {
	u32 status = readl(addr);
	return status | CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC;
}

u32 cxl_ras_cor_readl(void *addr) {
	u32 status = readl(addr);
	return status | CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC;
}
#else
#define cxl_ras_uncor_readl readl
#define cxl_ras_cor_readl readl
#endif

You can obviously consolidate the uncor/cor versions, but I'll let you figure out the naming there ;).
Can also be a bit safer and create static inline functions in the #else, but I just went the easy route.

> diff --git a/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch b/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
> new file mode 100644
> index 0000000..d8562cc
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/patches/0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
> @@ -0,0 +1,51 @@
> +From 1b4054d82a1834e211ef3f284b9f51926db8f060 Mon Sep 17 00:00:00 2001
> +From: Terry Bowman <terry.bowman@amd.com>
> +Date: Tue, 7 Apr 2026 16:47:45 -0500
> +Subject: [PATCH] test/cxl: Force RAS status in cxl_handle_cor_ras() and
> + cxl_handle_ras()
> +
> +CXL RAS error injection is present for Root Ports but not for other CXL
> +devices. Provide the means to test protocol errors for all CXL devices
> +in a testing environment. Use 'aer-inject' userspace tool to deliver AER
> +internal error notification which will trigger the CXL driver's RAS
> +handling. Hardcode the status for CE and UCE errors in cxl_handle_ras()
> +and cxl_handle_cor_ras().
> +
> +Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> +---
> + drivers/cxl/core/ras.c | 5 +++++
> + 1 file changed, 5 insertions(+)
> +
> +diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
> +index 006c6ffc2f56..09ff82973c70 100644
> +--- a/drivers/cxl/core/ras.c
> ++++ b/drivers/cxl/core/ras.c
> +@@ -183,6 +183,9 @@ void devm_cxl_port_ras_setup(struct cxl_port *port)
> + }
> + EXPORT_SYMBOL_NS_GPL(devm_cxl_port_ras_setup, "CXL");
> + 
> ++#define CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC 0x1
> ++#define CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC 0x1
> ++
> + void cxl_handle_cor_ras(struct device *dev, void __iomem *ras_base)
> + {
> + 	void __iomem *addr;
> +@@ -193,6 +196,7 @@ void cxl_handle_cor_ras(struct device *dev, void __iomem *ras_base)
> + 
> + 	addr = ras_base + CXL_RAS_CORRECTABLE_STATUS_OFFSET;
> + 	status = readl(addr);
> ++	status |= CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC;
> + 	if (status & CXL_RAS_CORRECTABLE_STATUS_MASK) {
> + 		writel(status & CXL_RAS_CORRECTABLE_STATUS_MASK, addr);
> + 		trace_cxl_aer_correctable_error(to_cxl_memdev(dev), status);
> +@@ -232,6 +236,7 @@ bool cxl_handle_ras(struct device *dev, void __iomem *ras_base)
> + 
> + 	addr = ras_base + CXL_RAS_UNCORRECTABLE_STATUS_OFFSET;
> + 	status = readl(addr);
> ++	status |= CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC;
> + 	if (!(status & CXL_RAS_UNCORRECTABLE_STATUS_MASK))
> + 		return false;
> + 
> +-- 
> +2.34.1
> +

