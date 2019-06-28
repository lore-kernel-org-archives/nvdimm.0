Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAFA62129EBB7
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 12:11:20 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 08/13] Documentation/daxctl: add a man page for
 daxctl-reconfigure-device
Date: Fri, 28 Jun 2019 13:11:05 -0600
Message-Id: <20190628191110.21428-9-vishal.l.verma@intel.com>
In-Reply-To: <20190628191110.21428-1-vishal.l.verma@intel.com>
References: <20190628191110.21428-1-vishal.l.verma@intel.com>
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
 Documentation/daxctl/Makefile.am              |   3 +-
 .../daxctl/daxctl-reconfigure-device.txt      | 139 ++++++++++++++++++
 2 files changed, 141 insertions(+), 1 deletion(-)
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
index 0000000..fb2b36b
--- /dev/null
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -0,0 +1,139 @@
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
+EXAMPLES
+--------
+
+* Reconfigure dax0.0 to system-ram mode, don't online the memory
+----
+# daxctl reconfigure-device --mode=system-ram --no-online dax0.0
+[
+  {
+    "chardev":"dax0.0",
+    "size":16777216000,
+    "target_node":2,
+    "mode":"system-ram"
+  }
+]
+----
+
+* Reconfigure dax0.0 to devdax mode, attempt to offline the memory
+----
+# daxctl reconfigure-device --human --mode=devdax --attempt-offline dax0.0
+{
+  "chardev":"dax0.0",
+  "size":"15.63 GiB (16.78 GB)",
+  "target_node":2,
+  "mode":"devdax"
+}
+----
+
+* Reconfigure all dax devices on region0 to system-ram mode
+----
+# daxctl reconfigure-device --mode=system-ram --region=0 all
+[
+  {
+    "chardev":"dax0.0",
+    "size":16777216000,
+    "target_node":2,
+    "mode":"system-ram"
+  },
+  {
+    "chardev":"dax0.1",
+    "size":16777216000,
+    "target_node":3,
+    "mode":"system-ram"
+  }
+]
+----
+
+* Run a process called 'some-service' using numactl to restrict its cpu
+nodes to '0' and '1', and  memory allocations to node 2 (determined using
+daxctl_dev_get_target_node() or 'daxctl list')
+----
+# daxctl reconfigure-device --mode=system-ram --no-online dax0.0
+[
+  {
+    "chardev":"dax0.0",
+    "size":16777216000,
+    "target_node":2,
+    "mode":"system-ram"
+  }
+]
+
+# numactl --cpunodebind=0-1 --membind=2 -- some-service --opt1 --opt2
+----
+
+DESCRIPTION
+-----------
+
+Reconfigure the operational mode of a dax device. This can be used to convert
+a regular 'devdax' mode device to the 'system-ram' mode which allows for the dax
+range to be hot-plugged into the system as regular memory.
+
+NOTE: This is a destructive operation. Any data on the dax device *will* be
+lost.
+
+NOTE: Device reconfiguration depends on the dax-bus device model. If dax-class is
+in use (via the dax_pmem_compat driver), the reconfiguration will fail. See
+linkdaxctl:daxctl-migrate-device-model[1] for more information.
+
+OPTIONS
+-------
+-r::
+--region=::
+	Restrict the operation to devices belonging to the specified region(s).
+	A device-dax region is a contiguous range of memory that hosts one or
+	more /dev/daxX.Y devices, where X is the region id and Y is the device
+	instance id.
+
+-m::
+--mode=::
+	Specify the mode to which the dax device(s) should be reconfigured.
+	- "system-ram": hotplug the device into system memory.
+
+	- "devdax": switch to the normal "device dax" mode. This requires the
+	  kernel to support hot-unplugging 'kmem' based memory. If this is not
+	  available, a reboot is the only way to switch back to 'devdax' mode.
+
+-N::
+--no-online::
+	By default, memory sections provided by system-ram devices will be
+	brought online automatically and immediately with the 'online_movable'
+	policy. Use this option to disable the automatic onlining behavior.
+
+-O::
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
+	Emit more debug messages
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkdaxctl:daxctl-list[1],daxctl-migrate-device-model[1]
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
