Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DC52B21309D22
 for <linux-nvdimm@lists.01.org>; Thu,  8 Aug 2019 18:38:14 -0700 (PDT)
Subject: [ndctl PATCH] daxctl/test: Skip daxctl-devices.sh on older kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Aug 2019 18:21:26 -0700
Message-ID: <156531368648.2136155.13013612862545053331.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If the 'kmem' module is missing skip the test to support running the
unit tests on older -stable kernels pre-v5.1.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/daxctl-devices.sh |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
index 04f53f7b13ab..4102fb6990ae 100755
--- a/test/daxctl-devices.sh
+++ b/test/daxctl-devices.sh
@@ -18,6 +18,13 @@ find_testdev()
 {
 	local rc=77
 
+	# The kmem driver is needed to change the device mode, only
+	# kernels >= v5.1 might have it available. Skip if not.
+	if ! modinfo kmem; then
+		"Unable to find kmem module"
+		exit $rc
+	fi
+
 	# find a victim device
 	testbus="$ACPI_BUS"
 	testdev=$("$NDCTL" list -b "$testbus" -Ni | jq -er '.[0].dev | .//""')

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
