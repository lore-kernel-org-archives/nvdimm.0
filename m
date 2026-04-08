Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6B73D9DC1
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775680376; cv=fail; b=KeqeNJ0FzQhNGxUtCi7jEygpThs4os6q+x4XIec45TG5p89Nhrw/sIp1DGr/QlDzeha8+fB0bOmX50HOHXPE4OuJwu63KXoczId3eXLzU9zjUjavZjXY0G2EfyTuR4TOMzebvH47ZEesFseOOHHvXr0V5kdR1JpONIZ7F2LeYe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775680376; c=relaxed/simple;
	bh=BhrI/yL0HKIbb0QrYt+509GicOBBXZ8Cz8hpXdu9FKI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FFBK1fqV/M4MMyqJGTweAaPWKjAw6km5KnI3lm/D0lTDcETb6zB20Mvfx2uwzRsHTQ6gjj+CN3cm6qn0pAzPRh4jT2musfLScP9v5m6gRCqgyjHS8R8EyhNDzrMBthXgNATIsc+TBojwTkvw7/oTcW/SbUZJnwBz28lRp/L2pbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EWfSF9ql; arc=fail smtp.client-ip=40.93.201.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EWfSF9ql"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evt6ZIOrVS676FOXeG8v0MCP54YScVX2qoPVbr4mIYXnLlm81FAjlfyf/bHd/AC/+bD/q91Jt86BO4L8Dmh4vWfM4dkqzuvQPFNGQIxu6D7p1ziEhWrubhwskIw8eirN5cI4NIJvb38S2rNaezT/hgapxlUn2Yu9Gq+r30XNW8gOq1E/M2dJDIfdzGvx/EzA0mE6z4bw9BDjRVnw3kQitoNcAeD6DD+A4eGe/kuy0yWsdFl39Vcq2UyugvG6baltlUH3Fi9Q6Ij9BcDR6n7CVzoU8QLbK3VuWXckOpkoJvWSlWbHORUmCMQsPv078bHv+cKp1Jkwa1GcXnC7xBu24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DXKGPbyZMZhViiQOeuTPUlY6tYfyPSlGSaO2rR7IEA=;
 b=oi9HhPNaVWPeHrB5jtegNXcRvfGZ9bhRbLivChVi84Q1Eg+ZIj/U5km7UnDAfl4Q7H3ZKJO3u6gEt69oHIOMfwT7G9GPs4vZTcTKr9w7H67xJIeGkUHU00CJ79OqISNv7Fw6ln3PuqemWU0gG6IE/RvusNSD75XZxrHF7YqtOuNJmHYvkis+0ph1LqVSHqVw7AuNZGqKMk6pDMCFQq/hLdCGs02SbrCYZcUiMAA65RYHPuqkTpPf2nXlOqm22ZfKr/sfh8UxLteEPYySZv5FsHl/woTU3oJjag0w1VRSqMIbR2WtIrSHt/wtRfIe4vdQ2ImgHJ3iRCfqHcpnK2Xvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=stgolabs.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DXKGPbyZMZhViiQOeuTPUlY6tYfyPSlGSaO2rR7IEA=;
 b=EWfSF9qlOkgoNVgS9Q7iRpDrNRki0VY7a0oyNUcQn0MjRfkymlNSaxz6wThpGuNa6JltR+6eGrBO3kfTS9GjlUK2RT4XClX4aleYFmY5xhWmUxm6nYcvUlESEsMIskY7ZsB0P0d3TVtLFFfRmUXH6Fo4UKU9zVd+Vt6rEuanvtc=
