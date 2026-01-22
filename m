Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622B73A4AD4
	for <nvdimm@lists.linux.dev>; Thu, 22 Jan 2026 20:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769114275; cv=fail; b=LyYmwjuGG/NfEV759wdFOfGK/hR70eDOi9/5gKYKZlSs/MptOEtbd9xl4c33ixxGzemF2iBv4pPnQwH44Qa5u84AOSEhM7cKQWwxAlrOz2dSpzROMBXnO0gS13J4wrV4b2RQq9VhhD6igGyqnqm96S2sPgcCbYvrG3v/wnXKcTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769114275; c=relaxed/simple;
	bh=HGT32yVdVcsyvZo1G+/Q8D87MnkXavA5ooUi6bB3ZNc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2n6jDswVd1Y7nL0aeVhdDv21K6xx4FW7rI7AiySqmww7gcAkuLFJirku1CivsTIh9hcwAcKZ0aImj9C0W0Ctve9wpgcU03zJSpbkj3Iwo4CavRuTWU7Yw4FgWSFMe7Ly32FQ1VCNipW9cQpaR6hZWkN5yk4v+RUHyLBiYBSayQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uMcJXjdp; arc=fail smtp.client-ip=40.107.208.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uMcJXjdp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DlmE7H001V06/8v8+Zfw2YtRicBsq73wDlTPQsFAo5bkVZEytZg81wmS9xmkZGFJgCun1zVWMjZ7rDleecrBgacToa+4pB8+3frNV3NzqrhJuqnffrNuO7kRuMW0c+uE0qSZHnfCsf5YcdlC5YQ9MhC8SWh8SRnx0AD2IVCTLiVbFWQGdczFzyV9daEPO0jWPiUZmWFIrHbHHFnav6VIK+YA1qltZ81MSEnGcCjkQPcvugnS0SecX2MPfXI0Q7OpZqrzh6h2gZw5pcVysLzSnSDYIwOnRzKEOmfWAGZWVGQrRFbaR6G4vTjLUIdsP5auwjj7Pm8cMfvcMmOlpcp/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jUpNt/pMbmyiEsHG5qvcDUFiPqVs/eZ2NnrRENK8RE=;
 b=aFcGgF0j6m2sbyHUL2sczv3f0RbJa6zLm4zCiMOPPWNxPqq2RPfYnFhXpjNRpXd7S4JWUwaWQE8WNiHCdaKzh3V9Ur+a10Vp2KPqRUFDCgk6QRluaeHzHOKU7CfEx3GusX+RC/TTb61B5uboOD+UAAWOBn5zVAU5qcCnXZkQofWTjJ0T0ycUrJPwObN2rNxCYLbHz8EO2IIMeuYIESVR6OfAnvGJo0L6K1bEI3ijtXMwrXZq1E08DvdxV3NCVi0oMj0VV057SLW8mGE7x9igR7v1QpJgMWnOnM62b12JqeYHT1PUR/pvFZwFloeKSk+6Unk+JAkUpg/YETmlH6t1mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jUpNt/pMbmyiEsHG5qvcDUFiPqVs/eZ2NnrRENK8RE=;
 b=uMcJXjdpUqr1hKKvWqZwFfiQJDoGKMXtUwYTjSixwR4EC3ii2fsHGn6qJIm+uPXRQeErznlci19aN0PNp1EEbL+gLdAq/X6fZG5D235YI51pZTKTipuKZ5bak7s84IVYpOWobO2eEeUwPc6IxU6zQL7svPpfBLxo0ezNcKdIjUg=
Received: from SA9PR13CA0046.namprd13.prod.outlook.com (2603:10b6:806:22::21)
 by DS0PR12MB8528.namprd12.prod.outlook.com (2603:10b6:8:160::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 20:37:39 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:22:cafe::60) by SA9PR13CA0046.outlook.office365.com
 (2603:10b6:806:22::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Thu,
 22 Jan 2026 20:37:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 20:37:39 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 14:37:38 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH 7/7] Documentation: Add docs for inject/clear-error commands
