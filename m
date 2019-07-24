Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B063C2194D387
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jul 2019 15:00:16 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v7 10/13] Documentation: Add man pages for daxctl-{on,
 off}line-memory
Date: Wed, 24 Jul 2019 15:57:38 -0600
Message-Id: <20190724215741.18556-11-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-1-vishal.l.verma@intel.com>
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
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

Add man pages for the two new commands: daxctl-online-memory, and
daxctl-offline-memory.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/daxctl/Makefile.am              |  4 +-
 .../daxctl/daxctl-offline-memory.txt          | 72 +++++++++++++++++
 Documentation/daxctl/daxctl-online-memory.txt | 80 +++++++++++++++++++
 3 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/daxctl/daxctl-offline-memory.txt
 create mode 100644 Documentation/daxctl/daxctl-online-memory.txt

diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 715fbad..37c3bde 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -29,7 +29,9 @@ man1_MANS = \
 	daxctl.1 \
 	daxctl-list.1 \
 	daxctl-migrate-device-model.1 \
-	daxctl-reconfigure-device.1
+	daxctl-reconfigure-device.1 \
+	daxctl-online-memory.1 \
+	daxctl-offline-memory.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/daxctl/daxctl-offline-memory.txt b/Documentation/daxctl/daxctl-offline-memory.txt
new file mode 100644
index 0000000..ba06287
--- /dev/null
+++ b/Documentation/daxctl/daxctl-offline-memory.txt
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+
+daxctl-offline-memory(1)
+========================
+
+NAME
+----
+daxctl-offline-memory - Offline the memory for a device that is in system-ram mode
+
+SYNOPSIS
+--------
+[verse]
+'daxctl offline-memory' <dax0.0> [<dax1.0>...<daxY.Z>] [<options>]
+
+EXAMPLES
+--------
+
+* Reconfigure dax0.0 to system-ram mode
+----
+# daxctl reconfigure-device --mode=system-ram --human dax0.0
+{
+  "chardev":"dax0.0",
+  "size":"7.87 GiB (8.45 GB)",
+  "target_node":2,
+  "mode":"system-ram"
+}
+----
+
+* Offline the memory
+----
+# daxctl offline-memory dax0.0
+dax0.0: 62 sections offlined
+offlined memory for 1 device
+----
+
+DESCRIPTION
+-----------
+
+Offline the memory sections associated with a device that has been converted
+to the system-ram mode. If one or more blocks are already offline, attempt to
+offline the remaining blocks. If all blocks were already offline, print a
+message and return success without actually doing anything.
+
+This is complementary to the 'daxctl-online-memory' command, and may be used
+when it is wished to offline the memory sections, but not convert the device
+back to 'devdax' mode.
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
+linkdaxctl:daxctl-reconfigure-device[1],daxctl-online-memory[1]
diff --git a/Documentation/daxctl/daxctl-online-memory.txt b/Documentation/daxctl/daxctl-online-memory.txt
new file mode 100644
index 0000000..5ac1cbf
--- /dev/null
+++ b/Documentation/daxctl/daxctl-online-memory.txt
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+
+daxctl-online-memory(1)
+=======================
+
+NAME
+----
+daxctl-online-memory - Online the memory for a device that is in system-ram mode
+
+SYNOPSIS
+--------
+[verse]
+'daxctl online-memory' <dax0.0> [<dax1.0>...<daxY.Z>] [<options>]
+
+EXAMPLES
+--------
+
+* Reconfigure dax0.0 to system-ram mode, don't online the memory
+----
+# daxctl reconfigure-device --mode=system-ram --no-online --human dax0.0
+{
+  "chardev":"dax0.0",
+  "size":"7.87 GiB (8.45 GB)",
+  "target_node":2,
+  "mode":"system-ram"
+}
+----
+
+* Online the memory separately
+----
+# daxctl online-memory dax0.0
+dax0.0: 62 new sections onlined
+onlined memory for 1 device
+----
+
+* Onlining memory when some sections were already online
+----
+# daxctl online-memory dax0.0
+dax0.0: 1 section already online
+dax0.0: 61 new sections onlined
+onlined memory for 1 device
+----
+
+DESCRIPTION
+-----------
+
+Online the memory sections associated with a device that has been converted
+to the system-ram mode. If one or more blocks are already online, print a
+message about them, and attempt to online the remaining blocks.
+
+This is complementary to the 'daxctl-reconfigure-device' command, when used with
+the '--no-online' option to skip onlining memory sections immediately after the
+reconfigure. In these scenarios, the memory can be onlined at a later time using
+'daxctl-online-memory'.
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
+linkdaxctl:daxctl-reconfigure-device[1],daxctl-offline-memory[1]
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