Received: from MN0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:208:52d::21)
 by SN7PR12MB6839.namprd12.prod.outlook.com (2603:10b6:806:265::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 20:32:49 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::c9) by MN0PR04CA0022.outlook.office365.com
 (2603:10b6:208:52d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.37 via Frontend Transport; Wed,
 8 Apr 2026 20:32:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 20:32:49 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 15:32:48 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<dan.j.williams@intel.com>, <shiju.jose@huawei.com>, <ming.li@zohomail.com>,
	<Smita.KoralahalliChannabasappa@amd.com>, <rrichter@amd.com>,
	<dan.carpenter@linaro.org>, <PradeepVineshReddy.Kodamati@amd.com>,
	<lukas@wunner.de>, <Benjamin.Cheatham@amd.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<alucerop@amd.com>, <ira.weiny@intel.com>
CC: <linux-cxl@vger.kernel.org>, <terry.bowman@amd.com>
Subject: [ndctl PATCH 1/3] test/cxl: Enable CXL protocol error testing using aer-inject
Date: Wed, 8 Apr 2026 15:32:29 -0500
Message-ID: <20260408203231.962206-2-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260408203231.962206-1-terry.bowman@amd.com>
References: <20260408203231.962206-1-terry.bowman@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|SN7PR12MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af8c520-e2c4-4261-679e-08de95ae0039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|56012099003|22082099003|18002099003|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	1XFTJIzSffnAuI6rQ0RB3xoSpcWEPOq/X2TW/nZ3cRxdvks54+1jslRza3oMeVuslANwteS2ZHg1OidsS1RKcloVJNbmZI6t0SxcF9+PqLtfW8NaQqc0yloks1HwON4nwaposMW0UzeHJ5AwedhmP5TjDyafttgpxIdJ2b8DMJu5dSu8r9by8/+nYwgr/meprG9P/Duu8a5aNrgF2moif4m4vWdsVzkQNQVO/sMHA4xBk+Klyd8p5sdXTATO9/rTCGcyoBuYRaEXrpLm17s5/AP+2BCaYHKSF6XUHycLQyHgI+9o+uJkl+fdM190VrrYer6H2Y6HETOeKkoDxexbzuSyGetW4PK7eWscBqmdlW0xaS0R9GRfgdAG7diKbkJa98MvzKm1LsLRBfR8NWTKvc4AKmOjzO0w+SeIWAzyV3qAhzt+BKhUZVEqpGo8RuWjPtoW0/NsyyZSQ6uFAHA9ptOMNJigRbu5hPyL79VlRaEJVZDi1s2idhf9h0/RQi1T+G72FXUXvt6Uvf0qH8NvpKMVU14/FihXNrpe2XLcdUwEq7mur5QqppLWT7bNlUYI/Zc4IFf8hNa2sKrMiqv6OWLd7iiz0pMTvD3jFfhAH4d75TIHi+Fa4pexhE+Uwi4aOG7wDY3Gz8RSiC1GFobHV/uWljhBbdciSBs6g1uj+i7isfP10R0BZXGnclh/qJ/xLNw8XbKV75MpvFVUF9ZFmSFKxbsKIc+bLWId78uIXFugANzgzkDDonvBec25MeyjXkI+NpQnwJBS8IwV0HrXpGZRv2GoAjyckWrUe3L15QdqjnszXiICc+WOJ8eSxPqC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(56012099003)(22082099003)(18002099003)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OvJqy4Q9pTP1ww7VbxtPt4Oknc7utZmcHWVcjUtQ4gfbxSHp1xAPubzTOzr5zNi1EuCfDVpv1/WmHusTd/UYwwul9zvVrQfTJ0z0lk+FtqEiqf3wd1fOeCJMVTM5RxtODkYFU0+NUsbjhaUylf1Y2bcjCTym0zoYlrgQpK+J6ofYyyLmMmSNA4YkTxWug3q5tf0xGpl2h+gSJdnbVcySjSxeayKeaKNQQ25GrXRqKiEQFyA6k0g7BCxKIQnXggee5Eg+DGWedMi9c+pncF26sNf7IQafGtwLMEG6nN973NVN1vRxVywc0CIuJ1yQOrRyEHXcUxTz+6QZ8OviEIbt2S8yPcaW5eWpe1fIFZdK4Wre6eaKvmIS/AQAsIzbPRvb5DQcnOCJ//QYBTmMY+NKI6/uWdUL3kOqC91SvBR46lOccdIimT9v71cz6Xx+9kdS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 20:32:49.3362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af8c520-e2c4-4261-679e-08de95ae0039
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6839

CXL protocol errors are signaled to the kernel's CXL drivers via PCIe
Advanced Error Reporting (AER) internal error types: Uncorrectable Internal
Errors (UIE) and Correctable Internal Errors (CIE). These errors in-turn
trigger RAS handling paths in the CXL core. The `aer-inject` tool has
lacked the ability to generate AER UIE and CIE events, making it difficult
to verify kernel handling without actual hardware protocol error conditions.
To address this testing gap, this patch introduces tooling and scripts that
allow for injected CXL protocol errors to be delivered to the CXL core.

This change adds a new `test/contrib/cxl-aer-einj` directory containing:

 - A README with instructions, prerequisites, and caveats for simulating CXL
   protocol errors using UIE/CIE AER injection.
 - Example sed commands for hardcoding ECC cache bits in CXL RAS handlers as
   a debug workaround for testing with zero hardware status.
 - Scripts to enable CXL tracing and to invoke CE/UCE injections for root
   ports, upstream switches, downstream ports, and endpoints.

The below patches are required to complete support. These patches will follow:

 - Patch (`0001-aer-inject-Add-internal-error-injection-support.patch`) for
   `aer-inject` to support UIE and CIE injection by defining new constants and
   updating parser rules.
 - Kernel test patch ('0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch')
   to force setting RAS status.

With internal error injection support in `aer-inject`, developers can trigger
RAS paths reliably in the CXL core and validate their protocol error handling
logic without relying on physical fault conditions.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
---
 test/contrib/cxl-aer-einj/README.md           | 80 +++++++++++++++++++
 .../cxl-aer-einj/scripts/ds-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/ds-uce-inject.sh     |  4 +
 .../cxl-aer-einj/scripts/enable-trace.sh      |  5 ++
 .../cxl-aer-einj/scripts/ep-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/ep-uce-inject.sh     |  4 +
 .../cxl-aer-einj/scripts/root-ce-inject.sh    |  4 +
 .../cxl-aer-einj/scripts/root-uce-inject.sh   |  4 +
 .../cxl-aer-einj/scripts/us-ce-inject.sh      |  4 +
 .../cxl-aer-einj/scripts/us-uce-inject.sh     |  4 +
 10 files changed, 117 insertions(+)
 create mode 100644 test/contrib/cxl-aer-einj/README.md
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/enable-trace.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh
 create mode 100755 test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh

diff --git a/test/contrib/cxl-aer-einj/README.md b/test/contrib/cxl-aer-einj/README.md
new file mode 100644
index 0000000..d31b572
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/README.md
@@ -0,0 +1,80 @@
+**Testing CXL Protocol Errors Using AER Injection**
+
+The `aer-inject` tool currently does not support injecting internal errors such as Correctable Internal Errors (CIE) and Uncorrectable Internal Errors (UIE). By default, internal errors are masked according to the PCI specification and are rarely used. However, these internal errors are now leveraged to notify the PCI and CXL subsystems of CXL protocol errors. The attached patches enable support for CE and UCE internal errors in `aer-inject`, allowing you to test CXL RAS functionality.
+
+**Important Caveats:**
+- `aer-inject` will only inject AER errors and does not inject CXL RAS-specific errors directly.
+- As a result, functions like `cxl_handle_ras()` and `cxl_handle_cor_ras()` will detect a status of 0 and exit early, which hampers testing.
+- To work around this, a debug patch must be added (example included) to hardcode the last RAS error status in `cxl_handle_ras()` and `cxl_handle_cor_ras()`. While not ideal, this workaround facilitates testing of the software paths involved. This is addressed below in 'Patch'.
+
+---
+
+### Prerequisites
+- `aer-einj` tool from: https://github.com/intel/aer-inject
+- Kernel configuration options:
+  ```
+  CONFIG_PCIEAER=y
+  CONFIG_PCIEAER_INJECT=y
+  CONFIG_PCIEPORTBUS=y
+  CONFIG_DEBUG_FS=y
+  CONFIG_CXL_PCI
+  CONFIG_CXL_RAS
+  CONFIG_CXL_PORT
+  CONFIG_CXL_BUS
+  ```
+  
+---
+
+### aer-inject Patch Details
+- The patch adds support for injecting both correctable (CE) and uncorrectable (UCE) internal errors.
+- The patch is located in `./patches` and should be applied to the `aer-inject` repository, based on the master branch (commit `81701cb`). The patch is '0001-aer-inject-Add-internal-error-injection-support.patch'.
+- Additionally, you'll need to apply a kernel-side workaround by hardcoding the RAS error status in the relevant handler, as described earlier.
+
+### Kernel patch Details
+Below is patch to set the RAS for testing. 'sed' scripts are also included 
+
+#### Kernel Patch to set CXL RAS status for testing
+Setting CXL protocol RAS status, is based on v7.0-rc6 (7aaa8047eafd). Patch is:
+0001-test-cxl-Force-RAS-status-in-cxl_handle_cor_ras-and-.patch
+
+#### Script to set the Kernel's CXL RAS status
+##### 1: Correctable Errors (CE)
+```bash
+sed -i '
+/void cxl_handle_cor_ras/,/}/ {
+	/status = readl(addr);/ {
+		i #define CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC 0x1
+		a\    status |= CXL_RAS_CORRECTABLE_STATUS_CACHE_ECC;
+	}
+}' drivers/cxl/core/ras.c
+```
+##### 2: Uncorrectable Errors (UCE)
+```bash
+sed -i '
+/bool cxl_handle_ras/,/}/ {
+	/status = readl(addr);/ {
+		i #define CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC 0x1
+		a\    status |= CXL_RAS_UNCORRECTABLE_STATUS_CACHE_ECC;
+	}
+}' drivers/cxl/core/ras.c
+```
+---
+
+### Testing Procedure
+- The provided scripts illustrate how I ran the tests. You'll need to modify the scripts to use the correct BDFs for your system.
+- Alternatively, you can run the tests manually using commands like:
+
+```bash
+aer-inject -s ${bdf} examples/correctable.internal
+```
+
+and
+
+```bash
+aer-inject -s ${bdf} examples/fatal.internal
+```
+
+*Ensure you replace `${bdf}` with the appropriate PCI BDF for your device.*
+
+---
+
diff --git a/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
new file mode 100755
index 0000000..c0e3417
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/ds-ce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0e:00.0"
+
+aer-inject -s ${bdf} examples/correctable.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
new file mode 100755
index 0000000..e238f63
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/ds-uce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0e:00.0"
+
+aer-inject -s ${bdf} examples/fatal.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/enable-trace.sh b/test/contrib/cxl-aer-einj/scripts/enable-trace.sh
new file mode 100755
index 0000000..753419f
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/enable-trace.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+
+echo 1 >  /sys/kernel/debug/tracing/events/cxl/enable
+echo 1 > /sys/kernel/debug/tracing/events/cxl/cxl_aer_correctable_error/enable
+echo 1 > /sys/kernel/debug/tracing/events/cxl/cxl_aer_uncorrectable_error/enable
diff --git a/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
new file mode 100755
index 0000000..3077c3c
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/ep-ce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0f:00.0"
+
+aer-inject -s ${bdf} examples/correctable.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh b/test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh
new file mode 100755
index 0000000..9dad325
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/ep-uce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0000:0f:00.0"
+
+aer-inject -s ${bdf} examples/fatal.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh
new file mode 100755
index 0000000..768522e
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/root-ce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0c:00.0"
+
+aer-inject -s ${bdf} examples/correctable.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh b/test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh
new file mode 100755
index 0000000..7238983
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/root-uce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0c:00.0"
+
+aer-inject -s ${bdf} examples/fatal.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh b/test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh
new file mode 100755
index 0000000..12ac104
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/us-ce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0d:00.0"
+
+aer-inject -s ${bdf} examples/correctable.internal
diff --git a/test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh b/test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh
new file mode 100755
index 0000000..bcd130e
--- /dev/null
+++ b/test/contrib/cxl-aer-einj/scripts/us-uce-inject.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+bdf="0d:00.0"
+
+aer-inject -s ${bdf} examples/fatal.internal
-- 
2.34.1

