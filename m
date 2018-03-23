Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1900722146724
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 09:47:29 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, documentation: update copyright
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2018 09:44:57 -0700
Message-ID: <152182349753.29410.6891491989222586676.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Use SPDX identifiers in the documentation source, and move the
"Copyright" boilerplate that is emitted into the man page into a common
header file.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/copyright.txt                     |    8 ++++++++
 Documentation/daxctl/Makefile.am                |    3 ++-
 Documentation/daxctl/daxctl-list.txt            |    9 +++------
 Documentation/daxctl/daxctl.txt                 |    4 ++++
 Documentation/ndctl/Makefile.am                 |    3 ++-
 Documentation/ndctl/dimm-description.txt        |    2 ++
 Documentation/ndctl/human-option.txt            |    2 ++
 Documentation/ndctl/labels-description.txt      |    2 ++
 Documentation/ndctl/labels-options.txt          |    2 ++
 Documentation/ndctl/namespace-description.txt   |    2 ++
 Documentation/ndctl/ndctl-check-labels.txt      |    9 +++------
 Documentation/ndctl/ndctl-check-namespace.txt   |    9 +++------
 Documentation/ndctl/ndctl-create-namespace.txt  |    9 +++------
 Documentation/ndctl/ndctl-destroy-namespace.txt |    9 +++------
 Documentation/ndctl/ndctl-disable-dimm.txt      |    9 +++------
 Documentation/ndctl/ndctl-disable-namespace.txt |    9 +++------
 Documentation/ndctl/ndctl-disable-region.txt    |    9 +++------
 Documentation/ndctl/ndctl-enable-dimm.txt       |    9 +++------
 Documentation/ndctl/ndctl-enable-namespace.txt  |    9 +++------
 Documentation/ndctl/ndctl-enable-region.txt     |    9 +++------
 Documentation/ndctl/ndctl-init-labels.txt       |    9 +++------
 Documentation/ndctl/ndctl-inject-error.txt      |    9 +++------
 Documentation/ndctl/ndctl-inject-smart.txt      |    9 +++------
 Documentation/ndctl/ndctl-list.txt              |    9 +++------
 Documentation/ndctl/ndctl-read-labels.txt       |    9 +++------
 Documentation/ndctl/ndctl-update-firmware.txt   |    9 +++------
 Documentation/ndctl/ndctl-write-labels.txt      |    2 ++
 Documentation/ndctl/ndctl-zero-labels.txt       |    9 +++------
 Documentation/ndctl/ndctl.txt                   |    9 +++------
 Documentation/ndctl/region-description.txt      |    2 ++
 Documentation/ndctl/xable-dimm-options.txt      |    2 ++
 Documentation/ndctl/xable-namespace-options.txt |    2 ++
 Documentation/ndctl/xable-region-options.txt    |    2 ++
 33 files changed, 93 insertions(+), 116 deletions(-)
 create mode 100644 Documentation/copyright.txt

diff --git a/Documentation/copyright.txt b/Documentation/copyright.txt
new file mode 100644
index 000000000000..1d603645211c
--- /dev/null
+++ b/Documentation/copyright.txt
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+
+COPYRIGHT
+---------
+Copyright (c) 2016 - 2018, Intel Corporation. License GPLv2: GNU GPL
+version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
+you are free to change and redistribute it.  There is NO WARRANTY, to
+the extent permitted by law.
diff --git a/Documentation/daxctl/Makefile.am b/Documentation/daxctl/Makefile.am
index 5913c94ca3be..259dafd18e5e 100644
--- a/Documentation/daxctl/Makefile.am
+++ b/Documentation/daxctl/Makefile.am
@@ -22,6 +22,7 @@ CLEANFILES = $(man1_MANS)
 
 XML_DEPS = \
 	../../version.m4 \
+	../copyright.txt \
 	Makefile \
 	asciidoc.conf
 
@@ -33,6 +34,6 @@ RM ?= rm -f
 		--unsafe -adaxctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
-%.1: %.xml
+%.1: %.xml $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@ && \
 		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
diff --git a/Documentation/daxctl/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
index 6249645f4bbd..99ca4a1b4f28 100644
--- a/Documentation/daxctl/daxctl-list.txt
+++ b/Documentation/daxctl/daxctl-list.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 daxctl-list(1)
 =============
 
