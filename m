Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012071.outbound.protection.outlook.com [52.101.48.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999E93126D4
	for <nvdimm@lists.linux.dev>; Fri,  6 Feb 2026 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770414640; cv=fail; b=OEVivsM7WCTLGAL+hD6ettxk3ie3+rbtbfaYtVT6zgg6v56yEbA/urpKgSJTfm1jdxT16IvcjF/2xPzSD6JPgfqTYgeJ+v7+KApYXQmnJKbVY7Ky4QC7oVoA63hkNojVWhbxJ2kQeNmFNwFeul1iJFhNEiHKsO4z72/tTjEDCdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770414640; c=relaxed/simple;
	bh=wfS+wQnq2IKI4qWNSNU43Q+9a6s/E1fXDOShD6g13G0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAzdYx5WCytJwGwvcRxvYfcn//Apuve8zXcEEds6sIlXZW0k+GZ0mGY5qYsiYLBCh8G3KU5UnxhCZUtPCDS22RWmQWUgZYfWVQt73sHrBkHI0doTF6YM4jnANNPeB0WK48WREBKcN9Lj9swI15hHWJEoNi0LIL7A+PYD9LL/PPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J3bBe/NF; arc=fail smtp.client-ip=52.101.48.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J3bBe/NF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CG/p3IQmihfth4uuZIfgBF4rFWEpwCcaimjgZrb52FqJKN0tTup5bTLoNINICnOxHWqCJYaX8Lz6rfkJwHWhRctCqhUvxt3a2v0Kp2GeTVVSnyRWLg5OCUMETHnyyHbEKOEcYbHecqRai4tC4kkT/gYNzAFpo1c05nw/+uX6AmEQd0iWzykd/F1N3NClhxd0YBgvqpi1yKUjxXd4dXDe3kn5acI9UEIVbWDSmqVcopB3hodkSE6JldxpVGQTP+fXNcXLfrqBkx5CFWCiObND0daBBSwy/gmg3o4/B88nZaKLTS37LLnf8adzuuVnentdH8HQLT9SJi4DPCt10hXDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kzOb21PXaDcvwCQC6YtCubd+bjrn6ZN97eqWJqabEE=;
 b=PBW4wmHcy+vUjccjZtT5u7DcaOvopJF2ECQiH0oio91skAsgfcV92YProQJ+2UT0l80obUTn7c0gkjcpUmBCgP9WIJkIc0uKbnuhLojMexQ5NrrmnTVKzFoIutJ5IuE8/t3wos9oPbwHnPMz/B79enlGGwxFdfREAXIYMc1tr0sFJZMyLzzQ8Npl5l/ezL1Rl31REWuy9RfADbX2FkMAgwe/T23QVjcVjCQjBhrfiEztOg9X3cA0WScn6ukQV7U3e0HMTpfxv/KpYgo4R2r9x3Wyb7CYFrqHT0OAPhmaZqi41fpdHyL/i+FtpMGWZUQU8PzCxHsrek7/ho3pfEsefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kzOb21PXaDcvwCQC6YtCubd+bjrn6ZN97eqWJqabEE=;
 b=J3bBe/NFIuK8zHvWq4OwP8rjNSMuUeu6fY3JqePgc/pn/95VUOMXkzxefYWXRjmljQP2AhQkKQu5mgUtUxA97NOymL0/lJOLumN8XZfvS9Jni5YB1RbTVoRb/R+7TdLnbl1zRCj6HBc4knnzb5MBWr2EMN5fyDk4Vlq0kjvIxN4=
Received: from BLAPR03CA0164.namprd03.prod.outlook.com (2603:10b6:208:32f::20)
 by DS7PR12MB8251.namprd12.prod.outlook.com (2603:10b6:8:e3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.14; Fri, 6 Feb 2026 21:50:31 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::88) by BLAPR03CA0164.outlook.office365.com
 (2603:10b6:208:32f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 21:50:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 21:50:31 +0000
Received: from ausbcheatha02.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 15:50:26 -0600
From: Ben Cheatham <Benjamin.Cheatham@amd.com>
To: <nvdimm@lists.linux.dev>, <alison.schofield@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>
CC: <linux-cxl@vger.kernel.org>, <benjamin.cheatham@amd.com>
Subject: [PATCH v8 7/7] Documentation: Add docs for protocol and poison injection commands
Date: Fri, 6 Feb 2026 15:50:08 -0600
Message-ID: <20260206215008.8810-8-Benjamin.Cheatham@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
References: <20260206215008.8810-1-Benjamin.Cheatham@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|DS7PR12MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b65c7b-1771-48be-1f1f-08de65c9bfc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cczzSw1Qiq6fvt9uEeFLW3VYgTTYRvc9pj+tWxq35zDseAmnrczEwwDr4aOk?=
 =?us-ascii?Q?T74DhdHE7rB0A/fNoiiiMoDWrHGe/Xe4XvaUWL7bghRg22wvdisHNkvY5EOM?=
 =?us-ascii?Q?9JVf+8812GYty6hIuDyIUgLWG2g4xcqwRgEcjaQ9/AvzWN6jlEr/d1KFvj47?=
 =?us-ascii?Q?wm7QBK/7KHKeskoVMO5OuzTmglzbRC/Vn2xscAaVuCbbTzEcTRr2DHwQxnYr?=
 =?us-ascii?Q?y6WEandRa0FfV6Au0bMs7JeOiHsTrV/cDPLkSAMQTNkwPn4fOiwdIj4VKTEl?=
 =?us-ascii?Q?XQ8CYdPNQVnLR6U8gMv4Wc3WkWriLvTleH8TtJK2fcptTbQn42mTKGn0JnHx?=
 =?us-ascii?Q?6GDNIrGrG2HJJMA1m1V9orhIzf2KuTN5REhaNgXrNlxEDKbN+yOG6gETHq/U?=
 =?us-ascii?Q?L77CUf3gIYoZeSnpyqcMlAGCBkp1BsYu4ttBxsy3Ae24tti290S2jZ33EsXc?=
 =?us-ascii?Q?H6WaXec+nWysw+khr5GztDzQdNQ9kcG4m5q+h+n+K/2pFt7O8xCY+DYzzasa?=
 =?us-ascii?Q?aP1IhFzGGLo9LfCzzrIo+ESylL0cuxww+Y0LC4f9RNTXYAlesy9ApACbX/hW?=
 =?us-ascii?Q?XUGbvel+jEL8LJT0HHhrSsxYQ1dCa+r2HvmHZ80aN0Q82InRWJybCxOozNoI?=
 =?us-ascii?Q?/N0HEb9jy/XMKrwYM9t9UZOIoeZla5m+TEr/AYrWo4e8H5mosLrWXHqVJtst?=
 =?us-ascii?Q?sZyLhMk8QERxY6TlJUHLpBeU0WInUZDBVTorVJAKLddn8IJy6KMM+ekuftnh?=
 =?us-ascii?Q?p17kTTR8mwTIOn1uvTVox5w08nwCDjsu5N7RlKBbquQo5nbVx94iwvdhqNbD?=
 =?us-ascii?Q?9DebhnjAk7ruyhikKAXF2rykct6i2+TrehjljKunOYy5QqQ03sFgBGwxaYm3?=
 =?us-ascii?Q?Dm9rl3FXzpafFv39bQkBYYKHyQdfq6XPCzv+8i02ybqFXFs/NvbYUyp9tqn5?=
 =?us-ascii?Q?NbNJx2JneHkVFj9nXDlUZxJtc7zrWHz77qGLvOIEZLFeTKxUi5fB+ITBQr5+?=
 =?us-ascii?Q?moD2XyG4ivC0RssD1CSuP3uyu3UMc0aSX0JPTeViZleJ53cib1k1uobLtr/1?=
 =?us-ascii?Q?8WlCCP8TsGkcVqMco5nO/nczONdD3ryHeR38fO0jvjF8xDmXrZnPIkVA5x7k?=
 =?us-ascii?Q?O/4yZqkM4ZkOBarp3/3GUdKa2LHTCQ5DJShFgN5NGx8jQyBAJHr1XA5BkWf7?=
 =?us-ascii?Q?ZoNhwO4WDOdVLBIDHHpblDMpCjhnQzrkus8umcR0rLJ9gFimjsUETtKBGD5j?=
 =?us-ascii?Q?SkV4Bf5tL3KtHI1AQae3i9dJeoilAiMtRutn/GPTMIzFwou88FCdybwt5Eey?=
 =?us-ascii?Q?NsT7z00I512vglKKUB0ALcz1j+L4cC23xwdYvJLcJE+AMCISzS8/vMSa3msh?=
 =?us-ascii?Q?AGu9lq+LhoGm34V2NgZoM+Xcwr3sIS0At36WB3LaKT69q22WaYW1AKACs1Yh?=
 =?us-ascii?Q?vHlC0ZPxJZTKJg1EAHvAOmADMiKo0vzNUecIa7jpMUfXXw74NvOQQzAbU7Ab?=
 =?us-ascii?Q?+KyG1UM8R9pDDhV0MklJNa7exCKOExPLm+6OxZv8/lSERfmZ8MmuZi6yPd0K?=
 =?us-ascii?Q?1dlPkfQ9kVgcLVaUZEjy57Q+dE4UdkfI58OehLhViNKU7cWxpOQTr+5tOKxd?=
 =?us-ascii?Q?TEVBc6O4A90MK1tElIzsXTM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Em/Ivc2PqITw+8oCkTub1m/shSGZuSR5puohUvChCrATV/VaJsbO23tQ/kGDousbqpZdXhD9erO4WyhTjQYuIHTl1OT07lIyanpjME46v4n37g7xDZcPrvSilfpelerVVuJFsvUQJOFwS3hJ/h6hLf6ARXrd+xOCD3mb7A3UW+O1JusLF8gi9EIvhI5P9xp4jIno9LG+ZpjBHySzz5VtLeagKh/ywBeTmitTs61jQTOWVShOWQBb5ZD+DJBo6fdx3p9KHjxeYs+yP3cX67D1iz4IYt48W8x127x1DdDRum9F/qD81ZebipN/OcPFAjl4avO12wthtA+eUd1rQuWtyKwH6WIl6139NL24TRiIPhvrd+TZcwaGgrXHv/T6FV9hEM+wtvb+08hTVzWpz8KGjJXMZh2B8f+EgW1qKVVEC1LaPJJ/y+5bL1q07fO/lo2W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 21:50:31.3023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b65c7b-1771-48be-1f1f-08de65c9bfc6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8251

Add man pages for the 'cxl-inject-protocol-error', 'cxl-inject-media-poison',
and 'cxl-clear-media-poison' commands. These man pages show usage and examples
for each of their use cases.

Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
---
 Documentation/cxl/cxl-clear-media-poison.txt  |  85 ++++++++++++++
 Documentation/cxl/cxl-inject-media-poison.txt |  85 ++++++++++++++
 .../cxl/cxl-inject-protocol-error.txt         | 105 ++++++++++++++++++
 Documentation/cxl/meson.build                 |   3 +
 4 files changed, 278 insertions(+)
 create mode 100644 Documentation/cxl/cxl-clear-media-poison.txt
 create mode 100644 Documentation/cxl/cxl-inject-media-poison.txt
 create mode 100644 Documentation/cxl/cxl-inject-protocol-error.txt

diff --git a/Documentation/cxl/cxl-clear-media-poison.txt b/Documentation/cxl/cxl-clear-media-poison.txt
new file mode 100644
index 0000000..3c997b5
--- /dev/null
+++ b/Documentation/cxl/cxl-clear-media-poison.txt
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-clear-media-poison(1)
+=========================
+
+NAME
+----
+cxl-clear-media-poison - Clear poison from CXL memory
+
+SYNOPSIS
+--------
+[verse]
+'cxl clear-media-poison' <memdev> [<options>]
+
+Clear poison from a CXL memory device's memory. CXL memdevs can be specified
+by device name (e.g. "mem0"), device id ("X" in "memX"), or host device name
+("0000:35:00.0").
+
+To see if a device has poison that can be cleared use the 'cxl-list' command
+with the '-L'/'--media-errors' option. An example of a device that has had
+poison injected at device physical address (a.k.a. "offset") 0x1000:
+
+----
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
+----
+
+A device physical address is required to clear poison from a CXL memdev. The
+'-a'/'--address' option is used to specify the address to clear poison at.
+The address can be given in either decimal or hexadecimal. An example using
+the example device above:
+
+----
+# cxl clear-media-poison mem0 -a 0x1000
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
+See the 'inject-media-poison' command for how to inject poison into a CXL
+memory device.
+
+This command depends on the CXL debug filesystem (normally mounted at
+"/sys/kernel/debug/cxl") to clear device poison.
+
+OPTIONS
+-------
+-a::
+--address::
+	Device physical address (DPA) to clear poison at. Address can
+	be specified in hex or decimal.
+
+--debug::
+	Enable debug output
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]
+linkcxl:cxl-clear-media-poison[1]
diff --git a/Documentation/cxl/cxl-inject-media-poison.txt b/Documentation/cxl/cxl-inject-media-poison.txt
new file mode 100644
index 0000000..d35f1dc
--- /dev/null
+++ b/Documentation/cxl/cxl-inject-media-poison.txt
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-inject-media-poison(1)
+==========================
+
+NAME
+----
+cxl-inject-media-poison - Inject poison into CXL memory
+
+SYNOPSIS
+--------
+[verse]
+'cxl inject-media-poison' <memdev> [<options>]
+
+WARNING: Poison injection can cause system instability and should only be used
+for debugging hardware and software error recovery flows. Use at your own risk!
+
+Inject poison into a CXL memory device's memory. CXL memdevs can be specified
+by device name (e.g. "mem0"), device id ("X" in "memX"), or host device name
+("0000:35:00.0").
+
+Poison can only be used with CXL memory devices with poison injection support.
+To see which CXL devices support poison injection, see the "poison_injectable"
+attribute under the device in 'cxl-list'. An example of a device that
+supports poison injection:
+
+----
+# cxl list -u -m mem0
+{
+	"memdev":"mem0",
+	"ram_size":"256.00 MiB (268.44 MB)",
+	"serial":"0",
+	"host":"0000:0d:00.0",
+	"firmware_version":"BWFW VERSION 00",
+	"poison_injectable":true
+}
+
+----
+
+A device physical address is required for poison injection. The '-a'/'--address'
+option is used to specify the device physical address to inject poison to. The
+address can be given in either decimal or hexadecimal. For example:
+
+----
+# cxl inject-media-poison mem0 -a 0x1000
+poison inject at mem0:0x1000
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
+See the 'clear-media-poison' command for how to clear poison from a CXL
+memory device.
+
+This command relies on the CXL debugfs to inject poison (normally mounted
+at "/sys/kernel/debug/cxl"). If the CXL debugfs is inaccesible, the
+"poison_injectable" attribute will always be set to "false".
+
+OPTIONS
+-------
+-a::
+--address::
+	Device physical address (DPA) to use for poison injection. Address can
+	be specified in hex or decimal. Required for poison injection.
+
+--debug::
+	Enable debug output
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]
+linkcxl:cxl-clear-media-poison[1]
diff --git a/Documentation/cxl/cxl-inject-protocol-error.txt b/Documentation/cxl/cxl-inject-protocol-error.txt
new file mode 100644
index 0000000..196b6f6
--- /dev/null
+++ b/Documentation/cxl/cxl-inject-protocol-error.txt
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-inject-protocol-error(1)
+============================
+
+NAME
+----
+cxl-inject-protocol-error - Inject CXL protocol errors into CXL downstream ports
+
+SYNOPSIS
+--------
+[verse]
+'cxl inject-protocol-error' <dport> [<options>]
+
+WARNING: Error injection can cause system instability and should only be used
+for debugging hardware and software error recovery flows. Use at your own risk!
+
+Inject a CXL protocol error into a CXL downstream port (dport). Donwstream ports
+that support error injection will have their 'protocol_injectable' attribute
+in 'cxl-list' set to true.
+
+The '-p'/'--protocol' and '-s'/'--severity' options are required for error injection.
+The '-p' option is used to specify the CXL protocol to inject an error on; either
+"mem" (CXL.mem) or "cache" (CXL.cache). The '-s' option specifies the severity
+of the error and can be one of: "correctable", "uncorrectable", or "fatal".
+
+The types of errors (and severities) available depends on the platform. To find
+the available error types for injection, see the "injectable_protocol_errors"
+attribute under the applicable CXL bus object in the output of 'cxl-list'.
+For example:
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
+The dport to inject an error into is specified by host name (e.g. "0000:0e:01.1").
+Here's an example injection using the example bus listing above:
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
+# cxl inject-protocol-error "0000:e0:01.1" -p mem -s correctable
+cxl inject-protocol-error: inject_proto_err: injected mem-correctable protocol error.
+
+----
+
+CXL protocol (CXL.cache/mem) error injection requires the platform to support
+ACPI v6.5+ error injection (EINJ). In addition to platform support, the
+CONFIG_ACPI_APEI_EINJ and CONFIG_ACPI_APEI_EINJ_CXL kernel configuration options
+must be enabled. For more information, view the Linux kernel documentation on EINJ.
+
+This command depends on the CXL debug filesystem (normally mounted at
+"/sys/kernel/debug/cxl") to inject protocol errors. If the CXL debugfs is not
+accessible the "protocol_injectable" attribute of dports will always be
+set to false, and the "injectable_protocol_errors" attribute of CXL busses
+will always be empty.
+
+OPTIONS
+-------
+-p::
+--protocol::
+	Which CXL protocol to inject an error on. Can be either "mem" (CXL.mem)
+	or "cache (CXL.cache).
+
+-s::
+--severity::
+	Severity level of error to be injected. Can be one of the following:
+	"correctable", "uncorrectable", or "fatal".
+
+--debug::
+	Enable debug output
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1]
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 8085c1c..c4b22ab 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -50,6 +50,9 @@ cxl_manpages = [
   'cxl-update-firmware.txt',
   'cxl-set-alert-config.txt',
   'cxl-wait-sanitize.txt',
+  'cxl-inject-protocol-error.txt',
+  'cxl-inject-media-poison.txt',
+  'cxl-clear-media-poison.txt',
 ]
 
 foreach man : cxl_manpages
-- 
2.52.0

