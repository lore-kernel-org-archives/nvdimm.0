Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3B1FDA82
	for <nvdimm@lists.linux.dev>; Thu, 24 Apr 2025 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529963; cv=fail; b=Ypic0AxkKP6MkrWx4cIarnCcOmLdwgfBMWPf3iLuzV5qtRF39RPrJvtV5s9N1sCfSFe7aGxX2D9yNYzXuEDDMAItHKwTyWXx2N6rttxSdtV+c/ha4LQSuKODadfi3nssLMm+hgcCkYGe4+qSpTfwg+aKB+WExLWQqi0rxmEeEko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529963; c=relaxed/simple;
	bh=bBzu1SAPMiyX6II1M1lNJjeVeGlOnGe6Ocoghz3gQq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dp2LMj3y3BgULMcdTOb6p575n+OMqyg/Lb5yJWN+C1DBVvr9eZWY6zXqTMPAsHYoElxPj6aEWpMBqbxtVfWjHg5ChcYaAr9dlAzAz3mrUPZ8egzXfrxkHFZBE6cBIUEobQZSRgotdO3jPe+VSrCPGM4TFjsDvD4cEuGZKDups1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NLbw+M5W; arc=fail smtp.client-ip=40.107.100.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NLbw+M5W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y5zuYCs/Pv3/CF2B1dPGHBco5jBAx2jwXddAAInYt6omvb95lm01IbvOhPeTtECdFylM1rJv17bilZuSRBczYWqDpzOsfkjTXSywaeFOu/X1jXROFVxRSZwLdc3uipTXJW27QfGUhBnoHqVVnrwJZdwrO29QYjLkXilL89pCcHSJiewRLfIp6xHde0BTkQnPfds/MOvLkcv/LdB2q+XOo52DQWsMzg46mzTqripN5aeI7uSlIivOfoEIQ7+7oXkpNLUhy0DXGCyqzdHMSoljZ6K16Ei8Z3dyQLKR9vgWI/h9aJOzFAXBActHg9gu7oHSSvDZicgZQ8hWZPQAR3kAXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQWyynqrXnUtY0z1QdgSapL5+QMXcdezAo2yk//YGwQ=;
 b=borWtmkGCFulPCahdCULb8+5yh1/5XMcxWkEiDFjpCk7wswgBqJ2JF7A9wL24ShnUIIXWjYmh1GWGTIwKZjFnSgMDYye5gVDo2M9ycdXgiXiwiMx4jMZyJ9tLcUPxw+YYpe1ViVY8uuJLa7dLFd+xDPnmfHA6pU9MUFLuz6PhO67YlnFjTCtFquIGUeflmMCu1yhQEaH6DZzFxbc/+6iHofQN8wzv/dmCRxM0s4bNsokGN2FbtliSNXJamDYNX7ZuFxFgnh/FB1z5P1Vz5uU1HXCZJugMt+s9tyFXrh1KLAyxcdMYP38jMw9yXGNEBS/zDvtaf67arsJXMLJvtFmcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQWyynqrXnUtY0z1QdgSapL5+QMXcdezAo2yk//YGwQ=;
 b=NLbw+M5WqCDpMtvY7T0yxmr88RAoySNdAdAEQkEa3vXhI0kaMS/Y2hOB0qpE57gl/T+1nTh/QiimnZ4ZSL+yPpmWLYGnSParYrQtzugp11ImM9Cg0ShvhaCQ/kIbDRoaHuBl0yezcKk5fCixGHnb+Xx0B47wdi/ycpwmDY6eck8=
