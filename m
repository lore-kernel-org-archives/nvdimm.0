Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A67772034BBC0
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 18:21:49 -0800 (PST)
Subject: [ndctl PATCH 4/4] ndctl,
 create-namespace: document autolabel operation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Nov 2017 18:17:44 -0800
Message-ID: <151079866442.25456.15054015233088377884.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151079864874.25456.11655607153151633382.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151079864874.25456.11655607153151633382.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Kelly Couch <kelly.j.couch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Write up how the autolabel mechanism operates, when it is used, and what
to do when it fails.

Reported-by: Kelly Couch <kelly.j.couch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-check-labels.txt     |    3 +-
 Documentation/ndctl/ndctl-check-namespace.txt  |    3 +-
 Documentation/ndctl/ndctl-create-namespace.txt |   47 +++++++++++++++++++++++-
 Documentation/ndctl/ndctl-init-labels.txt      |    4 +-
 Documentation/ndctl/ndctl-read-labels.txt      |    3 +-
 Documentation/ndctl/ndctl-write-labels.txt     |    3 +-
 Documentation/ndctl/ndctl-zero-labels.txt      |    3 +-
 7 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/Documentation/ndctl/ndctl-check-labels.txt b/Documentation/ndctl/ndctl-check-labels.txt
index 210eb23caf66..a7c8a5f2dcbd 100644
--- a/Documentation/ndctl/ndctl-check-labels.txt
+++ b/Documentation/ndctl/ndctl-check-labels.txt
@@ -28,5 +28,4 @@ the extent permitted by law.
 
 SEE ALSO
 --------
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
diff --git a/Documentation/ndctl/ndctl-check-namespace.txt b/Documentation/ndctl/ndctl-check-namespace.txt
index 07fe15ac5485..49353b1b217f 100644
--- a/Documentation/ndctl/ndctl-check-namespace.txt
+++ b/Documentation/ndctl/ndctl-check-namespace.txt
@@ -67,5 +67,4 @@ SEE ALSO
 --------
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-enable-namespace[1],
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 0910edd753ab..c8b1c99c5229 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -159,6 +159,48 @@ OPTIONS
 	namespace' operations will be aborted.  The namespace must be
 	unmounted before being reconfigured.
 
+-L::
+--autolabel::
+--no-autolabel::
+	Legacy NVDIMM devices do not support namespace labels. In that
+	case the kernel creates region-sized namespaces that can not
+	be deleted.  Their mode can be changed, but they can not be
+	resized smaller than their parent region. This is termed a
+	"label-less namespace". In contrast, NVDIMMs and hypervisors
+	that support the ACPI 6.2 label area definition (ACPI 6.2
+	Section 6.5.10 NVDIMM Label Methods) support "labelled
+	namespace" operation.
+
+	There are two cases where the kernel will default to
+	label-less operation:
+
+	* NVDIMM does not support labels
+
+	* The NVDIMM supports labels, but the Label Index Block (see
+	  UEFI 2.7) is not present and there is no capacity aliasing
+	  between 'blk' and 'pmem' regions.
+
+	In the latter case the configuration can be upgraded to
+	labelled operation by writing an index block on all DIMMs in a
+	region and re-enabling that region. The 'autolabel' capability
+	of 'ndctl create-namespace --reconfig' tries to do this by
+	default if it can determine that all DIMM capacity is
+	referenced by the namespace being reconfigured. It will
+	otherwise fail to autolabel and remain in label-less mode if
+	it finds a DIMM contributes capacity to more than one region.
+	This check prevents inadvertent data loss of that other region
+	is in active use. The --autolabel option is implied by
+	default, the --no-autolabel option can be used to disable this
+	behavior. When automatic labeling fails and labelled operation
+	is still desired the safety policy can be bypassed by the
+	following commands, note that all data on all regions is
+	forfeited by running these commands:
+
+	[verse]
+	ndctl disable-region all
+	ndctl init-labels all
+	ndctl enable-region all
+
 -v::
 --verbose::
 	Emit debug messages for the namespace creation process
@@ -177,7 +219,8 @@ the extent permitted by law.
 SEE ALSO
 --------
 linkndctl:ndctl-zero-labels[1],
+linkndctl:ndctl-init-labels[1],
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-enable-namespace[1],
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol
+]
diff --git a/Documentation/ndctl/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
index a5c0c127e279..d30ccc5fed0d 100644
--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -85,5 +85,5 @@ the extent permitted by law.
 
 SEE ALSO
 --------
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+linkndctl:ndctl-create-namespace[1],
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
diff --git a/Documentation/ndctl/ndctl-read-labels.txt b/Documentation/ndctl/ndctl-read-labels.txt
index a1640d6ff566..a15e0f1061d6 100644
--- a/Documentation/ndctl/ndctl-read-labels.txt
+++ b/Documentation/ndctl/ndctl-read-labels.txt
@@ -34,5 +34,4 @@ the extent permitted by law.
 
 SEE ALSO
 --------
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
diff --git a/Documentation/ndctl/ndctl-write-labels.txt b/Documentation/ndctl/ndctl-write-labels.txt
index bace46fba160..5e54cece95ca 100644
--- a/Documentation/ndctl/ndctl-write-labels.txt
+++ b/Documentation/ndctl/ndctl-write-labels.txt
@@ -25,5 +25,4 @@ include::labels-options.txt[]
 
 SEE ALSO
 --------
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
diff --git a/Documentation/ndctl/ndctl-zero-labels.txt b/Documentation/ndctl/ndctl-zero-labels.txt
index 56dacf1c1714..4d56696b1933 100644
--- a/Documentation/ndctl/ndctl-zero-labels.txt
+++ b/Documentation/ndctl/ndctl-zero-labels.txt
@@ -27,5 +27,4 @@ the extent permitted by law.
 
 SEE ALSO
 --------
-http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
-Specification]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