Date: Thu, 22 Jan 2026 14:37:28 -0600
Message-ID: <20260122203728.622-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
References: <20260122203728.622-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|DS0PR12MB8528:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a45d332-64dd-4bc5-d0c7-08de59f615c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TJEN8zWSeeeK2w9AIAXda4iINSj9PtIGLJcJuzU/aXmYVx8ssR+PRlwkU+OC?=
 =?us-ascii?Q?hKICOShDl8eZzmcTVh1r7pkuz9vixjr+/4NmmBufaUU+6Z5+kgj4KEEbLlSV?=
 =?us-ascii?Q?LBBQuC9sIu0ho6SecujSc8l/fqCVH/tR0XqT8kdM2+beHoU1ium/SBWfYDKi?=
 =?us-ascii?Q?mPyRqBOtGptxom9pdpwqmSP7Pkht8wQGj5gp7nld3P8XfVgnM3es/gzjPJDS?=
 =?us-ascii?Q?8bsS+1k68VUrLru2jTPXZimsYRjmuhv12Mki4zGvcO+N3MLxdxMuUAXuDkWZ?=
 =?us-ascii?Q?dxfiI3IkB6e2LjZlHypmU9/dE5/gGarimzSoa+n7EzbbmNgZGqEDvZa0UrBC?=
 =?us-ascii?Q?v3dyTF9URF4obrW094RSly9bcCTBJdmByNn2e2UYJ4HqZBSFamA4tycCxK8S?=
 =?us-ascii?Q?Tev5q94mZ2KasifMzOF2pZN5P3D31s6KVKS/YDbaemb88GJ94iVw8Jtb2jCW?=
 =?us-ascii?Q?ICo5mglF/V7ni2gBi/rddbbL43cv4mqViEWxwDrYBXLsdVabvQ6WMMo/+zxp?=
 =?us-ascii?Q?DNFQqHLou70/SiAzUJAZsUOOJVFtQ5t55xcFd1RRWhGY57i24/NpobJmt2zY?=
 =?us-ascii?Q?rFD/4fNkfquSf6lO0QC5vu95p6hsoI0VxvMLMEaXmB5NsDoYYyfHTIz/lGwD?=
 =?us-ascii?Q?sRvCLtNvFMmVwZRFS0PfIY6K+w6CakzWVA1xS7c+NFN2hKHbRgXvQf6uWwj3?=
 =?us-ascii?Q?/bGX5zUZ5lZF4+UBln/R40B699P4W7cpK8WUf3OJzEWsVxd5GUdiEnhdZS8H?=
 =?us-ascii?Q?iJlOpD8s0GYZ64xj00/O4WpevjUpcZOYDm5pAoAU5FP5mw4Mlqc9xP8QyUzK?=
 =?us-ascii?Q?XnLcwploqxkIfzeFHalbE+/za1bqISEdeVI3KMYbMw0UNogprdCPQ5TQcP9c?=
 =?us-ascii?Q?+ssIYBqAr4bs5n/Z6+I+pGtzyzM3MjqrBNPx+k3Ki7XoKJPXxYFtjFcqQgnR?=
 =?us-ascii?Q?QcFygqdyCk2At8HQj6vc5Olai7AAAB5trNVgCD2S9ZiK2YCjbqfk6MNO2hUB?=
 =?us-ascii?Q?JsT4AHRLQLGYTG0tYx2gcL488e+2zsPQzjSxKzGg/E2OGxWmyNCgrmUuHeQ2?=
 =?us-ascii?Q?YkrKKQLvO8g5w+7xBaicfr/mFdjwsqTGs2QbheSXgHqlpjmL9eUH9cZMkHJT?=
 =?us-ascii?Q?zGXhx6nK5uG798PL+FgFnlucouI+J8oz5NspU2jVDtYLBJ+8r77Kq+mST/e9?=
 =?us-ascii?Q?8VGZE4jJYx6OnfERv6LkABuvjrJqvzHnGR7wK5GP3MnvixMSStMikwa8mM3B?=
 =?us-ascii?Q?vkYQERRJ2m2ur7WjZ9T36eYPwWUPbuq/Bvuo1RT+RmUxBZNKhSt7heH2GQGf?=
 =?us-ascii?Q?EoCqnajmNwswtNAQvDd2YOf2UcFiXd9R3UWqOuHGraBpnQXcrk07b2Z85ROz?=
 =?us-ascii?Q?pvmv2uG+IUV3xSBTZki7kl4dfMPdieJJGuFp88b9Q4/0TWlTdtg9r0a/tTaK?=
 =?us-ascii?Q?wmazQMB52bbb2XbysYVhFTuHQqkStBV7FXZMQIphn/VZEZYeA6tfDLgapUPZ?=
 =?us-ascii?Q?LLPzj8eZfkvLsroRDXlB9q5TBplqX6OXp3bPBiP/QeRJcX4/Yb2Lk9uHRVMB?=
 =?us-ascii?Q?IBhT2m5u4AHcohrUJkg+nnMLRKnsdwrAtRRYexxIQKoVNnzxfLCqxDc5yRZm?=
 =?us-ascii?Q?BRDbUgCPF0fcjJDCjcRWo5Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 20:37:39.4650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a45d332-64dd-4bc5-d0c7-08de59f615c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8528

Add man pages for the 'cxl-inject-error' and 'cxl-clear-error' commands.
These man pages show usage and examples for each of their use cases.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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

