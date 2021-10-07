Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34A62C83
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 21:59:53 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226274521"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226274521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 14:59:53 -0700
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="489190411"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 14:59:53 -0700
Subject: [PATCH] daxctl: Add "Soft Reservation" theory of operation
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: John Groves <john@jagalactic.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 07 Oct 2021 14:59:53 -0700
Message-ID: <163364399303.201290.6835215953983673447.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

As systems are starting to ship memory with the EFI "Special Purpose"
attribute that Linux optionally turns into "Soft Reserved" ranges one of
the immediate first questions is "where is my special memory, and how do
access it". Add some documentation to explain the default behaviour of
"Soft Reserved".

Reported-by: John Groves <john@jagalactic.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/daxctl/daxctl-reconfigure-device.txt |  127 ++++++++++++++------
 1 file changed, 88 insertions(+), 39 deletions(-)

diff --git a/Documentation/daxctl/daxctl-reconfigure-device.txt b/Documentation/daxctl/daxctl-reconfigure-device.txt
index f112b3c6120f..132684c193f0 100644
--- a/Documentation/daxctl/daxctl-reconfigure-device.txt
+++ b/Documentation/daxctl/daxctl-reconfigure-device.txt
@@ -12,6 +12,94 @@ SYNOPSIS
 [verse]
 'daxctl reconfigure-device' <dax0.0> [<dax1.0>...<daxY.Z>] [<options>]
 
+DESCRIPTION
+-----------
+
+Reconfigure the operational mode of a dax device. This can be used to convert
+a regular 'devdax' mode device to the 'system-ram' mode which arranges for the
+dax range to be hot-plugged into the system as regular memory.
+
+NOTE: This is a destructive operation. Any data on the dax device *will* be
+lost.
+
+NOTE: Device reconfiguration depends on the dax-bus device model. See
+linkdaxctl:daxctl-migrate-device-model[1] for more information. If dax-class is
+in use (via the dax_pmem_compat driver), the reconfiguration will fail with an
+error such as the following:
+----
+# daxctl reconfigure-device --mode=system-ram --region=0 all
+libdaxctl: daxctl_dev_disable: dax3.0: error: device model is dax-class
+dax3.0: disable failed: Operation not supported
+error reconfiguring devices: Operation not supported
+reconfigured 0 devices
+----
+
+'daxctl-reconfigure-device' nominally expects that it will online new memory
+blocks as 'movable', so that kernel data doesn't make it into this memory.
+However, there are other potential agents that may be configured to
+automatically online new hot-plugged memory as it appears. Most notably,
+these are the '/sys/devices/system/memory/auto_online_blocks' configuration,
+or system udev rules. If such an agent races to online memory sections, daxctl
+checks if the blocks were onlined as 'movable' memory. If this was not the
+case, and the memory blocks are found to be in a different zone, then a
+warning is displayed. If it is desired that a different agent control the
+onlining of memory blocks, and the associated memory zone, then it is
+recommended to use the --no-online option described below. This will abridge
+the device reconfiguration operation to just hotplugging the memory, and
+refrain from then onlining it.
+
+In case daxctl detects that there is a kernel policy to auto-online blocks
+(via /sys/devices/system/memory/auto_online_blocks), then reconfiguring to
+system-ram will result in a failure. This can be overridden with '--force'.
+
+
+THEORY OF OPERATION
+-------------------
+The kernel device-dax subsystem surfaces character devices
+that provide DAX-access (direct mappings sans page-cache buffering) to a
+given memory region. The devices are named /dev/daxX.Y where X is a
+region-id and Y is an instance-id within that region. There are 2
+mechanisms that trigger device-dax instances to appear:
+
+1. Persistent Memory (PMEM) namespace configured in "devdax" mode. See
+"ndctl create-namspace --help" and
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/dax/Kconfig[CONFIG_DEV_DAX_PMEM].
+In this case the device-dax instance is statically sized to its host
+memory region which is bounded to the physical address range of the host
+namespace.
+
+2. Soft Reserved memory enumerated by platform firmware. On EFI systems
+this is communicated via the so called EFI_MEMORY_SP "Special Purpose"
+attribute. See
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/dax/Kconfig[CONFIG_DEV_DAX_HMEM].
+In this case the device-dax instance(s) associated with the given memory
+region can be resized and divided into multiple devices.
+
+In the Soft Reservation case the expectation for EFI + ACPI based
+platforms is that in addition to the EFI_MEMORY_SP attribute the
+firmware also creates distinct ACPI proximity domains for any address
+range that has different performance characteristics than default
+"System RAM". So, the SRAT will define the proximity domain, the SLIT
+communicates relative distance to other proximity domains, and the HMAT
+is populated with nominal read/write latency and read/write bandwidth
+data. That HMAT data is emitted to the kernel log on bootup, and also
+exported to sysfs. See
+https://www.kernel.org/doc/html/latest/admin-guide/mm/numaperf.html[NUMAPERF],
+for the runtime representation of CPU to Memory node performance
+details.
+
+Outside of the NUMA performance details linked above the other method to
+detect the presence of "Soft Reserved" memory is to dump /proc/iomem and
+look for "Soft Reserved" ranges. If the kernel was not built with
+CONFIG_EFI_SOFTRESERVE, predates the introduction of
+CONFIG_EFI_SOFTRESERVE (v5.5), or was booted with the efi=nosoftreserve
+command line then device-dax will not attach and the expectation is that
+the memory shows up as a memory-only NUMA node. Otherwise the memory
+shows up as a device-dax instance and DAXCTL(1) can be used to
+optionally partition it and assign the memory back to the kernel as
+"System RAM", or the device can be mapped directly as the back end of a
+userspace memory allocator like https://pmem.io/vmem/libvmem/[LIBVMEM].
+
 EXAMPLES
 --------
 
