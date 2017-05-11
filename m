Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2A5921A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 13:18:21 -0700 (PDT)
Subject: [PATCH] ndctl: add list -M documentation
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 11 May 2017 13:18:21 -0700
Message-ID: <149453390131.38698.13565665088604739422.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding the list --media-errors option to documentation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl-list.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 444a6f9..0ac08a8 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -146,6 +146,35 @@ include::xable-region-options.txt[]
 --idle::
 	Include idle (not enabled) devices in the listing
 
+-M::
+--media-errors::
+	Include media errors (badblocks) in the listing. badblocks_count
+	may count blocks that are not in the data space of the namespace
+	for sector mode.
+[verse]
+{
+  "dev":"namespace7.0",
+  "mode":"raw",
+  "size":33554432,
+  "blockdev":"pmem7",
+  "badblock_count":17,
+  "badblocks":[
+    {
+      "offset":4,
+      "length":1
+    },
+    {
+      "offset":32768,
+      "length":8
+    },
+    {
+      "offset":65528,
+      "length":8
+    }
+  ]
+}
+
+
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1]

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