Received: from BYAPR21CA0023.namprd21.prod.outlook.com (2603:10b6:a03:114::33)
 by CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Thu, 24 Apr
 2025 21:25:54 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::bb) by BYAPR21CA0023.outlook.office365.com
 (2603:10b6:a03:114::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.5 via Frontend Transport; Thu,
 24 Apr 2025 21:25:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 21:25:53 +0000
Received: from bcheatha-HP-EliteBook-845-G8-Notebook-PC.amd.com
 (10.180.168.240) by SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Apr 2025 16:25:51 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>
Subject: [PATCH 6/6] cxl: Add inject-error command
Date: Thu, 24 Apr 2025 16:24:01 -0500
Message-ID: <20250424212401.14789-7-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
References: <20250424212401.14789-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 01488025-0f17-40cb-fe98-08dd83769814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7E7563u1RAD2pdPYZ//kaPrxoXJxjtnKUbjo1gA7wqtnN2HruiBzgHEo2X6g?=
 =?us-ascii?Q?RGxI8KX620iONqp2jZNGzAl9zshPy/HUOcCxUXTeohOE8ypcq7r/6poaO2F8?=
 =?us-ascii?Q?Avt+3BsMHJ596cvw9sWEQ1OO8DrzrlKCqBH4ehEMblYfS7KbFenJsq+M26R1?=
 =?us-ascii?Q?BhyyTZO1+lWfKmaoBO+ZWt72UW94eLYsvP+OXjBBGegNb/wc1NeCBvDRobQD?=
 =?us-ascii?Q?1Dz8Xcdax+VTBLJTBr0YtHIXQvlX2zEmuThvyIhdVEG+42+p9LnGj9BXqDFr?=
 =?us-ascii?Q?G1OW8NA9f1+ePTak91om1pULltXo/4NiYXNwWCA3zsP/U+dCFdm7pvccgiXl?=
 =?us-ascii?Q?WvXFoguYHc3Y8FGz+MyHhSnioRV/csK1nDZTCz4ArofMsWM2EBcdQcSfw3Rr?=
 =?us-ascii?Q?maKmVDsqHRfpRPifkv9RU2DH6euQwWZStu8mAaX9vQRblkHWY9E6N93LEkTA?=
 =?us-ascii?Q?GWUJQy7/qm4yRidQUvSGeW2DSRzCVt2xvMFZI1u2K+y5OR6dKiO7rCqvu/Mp?=
 =?us-ascii?Q?ea+6W0B3fKa/FVHKsvZRZhiKCyj6gzRsOPHhimg8V8n+BaNhRCq90qe/afsJ?=
 =?us-ascii?Q?t2W/MiGPxTNgvDgpjNJcjRFkIXiW4b8yqGQX940BuocZMs8hS+wHLDSLv6H9?=
 =?us-ascii?Q?1vkDnxYWANOfaZl8BJXxbXhZS2A0VafhTrDx0PKnRKZrEwEihLTtgnutEgUV?=
 =?us-ascii?Q?IZd2BozXD7eEYYShBwDjeOG131ZhJ4eI35bfnyEGvaH/ShaAWwvWNX3lQ/NK?=
 =?us-ascii?Q?HsPjI49JQRna4Q2f1w5LyowcsSt5/RRbskebweQqzNkfvXOs0MppniVRLSHY?=
 =?us-ascii?Q?2yQhXgmw0eDJhMvLMedLB+N7yohmYIksz9r93izt5PntyHc1jJkLl5LCj1Ik?=
 =?us-ascii?Q?Fsbcng/Y5dlr8G1ZrpIBq02xzz29tvRCocU5Usu23KYvM7aNBhWCvKOPqg7I?=
 =?us-ascii?Q?Ztvpl1gCldZ/fkKOkCuX4i4wCdr9bzDHnT9mLRigu2k/dJlXsV4MUSdaIEGL?=
 =?us-ascii?Q?df4fgk4TjwJy1SSOvakZOI/v6lsNLbZczmtkw104/esbj17QvWLaCPz5z3Rj?=
 =?us-ascii?Q?WBnO2pTSWoAa/mbwTWywWlbjaxu68RRx0DYKJ74JMIJLRrsCiAD35O5JeT32?=
 =?us-ascii?Q?kK7uII7o7FqqwIvvizsFcZoaxpGqnbdux+3ibqtt45umsMwFzhnZXBv3TN9n?=
 =?us-ascii?Q?Pic32suRz24nzj6GYLY2G2VsX9JgJqRS3kVA8opYKOzh3TYjMDyWUUO/Ha5u?=
 =?us-ascii?Q?27OMXIV1zDuuhWgRLjSyphJpn+zm0+0N/UrR41TKDn5tPuACZ0P8ZsE0LPx4?=
 =?us-ascii?Q?OfQDXXe8ObL+hWTMsDe83/Hen1cSjbtN1TGBueHGO6vkJFp/2gWCaMZ8u/Q/?=
 =?us-ascii?Q?4hftbNaTYWjmR7j5RXfs1Eu4BpF3ZFOX/9NAn+2IusWZwO+IPjt1hjHBf4zM?=
 =?us-ascii?Q?BgNpzc+wFTmF4SISEGFkEG/1UuezTcMzEbjj3PQ7/y/yLsW75qn/mA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 21:25:53.5808
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01488025-0f17-40cb-fe98-08dd83769814
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186

Add the "inject-error" command that can be used to inject CXL protocol
errors into CXL downstream ports and poison in to memory devices. The
available error types can be found by using 'cxl-list' with the
"-N"/"--injectable-errors" option.

The full list of supported device and error types can be found in the
command's documentation.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-inject-error.txt | 139 ++++++++++++++++
 Documentation/cxl/meson.build          |   1 +
 cxl/builtin.h                          |   1 +
 cxl/cxl.c                              |   1 +
 cxl/inject-error.c                     | 211 +++++++++++++++++++++++++
 cxl/meson.build                        |   1 +
 6 files changed, 354 insertions(+)
 create mode 100644 Documentation/cxl/cxl-inject-error.txt
 create mode 100644 cxl/inject-error.c

diff --git a/Documentation/cxl/cxl-inject-error.txt b/Documentation/cxl/cxl-inject-error.txt
new file mode 100644
index 0000000..50b25fe
--- /dev/null
+++ b/Documentation/cxl/cxl-inject-error.txt
@@ -0,0 +1,139 @@
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
+  	"offset":"0x1000",
+  	"length":64,
+  	"source":"Injected"
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
+error and device poison injection. If your kernel debugfs is not mounted at
+the normal spot (/sys/kernel/debug) you will need to provide the path for it
+using the '--debugfs' option.
+
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
+--clear::
+	Clear poison previously injected into a device.
+
+--debug::
+	Enable debug output
+
+--debugfs::
+	The mount point of the Linux kernel debug filesystem (debugfs).	Defaults
+	to "/sys/kernel/debug" if left unspecified.
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 8085c1c..1502d25 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -50,6 +50,7 @@ cxl_manpages = [
   'cxl-update-firmware.txt',
   'cxl-set-alert-config.txt',
   'cxl-wait-sanitize.txt',
+  'cxl-inject-error.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/builtin.h b/cxl/builtin.h
index c483f30..e82fcb5 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -25,6 +25,7 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx);
 #ifdef ENABLE_LIBTRACEFS
 int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx);
 #else
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 1643667..a98bd6b 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -80,6 +80,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-region", .c_fn = cmd_disable_region },
 	{ "destroy-region", .c_fn = cmd_destroy_region },
 	{ "monitor", .c_fn = cmd_monitor },