@@ -83,45 +171,6 @@ reconfigured 1 device
 reconfigured 1 device
 ----
 
-DESCRIPTION
------------
-
-Reconfigure the operational mode of a dax device. This can be used to convert
-a regular 'devdax' mode device to the 'system-ram' mode which arranges for the
-dax range to be hot-plugged into the system as regular memory.
-
-NOTE: This is a destructive operation. Any data on the dax device *will* be
-lost.
-
-NOTE: Device reconfiguration depends on the dax-bus device model. See
-linkdaxctl:daxctl-migrate-device-model[1] for more information. If dax-class is
-in use (via the dax_pmem_compat driver), the reconfiguration will fail with an
-error such as the following:
-----
-# daxctl reconfigure-device --mode=system-ram --region=0 all
-libdaxctl: daxctl_dev_disable: dax3.0: error: device model is dax-class
-dax3.0: disable failed: Operation not supported
-error reconfiguring devices: Operation not supported
-reconfigured 0 devices
-----
-
-'daxctl-reconfigure-device' nominally expects that it will online new memory
-blocks as 'movable', so that kernel data doesn't make it into this memory.
-However, there are other potential agents that may be configured to
-automatically online new hot-plugged memory as it appears. Most notably,
-these are the '/sys/devices/system/memory/auto_online_blocks' configuration,
-or system udev rules. If such an agent races to online memory sections, daxctl
-checks if the blocks were onlined as 'movable' memory. If this was not the
-case, and the memory blocks are found to be in a different zone, then a
-warning is displayed. If it is desired that a different agent control the
-onlining of memory blocks, and the associated memory zone, then it is
-recommended to use the --no-online option described below. This will abridge
-the device reconfiguration operation to just hotplugging the memory, and
-refrain from then onlining it.
-
-In case daxctl detects that there is a kernel policy to auto-online blocks
-(via /sys/devices/system/memory/auto_online_blocks), then reconfiguring to
-system-ram will result in a failure. This can be overridden with '--force'.
 
 OPTIONS
 -------

