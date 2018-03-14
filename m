Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17FBE2202E497
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 13:48:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, docs: cleanup the man page for create-namespace
Date: Wed, 14 Mar 2018 14:54:36 -0600
Message-Id: <20180314205436.9776-1-vishal.l.verma@intel.com>
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
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index c8b1c99..29374d3 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -171,14 +171,14 @@ OPTIONS
 	Section 6.5.10 NVDIMM Label Methods) support "labelled
 	namespace" operation.
 
-	There are two cases where the kernel will default to
-	label-less operation:
+	- There are two cases where the kernel will default to
+	  label-less operation:
 
-	* NVDIMM does not support labels
+	  * NVDIMM does not support labels
 
-	* The NVDIMM supports labels, but the Label Index Block (see
-	  UEFI 2.7) is not present and there is no capacity aliasing
-	  between 'blk' and 'pmem' regions.
+	  * The NVDIMM supports labels, but the Label Index Block (see
+	    UEFI 2.7) is not present and there is no capacity aliasing
+	    between 'blk' and 'pmem' regions.
 
 	In the latter case the configuration can be upgraded to
 	labelled operation by writing an index block on all DIMMs in a
@@ -196,7 +196,6 @@ OPTIONS
 	following commands, note that all data on all regions is
 	forfeited by running these commands:
 
-	[verse]
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
