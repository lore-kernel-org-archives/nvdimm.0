Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C62765E2
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974857; cv=fail; b=ry3B0pDZyhviOneZrAkurYTWbZIMFX1NDZQaRYWeT/9Q9vS0xLPSe5bK8Q05h+YmdXAEctJSyUB+eCqqQgl9am1KBinjTvltS60tNdIUDogwhNII80RDx7TKXeB66sMeAaYMMy2UY1aQfeXHTXLFNAie3zObiA19I8BjJZUH41Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974857; c=relaxed/simple;
	bh=re18WJU2pvnHxtlnvHIRP7QaHoZVUjGI4MigHug6L0E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhpdJd+V/ms1CmGll/kQF0UpMkbCpOiThgb8FTt0S/kgnfL7PPgIP0LV7i8bYSQz9AGiffupEt9deHeLt44HFYYmGx8fz5LSxESrRmJcYEIt9FMOJ2Ll8K0enNTjHl0eKoyVHyJltZa+tuDjDmEtLSCSJZp8gGGMyULPVbumHvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ShaZcxgJ; arc=fail smtp.client-ip=40.93.198.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ShaZcxgJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ejh7nWCAOZj9X32c6XHE0BQooNRI9HwmYnjsXUFyjoqAvkxhii3aQzHgEQJ/vk4ynxdQ8KhnU0YtMDgp2t2FzL9C712GgrTrmWwQ/5xizglZhStznv5yOFLpn9Za9svBpWrploGVcEETOD2OHpO6BjvEH6cZieExtH8pZlGgcXG+mW1qIMoM1Rij2TIR0xbvw/4tY0H11O6bcS61U2LJK70kHW2UiV9ekrTatx/SQJfqWcusBCRkjSusJXD5zW6LsN1ejfi3k3UKaMZ4PSE0w3UB96YfOMP6He+o8LuVIBCn/e3Gq0fZHjkN0Ov5av2q4kj3G1Uze/KLLPjW5aIB3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAjXduOPfYkf/KddpbtEaBUmTZwkkIwCU5EsV4KHE10=;
 b=Jl4MHLnwb2SiyYrydqBaKeQiK448XmgqZzS6ADdvwO2HvbLASP7SaLiYUcq5mFw1xXxtPtFg9vE3O9zYlwv79Y+0NrBOoitpILKxF0C1D8ZB3CwWf3zsqEFrcjGN1GRtVcLOnaOqN6e0ItwvUzI1cXIXFKlx7HAF1eKzX+Sy24IROWe7DaIfw8EmZxKidy59yFc+d5hJWajg+WNqwF+nwL6+PHoWtUg8DnMNv0IYoiGshsYcHb+n5Y3zurO8UTcJW/YBsg/WajS5auHPF2lLf/40hfnsZvVdLM5ZPyVNW++M57cSW/bFIlAAoYqFi0gY23ZnprIlVghIkgY3KD9vjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAjXduOPfYkf/KddpbtEaBUmTZwkkIwCU5EsV4KHE10=;
 b=ShaZcxgJb4V2FG2TFkalU6yIzCuh/54RjTvajZ04+tICGf0m4UeeTf/i9DzNAwQcyf3lqrOZyxikH3m5J5mO3DmtrVUnL8D80r1DHA4F0uknJAIYwhDILH+0aZxacfcQM2QMc4+TXtlQH+vbsqNIZkyxLfctHpnICR5VeTHmV04=
Received: from MN2PR20CA0064.namprd20.prod.outlook.com (2603:10b6:208:235::33)
 by IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 16:07:32 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::53) by MN2PR20CA0064.outlook.office365.com
 (2603:10b6:208:235::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 16:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 16:07:32 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 10:07:29 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 7/7] Documentation: Add docs for inject/clear-error commands
