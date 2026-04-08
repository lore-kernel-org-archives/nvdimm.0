Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010064.outbound.protection.outlook.com [40.93.198.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE73603FB
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 21:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684384; cv=fail; b=T7PXmYtt3J7snKPE3GUonhoAE+xYH0gWrl5RwQ4FbzfbvrfNA/PxbPkHHUOx/8H98aOKUX0Jz6Ok1J8O6+B4/QUPp3M08p0KEzzcgwM/63KqUwfbBVvhiRHwUt9/Z+eSWjPRzYswUOZ1kmrQ0QlvcPTDsGVpId2/eVmQF/KSVek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684384; c=relaxed/simple;
	bh=8d2QGBUTpEdaU8mw1SNYGu1CmGKLQO+5hai9PJdS1V4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=iP2yytBq1lOp8zj1JjSCi/w22s2Fp5UcDO67g82VODU8Ss6YvDYUELfIDUXJJltvIBFlPukujSexxdm5cmZzUyX99iUCOYTxeulyWXYBgcqYD3uXdNYPcasXCa+blYis/RIOwivNC5G73uxN4Dsan/1HPWj0lNpyRCIPzPgOnsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pP7hp4N3; arc=fail smtp.client-ip=40.93.198.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pP7hp4N3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGGFzL0q7vYIqQuhIQDJw25HJ+/z9Kdusik++lf4C3xmkqgcjIj6JjSC9VKY8Xm2EmHINEuBDStQ2I1aVZQUcHwVYxQmqJ3gjU9hIchfIgm+oc7w89BU4HHaPk5Dc0WYC4/sHouC3MtBwv50l2cFnCGwhHaolMsApJS0De7537eTLesTtsoh3P3Nnnk/hpdFxauJFPqpR4fxPdUU07Y1/VLB1xNJargBv/mc4bP170ohJiRdxTDpiAIwPtppm0q4oKVi14BBr9zyug5rW1pD+iUTTwwK0TBdthNq7AS8msENEUBy2NIc0uiqZ59Of2aedFUUv53H3HXBU9IpuVnlRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tC07lowYk8TsxNe5tjKmrJOuZKy5srMJwyz0DpMPQ40=;
 b=YYz62l+SYc3cQQkP8Xyjocdy3B1fUIBwHWKWw+UaKFaqPYH7lHW2yaTkcIfNQjhGE1mE6Gtwx20dY16Q/LKw2M0pksPrOx9JfQm62HqKESGDBaFiqJhUgMI+cQPNyC23VCy9Ymw3AJqWG4/Ro5vjJuJ0hjDfwzdPws4HqozENgNdxjqcZ6bepaIis0BvfLS2HMfwwxa3ugqdTPTDk1xUnh1KfxTIq/LpGv0MCtdD5om+Z5uuHYoSXTA1lmsFgH9Ap/RLQikKayy+i1NUWzF5ERdrvPkQDF1n+OJk2lQvP7OajCjyqPxRBcEDev6syci99rG7ULLv24WA3KiWAEq3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tC07lowYk8TsxNe5tjKmrJOuZKy5srMJwyz0DpMPQ40=;
 b=pP7hp4N3PCi9Kximi1uyUPKdTsC6/N8phQK70cdjYYaOp1qbo8UBmTW89CWeGf6pdOXSpkKb6kLyMODx1K6qM1OPXTAg7aZC+oBQ5o8KQlqYJpl3gsYtl0HJCK90BcU+dkMT9YAJLA1EKjaToIz7FvGnyzUg1yQEXdXqPzeDbqU=
Received: from SJ0PR03CA0280.namprd03.prod.outlook.com (2603:10b6:a03:39e::15)
 by DS7PR12MB6119.namprd12.prod.outlook.com (2603:10b6:8:99::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.19; Wed, 8 Apr 2026 21:39:37 +0000
Received: from CO1PEPF000075EE.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::8) by SJ0PR03CA0280.outlook.office365.com
 (2603:10b6:a03:39e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 21:39:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000075EE.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 21:39:36 +0000
Received: from [10.236.182.193] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 16:39:35 -0500
Message-ID: <3123850e-fc7e-43ff-9e54-e2b79f12f074@amd.com>
Date: Wed, 8 Apr 2026 16:39:34 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Subject: Re: [ndctl PATCH 1/3] test/cxl: Enable CXL protocol error testing
 using aer-inject
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
 <20260408203231.962206-2-terry.bowman@amd.com>
Content-Language: en-US
In-Reply-To: <20260408203231.962206-2-terry.bowman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EE:EE_|DS7PR12MB6119:EE_
X-MS-Office365-Filtering-Correlation-Id: 444dc5b9-392a-43fd-3e7d-08de95b754c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700016|1800799024|921020|13003099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lCb6OvuYhxHQbN7exvkYzD2ZvkTqY1exdaImjr0r9lLpTGZRml6uGfkJ6NebmWhe79xWm5sQjvmTs40RMQ9+RjcLEiblJJrmGrFlJOvGws3hkBr13wQ2uucMPK1womUexhcEpJ0yRpifP3hZ3nhqIiE7ylZqcpCQnRAHOuDnzhqXjN22PyXG78uCUQX8/FMU8v5cObJIWHftplF897LuqsktDeXzcz21NXC+uW3bObIfuggctesE+M/0a3tIFzOD7WvAZNejY9Nk6rTh+Kk21D5ORODw9Mya9Gw9DBGrfZMGCBvEKi5CQPIfeLuuS8MXW4VJTuHRmg4pyecXZgxVbikngPdCMBJeQh4yKrlp0dQNI/JEkukj/09G/7tgIpRkxVa9irLXGzzioX6njpBv8GxMu02JyJnjlTBLTNI0D5s3sleXW/xZDqdF9TGraABmkf9uSrkVMM+309kxYOShEogwTxJD/jetoZ6omHXdBwVhyvpMybVZfAcz4A6eVp1RB1Qx6A2V7zcfOXVA/OoHDYhKMKxQiNtMNVJ4purb9itlPFTwgeHoLOfBfFX9HiXuPdscrAS6nIk9zUgFIp/OuSTO9hKD6V7oxqnp8sQtL7OjtRbflYhYqnIqZeqkCJ+6SWnUCdAAR8BXtk6lvNRppa3cEJWemPacV0A/F6/HFGwUOKy53LT7I6SSMB9HQ8K4Am2rcOn0u1oRDDMTSFeM3uoUuDN3MhRRiDmTbOLdQP7FgOvX2J/1g+lH6YoHgTwCR76oEXPrGNc/quXVcbapxs4Z7/ZVX+kf1LqllQeKKtMtbpyAT4iJ9Via8pNaX+mYachBFw6OX0M6bOTg54tOEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700016)(1800799024)(921020)(13003099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e44+LARgK5qXvqUdIrtn3T65Mp7BZVCCCoYlGOmSdn1rKsXyi8H3bXgAl4Oi4tSDxN+VO2dlYyKa2qJuVujO4hbzgJhY2z6iMHwJB7kHfm2oWC/s8z8QhQ+4f3xRqhxO9SVj104QPwcsdUd1XaQJv+H/u3MzqBr+zDQW3nMPN/8GcgP55pE1eD6xSb8qcy6J65XXgZadMVa21rFU9h3AdiRztk481iDttMx3PgsJv1bnFONCFsxwRodIEcsjcmamrRWNb5+Gg8rnp1VNo9fo4E5RgQGHeqR7aBVXYt8UeUk84smL7ToDHzkteD/Jp6+ax2ngD73WqYRpjVFE11BEmZlOG3ZZoK7c2XhhzT6XOXxHa1/1ZBJRUVO6M5qQDHdqg6fiZeq+rYgZYGFv4InDylPkWZD+gSHeWNBmN7dzuCX7EF9D3ovUtd6G38Q2pFXH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 21:39:36.5411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 444dc5b9-392a-43fd-3e7d-08de95b754c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6119

On 4/8/2026 3:32 PM, Terry Bowman wrote:
> CXL protocol errors are signaled to the kernel's CXL drivers via PCIe
> Advanced Error Reporting (AER) internal error types: Uncorrectable Internal
> Errors (UIE) and Correctable Internal Errors (CIE). These errors in-turn
> trigger RAS handling paths in the CXL core. The `aer-inject` tool has
> lacked the ability to generate AER UIE and CIE events, making it difficult
> to verify kernel handling without actual hardware protocol error conditions.
> To address this testing gap, this patch introduces tooling and scripts that
> allow for injected CXL protocol errors to be delivered to the CXL core.
> 
> This change adds a new `test/contrib/cxl-aer-einj` directory containing:
> 
>  - A README with instructions, prerequisites, and caveats for simulating CXL
>    protocol errors using UIE/CIE AER injection.
>  - Example sed commands for hardcoding ECC cache bits in CXL RAS handlers as
>    a debug workaround for testing with zero hardware status.
>  - Scripts to enable CXL tracing and to invoke CE/UCE injections for root
>    ports, upstream switches, downstream ports, and endpoints.
> 
> The below patches are required to complete support. These patches will follow:
> 
>  - Patch (`0001-aer-inject-Add-internal-error-injection-support.patch`) for
>    `aer-inject` to support UIE and CIE injection by defining new constants and
>    updating parser rules.

I have no clue what the aer-inject PR process is, but I'd expect that to be added in that project
instead of this one. If it isn't maintained or private then I guess this can work, but it's probably
out of scope for ndctl (if I had to guess).

>  - Kernel test patch ('0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch')
>    to force setting RAS status.

Same thing for this, but I'll save comments for patch 3/3.

> 
> With internal error injection support in `aer-inject`, developers can trigger
> RAS paths reliably in the CXL core and validate their protocol error handling
> logic without relying on physical fault conditions.
> 
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> ---
>  test/contrib/cxl-aer-einj/README.md           | 80 +++++++++++++++++++
>  .../cxl-aer-einj/scripts/ds-ce-inject.sh      |  4 +
>  .../cxl-aer-einj/scripts/ds-uce-inject.sh     |  4 +
>  .../cxl-aer-einj/scripts/enable-trace.sh      |  5 ++
>  .../cxl-aer-einj/scripts/ep-ce-inject.sh      |  4 +
>  .../cxl-aer-einj/scripts/ep-uce-inject.sh     |  4 +
>  .../cxl-aer-einj/scripts/root-ce-inject.sh    |  4 +
>  .../cxl-aer-einj/scripts/root-uce-inject.sh   |  4 +
>  .../cxl-aer-einj/scripts/us-ce-inject.sh      |  4 +
>  .../cxl-aer-einj/scripts/us-uce-inject.sh     |  4 +

These paths are somewhat redundant. There's already a scripts directory, so I'd put all of
the .sh scripts in a cxl-aer-einj subdir in the scripts directory (so ndctl/scripts/cxl-aer-einj/*.sh).

As for the README, the contents would be merged into the inject-protocol-error documentation and the
file removed (see my comments on the cover letter).

>  10 files changed, 117 insertions(+)
>  create mode 100644 test/contrib/cxl-aer-einj/README.md
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/enable-trace.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh
>  create mode 100755 test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh
> 
> diff --git a/test/contrib/cxl-aer-einj/README.md b/test/contrib/cxl-aer-einj/README.md
> new file mode 100644
> index 0000000..d31b572
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/README.md
> @@ -0,0 +1,80 @@
> +**Testing CXL Protocol Errors Using AER Injection**
> +
> +The `aer-inject` tool currently does not support injecting internal errors such as Correctable Internal Errors (CIE) and Uncorrectable Internal Errors (UIE). By default, internal errors are masked according to the PCI specification and are rarely used. However, these internal errors are now leveraged to notify the PCI and CXL subsystems of CXL protocol errors. The attached patches enable support for CE and UCE internal errors in `aer-inject`, allowing you to test CXL RAS functionality.
> +
> +**Important Caveats:**
> +- `aer-inject` will only inject AER errors and does not inject CXL RAS-specific errors directly.
> +- As a result, functions like `cxl_handle_ras()` and `cxl_handle_cor_ras()` will detect a status of 0 and exit early, which hampers testing.
> +- To work around this, a debug patch must be added (example included) to hardcode the last RAS error status in `cxl_handle_ras()` and `cxl_handle_cor_ras()`. While not ideal, this workaround facilitates testing of the software paths involved. This is addressed below in 'Patch'.
> +
> +---
> +
> +### Prerequisites
> +- `aer-einj` tool from: https://github.com/intel/aer-inject
> +- Kernel configuration options:
> +  ```
> +  CONFIG_PCIEAER=y
> +  CONFIG_PCIEAER_INJECT=y
> +  CONFIG_PCIEPORTBUS=y
> +  CONFIG_DEBUG_FS=y
> +  CONFIG_CXL_PCI
> +  CONFIG_CXL_RAS
> +  CONFIG_CXL_PORT
> +  CONFIG_CXL_BUS
> +  ```
> +  
> +---
> +
> +### aer-inject Patch Details
> +- The patch adds support for injecting both correctable (CE) and uncorrectable (UCE) internal errors.
> +- The patch is located in `./patches` and should be applied to the `aer-inject` repository, based on the master branch (commit `81701cb`). The patch is '0001-aer-inject-Add-internal-error-injection-support.patch'.
> +- Additionally, you'll need to apply a kernel-side workaround by hardcoding the RAS error status in the relevant handler, as described earlier.
> +
> +### Kernel patch Details
> +Below is patch to set the RAS for testing. 'sed' scripts are also included 
> +
> +#### Kernel Patch to set CXL RAS status for testing
> +Setting CXL protocol RAS status, is based on v7.0-rc6 (7aaa8047eafd). Patch is:
> +0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
> +
> +#### Script to set the Kernel's CXL RAS status
> +##### 1: Correctable Errors (CE)
> +```bash
> +sed -i '
> +/void cxl_handle_cor_ras/,/}/ {
> +	/status = readl(addr);/ {
> +		i #define CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC 0x1
> +		a\    status |= CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC;
> +	}
> +}' drivers/cxl/core/ras.c
> +```
> +##### 2: Uncorrectable Errors (UCE)
> +```bash
> +sed -i '
> +/bool cxl_handle_ras/,/}/ {
> +	/status = readl(addr);/ {
> +		i #define CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC 0x1
> +		a\    status |= CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC;
> +	}
> +}' drivers/cxl/core/ras.c

This section probably isn't needed, see comments on patch 3/3.

> +```
> +---
> +
> +### Testing Procedure
> +- The provided scripts illustrate how I ran the tests. You'll need to modify the scripts to use the correct BDFs for your system.
> +- Alternatively, you can run the tests manually using commands like:

I think you should drop the scripts. If the user has to manually change half the script to make them work, it's probably better
to just give an example or two and let them make the script(s).

> +
> +```bash
> +aer-inject -s ${bdf} examples/correctable.internal
> +```
> +
> +and
> +
> +```bash
> +aer-inject -s ${bdf} examples/fatal.internal
> +```
> +
> +*Ensure you replace `${bdf}` with the appropriate PCI BDF for your device.*

Should probably be renamed SBDF instead of BDF. Most systems don't use the S part, but I'm sure ones exist that do. It may be helpful
to also mention how to find the SBDF (i.e. an example 'lspci' command), but I think anyone who needs that probably shouldn't be
running these scripts...

> +
> +---
> +
> diff --git a/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
> new file mode 100755
> index 0000000..c0e3417
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
> @@ -0,0 +1,4 @@
> +#!/bin/bash
> +bdf="0e:00.0"
> +
> +aer-inject -s ${bdf} examples/correctable.internal
> diff --git a/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
> new file mode 100755
> index 0000000..e238f63
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
> @@ -0,0 +1,4 @@
> +#!/bin/bash
> +bdf="0e:00.0"
> +
> +aer-inject -s ${bdf} examples/fatal.internal
> diff --git a/test/contrib/cxl-aer-einj/scripts/enable-trace.sh b/test/contrib/cxl-aer-einj/scripts/enable-trace.sh
> new file mode 100755
> index 0000000..753419f
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/scripts/enable-trace.sh
> @@ -0,0 +1,5 @@
> +#!/bin/bash
> +
> +echo 1 >  /sys/kernel/debug/tracing/events/cxl/enable
> +echo 1 > /sys/kernel/debug/tracing/events/cxl/cxl_aer_correctable_error/enable
> +echo 1 > /sys/kernel/debug/tracing/events/cxl/cxl_aer_uncorrectable_error/enable
> diff --git a/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
> new file mode 100755
> index 0000000..3077c3c
> --- /dev/null
> +++ b/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
> @@ -0,0 +1,4 @@
> +#!/bin/bash
> +bdf="0f:00.0"
> +
> +aer-inject -s ${bdf} examples/correctable.internal

If you don't want to remove the scripts as per my suggestion above, I would at least consolidate them based on the examples/* file
they use and make the user give the bdf as an argument. For example: ep-uce-inject.sh and root-uce-inject.sh would get turned into
something like "uce-inject.sh".
