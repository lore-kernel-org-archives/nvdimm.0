Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A9634D902
	for <nvdimm@lists.linux.dev>; Tue, 21 Oct 2025 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071608; cv=fail; b=kOKDuRQos9puu7gn9BhO4axXN4taWpvODtzGOuwXH5lho/tWjTPsrWfT1jeREKKBxwF8Z/A3CEPYbKw4pC07LhuMZAyX48AdUIyc2EuRzUD4edZBkrWNL6+BF7TmDtjXjFJdlgkf8w8p7MPAvyPGrk2fVUJpkEyCCgMggl1mLc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071608; c=relaxed/simple;
	bh=ZdeMWWWZ/tTVtpL0QJtYPC3b9bLqqLrXV3h7RyWrBO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qdo+8MLBgEZ6F2f9JgsFDYAoDFOWMEBHljgddLq8UlhgDEG4dKn/DBq3OThWDK4BQZyUeJJLuOP7KxlzdpfGCknmHbpd4tSMFa9ZOufRokHz5D93/M0ObWHh9n7yZN5BH3rPNhnu/4I0N7eSNfb4u7yz3TebmwHxtJ9ft/aF3TI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=03yo7KTz; arc=fail smtp.client-ip=52.101.48.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="03yo7KTz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKdQtve+zCaZnPOOfqXcE/GCi99vIEtOIiuFn1HWa+M7eiK7vUwmDDU+nVM12XmeZIVh+6pCWdx161uxQS58xgBL5zYsJtjetTP8m5JCKqfH2g9I5JDV4GOtG87927bDgA1Lyti9/Klpff/vWFRqvldaltJQAAsyQnotTsmrk+GSMnfr+vZcVWqSSmWVu4dfKUaU6MwyCX+6dnCYPItXM/g3cW30Wo3o+JQ2BNLHTEg7gWmOw/grkhQ7mbZlWOMs7MGa9QO28Zk/75heU0/UIIdkFN/f7ATQYW7HPhPaYA9hpCS5k+gc62wreYXIhxI6OmNLDiV0SRXUW+M0/Ndu9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEseBNzulhx+mmLwLD/rESOS7Ff/ws+tCAF5vi29yoI=;
 b=Lm0107Nuncg1kz2UWSfzZrDrGdUbAGekY8CP4DnMEDQsk0nF9aVzTzqAzcRkX7bsHh9A26lzDYdPUw6MvScfSG4hnrMLjsKHcbE3GmcvVb+3zrxn8EukZEtkSC3Pa+BgP41N3vtqs36r4VOxaEmBJCC/wNrx6SHH7Q9ZbCUkKl/CF0Eq8ZmY3BrJNmX8bTIq2iqeo+KgAa9OV40x9Ip7axqe4wX1E5vt7Et1QnWXoLmnM1kIm1tMDYapv9OKHWPjPc4SdDl4bEKZgtP2xxVhHDZ7Gpj7KKqglZG56Cf9ieoy96GZINCVQQxckXPxqZNY+MT42wsCJi6M9nmlPGwONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEseBNzulhx+mmLwLD/rESOS7Ff/ws+tCAF5vi29yoI=;
 b=03yo7KTzdZPkI8evYa7ZQc215Lm58BNKN+19p8jj7/tykSYApD/dK2M0/R8RfJtyiyIvy+SfjLzkXbc5TGRTkNpqH8tfPplfOqY7gqkysDMmYZjtQx1X1XOBOHnqJ5PH+wpaff1BN3gIJmKEQRe9P5lUfeq2d4Vmn/kXf1dcKUw=