@@ -93,9 +95,4 @@ OPTIONS
   "size":"30.57 GiB (32.83 GB)"
 }
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
diff --git a/Documentation/daxctl/daxctl.txt b/Documentation/daxctl/daxctl.txt
index 5da9746ea62a..f81b161c9771 100644
--- a/Documentation/daxctl/daxctl.txt
+++ b/Documentation/daxctl/daxctl.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 daxctl(1)
 =========
 
@@ -27,6 +29,8 @@ the Linux kernel Device-DAX facility. This facility enables DAX mappings
 of performance / feature differentiated memory without need of a
 filesystem.
 
+include::../copyright.txt[]
+
 SEE ALSO
 --------
 linkdaxctl:ndctl-create-namespace[1],
diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 27b207698d5a..9acb4acd966a 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -40,6 +40,7 @@ XML_DEPS = \
 	../../version.m4 \
 	Makefile \
 	asciidoc.conf \
+	../copyright.txt \
 	region-description.txt \
 	xable-region-options.txt \
 	dimm-description.txt \
@@ -56,6 +57,6 @@ RM ?= rm -f
 		--unsafe -andctl_version=$(VERSION) -o $@+ $< && \
 		mv $@+ $@
 
-%.1: %.xml
+%.1: %.xml $(XML_DEPS)
 	$(AM_V_GEN)$(RM) $@ && \
 		$(XMLTO) -o . -m ../manpage-normal.xsl man $<
diff --git a/Documentation/ndctl/dimm-description.txt b/Documentation/ndctl/dimm-description.txt
index 95d0891c0b13..96666a0a51b4 100644
--- a/Documentation/ndctl/dimm-description.txt
+++ b/Documentation/ndctl/dimm-description.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 DESCRIPTION
 -----------
 A generic DIMM device object, named /dev/nmemX, is registered for each
diff --git a/Documentation/ndctl/human-option.txt b/Documentation/ndctl/human-option.txt
index ce2fefad174e..af1215c22dae 100644
--- a/Documentation/ndctl/human-option.txt
+++ b/Documentation/ndctl/human-option.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 -u::
 --human::
 	Format numbers representing storage sizes, or offsets as human
diff --git a/Documentation/ndctl/labels-description.txt b/Documentation/ndctl/labels-description.txt
index 8e89ae1c52e7..6244a49a9d3f 100644
--- a/Documentation/ndctl/labels-description.txt
+++ b/Documentation/ndctl/labels-description.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 DESCRIPTION
 -----------
 The namespace label area is a small persistent partition of capacity
