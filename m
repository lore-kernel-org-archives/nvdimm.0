Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6749B2124B938
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 14:32:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 6/8] Documentation/daxctl: add a man page for
 daxctl-reconfigure-device
Date: Fri,  3 May 2019 15:32:29 -0600
Message-Id: <20190503213231.12280-7-vishal.l.verma@intel.com>
In-Reply-To: <20190503213231.12280-1-vishal.l.verma@intel.com>
References: <20190503213231.12280-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a man page describing the new daxctl-reconfigure-device command.

Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/daxctl/Makefile.am              |  3 +-
 .../daxctl/daxctl-reconfigure-device.txt      | 74 +++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/daxctl/daxctl-reconfigure-device.txt

diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 6aba035..715fbad 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -28,7 +28,8 @@ endif
 man1_MANS = \
 	daxctl.1 \
 	daxctl-list.1 \
-	daxctl-migrate-device-model.1
+	daxctl-migrate-device-model.1 \
+	daxctl-reconfigure-device.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
new file mode 100644
index 0000000..d79547c
--- /dev/null
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+
+daxctl-reconfigure-device(1)
+============================
+
+NAME
+----
+daxctl-reconfigure-device - Reconfigure a dax device into a different mode
+
+SYNOPSIS
+--------
+[verse]
+'daxctl reconfigure-device' <dax0.0> [<dax1.0>...<daxY.Z>] [<options>]
+
+DESCRIPTION
+-----------
+
+Reconfigure the operational mode of a dax device. This can be used to convert
+a regular 'devdax' mode device to the 'system-ram' mode which allows for the dax
+range to be hot-plugged into the system as regular memory.
+
+NOTE: This is a destructive, one-way operation. Any data on the dax device
+*will* be lost, and once reconfigured, there is no equivalent operation to
+go back to the normal 'devdax' mode until a reboot.
+
+OPTIONS
+-------
+-r::
+--region=::
+	Restrict the reconfigure operation to devices belonging to the
+	specified region(s). A device-dax region is a contiguous range of
+	memory that hosts one or more /dev/daxX.Y devices, where X is the
+	region id and Y is the device instance id.
+
+-m::
+--mode=::
+	Specify the mode to which the dax device(s) should be reconfigured.
+	- "system-ram": hotplug the device into system memory. This is a
+	  one-way operation. Once a device is configured this way, the
+	  setting persists across reboots, until the command is called again
+	  to explicitly switch to the 'devdax' mode.
+
+	- "devdax": switch to the normal "device dax" mode. This only takes
+	  effect following a system reboot.
+
+-N::
+--no-online::
+	By default, memory sections provided by system-ram devices will be
+	brought online automatically and immediately. Use this option to
+	disable the automatic onlining behavior.
+
+--attempt-offline::
+	When converting from "system-ram" mode to "devdax", it is expected
+	that all the memory sections are first made offline. By default,
+	daxctl won't touch online memory. However with this option, attempt
+	to offline the memory on the NUMA node associated with the dax device
+	before converting it back to "devdax" mode.
+
+-u::
+--human::
+	By default the command will output machine-friendly raw-integer
+	data. Instead, with this flag, numbers representing storage size
+	will be formatted as human readable strings with units, other
+	fields are converted to hexadecimal strings.
+
+-v::
+--verbose::
+	Emit more debug messages for the reconfiguration process
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkdaxctl:daxctl-list[1]
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