Received: from PH8PR21CA0017.namprd21.prod.outlook.com (2603:10b6:510:2ce::17)
 by PH7PR12MB6954.namprd12.prod.outlook.com (2603:10b6:510:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 18:33:22 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:510:2ce:cafe::a7) by PH8PR21CA0017.outlook.office365.com
 (2603:10b6:510:2ce::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.4 via Frontend Transport; Tue,
 21 Oct 2025 18:33:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 18:33:22 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Oct
 2025 11:33:22 -0700
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>, Ben Cheatham
	<Benjamin.Cheatham@amd.com>
Subject: [ndctl PATCH v3 7/7] Documentation: Add docs for inject/clear-error commands
Date: Tue, 21 Oct 2025 13:31:24 -0500
Message-ID: <20251021183124.2311-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
References: <20251021183124.2311-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|PH7PR12MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 04dd1137-3525-4454-2847-08de10d050c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uuGdepfn7UonfdNXRT4SOKSXrz+qk+J4iDYIfEb48uMw3AdLFmuC75GzCpmu?=
 =?us-ascii?Q?NJkZuKXzCFBbeWupm6g74t/NasfaCr5CxfRrAyMY2AxEZNWlms5x13rELk+9?=
 =?us-ascii?Q?/8msnuyvMd/C8h1Ux5zhYPnFosK1Wn9w9BUQqgOAi156JKzKOMGgsybG+1nd?=
 =?us-ascii?Q?E1k6zKw4Ak6pFG6Ew+JxPmIcghQ9bfG2K5oxC6KhsF4PIdTArIbJDUiWjsLB?=
 =?us-ascii?Q?HewpL08Sb3flJMazMr2zSjAonMpWk8q6mhiFRb+CZk3AbEhNjW7KXrVt0g16?=
 =?us-ascii?Q?2tkQoF/8s9cfKAJcGWxAx2lLgJWNGRBi7O59EYwpHyFX2sbQ1KZVKEJhDnUD?=
 =?us-ascii?Q?EsbK8oF2/7Mf5dWhnItT44hi8hTheuwWEbbS88p6Umkd61WA+G8S02APlhgu?=
 =?us-ascii?Q?/ZcA038XzAzlh7eM5J2UbBOmm33lJs7sHrAgy3/BCBV8Hh1DKlKLF+0ivjDA?=
 =?us-ascii?Q?TDmswrNWTBKz6Z2KK54fEBzeC6toLk2wFwzusdLWSK3MU/WxWAJDayldEYpA?=
 =?us-ascii?Q?YRpkBptMJXyyWcw8MbJFLCMT1nqlvF9SyyBN5VgIUPXNJeIl3US7pfC7ZcQt?=
 =?us-ascii?Q?xfKdv5Iszd/CRCbECcxJb4OuQ8n9E4+LlL1X/0O5uLXNeSMBUFdcRXGuWDOV?=
 =?us-ascii?Q?PjcT+ze5WwskV7zBY3RmJlFVgLsSJokezdLdMZ4DfPW6gqxLYD56lobaJySf?=
 =?us-ascii?Q?6ai7Wy5kNHMUWzVJLvDWwqI25+juKHOxuSRlYxRPJYwY9RAalW26yvfoGQR4?=
 =?us-ascii?Q?e0HRFM0HNb+9XoT0s1ee3nL6FPJtT6X662d4oB1bDOahtQAuAb/wUulkNAeO?=
 =?us-ascii?Q?z1mWnERxC4gSpr/AKYpaxMFSsVz63d1s2MekabzXQHAjTfLO5J2RiqCKD2ZB?=
 =?us-ascii?Q?z+px1cZ89RMxAlxHwghJ3T9x3nlinRval0wLA+xBTQ4BbNwRR+2hPepY5dWt?=
 =?us-ascii?Q?FOt9Og1dNzB/bR6+Jv2n1ra5RK8rEBjv7IC4sVwg3LAxCa2FijgGwWFJdwKC?=
 =?us-ascii?Q?oY9Qol3x3fip1vTfqQd87+/ccmLHUzttMYo4YNo6T0KG67cFj7arcAnduK2D?=
 =?us-ascii?Q?NNBXUCOobY2SBf0UHkXFwMfAYUtDuUq0I8GlrftPRUaYZ28hqIrDwqQMO05O?=
 =?us-ascii?Q?IqLqESeoS2+qwOGBIDj0gNOTmu8uwMJnYrEvzB7BX8qUN89DewfyfFE6NZ8S?=
 =?us-ascii?Q?SSQa/U7sChC/w0RQVDpSBvMQRGK2gfKUyj2zrGRwWfGszVYY6zbvYtkeumcx?=
 =?us-ascii?Q?a4SfkYZAbnznW6u5xqBXf4qrWd5IVTZPy1SaAOAiZMU92B7HKrKm9vmuUOyF?=
 =?us-ascii?Q?gU6m5cn7Tn8ld2exuCm8JZzcWPIHLpmJL6s4uPglhVkJOoC6U2E53W90GGu6?=
 =?us-ascii?Q?6qNj50t0l/OVclG1ZeaXt00SyxY8g7EdDpJTVY6mlWRjggpi9IdNjMcW9zD6?=
 =?us-ascii?Q?xskF3A6r2BGbErZZIr/zX3i6DcZfSczea/qQQpEBunDG3deA9Y421uI3WO8h?=
 =?us-ascii?Q?X/Z4qjibV2G76LL8RsS8pLkcTdK+v8ReWKnp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:33:22.6914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04dd1137-3525-4454-2847-08de10d050c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6954

Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
These man pages show usage and examples for each of their use cases.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-clear-error.txt  |  67 +++++++++++++
 Documentation/cxl/cxl-inject-error.txt | 129 +++++++++++++++++++++++++
 Documentation/cxl/meson.build          |   2 +
 3 files changed, 198 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt

diff --git a/Documentation/cxl/cxl-clear-error.txt b/Documentation/cxl/cxl-clear-error.txt
new file mode 100644
index 0000000..ccb0e63
--- /dev/null
+++ b/Documentation/cxl/cxl-clear-error.txt
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-clear-error(1)
+==================
+
+NAME
+----
+cxl-clear-error - Clear CXL errors from CXL devices
+
+SYNOPSIS
+--------
+[verse]
+'cxl clear-error' <device name> [<options>]
+
+Clear an error from a CXL device. The types of devices supported are:
+
+"memdevs":: A CXL memory device. Memory devices are specified by device
+name ("mem0"), device id ("0") and/or host device name ("0000:35:00.0").
+
+Only device poison (viewable using the '-L'/'--media-errors' option of
+'cxl-list') can be cleared from a device using this command. For example:
+
+----
+
+# cxl list -m mem0 -L -u
+{
+  "memdev":"mem0",
+  "ram_size":"1024.00 MiB (1073.74 MB)",
+  "ram_qos_class":42,
+  "serial":"0x0",
+  "numa_node:1,
+  "host":"0000:35:00.0",
+  "media_errors":[
+    {
+	  "offset":"0x1000",
+	  "length":64,
+	  "source":"Injected"
+	}
+  ]
+}
+
+# cxl clear-error mem0 -a 0x1000
+poison cleared at mem0:0x1000
+
+# cxl list -m mem0 -L -u
+{
+  "memdev":"mem0",
+  "ram_size":"1024.00 MiB (1073.74 MB)",
+  "ram_qos_class":42,
+  "serial":"0x0",
+  "numa_node:1,
+  "host":"0000:35:00.0",
+  "media_errors":[
+  ]
+}
+
+----
+
+OPTIONS
+-------
+-a::
+--address::
+	Device physical address (DPA) to clear poison from. Address can be specified
+	in hex or decimal. Required for clearing poison.
+
+--debug::
+	Enable debug output
diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
new file mode 100644
index 0000000..e1bebd7
--- /dev/null
+++ b/Documentation/cxl/cxl-inject-error.txt
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-inject-error(1)
+===================
+
+NAME
+----
+cxl-inject-error - Inject CXL errors into CXL devices
+
+SYNOPSIS
+--------
+[verse]
+'cxl inject-error' <device name> [<options>]
+
+Inject an error into a CXL device. The type of errors supported depend on the
+device specified. The types of devices supported are:
+
+"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
+Eligible CXL 2.0+ ports are dports of ports at depth 1 in the output of cxl-list.
+Dports are specified by host name ("0000:0e:01.1").
+"memdevs":: A CXL memory device. Memory devices are specified by device name
+("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
+
+There are two types of errors which can be injected: CXL protocol errors
+and device poison.
+
+CXL protocol errors can only be used with downstream ports (as defined above).
+Protocol errors follow the format of "<protocol>-<severity>". For example,
+a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
+found with the '-N' option of 'cxl-list' under a CXL bus object. For example:
+
+----
+
+# cxl list -NB
+[
+  {
+	"bus":"root0",
+	"provider":"ACPI.CXL",
+	"injectable_protocol_errors":[
+	  "mem-correctable",
+	  "mem-fatal",
+	]
+  }
+]
+
+----
+
+CXL protocol (CXL.cache/mem) error injection requires the platform to support
+ACPI v6.5+ error injection (EINJ). In addition to platform support, the
+CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
+will need to be enabled. For more information, view the Linux kernel documentation
+on EINJ.
+
+Device poison can only by used with CXL memory devices. A device physical address
+(DPA) is required to do poison injection. DPAs range from 0 to the size of
+device's memory, which can be found using 'cxl-list'. An example injection:
+
+----
+
+# cxl inject-error mem0 -t poison -a 0x1000
+poison injected at mem0:0x1000
+# cxl list -m mem0 -u --media-errors
+{
+  "memdev":"mem0",
+  "ram_size":"256.00 MiB (268.44 MB)",
+  "serial":"0",
+  "host":"0000:0d:00.0",
+  "firmware_version":"BWFW VERSION 00",
+  "media_errors":[
+    {
+      "offset":"0x1000",
+      "length":64,
+      "source":"Injected"
+    }
+  ]
+}
+
+----
+
+Not all devices support poison injection. To see if a device supports poison injection
+through debugfs, use 'cxl-list' with the '-N' option and look for the "poison-injectable"
+attribute under the device. Example:
+
+----
+
+# cxl list -Nu -m mem0
+{
+  "memdev":"mem0",
+  "ram_size":"256.00 MiB (268.44 MB)",
+  "serial":"0",
+  "host":"0000:0d:00.0",
+  "firmware_version":"BWFW VERSION 00",
+  "poison_injectable":true
+}
+
+----
+
+This command depends on the kernel debug filesystem (debugfs) to do CXL protocol
+error and device poison injection.
+
+OPTIONS
+-------
+-a::
+--address::
+	Device physical address (DPA) to use for poison injection. Address can
+	be specified in hex or decimal. Required for poison injection.
+
+-t::
+--type::
+	Type of error to inject into <device name>. The type of error is restricted
+	by device type. The following shows the possible types under their associated
+	device type(s):
+----
+
+Downstream Ports: ::
+	cache-correctable, cache-uncorrectable, cache-fatal, mem-correctable,
+	mem-fatal
+
+Memdevs: ::
+	poison
+
+----
+
+--debug::
+	Enable debug output
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 8085c1c..0b75eed 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -50,6 +50,8 @@ cxl_manpages = [
   'cxl-update-firmware.txt',
   'cxl-set-alert-config.txt',
   'cxl-wait-sanitize.txt',
+  'cxl-inject-error.txt',
+  'cxl-clear-error.txt',
 ]
 
 foreach man : cxl_manpages
-- 
2.34.1