diff --git a/Documentation/ndctl/labels-options.txt b/Documentation/ndctl/labels-options.txt
index e13cdc5f24b1..539ace079557 100644
--- a/Documentation/ndctl/labels-options.txt
+++ b/Documentation/ndctl/labels-options.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 <memory device(s)>::
 	One or more 'nmemX' device names. The keyword 'all' can be specified to
 	operate on every dimm in the system, optionally filtered by bus id (see
diff --git a/Documentation/ndctl/namespace-description.txt b/Documentation/ndctl/namespace-description.txt
index 0446642bf308..32ab5cd83983 100644
--- a/Documentation/ndctl/namespace-description.txt
+++ b/Documentation/ndctl/namespace-description.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 DESCRIPTION
 -----------
 A REGION, after resolving DPA aliasing and LABEL specified boundaries,
diff --git a/Documentation/ndctl/ndctl-check-labels.txt b/Documentation/ndctl/ndctl-check-labels.txt
index a7c8a5f2dcbd..3cfb1e1c9181 100644
--- a/Documentation/ndctl/ndctl-check-labels.txt
+++ b/Documentation/ndctl/ndctl-check-labels.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-check-labels(1)
 ====================
 
@@ -19,12 +21,7 @@ OPTIONS
 -------
 include::labels-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-check-namespace.txt b/Documentation/ndctl/ndctl-check-namespace.txt
index ea4183af9444..2ece4e770305 100644
--- a/Documentation/ndctl/ndctl-check-namespace.txt
+++ b/Documentation/ndctl/ndctl-check-namespace.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-check-namespace(1)
 =========================
 
@@ -67,12 +69,7 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 8de6689f857f..14c5409f059b 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-create-namespace(1)
 =========================
 
@@ -208,12 +210,7 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-destroy-namespace.txt b/Documentation/ndctl/ndctl-destroy-namespace.txt
index 7078c0b21929..f1a6e30de5ea 100644
--- a/Documentation/ndctl/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl/ndctl-destroy-namespace.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-destroy-namespace(1)
 =========================
 
@@ -25,12 +27,7 @@ include::xable-namespace-options.txt[]
 	namespace' operations will be aborted.  The namespace must be
 	unmounted before being destroyed.
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-disable-dimm.txt b/Documentation/ndctl/ndctl-disable-dimm.txt
index b767402e93b8..d5a8d19966cf 100644
--- a/Documentation/ndctl/ndctl-disable-dimm.txt
+++ b/Documentation/ndctl/ndctl-disable-dimm.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-disable-dimm(1)
 =======================
 
@@ -17,12 +19,7 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-disable-namespace.txt b/Documentation/ndctl/ndctl-disable-namespace.txt
index 5304ff97b900..5d3a8be1f503 100644
--- a/Documentation/ndctl/ndctl-disable-namespace.txt
+++ b/Documentation/ndctl/ndctl-disable-namespace.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-disable-namespace(1)
 =========================
 
@@ -16,12 +18,7 @@ OPTIONS
 -------
 include::xable-namespace-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-disable-region.txt b/Documentation/ndctl/ndctl-disable-region.txt
index 5871ebe09650..ea1fd3ac0008 100644
--- a/Documentation/ndctl/ndctl-disable-region.txt
+++ b/Documentation/ndctl/ndctl-disable-region.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-disable-region(1)
 =======================
 
@@ -17,12 +19,7 @@ OPTIONS
 <region>::
 include::xable-region-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-enable-dimm.txt b/Documentation/ndctl/ndctl-enable-dimm.txt
index 5b399c20bd15..cd9908d41696 100644
--- a/Documentation/ndctl/ndctl-enable-dimm.txt
+++ b/Documentation/ndctl/ndctl-enable-dimm.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-enable-dimm(1)
 ====================
 
@@ -17,12 +19,7 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-enable-namespace.txt b/Documentation/ndctl/ndctl-enable-namespace.txt
index 69971a0f68a1..9390a992177f 100644
--- a/Documentation/ndctl/ndctl-enable-namespace.txt
+++ b/Documentation/ndctl/ndctl-enable-namespace.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-enable-namespace(1)
 =========================
 
@@ -16,12 +18,7 @@ OPTIONS
 -------
 include::xable-namespace-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-enable-region.txt b/Documentation/ndctl/ndctl-enable-region.txt
index c4939e0f7caa..6c4ad9fefb0a 100644
--- a/Documentation/ndctl/ndctl-enable-region.txt
+++ b/Documentation/ndctl/ndctl-enable-region.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-enable-region(1)
 ====================
 
@@ -17,12 +19,7 @@ OPTIONS
 <region>::
 include::xable-region-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
index d30ccc5fed0d..580d82aa99cf 100644
--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-init-labels(1)
 ====================
 
@@ -76,12 +78,7 @@ include::labels-options.txt[]
 	be an existing / valid namespace index.  Warning, this will
 	destroy all defined namespaces on the dimm.
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
index fbf38374be38..01f6c22f1561 100644
--- a/Documentation/ndctl/ndctl-inject-error.txt
+++ b/Documentation/ndctl/ndctl-inject-error.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-inject-error(1)
 =====================
 
@@ -96,12 +98,7 @@ include::human-option.txt[]
 --region=::
 include::xable-region-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
index 212bca0f6ae5..0dc6481cace3 100644
--- a/Documentation/ndctl/ndctl-inject-smart.txt
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-inject-smart(1)
 =====================
 
@@ -90,12 +92,7 @@ OPTIONS
 
 include::human-option.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2018, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index c4b38f975b8c..04affc42323d 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-list(1)
 =============
 
@@ -221,12 +223,7 @@ include::human-option.txt[]
   "badblock_count":8
 }
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-read-labels.txt b/Documentation/ndctl/ndctl-read-labels.txt
index a15e0f1061d6..0127e15f0721 100644
--- a/Documentation/ndctl/ndctl-read-labels.txt
+++ b/Documentation/ndctl/ndctl-read-labels.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-read-labels(1)
 ====================
 
