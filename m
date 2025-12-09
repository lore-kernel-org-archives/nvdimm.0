Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010027.outbound.protection.outlook.com [52.101.201.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C18285061
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300556; cv=fail; b=sVOYvTlgZGn2Y/VU6n2ZXLPUVll8l+wQxoHpcJxSBhhfU8hBLeru7nq+7WE45AebL6M7sH813QGNaFIZ9psD0RFoaoXdwA2apFqa8be4lgJKOQ6XNI6zbeRe6uPNojF5eK2V9wBC0R6rFiP858CRHu5Sb9hFnFGD7rscx8zr6xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300556; c=relaxed/simple;
	bh=jReb5ZzfW5GH9j7FkHlOJ/RgaGlI7Uvsmm28pg1oBlE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A9CsXdwegwbxPd7eYsL9dWumc8DBE7w6ZvEoY4CzSQTYWjN4mqpoqo3hrt9wQBmUdzBra99iHyj7OAnz3Xgcl9QWsjEgfn0nE60pX6vuWjf8FJuAHaDt5OOBUIOInRTg281Y0K1KRwng7op8xol42OZZjzOwjUhIfdorV9h87qE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2w23YW0n; arc=fail smtp.client-ip=52.101.201.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2w23YW0n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GEWvTD1/weWnt2FF9Q4DilomTrTv33dAjW+hHWYFQe/s3etJs5JMoyKy/urE+pSGrnHZQ+cbAXSpmcoBzloE7U/ujdlHUYmWuAVSLIieDt71xM5gx+XJaPWVZIEr7UnPPcqjaPvOoWLyo17Ijgad9OVshpvCOhyRCis0iRSUJhX1NgqJ/9x9R4FnamyIfwm4b1gjalWx1ZcnNk6V/mLhv6Pqv5Us1q+/erokugUV8HYnHKPmZimBpqSoJxPjRtRVIhL7g8nzigKegMaeCBGfbtW3EoDrn8u71ZLi5d4TboHj6PmHPdDtSGqppQ7xu+SfXHyR9648OgxT7NgyinQ2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mQnlYNIm3aPrCcJ+cLJj0JkELvijr45puYNGYjmWcI=;
 b=W3jBIW2vELy/jjMieBFhO74tSiEP2ZoIWQHpgrOdnRCMPC0TwPofr+Om5f6PovFvX8m9itDc1nLi95CDdE3QmhPVOyS8rT6OtpDXB9rBPhbkWGQs8KkaG+uIDK5E1aVL4Y4BSsy1vneIA+RxRVG8wRisTdmAOCbTU4SbzVfcLNgXFmdBkt9kHPLc5kmdB+iJBfGxd2+hi4XOZ8BJ/4cfNHQPyasijVpMde7tgIA1IdbbMtanrIrOouoEDbyW+Hgmduu4ruQj1FbdRFWvjjn2cH9d1Q1Y5zt0HtuHWNhe+h9rGiW8unyePcDny6jwuLtWfv4y6ffuqqMbjnbhSid5qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mQnlYNIm3aPrCcJ+cLJj0JkELvijr45puYNGYjmWcI=;
 b=2w23YW0nxAZy+Tma+4eEiBOfBGI7QVcj5VHhd6J68dIiLyJBEmZf7usRDt6Ah21LPiUjmNUMQqn6X8am3tSvtxhZxFJ79/FoSRo8IJYZbNAfW6nymRf6hIlWx0+SrbGhwvsEOGydBS5K+3Wt1vROBU0X9kPYUu1r/ASxbGa5p2w=
Received: from SJ0PR13CA0111.namprd13.prod.outlook.com (2603:10b6:a03:2c5::26)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 17:15:47 +0000
Received: from CO1PEPF000042A9.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::45) by SJ0PR13CA0111.outlook.office365.com
 (2603:10b6:a03:2c5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.7 via Frontend Transport; Tue, 9
 Dec 2025 17:15:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042A9.mail.protection.outlook.com (10.167.243.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 9 Dec 2025 17:15:46 +0000
Received: from ausbcheatha02.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 9 Dec
 2025 11:15:45 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>
CC: <linux-cxl@vger.kernel.org>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <benjamin.cheatham@amd.com>
Subject: [PATCH v4 7/7] Documentation: Add docs for inject/clear-error commands
Date: Tue, 9 Dec 2025 11:14:04 -0600
Message-ID: <20251209171404.64412-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
References: <20251209171404.64412-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A9:EE_|BL1PR12MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8e577c-d1c7-4f6c-d2d1-08de37469800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lUsmeeJdJ2VWJWSeT8qmj1TywLwqV24DU/E+44HltrqQXLYbMm+m6dHy42F6?=
 =?us-ascii?Q?FTSyh9aOIU48EOlSalDe25NZBFQKMqykkuX5bCGif8fKLGh30+pBNe09Zwxk?=
 =?us-ascii?Q?NbFEU6l4JFdEfcyRAkExpMZSFMH5pNzOuDBPwDSkfnurdwl0GM1K2HTRG1jX?=
 =?us-ascii?Q?xv53sybUNemBqju50eaUHY2uofw5CuqQxfu/g5WhUYTRMwzhtRvj5WfGnp1A?=
 =?us-ascii?Q?EJWoS53bWYh0rpr/9kF73tLemy6If/gnMl9pvX1d526aXlLgG37OXXBX/CRC?=
 =?us-ascii?Q?V0P4DfymaUBOHnqO0Ql0Zef9Kt9Z3wT+XhSWRyH+xv93nJcc5Y1tN9Efkkup?=
 =?us-ascii?Q?whselHZN8/meLFbkpbWYs/EXtbSa3CyvW2L9LEF92JI269Riwn8ekH+cpBv4?=
 =?us-ascii?Q?w3trlWwp37kRfgp5g3xJ+CH51xPIgDPtb8fFMn2Kn/eCfwwcwsa1vY6SkWLV?=
 =?us-ascii?Q?WN/U3hfUiSEVV/fkb35XH/9267mdEU0DrWVgvgpmQcm5V2We7u4xFWHP5IKX?=
 =?us-ascii?Q?zlHwIEEyH9LbczAquvuVri4lbK16Ty2QizqTeTrg+Rub58kG535MCEDAZnOk?=
 =?us-ascii?Q?srZjiS7BBNiVTfnUAkem60h9/rOkNSPW9whP6gQag2nQr5nTZ+jwnx/kkJm/?=
 =?us-ascii?Q?tfM8V4DpUe4Lp/MtANgKoKcDT1bcyhhAdSwcEpz2D0d16nc9AZa5Gfc81hUu?=
 =?us-ascii?Q?vLR3/N1maB1+t/4VGLSLsMI46XlYTChUJS38okX9aX15/root1L8w9dmeoYl?=
 =?us-ascii?Q?XTFECwB2nYra5ALbR5aIhqPPqjVeZ7zvU/Y9666NHegTFOnSl65wb2fqUUvI?=
 =?us-ascii?Q?fRIEIKcpqGMOahvFgV4aGhzBhDhTYf+ZOjkGAK2w3DjzgEuX8Kotwwe49uub?=
 =?us-ascii?Q?qoj/Gv9hiRk4QYLcL5dTUaWSqJF+5pQlhbHwq9MlMn6zQzOkv1DCgkdZmxr+?=
 =?us-ascii?Q?aGRgnYlQtsXlscCbQMOoejr6YTKhlzYmx0J84Pe/INJ0SuiSntnLkgSc3UX9?=
 =?us-ascii?Q?uLEWyBLT8R9iky/v1qaj6ngVJ8UrtNCKleh1/BDvNaPui1jxpv4Jv3ME4tyi?=
 =?us-ascii?Q?5LOj+oOUYTOiV5ddeXNcSfqLUYbW4Yz+atn5lSXgXR7dMNDlqaTqQ90eEB19?=
 =?us-ascii?Q?aIiN0tkmmMsmkcOcbhArRa4Qdqi2W87Rcx4eRzCRzkJDd7tFKkIq0lpMv4NO?=
 =?us-ascii?Q?96e/uTisptVJYoMZAvNLQ2Auln05phX679n4coD1zlpQ587cp+cvDuuyyO6g?=
 =?us-ascii?Q?UceaVqoNtWrP47/ob/pEh8X9LcRQMLPhI4503ul3GcW9KthGxOGytpeXVcg0?=
 =?us-ascii?Q?krPkO2XXoRF9OVkoMJhTf52B4pUu6Vc/qaNYygvIiZGQZJLuWr/taH6+Og1H?=
 =?us-ascii?Q?p8fz2eHb0pX0vwyA2H9lWojOyTJehnPNjo+9+C7zFCh0JmvaLDF/yxJy1pYQ?=
 =?us-ascii?Q?FWSJUxYTZsxhn+h+ECPhVdBzOmBXSV2fa1WLkq5PZANRn90AG6Iss/nmFOa7?=
 =?us-ascii?Q?fbXNPOeQ/Dy8x2zT3XFNky/3r3SaOIosQ5iC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 17:15:46.9286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8e577c-d1c7-4f6c-d2d1-08de37469800
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803

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
2.51.1

