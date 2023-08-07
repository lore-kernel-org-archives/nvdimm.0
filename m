Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B214F88
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 21:36:55 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6tk2fgkthCyiYnAvG+2mmStZtqMJbPog7YHgscN6yuzet0emeoAhTnQMVesVUwuh+jhKaGuTcjRv4Yll05afC3t6RQABW8RhcMrUT+2YurlhPYCDrPylyws0tXIMz7U1S1uqj2ftPPBI9k2hSrC6CP8igEVhnMiiBdBX+rgF8DRbuWTpmyxtoQ4jMl7Hs8cXxOn0luC7M4CKUMtv1oloraEaswRGZ8/rF9VVnf3I0uRUCizrK6EDjupDtphYdaXXPJwDVcMwDmtGNvLxlZ7OEF0goLC/QVpwZOodUluKctpE3NXz8fn03FPwJC5t76eEzNseVTCOd4DniPMQrPCJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ii86rUJuT5Iah0jCy8S3M8RP2Bfh2+EH9Vajyr4larA=;
 b=euy1i1QzJCj/RZijX5InDWPC9yI5PaNPg0gRhjnsGHGk4G1RvGodolWlznzJ3cQSuatVV0f+5CM4uYrxTdcfC99DSdlsr+RKtWgUGL8KTKVvESvEPZtHCrOzjgJnFIyKMm1pjz2uoZNOXH3+0SpMoKRHrFekyKbt3/7fLId685vrJ28hJxvmOvN5M05yVAzhyQ1jgyCBaAKOusuhKhD39OWS7RKzCwLu/umYu+Ok7YhEpdAuvo1WsYZcn1cnE31KB5oNy/GO+DLl3posDyAkZY3bSBpWVJ5JjFkhbs6GyMEeEZagS+/yATHOnmahjb3NiCckASLNDLHGTighHBaqwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ii86rUJuT5Iah0jCy8S3M8RP2Bfh2+EH9Vajyr4larA=;
 b=zzqXHouu9Alp7g/cwLnT6ykKsChe4NVG5+kJRWDxHOncHcW60m3igFzZngjz6oQ9gwju6OifAA5IEOvSi9ZSalOgVPuOcVeQFC8IZdtDs0BMJeuRwiYq5+BpDnayzIyBm1wCN8tsAjh+2AUomoKMvtvmKdc2mpewGDlCmzFo4CE=
