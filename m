Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AF592098C8D5
 for <linux-nvdimm@lists.01.org>; Sun, 24 Jun 2018 14:41:29 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 Documentation: Add namespace 'theory of operation'
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 24 Jun 2018 14:31:31 -0700
Message-ID: <152987589167.5032.13806344242673075164.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Provide more background information on namespace mechanics, the mode
types, and expected usage models.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/namespace-description.txt  |   56 +++++++++++++++++++++---
 Documentation/ndctl/ndctl-create-namespace.txt |    1 
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/Documentation/ndctl/namespace-description.txt b/Documentation/ndctl/namespace-description.txt
index 32ab5cd83983..33d32277b885 100644
--- a/Documentation/ndctl/namespace-description.txt
+++ b/Documentation/ndctl/namespace-description.txt
@@ -1,8 +1,52 @@
 // SPDX-License-Identifier: GPL-2.0
 
-DESCRIPTION
------------
-A REGION, after resolving DPA aliasing and LABEL specified boundaries,
-surfaces one or more "namespace" devices.  The arrival of a "namespace"
-device currently triggers either the nd_blk or nd_pmem driver to load
-and register a disk/block device.
+THEORY OF OPERATION
+-------------------
+The capacity of an NVDIMM REGION (contiguous span of persistent memory)
+is accessed via one or more NAMESPACE devices. REGION is the Linux term
+for what ACPI and UEFI call a DIMM-interleave-set, or a
+system-physical-address-range that is striped (by the memory controller)
+across one or more memory modules.
+
+The UEFI specification defines the 'NVDIMM Label Protocol' as the
+combination of label area access methods and a data format for
+provisioning one or more NAMESPACE objects from a REGION. Note that
+label support is optional and if Linux does not detect the label
+capability it will automatically instantiate a "label-less" namespace
+per region. Examples of label-less namespaces are the ones created by
+the kernel's 'memmap=ss!nn' command line option (see the nvdimm wiki on
+kernel.org), or NVDIMMs without a valid 'namespace index' in their label
+area.
+
+A namespace can be provisioned to operate in one of 4 modes, 'fsdax',
+'devdax', 'sector', and 'raw'. Here are the expected usage models for
+these modes:
+	- fsdax: Filesystem-DAX mode is the default mode of a namespace
+	  when specifying 'ndctl create-namespace' with no options. It creates
+	  a block device (/dev/pmemX[.Y]) that supports the DAX capabilities
+	  of Linux filesystems (xfs and ext4 to date). DAX removes the page
+	  cache from the I/O path and allows mmap(2) to establish direct
+	  mappings to persistent memory media. The DAX capability enables
+	  workloads / working-sets that would exceed the capacity of the page
+	  cache to scale up to the capacity of persistent memory. Workloads
+	  that fit in page cache or perform bulk data transfers may not see
+	  benefit from DAX. When in doubt, pick this mode.
+
+	- devdax: Device-DAX mode enables similar mmap(2) DAX mapping
+	  capabilities as Filesystem-DAX. However, instead of a block-device
+	  that can support a DAX-enabled filesystem, this mode emits a single
+	  character device file (/dev/daxX.Y). Use this mode to assign
+	  persistent memory to a virtual-machine, register persistent memory
+	  for RDMA, or when gigantic mappings are needed.
+
+	- sector: Use this mode to host legacy filesystems that do
+	  not checksum metadata or applications that are not prepared for torn
+	  sectors after a crash. Expected usage for this mode is for small
+	  boot volumes. This mode is compatible with other operating systems.
+
+	- raw: Raw mode is effectively just a memory disk that does
+	  not support DAX. Typically this indicates an namespace that was
+	  created by tooling or another operating system that did not know how
+	  to create a Linux 'fsdax' or 'devdax' mode namespace. This mode is
+	  compatible with other operating systems, but again, does not support
+	  DAX operation.
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 14c5409f059b..4b8b0d1c3eac 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -219,3 +219,4 @@ linkndctl:ndctl-init-labels[1],
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-enable-namespace[1],
 http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
+https://nvdimm.wiki.kernel.org[Linux Persistent Memory Wiki]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
