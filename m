Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B4B326927
	for <nvdimm@lists.linux.dev>; Mon, 15 Dec 2025 21:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834688; cv=fail; b=CJkJbjOts38mXNGRtuOSb7eThV2njZ64Xz2S5jxL1Tjt37d8KrElY380aw0xvhZeZYbynYuGlfZIyy0oDKGXZYS2MRZZ3HiN/ypUoARdSWK9Y/+HDD7UbULO98k7hRujlli1FeXa6jeCMTw3cavaoEIW1sfB8kEbIv0fNGPUdsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834688; c=relaxed/simple;
	bh=PTLQ7UXhonkOTY0AoVBJ9FLhRNQfOHwe2QifgKPpY3Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IzYgDDp+mstYZ0+rN7o9psC2Tq3ik2K8gw+809URUti9PT2iNOsILdOdkxE91cPqedzLbNien/mwVOi2jtXHTIqaDCIIWgrHyTE2G+ikPgEWsyGsytkqG8worpe4VMoNero9UBJsNQbo0hU5khqA5dL/HpzotEAOlX9ML69H/f0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2qhIi41R; arc=fail smtp.client-ip=40.93.195.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2qhIi41R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKB+R3197G9cuXgd3jy5nyhomq9emDV0NEIXY/PvRHrF2A3qA0VgaMSDb+wYebIiZ2SOvq137z9Jr8SXSO3AIjOY2R8ts+YfwV5kuF8O4UecmsOocOIaDXJdCBcYgDclPW+BbGqQsvrQIhlq8EVC5W4VJmMpZv6MhXw9dXR8RTSjjt5AsoTeZKBay6a+T+YYjYWj+Hf1qNZZ3SO+VhWpITeotWiGV/utlyTT5svvNfBu65CqhG1HdDORlhb/iQI8TN3THE12vRwMhXSPZ3a/XAhHYmqkjQuEvT7VU1uJqWUyVUABe9mfEt4xRe7z6DFdmT3Ij66oaCgy1EnMZ4KW1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6Or3Ptqmm+bg0HiOu/p1xWt/k535OQuRmXT2TpaUxs=;
 b=US4oVcbkXWzYduvQt1woqCWxQ89Gi0g+VDSqvjz+LdzhtE+LoMUlWvTY0B5GUHyoTM4rXKzoiC0hGMvgHdE3j2Tfl/6LXOdIfU9ftMiAxs2uaZsl9kEH7EhmrA3nJwxYefZPmLOJhSAg7OMSNuVAmtPsf/PWCikEpFZ//Qs503r8B0aZruGzyQ0ORQVEQQ6Hq8dUe6z/fN/NPY3Fm/m9AfyUmSCL0Z+CQs5SmfcseW2CQYKRZYLSNU1MZkM/F8/7TEayq65PbXd/CAzmHuqyFMqIhdzOf9LMOelVTEi72+eFJYYgIPVq0Mff8ZryA4h7XNxdcDu/LZ39TXEg3X8giQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6Or3Ptqmm+bg0HiOu/p1xWt/k535OQuRmXT2TpaUxs=;
 b=2qhIi41Rq+o6Lki+++mqSMlqnEnrczi6lMfGb1gWSAYlU9EKt34MaPwBxaG/E1pexnQskjNNWiF0ev0GBrDZM0RKCom2OdM3+2q/fZQ4sd4oduSPJ9q1uRAz3EE0tCNeAvVZhmVFY6l8RgDxXU2JqXpI32gwuBl6PBDbRY4F23g=
Received: from SJ0PR13CA0135.namprd13.prod.outlook.com (2603:10b6:a03:2c6::20)
 by LV8PR12MB9263.namprd12.prod.outlook.com (2603:10b6:408:1e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:37:55 +0000
Received: from MWH0EPF000971E9.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::ec) by SJ0PR13CA0135.outlook.office365.com
 (2603:10b6:a03:2c6::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6 via Frontend Transport; Mon,
 15 Dec 2025 21:37:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E9.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:37:53 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 15:37:52 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v5 7/7] Documentation: Add docs for inject/clear-error commands
