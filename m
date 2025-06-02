Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F238B1993BD
	for <nvdimm@lists.linux.dev>; Mon,  2 Jun 2025 20:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748897888; cv=fail; b=bi4xpv8AEhvZvzgAQRKXGoTv8Zqp0xxUvJfcNqxEpf+2apYx8w6ZPkkV3BIo/7NY8PN+KXEO16APLRno9XKi+H+m1tIkfj14WcewWSz/yp/RKZNmMjgTGwhSBOCrkz4XsgrT3626djaj0iFs5IXdL7qbx/2T/RYvXMO234maT+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748897888; c=relaxed/simple;
	bh=I68xBZmXvTkjIXNm8JPJ7abYCNgkS+DCdZ+IsTwIeEY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yamyv7Yl5mp7sWDG+YpCS8AnZWYd+8h+mLcyDSJ1Bm7wFNWFQ2JNWtnXn27QXqLMred4MKWb+rECUD+N0ngBLeSaTyE+nvTKi10yqCb7YmLdHVZPVrvDsXFYkTNu9bVtDdd5kVyNd+wGSael7XFDdA0EiMVoBAZ0GKinPtr4hzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qzjuAh4R; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qzjuAh4R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVilo+Xf7MSv6q0ZL+KNC2iBc4CrkAZUpaWBdCvGS3zZIANu5FFchjQICBTFuMiqasQ41KGfs+DkU1nV6pnvefHrdlrZNH5XL8wbFw+nxX2e9lQUCgmq/Kvrz1POI01oCDyhiB0RDDXtL9CXrejQ7kmUH14Ngf9xjsMbZrLwECgvgt2EUZ4TJFYYagXlTx6cvBIbgub/ZRHEVs8jH3GdK0BGhEc+dpwI2LH+TMMe7CMwT0wckcYHMmUKHrNvZ27OI8j3BAbNhQ1uPMK7R7mbrodZV4uw6lHhMCdNn9+jSg1iSlThUqsiJrcFlAtGQ1B9+q2ZePOk3/q1GLZdVtUfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqqP2PlRq6Fma43b8rDZtyGyQVmqzd/Dtn/r4IGqwzM=;
 b=O4kSwS/3Dc4dh3RNe0nTOiUk2JaPesU3K/uu4/aN/lFHAfCNJxte8YCZ4RXcMKbsPtmGOq5iJdDNrF98UXv/t/OIH/y6pfrECGJJcTc3aznhnxlhxVH9Pp7nWJVkiinZkhI+FTKFYgiXuMZaKWS+1vHd5oOM85o+Cy0iQ0ACALR+jbirGKG6BS32am8nJmy4gTHXYq0ZfbHEuWKodnESa+ofJQBy8JoSTVacen/Abn8WO4A1gK87BdiNLaI64ZrYwhUWfPF3Pbjr/teW+rn09skKFet9hw7gNuNFrW8t2t7g3VWGSEkQvF2FSBF9kgiUhOLyMw/j+HOqjK1X9DruoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqqP2PlRq6Fma43b8rDZtyGyQVmqzd/Dtn/r4IGqwzM=;
 b=qzjuAh4RKDEmj73esqAVWgFD7E5z+DVhB3+DRssQmVKl3t6V3elPsrHg2hX7oFICGa4aKxvWasMQWjZ0zm1MJpbVLCbRTRsWpdduvCqwxv2NSwadZ8fvspzj1vwsJeTpnJmI3lWatBdjDDrPWzFl4TPWtcLIhxZaXYe6sW/BvP8=