@@ -25,12 +27,7 @@ include::labels-options.txt[]
 	parse the label data into json assuming the 'NVDIMM Namespace
 	Specification' format.
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl-update-firmware.txt b/Documentation/ndctl/ndctl-update-firmware.txt
index bd8ef24ca80e..449d85810546 100644
--- a/Documentation/ndctl/ndctl-update-firmware.txt
+++ b/Documentation/ndctl/ndctl-update-firmware.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-update-firmware(1)
 ========================
 
@@ -30,9 +32,4 @@ include::xable-dimm-options.txt[]
 --verbose::
         Emit debug messages for the namespace check process.
 
-COPYRIGHT
----------
-Copyright (c) 2017 - 2018, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-write-labels.txt b/Documentation/ndctl/ndctl-write-labels.txt
index 5e54cece95ca..38bb0110c269 100644
--- a/Documentation/ndctl/ndctl-write-labels.txt
+++ b/Documentation/ndctl/ndctl-write-labels.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-write-labels(1)
 =====================
 
diff --git a/Documentation/ndctl/ndctl-zero-labels.txt b/Documentation/ndctl/ndctl-zero-labels.txt
index 4d56696b1933..a1a5518fe93e 100644
--- a/Documentation/ndctl/ndctl-zero-labels.txt
+++ b/Documentation/ndctl/ndctl-zero-labels.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl-zero-labels(1)
 ====================
 
@@ -18,12 +20,7 @@ OPTIONS
 -------
 include::labels-options.txt[]
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
index b2e2ab93c4f5..b33e2777f5b4 100644
--- a/Documentation/ndctl/ndctl.txt
+++ b/Documentation/ndctl/ndctl.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 ndctl(1)
 =======
 
@@ -30,12 +32,7 @@ supported by the tool include, provisioning capacity (namespaces), as
 well as enumerating/enabling/disabling the devices (dimms, regions,
 namspaces) associated with an NVDIMM bus.
 
-COPYRIGHT
----------
-Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
-version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
-you are free to change and redistribute it.  There is NO WARRANTY, to
-the extent permitted by law.
+include::../copyright.txt[]
 
 SEE ALSO
 --------
diff --git a/Documentation/ndctl/region-description.txt b/Documentation/ndctl/region-description.txt
index bc3d12295c01..c14416a3be69 100644
--- a/Documentation/ndctl/region-description.txt
+++ b/Documentation/ndctl/region-description.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 DESCRIPTION
 -----------
 A generic REGION device is registered for each PMEM range or
diff --git a/Documentation/ndctl/xable-dimm-options.txt b/Documentation/ndctl/xable-dimm-options.txt
index ad79208a61eb..709e2e4202dd 100644
--- a/Documentation/ndctl/xable-dimm-options.txt
+++ b/Documentation/ndctl/xable-dimm-options.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 	A 'nmemX' device name, or a dimm id number. The keyword 'all' can
 	be specified to carry out the operation on every dimm in the system,
 	optionally filtered by bus id (see --bus= option).
diff --git a/Documentation/ndctl/xable-namespace-options.txt b/Documentation/ndctl/xable-namespace-options.txt
index cb24c2d61328..babc248f2288 100644
--- a/Documentation/ndctl/xable-namespace-options.txt
+++ b/Documentation/ndctl/xable-namespace-options.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 <namespace>::
 A 'namespaceX.Y' device name. The keyword 'all' can be specified to carry out
 the operation on every namespace in the system, optionally filtered by region
diff --git a/Documentation/ndctl/xable-region-options.txt b/Documentation/ndctl/xable-region-options.txt
index 243510cc0742..69d39266a4f1 100644
--- a/Documentation/ndctl/xable-region-options.txt
+++ b/Documentation/ndctl/xable-region-options.txt
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
 	A 'regionX' device name, or a region id number. The keyword 'all' can
 	be specified to carry out the operation on every region in the system,
 	optionally filtered by bus id (see --bus= option).

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