Received: from SA1PR03CA0011.namprd03.prod.outlook.com (2603:10b6:806:2d3::23)
 by MW5PR12MB5599.namprd12.prod.outlook.com (2603:10b6:303:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Mon, 7 Aug
 2023 21:36:53 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:806:2d3:cafe::49) by SA1PR03CA0011.outlook.office365.com
 (2603:10b6:806:2d3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27 via Frontend
 Transport; Mon, 7 Aug 2023 21:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.19 via Frontend Transport; Mon, 7 Aug 2023 21:36:52 +0000
Received: from ethanolx7ea3host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 16:36:51 -0500
From: Terry Bowman <terry.bowman@amd.com>
To: <nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <vishal.l.verma@intel.com>, <mav@ixsystems.com>
CC: <terry.bowman@amd.com>, <linux-cxl@vger.kernel.org>
Subject: [ndctl RFC 1/1] cxl: Script to manage regions during CXL device hotplug remove-reinsert
Date: Mon, 7 Aug 2023 16:36:35 -0500
Message-ID: <20230807213635.3633907-2-terry.bowman@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807213635.3633907-1-terry.bowman@amd.com>
References: <20230807213635.3633907-1-terry.bowman@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|MW5PR12MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: dd326b5a-e1eb-4441-92fe-08db978e6a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aSn+kFSDvT4EFIGTsy9m5ww09aXN2ZTo0ZOyyOauq+XL4uwjjP+wKOtXr6SmYz177C1wtqRGHz1yt5K1fGce/YwTEaGF05mca2LQcBWO1N18dxdEAyvKRWCbPOCKoRpEGOids+ZqvSUSmVnJmIMvIzsJeBf8YuRbAlqLsVlOzjQmu6jtpNyh2fjl1AIBFAdbQq6n3VUt8PqcyCtuRyOSkzJtx8mMmRdDTK36A6u2R+06uyyNvrPJwRNdEuXbG9g/mMDgWVISuAw4D32zBoyfGZuLh+hcjb6EkaVK6c4T1uFdjW4xNBmRDTOD22E7kiAo+GX69StQyFroTTIb/bqLrjrIvOwyB7yJb5QeNb/mhZs3nylgQ4jx4p/+vtqYiF0LFzeNyXHxSutVWruA9gSesI4T8a2lQuH4jvLRHGRlhD03Q2cYW6/jIlQS7K2T9XzemPmmf0NumYjsOgIJ4DNPjwITS3VJkK2dObPPkSNhZKR4Z01h/rkG8um4/uIKL7eT6kmAUz3f6UNzhJf0aU8rB3eMhvQfA5mbj/7R1Wk1izPh53TWpt5+wm7bnS6OflFAz0AtWNnke8gRU6wiKTD6sGQEMNmab/75cdIi9Vuug/SO75yX7mi3uDa1j/ISs+tJJ1SaUL8RSfbxpm3Ux5UiZb5PE8+6I/hfQ9FwV8etdH5YfjV5FXF1ajqlUcZfXb+UzLZo+VSwYvyDTnKGXVIBX9b1Qh/5JrHAipd8u6C4kxL82RQtMlYcstUGBD0Dk2Lv3eYQgBvSOucMa9632+iwkGsPg5oDBt+t1gX1gHzBa4M=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(186006)(1800799003)(82310400008)(451199021)(46966006)(36840700001)(40470700004)(7696005)(6666004)(40460700003)(86362001)(40480700001)(26005)(36860700001)(1076003)(336012)(426003)(2616005)(36756003)(83380400001)(47076005)(81166007)(82740400003)(356005)(5660300002)(30864003)(41300700001)(16526019)(8676002)(8936002)(4326008)(2906002)(70586007)(70206006)(316002)(478600001)(44832011)(110136005)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 21:36:52.4102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd326b5a-e1eb-4441-92fe-08db978e6a20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5599

Hotplug removing a CXL device and hotplug reinserting the same device
currently requires manual interaction for managing the device
region. The CXL device region must be manually destroyed before
hotplug removal and manually created after hotplug reinsertion.

Create a script to automatically destroy and recreate the region
during CXL device hotplug remove-reinsert. Save region characteristics to
a file before destroying the region and hotplug remove. Use the region
characteristics stored in the file to recreate the region after
hotplug reinsert.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
---
 README.txt     | 311 +++++++++++++++++++++++++++++++++++++++++
 cxl-hotplug.py | 366 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 677 insertions(+)
 create mode 100644 README.txt
 create mode 100755 cxl-hotplug.py

diff --git a/README.txt b/README.txt
new file mode 100644
index 0000000..97fa793
--- /dev/null
+++ b/README.txt
@@ -0,0 +1,311 @@
+                          ____________________
+
+                           CXL-HOTPLUG.README
+                          ____________________
+
+
+Table of Contents
+_________________
+
+1. Purpose
+2. Requirements
+.. 1. Kernel - v6.4.0
+.. 2. ndctl - v77 or later
+.. 3. QEMU - v8.0.3 + the following patches:
+.. 4. Python modules:
+.. 5. Additional tool details
+3. Usage
+4. Examples
+.. 1. Swap a device
+.. 2. Manually unplug and plugin a device
+.. 3. Manually unplug and plugin a device (w/ step by step details)
+
+
+
+
+
+1 Purpose
+=========
+
+  Hotplug adding and removing CXL devices requires region management not
+  automatically provided. For instance, if a CXL device is added then a
+  region must be 'created' before the memory can be used. Likewise, a
+  region must be 'destroyed' before a CXL device can be
+  removed. Removing a CXL device before a region is 'destroyed' can
+  result in CXL device data loss or corruption.
+
+  This tool aims to provide region delete and create automation for an
+  existing CXL device. The typical usage is to hotplug remove an
+  existing CXL device and then hotplug readd the same device immediately
+  or at some later time.
+
+  An unplug function is provided that will 'destroy' the region making
+  the device ready for hotplug removal. Note, 'destroying' a PMEM region
+  incurrs no loss of data. 'destroying' a RAM region will lose the
+  region data. This tool saves the region structure information so that
+  the device's region can be created in the future. After the device is
+  hot hotplug added in the future the region information is used to
+  recreate the region. The region information is saved to a default file
+  or can be directed to a specific file provided on the tool comandline.
+
+  This tool provides a swap function that automatically executes the
+  unplug and plugin functions.
+
+  This tool is currently limited to non interleaved devices.
+
+
+2 Requirements
+==============
+
+  Tested using the following:
+
+
+2.1 Kernel - v6.4.0
+~~~~~~~~~~~~~~~~~~~
+
+  To include the following kernel config settings:
+  ,----
+  | scripts/config --enable LIBNVDIMM
+  | scripts/config --enable CONFIG_CXL_BUS
+  | scripts/config --enable CONFIG_CXL_PCI
+  | scripts/config --enable CONFIG_CXL_ACPI
+  | scripts/config --enable CONFIG_CXL_MEM
+  | scripts/config --enable CONFIG_CXL_PMEM
+  | scripts/config --enable CONFIG_CXL_PORT
+  | scripts/config --enable CONFIG_CXL_SUSPEND
+  | scripts/config --enable CONFIG_CXL_REGION
+  | scripts/config --enable CONFIG_CXL_REGION_INVALIDATION_TEST
+  | scripts/config --enable CONFIG_PCIEAER_CXL
+  | scripts/config --enable CONFIG_TRANSPARENT_HUGEPAGE
+  | scripts/config --enable CONFIG_DEV_DAX
+  | scripts/config --enable CONFIG_DEV_DAX_HMEM
+  | scripts/config --enable CONFIG_DEV_DAX_KMEM
+  | scripts/config --enable CONFIG_DEV_DAX_PMEM
+  `----
+  The above configures for statically linked drivers. They could be
+  dynamically linked as modules as well.
+
+
+2.2 ndctl - v77 or later
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+
+2.3 QEMU - v8.0.3 + the following patches:
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+  20230227163157.6621-1-Jonathan.Cameron@huawei.com
+  20230303150908.27889-1-Jonathan.Cameron@huawei.com
+  <https://lore.kernel.org/linux-cxl/20230303152903.28103-1-Jonathan.Cameron@huawei.com/\#r>
+
+
+2.4 Python modules:
+~~~~~~~~~~~~~~~~~~~
+
+  The following python modules are required: json subprocess os argparse
+  logging
+
+
+2.5 Additional tool details
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+  <https://confluence.amd.com/display/ALK/CXL+QEMU>
+
+
+3 Usage
+=======
+
+  The utility requires one of the sub-commands: plugin,unplug,list,swap.
+
+  Commandline usage information:
+  ,----
+  | usage: cxl-hotplug.py [-h] {plugin,unplug,list,swap} ...
+  | 
+  | positional arguments:
+  | {plugin,unplug,list,swap}
+  | 
+  | options:
+  |   -h, --help            show this help message and exit
+  `----
+
+  Commandline plugin usage information:
+  ,----
+  | usage: cxl-hotplug.py plugin [-h] -m MEMDEV [-c CONFIG_FILE] [-d]
+  | 
+  | options:
+  |   -h, --help      show this help message and exit
+  |   -m MEMDEV       CXL memory device to prepare for unplug
+  |   -c CONFIG_FILE  CXL JSON configuration file to use
+  |   -d, --debug     Enable debugging
+  `----
+
+  Commandline unplug usage information:
+  ,----
+  | usage: cxl-hotplug.py unplug [-h] -m MEMDEV [-c CONFIG_FILE] [-d]
+  | 
+  | options:
+  |   -h, --help      show this help message and exit
+  |   -m MEMDEV       CXL memory device to prepare for unplug
+  |   -c CONFIG_FILE  CXL JSON configuration file to save
+  |   -d, --debug     Enable debugging
+  `----
+
+  Commandline swap usage information:
+  ,----
+  | usage: cxl-hotplug.py swap [-h] -m MEMDEV [-d]
+  | 
+  | options:
+  |   -h, --help   show this help message and exit
+  |   -m MEMDEV    CXL memory device to swap
+  |   -d, --debug  Enable debugging
+  `----
+
+
+4 Examples
+==========
+
+4.1 Swap a device
+~~~~~~~~~~~~~~~~~
+
+  ,----
+  | # cxl create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M
+  | # ./cxl-hotplug.py swap -m mem0
+  | Device 'mem0' can now be safely removed.
+  | Card is ready for removal.
+  | Press any key to continue after card reinsertion.
+  | Region created for 'mem0'.
+  `----
+
+
+4.2 Manually unplug and plugin a device
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+  ,----
+  | # cxl create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M
+  | # ./cxl-hotplug.py unplug -m mem0 -c my-cxl.json
+  | # ./cxl-hotplug.py plugin -m mem0 -c my-cxl.json
+  `----
+
+
+4.3 Manually unplug and plugin a device (w/ step by step details)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+  ,----
+  | # cxl list 
+  | [
+  |   {
+  |     "memdev":"mem0",
+  |     "ram_size":268435456,
+  |     "serial":0,
+  |     "host":"0000:0d:00.0"
+  |   }
+  | ]
+  | 
+  | # ./cxl-hotplug.py list
+  | Device        Region Name        Region Size        Movable
+  | ======        ===========        ===========        =======
+  |   mem0                 NA                 NA             NA
+  | 
+  | # cxl  create-region -t ram -m  mem0 -d decoder0.0 -w 1 -s 256M 
+  | {
+  |   "region":"region0",
+  |   "resource":"0x890000000",
+  |   "size":"256.00 MiB (268.44 MB)",
+  |   "type":"ram",
+  |   "interleave_ways":1,
+  |   "interleave_granularity":256,
+  |   "decode_state":"commit",
+  |   "mappings":[
+  |     {
+  |       "position":0,
+  |       "memdev":"mem0",
+  |       "decoder":"decoder2.0"
+  |     }
+  |   ]
+  | }
+  | cxl region: cmd_create_region: created 1 region
+  | 
+  | # cxl list 
+  | [
+  |   {
+  |     "memdevs":[
+  |       {
+  | 	"memdev":"mem0",
+  | 	"ram_size":268435456,
+  | 	"serial":0,
+  | 	"host":"0000:0d:00.0"
+  |       }
+  |     ]
+  |   },
+  |   {
+  |     "regions":[
+  |       {
+  | 	"region":"region0",
+  | 	"resource":36775657472,
+  | 	"size":268435456,
+  | 	"type":"ram",
+  | 	"interleave_ways":1,
+  | 	"interleave_granularity":256,
+  | 	"decode_state":"commit"
+  |       }
+  |     ]
+  |   }
+  | ]
+  | 
+  | # ./cxl-hotplug.py list
+  | Device        Region Name        Region Size        Movable
+  | ======        ===========        ===========        =======
+  |   mem0            region0          268435456           True
+  | 
+  | # ./cxl-hotplug.py unplug -m mem0 
+  | Device 'mem0' can now be safely removed.
+  | 
+  | # cxl list 
+  | [
+  |   {
+  |     "memdev":"mem0",
+  |     "ram_size":268435456,
+  |     "serial":0,
+  |     "host":"0000:0d:00.0"
+  |   }
+  | ]
+  | 
+  | # ./cxl-hotplug.py list
+  | Device        Region Name        Region Size        Movable
+  | ======        ===========        ===========        =======
+  |   mem0                 NA                 NA             NA
+  | 
+  | # ./cxl-hotplug.py plugin -m mem0 
+  | Region created for 'mem0'.
+  | 
+  | # cxl list 
+  | [
+  |   {
+  |     "memdevs":[
+  |       {
+  | 	"memdev":"mem0",
+  | 	"ram_size":268435456,
+  | 	"serial":0,
+  | 	"host":"0000:0d:00.0"
+  |       }
+  |     ]
+  |   },
+  |   {
+  |     "regions":[
+  |       {
+  | 	"region":"region0",
+  | 	"resource":36775657472,
+  | 	"size":268435456,
+  | 	"type":"ram",
+  | 	"interleave_ways":1,
+  | 	"interleave_granularity":256,
+  | 	"decode_state":"commit"
+  |       }
+  |     ]
+  |   }
+  | ]
+  | 
+  | # ./cxl-hotplug.py list
+  | Device        Region Name        Region Size        Movable
+  | ======        ===========        ===========        =======
+  |   mem0            region0          268435456           True
+  `----
diff --git a/cxl-hotplug.py b/cxl-hotplug.py
new file mode 100755
index 0000000..971e4e7
--- /dev/null
+++ b/cxl-hotplug.py
@@ -0,0 +1,366 @@
+#!/usr/bin/python3
+# SPDX-License-Identifier: LGPL-2.1
+#
+# Copyright (C) 2023, Advanced Micro Devices (AMD). All rights reserved.
+#
+# @Author - Terry Bowman
+#
+# Utility to support CXL hotplug removal and re-insertion. The purpose
+# is to recreate a CXL region during insertion that existed before
+# removal.
+#
+# '--unplug' sub-command option will save the CXL region information to
+# a file before a manual hotplug removal.
+#
+# '--plugin' sub-command after hotplug insertion will recreate a device
+# region using the details from the configuration file.
+#
+# '--swap' sub-command will run the same functionality as '--unplug',
+# then prompt for when the card is plugged in, and then execute the
+# '--plugin' functionality.
+#
+# '--list' sub-command will list the CXL devices and associated regions.
+#
+
+import json
+import subprocess
+import os
+import argparse
+import logging
+import tempfile
+
+class cxl_json:
+
+    cxl_memdev_json = {}
+    decoders_root_json = {}
+    regions_decoder_json = {}
+    daxregion_json = {}
+    daxregion_devices_json = {}
+
+    def cxl_list_memdev(self, memdev):
+        result = subprocess.run(["cxl", "list", "-m", memdev, "-RBMTXEPD"],
+                                capture_output=True, text=True)
+        if result.returncode != 0:
+            print("Error: cxl list command failed for: " + memdev)
+            exit(1)
+
+        result_json = json.loads(result.stdout)
+
+        if not result_json:
+            print("CXL list is empty for: " + memdev)
+            exit(1)
+
+        return(result_json[0])
+
+    # Cache embedded json dictionaries to make more easily accessible.
+    # This helps in later processing .
+    #
+    # If the CXL json dictionary is missing any CXL components than this
+    # implies a CXL device is not configured. In this case exit with an
+    # error and message.
+    def decode_json(self, fatal_error = True):
+        for key in self.cxl_memdev_json:
+            if key.startswith('decoders:root'):
+                self.decoders_root_json = self.cxl_memdev_json[key][0]
+        if self.decoders_root_json == None or \
+           len(self.decoders_root_json) == 0:
+            if fatal_error == True:
+                print("Error: Failed to find decoder root CXL json.")
+                exit(1)
+            else:
+                return
+
+        regions_decoder_key = "regions:" + self.decoders_root_json.get('decoder')
+        if self.decoders_root_json.get(regions_decoder_key) == None:
+            if fatal_error == True:
+                print("Error: Failed to find region decoder in CXL json.")
+                exit(1)
+            else:
+                return
+
+        self.regions_decoder_json = self.decoders_root_json.get(regions_decoder_key)[0]
+        if len(self.regions_decoder_json) == 0:
+            if fatal_error == True:
+                print("Error: Failed to find region decoder in CXL json.")
+                exit(1)
+            else:
+                return
+
+        # PMEM CXL JSON does not include DAX keys searched for below, return early
+        if 'pmem' == self.regions_decoder_json.get('type'):
+            return;
+
+        for key in self.regions_decoder_json:
+            if key.startswith('daxregion'):
+                self.daxregion_json = self.regions_decoder_json[key]
+        if len(self.daxregion_json) == 0:
+            if fatal_error == True:
+                print("Error: Failed to find daxregion in CXL json.")
+                exit(1)
+            else:
+                return
+
+        for key in self.daxregion_json:
+            if key.startswith('devices'):
+                self.daxregion_devices_json = self.daxregion_json[key][0]
+        if len(self.daxregion_devices_json) == 0:
+            if fatal_error == True:
+                print("Error: Failed to find daxregion devices in CXL json.")
+                exit(1)
+            else:
+                return
+
+    def get_block_size_bytes(self):
+        result = subprocess.run(["cat", "/sys/devices/system/memory/block_size_bytes"],
+                                capture_output=True, text=True)
+        if result.returncode != 0:
+            print("Error: cxl destroy-region command failed. rc = " +
+                  str(result.returncode))
+            exit(1)
+        return int(result.stdout, 16)
+
+    def is_region_movable(self):
+
+        # PMEM doesn't have movable concept
+        if 'pmem' == self.regions_decoder_json.get('type'):
+            return True;
+
+        block_size_bytes = self.get_block_size_bytes()
+        resource = self.regions_decoder_json.get('resource')
+        resource_size = self.regions_decoder_json.get('size')
+        start_block = int(resource/block_size_bytes)
+        stop_block = int((resource+resource_size)/block_size_bytes - 1)
+        is_movable = True
+
+        for i in range(0,(stop_block-start_block + 1)):
+            block = start_block + i
+            block_str = ("/sys/devices/system/memory/memory" + str(block) +
+                         "/valid_zones")
+            result = subprocess.run(["cat", block_str],
+                                    capture_output=True, text=True)
+            if result.returncode != 0:
+                print("Error: Block cat command failed. rc = " +
+                      str(result.returncode))
+                exit(1)
+
+            if "Movable" not in result.stdout:
+                is_movable = False
+                break;
+
+        return is_movable
+
+class cxl_unplug(cxl_json):
+
+    def __init__(self, memdev, config_file):
+        # Capture the current CXL (and DAX) configurations. Save
+        # configurations to file for using later with '--plugin'
+        # hot-plug adding the memory device.
+        self.cxl_memdev_json = self.cxl_list_memdev(memdev)
+        self.serialize_json(self.cxl_memdev_json, config_file)
+        self.decode_json()
+
+        if (self.regions_decoder_json.get('interleave_ways')>1):
+            print("Interleaved devices are not supported.")
+            exit(1)
+
+    def serialize_json(self, json_str, filename):
+        with open( filename , "w" ) as write:
+            json.dump(json_str, write)
+
+    def is_dax_memory_offline(self, dax_dev_json):
+        result = subprocess.run(["daxctl", "list"],
+                                capture_output=True, text=True)
+        if result.returncode != 0:
+            print("Error: daxctl offline command failed command. rc = " +
+                  str(result.returncode))
+            exit(1)
+
+        dax_dev_online_mb = json.loads(result.stdout)[0]["online_memblocks"]
+        logging.debug("online_memblocks = " +
+                      str(json.loads(result.stdout)[0]["online_memblocks"]))
+        return dax_dev_online_mb == 0
+
+    def offline_dax_memory(self):
+        # Note: self.daxregion_devices_json['movable'] JSON key is missing
+        # when True (ndctl v77). As a result, use the function region_movable()
+        if self.is_region_movable() == False:
+            print("Error: Entire region memory is not zone movable.")
+            exit(1)
+
+        dax_dev = self.daxregion_devices_json['chardev']
+        result=subprocess.run(["daxctl", "offline-memory", dax_dev],
+                              capture_output=True, text=True)
+        if result.returncode != 0:
+            if self.is_dax_memory_offline(dax_dev) == False:
+                print("Error: daxctl offline command failed. rc = " +
+                      str(result.returncode))
+                exit(1)
+
+    def offline_memory(self):
+        if 'ram' == self.regions_decoder_json.get('type'):
+            self.offline_dax_memory()
+
+    def cxl_destroy_region(self):
+        result = subprocess.run(["cxl", "destroy-region",
+                                 str(self.regions_decoder_json.get('region')),
+                                 "--force"],
+                                capture_output=True, text=True)
+        if result.returncode != 0:
+            print("Error: cxl destroy-region command failed. rc = " +
+                  str(result.returncode))
+            exit(1)
+
+    def unplug(self):
+        unplug_dev.offline_memory()
+        unplug_dev.cxl_destroy_region()
+        print("Device \'" + args.memdev + "\' can now be safely removed.")
+
+class cxl_plugin(cxl_json):
+
+    def __init__(self, config_file):
+        f = open(config_file)
+        self.cxl_memdev_json = json.load(f)
+        self.decode_json()
+
+        if (self.regions_decoder_json.get('interleave_ways')>1):
+            print("Interleaved devices are not supported.")
+            exit(1)
+
+    def cxl_create_region(self, cxl_memdev_json, memdev):
+        type = self.regions_decoder_json.get('type');
+        decoder = self.decoders_root_json.get('decoder')
+        interleave_ways = self.regions_decoder_json.get('interleave_ways')
+        interleave_granularity = self.regions_decoder_json.get('interleave_granularity')
+        size = self.regions_decoder_json.get('size')
+
+        result = subprocess.run(["cxl", "create-region",
+                                 "-m", memdev,
+                                 "-t", type,
+                                 "-d", decoder,
+                                 "-w", str(interleave_ways),
+                                 "-s", str(size),
+                                 "--debug"],
+                                capture_output=True, text=True)
+        if result.returncode!=0:
+            print("Error: cxl destroy-region command failed. rc = " +
+                  str(result.returncode))
+            exit(1)
+
+    def plugin(self, memdev):
+        self.cxl_create_region(self.cxl_memdev_json, memdev)
+        print("Region created for \'" + memdev + "\'.")
+
+class cxl_list(cxl_json):
+
+    cxl_memdevs_json = {}
+
+    def __init__(self):
+        self.cxl_memdevs_json = self.cxl_list_memdevs()
+
+    def display_memdevs(self):
+        if (self.cxl_memdevs_json == None):
+            print("Error: Failed to find memory devices")
+            return
+
+        if (len(self.cxl_memdevs_json) == 0):
+            print("Error: Failed to find memory devices")
+            return
+
+        print("Device        Region Name        Region Size        Movable")
+        print("======        ===========        ===========        =======")
+
+        for memdev in self.cxl_memdevs_json:
+            self.cxl_memdev_json = self.cxl_list_memdev(memdev['memdev'])
+            self.decode_json(fatal_error = False)
+            if len(self.regions_decoder_json) != 0:
+                region = self.regions_decoder_json.get('region');
+                size = self.regions_decoder_json.get('size')
+                is_movable_str = "True"
+                if self.is_region_movable() == 0:
+                        is_movable_str = "False"
+            else:
+                region = 'NA'
+                size = 'NA'
+                is_movable_str = 'NA'
+
+            print("%6s %18s %18s %14s" %
+                  (memdev['memdev'], region, size, is_movable_str))
+
+    def cxl_list_memdevs(self):
+        result = subprocess.run(["cxl", "list", "-M"],
+                                capture_output=True, text=True)
+        if result.returncode != 0:
+            print("Error: cxl list command failed.")
+            exit(1)
+
+        logging.debug("cxl_memdevs_json = " + result.stdout)
+        self.cxl_memdevs_json = json.loads(result.stdout);
+
+        return(self.cxl_memdevs_json)
+
+def init_args():
+    parser = argparse.ArgumentParser()
+    subparsers = parser.add_subparsers(dest='subparser_name', required=True)
+
+    parser_plugin = subparsers.add_parser('plugin')
+    parser_plugin.add_argument('-m', dest='memdev',
+                               help='CXL memory device to prepare for unplug',
+                               required=True)
+    parser_plugin.add_argument('-c', dest='config_file',
+                               help='CXL JSON configuration file to save/use',
+                               required=False, default="cxl.json")
+    parser_plugin.add_argument('-d', '--debug', help='Enable debug logging',
+                               required=False, action='store_true')
+
+    parser_unplug = subparsers.add_parser('unplug')
+    parser_unplug.add_argument('-m', dest='memdev',
+                               help='CXL memory device to prepare for unplug',
+                               required=True)
+    parser_unplug.add_argument('-c', dest='config_file',
+                               help='CXL JSON configuration file to save/use',
+                               required=False, default="cxl.json")
+    parser_unplug.add_argument('-d', '--debug', help='Enable debugging',
+                               required=False, action='store_true')
+
+    parser_list = subparsers.add_parser('list')
+    parser_list.add_argument('-d', '--debug', help='Enable debugging',
+                             required=False, action='store_true')
+
+    parser_swap = subparsers.add_parser('swap')
+    parser_swap.add_argument('-m', dest='memdev',
+                               help='CXL memory device to swap',
+                               required=True)
+    parser_swap.add_argument('-d', '--debug', help='Enable debugging',
+                             required=False, action='store_true')
+
+    return parser.parse_args()
+
+args = init_args()
+if args.debug:
+    logging.basicConfig(level=logging.DEBUG)
+
+logging.debug("args = " + str(args))
+
+if args.subparser_name == 'list':
+    list_dev = cxl_list();
+    list_dev.display_memdevs()
+
+if args.subparser_name == 'unplug':
+    unplug_dev = cxl_unplug(args.memdev, args.config_file);
+    unplug_dev.unplug()
+
+if args.subparser_name == 'plugin':
+    plugin_dev = cxl_plugin(args.config_file);
+    plugin_dev.plugin(args.memdev)
+
+if args.subparser_name == 'swap':
+    f, filename = tempfile.mkstemp()
+    unplug_dev = cxl_unplug(args.memdev, filename);
+    unplug_dev.unplug()
+
+    print("Card is ready for removal.")
+    input("Press any key to continue after card reinsertion.")
+
+    plugin_dev = cxl_plugin(filename);
+    plugin_dev.plugin(args.memdev)
+    os.close(f)
-- 
2.34.1

