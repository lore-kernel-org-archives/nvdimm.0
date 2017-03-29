Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DAC792041FBD0
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 22:06:56 -0700 (PDT)
Subject: [ndctl PATCH] Documentation, write-labels: add man page
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 22:01:46 -0700
Message-ID: <149076370694.25786.17308120640237891256.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Unlike read-labels, the write-labels command is meant to be run against
one dimm at a time. This hopefully avoids confusion trying to match
input files to output devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am            |    1 +
 Documentation/ndctl-write-labels.txt |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 Documentation/ndctl-write-labels.txt

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index eea11e087012..d72085df4845 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -2,6 +2,7 @@ man1_MANS = \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
 	ndctl-read-labels.1 \
+	ndctl-write-labels.1 \
 	ndctl-init-labels.1 \
 	ndctl-check-labels.1 \
 	ndctl-enable-region.1 \
diff --git a/Documentation/ndctl-write-labels.txt b/Documentation/ndctl-write-labels.txt
new file mode 100644
index 000000000000..bace46fba160
--- /dev/null
+++ b/Documentation/ndctl-write-labels.txt
@@ -0,0 +1,29 @@
+ndctl-write-labels(1)
+=====================
+
+NAME
+----
+ndctl-write-labels - write data to the label area on a dimm
+
+SYNOPSIS
+--------
+[verse]
+'ndctl write-labels <nmem> [-i <filename>]'
+
+include::labels-description.txt[]
+Read data from the input filename, or stdin, and write it to the given
+<nmem> device. Note that the device must not be active in any region,
+otherwise the kernel will not allow write access to the device's label
+data area.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+-i::
+--input::
+	input file
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