+	{ "inject-error", .c_fn = cmd_inject_error },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/inject-error.c b/cxl/inject-error.c
new file mode 100644
index 0000000..907bfc2
--- /dev/null
+++ b/cxl/inject-error.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2025 AMD. All rights reserved. */
+#include <util/parse-options.h>
+#include <cxl/libcxl.h>
+#include <cxl/filter.h>
+#include <util/log.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <limits.h>
+
+#define EINJ_TYPES_BUF_SIZE 512
+
+static const char *debugfs;
+static bool debug;
+
+static struct inject_params {
+	const char *type;
+	const char *address;
+	bool clear;
+} param;
+
+static const struct option inject_options[] = {
+	OPT_STRING('t', "type", &param.type, "Error type",
+		   "Error type to inject into <device>"),
+	OPT_STRING('a', "address", &param.address, "Address for poison injection",
+		   "Device physical address for poison injection in hex or decimal"),
+	OPT_BOOLEAN(0, "clear", &param.clear, "Clear poison instead of inject"),
+	OPT_STRING(0, "debugfs", &debugfs, "debugfs mount point",
+		   "Mount point for debug file system, defaults to /sys/kernel/debug"),
+#ifdef ENABLE_DEBUG
+	OPT_BOOLEAN(0, "debug", &debug, "turn on debug output"),
+#endif
+	OPT_END(),
+};
+
+static struct log_ctx iel;
+
+static struct cxl_protocol_error *find_cxl_proto_err(struct cxl_ctx *ctx,
+						     const char *type)
+{
+	struct cxl_protocol_error *perror;
+
+	cxl_protocol_error_foreach(ctx, perror) {
+		if (strcmp(type, cxl_protocol_error_get_str(perror)) == 0)
+			return perror;
+	}
+
+	log_err(&iel, "Invalid CXL protocol error type: %s\n", type);
+	return NULL;
+}
+
+static struct cxl_dport *find_cxl_dport(struct cxl_ctx *ctx, const char *devname)
+{
+	struct cxl_port *port, *top;
+	struct cxl_dport *dport;
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus) {
+		top = cxl_bus_get_port(bus);
+
+		cxl_port_foreach_all(top, port)
+			cxl_dport_foreach(port, dport)
+				if (!strcmp(devname,
+					    cxl_dport_get_devname(dport)))
+					return dport;
+	}
+
+	log_err(&iel, "Downstream port \"%s\" not found\n", devname);
+	return NULL;
+}
+
+static struct cxl_memdev *find_cxl_memdev(struct cxl_ctx *ctx, const char *filter)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (util_cxl_memdev_filter(memdev, filter, NULL))
+			return memdev;
+	}
+
+	log_err(&iel, "Memdev \"%s\" not found\n", filter);
+	return NULL;
+}
+
+static int inject_proto_err(struct cxl_ctx *ctx, const char *devname,
+			    struct cxl_protocol_error *perror)
+{
+	struct cxl_dport *dport;
+	int rc;
+
+	if (!devname) {
+		log_err(&iel, "No downstream port specified for injection\n");
+		return -EINVAL;
+	}
+
+	dport = find_cxl_dport(ctx, devname);
+	if (!dport)
+		return -ENODEV;
+
+	rc = cxl_dport_protocol_error_inject(dport,
+					     cxl_protocol_error_get_num(perror));
+	if (rc)
+		return rc;
+
+	printf("injected %s protocol error.\n",
+	       cxl_protocol_error_get_str(perror));
+	return 0;
+}
+
+static int inject_poison(struct cxl_ctx *ctx, const char *filter,
+			 const char *addr, bool clear)
+{
+	struct cxl_memdev *memdev;
+	size_t a;
+	int rc;
+
+	memdev = find_cxl_memdev(ctx, filter);
+	if (!memdev)
+		return -ENODEV;
+
+	if (!cxl_memdev_has_poison_injection(memdev)) {
+		log_err(&iel, "%s does not support error injection\n",
+			cxl_memdev_get_devname(memdev));
+		return -EINVAL;
+	}
+
+	if (!addr) {
+		log_err(&iel, "no address provided\n");
+		return -EINVAL;
+	}
+
+	a = strtoull(addr, NULL, 0);
+	if (a == ULLONG_MAX && errno == ERANGE) {
+		log_err(&iel, "invalid address %s: %s", addr, strerror(-EINVAL));
+		return -EINVAL;
+	}
+
+	if (clear)
+		rc = cxl_memdev_clear_poison(memdev, a);
+	else
+		rc = cxl_memdev_inject_poison(memdev, a);
+
+	if (rc) {
+		log_err(&iel, "failed to %s %s:%s: %s\n",
+			clear ? "clear poison at" : "inject point at",
+			cxl_memdev_get_devname(memdev), addr, strerror(-rc));
+	} else {
+		printf("poison %s at %s:%s\n", clear ? "cleared" : "injected",
+		       cxl_memdev_get_devname(memdev), addr);
+	}
+
+	return rc;
+}
+
+static int inject_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			 const struct option *options, const char *usage)
+{
+	struct cxl_protocol_error *perr;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	int rc = -EINVAL;
+
+	log_init(&iel, "cxl inject-error", "CXL_INJECT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		iel.log_priority = LOG_DEBUG;
+	} else {
+		iel.log_priority = LOG_INFO;
+	}
+
+	if (debugfs)
+		cxl_set_debugfs(ctx, debugfs);
+
+	if (argc != 1) {
+		usage_with_options(u, options);
+		return rc;
+	}
+
+	if (strcmp(param.type, "poison") == 0) {
+		rc = inject_poison(ctx, argv[0], param.address, param.clear);
+		if (rc)
+			log_err(&iel, "Failed to inject poison into %s: %s\n",
+				argv[0], strerror(-rc));
+
+		return rc;
+	}
+
+	perr = find_cxl_proto_err(ctx, param.type);
+	if (perr) {
+		rc = inject_proto_err(ctx, argv[0], perr);
+		if (rc)
+			log_err(&iel, "Failed to inject error: %d\n", rc);
+	}
+
+	log_err(&iel, "Invalid error type %s", param.type);
+	return rc;
+}
+
+int cmd_inject_error(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int rc = inject_action(argc, argv, ctx, inject_options,
+			       "inject-error <device> [<options>]");
+
+	return rc ? EXIT_FAILURE : EXIT_SUCCESS;
+}
diff --git a/cxl/meson.build b/cxl/meson.build
index e4d1683..29918e4 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -7,6 +7,7 @@ cxl_src = [
   'memdev.c',
   'json.c',
   'filter.c',
+  'inject-error.c',
   '../daxctl/json.c',
   '../daxctl/filter.c',
 ]
-- 
2.34.1