Date: Mon, 15 Dec 2025 15:36:30 -0600
Message-ID: <20251215213630.8983-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
References: <20251215213630.8983-1-Benjamin.Cheatham@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E9:EE_|LV8PR12MB9263:EE_
X-MS-Office365-Filtering-Correlation-Id: 259a07c2-089c-47fd-d659-08de3c22340d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jp2kIsVF9KOJmq+/1jmDrSq41NEeUgYlRUiyK134KV60/EGPCU6gYKWgYnmA?=
 =?us-ascii?Q?imMlbE4W0KeKl1ka2+xRUJIYU7aTmwb6GBM5IznS7quR5/Tf4AWB+o5iVXE2?=
 =?us-ascii?Q?aBgt3ebZ+Vm9SyvzWXbYTmFHZoI7ZxP2afTgDJlmNJH3VxB4NmZ2uHkQXi8p?=
 =?us-ascii?Q?U2ggNLO7muserwZJAyio0h8el1qMPyJkyrSBWWOZMWeGalUnjCRUfQhRhne+?=
 =?us-ascii?Q?EGxIonpB+Iw6rIqYizcyKyx5E9zt3fXcZEPfj/V5WpMv005ZZZd4idVLFaNn?=
 =?us-ascii?Q?sRARMhL7yS56nv7SztgaumYWIWd/EltA6FZ+xupGZ6j5NlYQ0Shr8J+uAWdb?=
 =?us-ascii?Q?KbkSAVkFIBz5RYI/NuYu/94TEjIcm2se6VpG5pP3xUBVf949iZESMMVmBj7h?=
 =?us-ascii?Q?f8elBW4V39hxDdQfWQEF1rkLSh18NhOadow6afaKtcS5nG0jl0R81B6w2+fC?=
 =?us-ascii?Q?cDwcCfB2yUwIhrv6dxLZmbz11YgSF7B+SqeijLD96RET6/6Sa6LGeYk73+v9?=
 =?us-ascii?Q?fW57Zz8RcnZlHd5HELUQF2toXCVguXzwYcXBT5WdF+LbWPBwT8v2u3lAKZlr?=
 =?us-ascii?Q?u+/coGEmKXNBjDqTOdpD5CwwvSbJGH82wWAvnvHdvf7VqnHzrhQCS1On3WLE?=
 =?us-ascii?Q?R646ZcmUaiNgfZG8OMdxsZFYBC9xeYP6f/F/w2xVGxXuyTWDfSLmZGsl2Brw?=
 =?us-ascii?Q?+RsW1R86DsrVlsB/TQiT2G5Yr/rpQH8mW6fHFIgMDmPvyrRLGv/DQGXOYO52?=
 =?us-ascii?Q?8ybKip7JHZQBbVG17rMsH0JC5zrnHeOxCdm27UZ5yY1J1etWbW0Fcu0fgGai?=
 =?us-ascii?Q?bXMPfU/zBgv3TsKffIj9hJGve1OL2x6e5dpOsW1IP81A4R+eZGjMI8iybMXs?=
 =?us-ascii?Q?xYZeFbUTF2erJ8gyX7nhgycQKb00qB0tQM97Hd51RWZSWokMPRwJ0yS5nVB6?=
 =?us-ascii?Q?rUUAuYPF9lKtuV8E+Dqf3zKzrP3DIV17p9FpLN35GNLmtgFha2H0k8oGAins?=
 =?us-ascii?Q?SoJcPPkaMum+IIE1ReW5W0WskaIySWU2doDUOBet9uHrvHvA95IC3jeYMCM5?=
 =?us-ascii?Q?JhTDkWdzU+e/JtJimMhfDkplBTcNGGu8+a5rHIrOt/TtobyrE95bRPO5xnac?=
 =?us-ascii?Q?8cqcD26Jch3PxOzRcWr+pAtRm4aBm1gPFh7+EpH2HQSbRBfKOxdvGctwN/KJ?=
 =?us-ascii?Q?gVhwJRaI50qVRRcHQfbNoJP1FRbvMDlInQakK+L11n3JaspKl1l/R45/W2S5?=
 =?us-ascii?Q?xuVZk6EXcaGskuiUgfSzpy+BcorgOK2nbhi+ICYZrbGYuuddqRv0gINtXDWu?=
 =?us-ascii?Q?QOwfgfO9TRKV5FMvlj5QEcLhoYZDJQ3byqWqzeQd5BRuXGMmX+qN57/qoxW2?=
 =?us-ascii?Q?D9ZAQM1xkyDlfIqoree4oXgZmBaKJB0Z28s3CFpWXiyKnxTBuiHT9vo+63Q8?=
 =?us-ascii?Q?PmLdJo0o03pPKI3PT9OW16bF3eBsC3evUhtAd7n9dZCfJH6Mun/VVWJLw08s?=
 =?us-ascii?Q?wRAtKA/YtH63sJjKD/TB2QNAMvtR+Exyl02j?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:37:53.1638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 259a07c2-089c-47fd-d659-08de3c22340d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9263

Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
These man pages show usage and examples for each of their use cases.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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
2.52.0

