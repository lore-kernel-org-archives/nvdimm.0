Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1AAFB21E49035
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 15:20:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl,
 docs: cleanup the man page for create-namespace
Date: Wed, 14 Mar 2018 16:26:41 -0600
Message-Id: <20180314222641.2826-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Clean up some rendering artifacts in the man page for
ndctl-create-namespace.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt | 54 +++++++++++++-------------
 1 file changed, 26 insertions(+), 28 deletions(-)

v2: Make the "In the latter case.." paragraph a continuation of the
first bullet.

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index c8b1c99..8de6689 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -171,32 +171,31 @@ OPTIONS
 	Section 6.5.10 NVDIMM Label Methods) support "labelled
 	namespace" operation.
 
-	There are two cases where the kernel will default to
-	label-less operation:
-
-	* NVDIMM does not support labels
-
-	* The NVDIMM supports labels, but the Label Index Block (see
-	  UEFI 2.7) is not present and there is no capacity aliasing
-	  between 'blk' and 'pmem' regions.
-
-	In the latter case the configuration can be upgraded to
-	labelled operation by writing an index block on all DIMMs in a
-	region and re-enabling that region. The 'autolabel' capability
-	of 'ndctl create-namespace --reconfig' tries to do this by
-	default if it can determine that all DIMM capacity is
-	referenced by the namespace being reconfigured. It will
-	otherwise fail to autolabel and remain in label-less mode if
-	it finds a DIMM contributes capacity to more than one region.
-	This check prevents inadvertent data loss of that other region
-	is in active use. The --autolabel option is implied by
-	default, the --no-autolabel option can be used to disable this
-	behavior. When automatic labeling fails and labelled operation
-	is still desired the safety policy can be bypassed by the
-	following commands, note that all data on all regions is
-	forfeited by running these commands:
-
-	[verse]
+	- There are two cases where the kernel will default to
+	  label-less operation:
+
+	  * NVDIMM does not support labels
+
+	  * The NVDIMM supports labels, but the Label Index Block (see
+	    UEFI 2.7) is not present and there is no capacity aliasing
+	    between 'blk' and 'pmem' regions.
+
+	- In the latter case the configuration can be upgraded to
+	  labelled operation by writing an index block on all DIMMs in a
+	  region and re-enabling that region. The 'autolabel' capability
+	  of 'ndctl create-namespace --reconfig' tries to do this by
+	  default if it can determine that all DIMM capacity is
+	  referenced by the namespace being reconfigured. It will
+	  otherwise fail to autolabel and remain in label-less mode if
+	  it finds a DIMM contributes capacity to more than one region.
+	  This check prevents inadvertent data loss of that other region
+	  is in active use. The --autolabel option is implied by
+	  default, the --no-autolabel option can be used to disable this
+	  behavior. When automatic labeling fails and labelled operation
+	  is still desired the safety policy can be bypassed by the
+	  following commands, note that all data on all regions is
+	  forfeited by running these commands:
+
 	ndctl disable-region all
 	ndctl init-labels all
 	ndctl enable-region all
@@ -222,5 +221,4 @@ linkndctl:ndctl-zero-labels[1],
 linkndctl:ndctl-init-labels[1],
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-enable-namespace[1],
-http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol
-]
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