Date: Fri, 9 Jan 2026 10:07:20 -0600
Message-ID: <20260109160720.1823-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
References: <20260109160720.1823-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: 25db6022-93aa-42e9-843a-08de4f993262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IpvpiME0SiSWDJLlWxOsC4nZjR3nrWfQL0byH/0yZJ2/8YU8zzEpaTiqjWaS?=
 =?us-ascii?Q?slG1DZihvIE9Q2XvfzZjkqWA+Df/Kn3qppTu9PPVFVjcGCeTyty6IP4I7hcG?=
 =?us-ascii?Q?NTzyhVhj5yPRO19tRDq5NKq23wGS5Dis9gy0R4KWgGZXLDIX2cFBsd+4YqX0?=
 =?us-ascii?Q?JludwuRUslzYlls1FZdMWu+ziVBqf1UZn/3Y1RohjVM9eu8kveiMgkku/MBe?=
 =?us-ascii?Q?KcXioqTXrz4t9jWCsgL0UDi7ew9dHDGPBUzQG9oIeO40/ckALQZSyaRbgztj?=
 =?us-ascii?Q?qfzUk7YPx6R4FpyAvGG5MV1XTAf/uvGzQDBEb0SgupkPbt7Qtym1iY+Lp6p2?=
 =?us-ascii?Q?HkMmWDh6FRHZn8V3o4yiGUmVzwZvk+ixrLf7wcC5txhzmsLWv0WdqLKAcl2R?=
 =?us-ascii?Q?7NicAe86Ntt9Xux1w29KaqgXXnMMx6DMwrUzIZIDmgT5n5SrrelksMHJuquW?=
 =?us-ascii?Q?pKQR05If2hP5T9XrYHOJZxCNhE2DK5TTRCb5zZEjoB4W1lU9A+kPLbmmI0xU?=
 =?us-ascii?Q?Vqq4Gmr9vCPT2EOzOqibiPIVOGoOnvzyrM8qbK2BtSBhRc9Z7sG191coJrt5?=
 =?us-ascii?Q?WDEIXtG3EDROjtDk47PnrA3LDiy+RQPTrmShM2wgnphPrme4gBmEMgjDv74O?=
 =?us-ascii?Q?NqTQojUHj5s0jKJ8fyMc5cVZSgE63HrzFxKR1giJ5oOTEDHHwPrJwwcLvIJE?=
 =?us-ascii?Q?MY+VAS1t4sTjScalVObyMzITztW4aXkiLUOypuLkMuGBHYukCQa7W0pyFk33?=
 =?us-ascii?Q?UNspiOQjY6YA1jQc6/ziILq/h3Ze1SKlyfhL/nXjYcereRdiUMfjI9fi0dVr?=
 =?us-ascii?Q?4z9rlvE/5OiuYSE4aSZb0JA4oj3NU7debTRdT1h0PmjupXPRJALLIRmcfIdA?=
 =?us-ascii?Q?vgEq+rPjK4zBFTktx8snjHSOOY7UyUA6kQIqGTfi/9LJP6OZSIUbckMaW6Uq?=
 =?us-ascii?Q?FtvpvOUgv19ME+aLPbpoWOqdtpRRXW7D8qE74nI2qNEDeSyiJQ9lv/hzGDsb?=
 =?us-ascii?Q?X0TBa9IPKi9xbesFveEL6XhqYcGgBNiNDNyHZZwFzzDOQih6M4asbdJ228KA?=
 =?us-ascii?Q?cv8+Qe/ZtnqSPDfkEIjXd7g0U5dcn9XsMVg5LwmqzyIdO/y5l6XT6W4cO434?=
 =?us-ascii?Q?oOk9TD9Z+U7ZQDIs/o1oE3Olq8VO9xXTV/nLWXeCgmCHsTBacxZNRbBKXSki?=
 =?us-ascii?Q?QU5DhiyTmMAKiwXRSwbxjxC/J2ZPj58FXyfxP5st/CKoao807kPG2tm+Tx7Y?=
 =?us-ascii?Q?XIMlwyz+OxcTuI5z2VSwEBxVTnWBm1wcxs6jpfmdKVbDrkCzgC6Taerwxn3I?=
 =?us-ascii?Q?y+SBmG9v9moY3QSDNoH90nkxsePmpiqgSVJ85n+xKouoKx951BxotLwR2KHg?=
 =?us-ascii?Q?abYuYFuNhrLhQSda8psyqZ4f/m4aosPQfSHAygY0cphUtJ83Umf3IWLNMlE4?=
 =?us-ascii?Q?GbfdKIKl9UaGtloP7zLuV5vH7RjEHI2FN8r/5hIUwSu5Yxh9u1SVABd6WkpG?=
 =?us-ascii?Q?9PGXwSfU9h+BAJuyjuQmXhUrrZ7Hain6Q5pS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 16:07:32.6640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25db6022-93aa-42e9-843a-08de4f993262
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206

Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
These man pages show usage and examples for each of their use cases.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-clear-error.txt  |  69 +++++++++++
 Documentation/cxl/cxl-inject-error.txt | 161 +++++++++++++++++++++++++
 Documentation/cxl/meson.build          |   2 +
 3 files changed, 232 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-error.txt
 create mode 100644 Documentation/cxl/cxl-inject-error.txt