Received: from BN8PR04CA0064.namprd04.prod.outlook.com (2603:10b6:408:d4::38)
 by MN6PR12MB8492.namprd12.prod.outlook.com (2603:10b6:208:472::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 2 Jun
 2025 20:58:01 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:d4:cafe::94) by BN8PR04CA0064.outlook.office365.com
 (2603:10b6:408:d4::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.31 via Frontend Transport; Mon,
 2 Jun 2025 20:58:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8792.29 via Frontend Transport; Mon, 2 Jun 2025 20:58:01 +0000
Received: from SCS-L-bcheatha.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 2 Jun
 2025 15:58:00 -0500
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>,
	<alison.schofield@intel.com>, <junhyeok.im@samsung.com>
Subject: [ndctl PATCH v2 7/7] Documentation: Add docs for inject/clear-error commands
Date: Mon, 2 Jun 2025 15:56:33 -0500
Message-ID: <20250602205633.212-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
References: <20250602205633.212-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|MN6PR12MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b79b57-4dbf-4679-42a1-08dda2182991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LuEtPtq7M/ocaJKspl/5IPLmHKDlSy7ZcLsfgh4o/wvvGt6nIqZ/UIW33i42?=
 =?us-ascii?Q?5qWSyMZFoeXTEx7ULinl+xZOb9/KSxVhdgZDJo8ExrHfhTYKWn6WjEwvgKbs?=
 =?us-ascii?Q?geFqN7gv1oKksuxc5EY+JCe1JF4dSimx3oG/MDM5MK5BM83tkJmfGcK24iAW?=
 =?us-ascii?Q?vnMj+U8BFgU4SNAQxS9g/QuKS7jQusjYmYdalapHKYF17UwF2pLYgOodAVYD?=
 =?us-ascii?Q?0yxdfmyZ3j0xGnfCn6Qiwz1z5Xus/y58Amb60A3m+1GnZhu4LMza9sJtaHZZ?=
 =?us-ascii?Q?0NMjsLKvjuyALhIumRQs0x5ngeGdbQMV6eqZkRJgWqt2Qn9TJuSKpSGkPBRf?=
 =?us-ascii?Q?FuSHcskvzsrTF6o3AcrUwG5qXK1jLTn+fWLpEwApU6KtzD1NUX+9zq0XH2tu?=
 =?us-ascii?Q?xJLjDAkiIE6ROqU3ONvOdQw2R0TOjZktktg/g8tiew0cJ4HV1euAw1LQpWyX?=
 =?us-ascii?Q?oYI9Rq4XA2cp/fDfr9VYHc69GkmJlRFqB7uQqVkvQcS6ETmsNl5UI1NWiReL?=
 =?us-ascii?Q?8U3/MKwKziYRwToY+IJ41hp1j3mLJQec64/FgozNS8J5ZaXIaDZdWLCfgufi?=
 =?us-ascii?Q?jAbZy2i7/CyHkjM4zU1iDfvyWDdYvgo3RgakyZAZP3mKaJZBSAky3huro0Gs?=
 =?us-ascii?Q?dcb6LEnffPhuaCOGQkjHZ9BeHIMvG/p2Rqc8yf5jAWc4vQel45IJvzOGAZyD?=
 =?us-ascii?Q?Nz8sSaT6zcPUgeyhkQ/QBWaizxXWcPAGgTIIXWBrQfRHI7AzSslMi7LVzU/e?=
 =?us-ascii?Q?WmO01ICSqtFB66cT43v5NELwJIOHR0eAp273Z+BGhTdpaF0DwQ92gfRDmIJG?=
 =?us-ascii?Q?3Zin7VlnbGSgQml35KiXwHGn+5sIW7Wo/btwoWjV/3Xu2SkcxPcaTMGfCL4q?=
 =?us-ascii?Q?SPKB2jGy87lNMKrB1AB8yNURp533Zx8uAOKkygZaVZM66nTN1So3BPvK4MO9?=
 =?us-ascii?Q?zkx/r1AYCGSoLQd1mLGDmSZFwDzKk7+g+YDyXlGkl+YGxRwjWvVCZXDi36n9?=
 =?us-ascii?Q?gh8A6/ltpmv9VJOrP7QxOAEqpS+W9TR+uM+O/kG4B/oyl9Nf9EnOfE7aCGQB?=
 =?us-ascii?Q?72kUdk7TR3Zgh+a6ttzlZQPl7CFqrTvEavJQdt1wjpDC5QjeQMk1wryaKBAc?=
 =?us-ascii?Q?G8ZiTBq7kOw3nYIUHQgxNmESFg3RzLkCtO1AOOI9cwRYccubZPZFRnGB1+XB?=
 =?us-ascii?Q?pt43ieis10Svg5/Kd3kQF3XSG1t7s78JOjYdQYubGgP9iY1YufKR6ptT7e7w?=
 =?us-ascii?Q?ESnzLc4RNb+MQhOIZ6HzbGiNh/OiqxWRIHwTpPnrOioP5YsFEm2ikg44vQrh?=
 =?us-ascii?Q?dOwBcCDwsuDVWw8hW1NcU9J24sQa/wtCjJubSksXui3Qz+K1Eemv/QWNTigX?=
 =?us-ascii?Q?+1qDPEMQLmglLC3OvtpGMNcYgnBEGzXqDAs/o7WZqn5zJFBrowdkwdN8Wf3t?=
 =?us-ascii?Q?M30pJ/NMWOIHjHOBwVG6dBQVy5ArDHUOl5Xap68Vv7vF52NV9gVkaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 20:58:01.6357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b79b57-4dbf-4679-42a1-08dda2182991
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8492

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
index 0000000..a0263dd
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