diff --git a/Documentation/cxl/cxl-clear-error.txt b/Documentation/cxl/cxl-clear-error.txt
new file mode 100644
index 0000000..9d77855
--- /dev/null
+++ b/Documentation/cxl/cxl-clear-error.txt
@@ -0,0 +1,69 @@
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
+This command depends on the kernel debug filesystem (debugfs) to clear device poison.
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
index 0000000..80d03be
--- /dev/null
+++ b/Documentation/cxl/cxl-inject-error.txt
@@ -0,0 +1,161 @@
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
+WARNING: Error injection can cause system instability and should only be used
+for debugging hardware and software error recovery flows. Use at your own risk!
+
+Inject an error into a CXL device. The type of errors supported depend on the
+device specified. The types of devices supported are:
+
+"Downstream Ports":: A CXL RCH downstream port (dport) or a CXL VH root port.
+Eligible ports will have their 'protocol_injectable' attribute in 'cxl-list'
+set to true. Dports are specified by host name ("0000:0e:01.1").
+"memdevs":: A CXL memory device. Memory devices are specified by device name
+("mem0"), device id ("0"), and/or host device name ("0000:35:00.0").
+
+There are two types of errors which can be injected: CXL protocol errors
+and device poison.
+
+CXL protocol errors can only be used with downstream ports (as defined above).
+Protocol errors follow the format of "<protocol>-<severity>". For example,
+a "mem-fatal" error is a CXL.mem fatal protocol error. Protocol errors can be
+found in the "injectable_protocol_errors" list under a CXL bus object. This
+list is only available when the CXL debugfs is accessible (normally mounted
+at "/sys/kernel/debug/cxl"). For example:
+
+----
+
+# cxl list -B
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
+on EINJ. Example using the bus output above:
+
+----
+
+# cxl list -TP
+ [
+  {
+    "port":"port1",
+    "host":"pci0000:e0",
+    "depth":1,
+    "decoders_committed":1,
+    "nr_dports":1,
+    "dports":[
+      {
+        "dport":"0000:e0:01.1",
+        "alias":"device:02",
+        "id":0,
+        "protocol_injectable":true
+      }
+    ]
+  }
+]
+
+# cxl inject-error "0000:e0:01.1" -t mem-correctable
+cxl inject-error: inject_proto_err: injected mem-correctable protocol error.
+
+----
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
+Not all memory devices support poison injection. To see if a device supports
+poison injection through debugfs, use 'cxl-list' look for the "poison-injectable"
+attribute under the device. This attribute is only available when the CXL debugfs
+is accessible. Example:
+
+----
+
+# cxl list -u -m mem0
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
+	mem-uncorrectable, mem-fatal
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
2.52.0

