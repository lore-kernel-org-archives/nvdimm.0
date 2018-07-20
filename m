Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EA5A2098EA8C
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 17:17:01 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] Documentation, create-namespace: clarify fsdax wording
Date: Thu, 19 Jul 2018 18:16:56 -0600
Message-Id: <20180720001656.16990-1-vishal.l.verma@intel.com>
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

Reword the description of the fsdax mode in the create-namespace
documentation to better distinguish when DAX can be used vs. how the raw
block device will use the page cache.

Link: https://github.com/pmem/issues/issues/915
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 4b8b0d1..343733d 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -68,10 +68,11 @@ OPTIONS
 	  comes at the cost of allocating per-page metadata. The
 	  capacity can be allocated from "System RAM", or from a
 	  reserved portion of "Persistent Memory" (see the --map=
-	  option).  Note that a filesystem is required for dax
-	  operation, the resulting raw block device (/dev/pmemX) will
-	  use the page cache. See "devdax" mode for raw device access
-	  that supports dax.
+	  option).  NOTE: A filesystem that supports DAX is required
+	  for dax operation. If the raw block device (/dev/pmemX) is
+	  used directly without a filesystem, it will use the page
+	  cache. See "devdax" mode for raw device access that supports
+	  dax.
 
 	- "devdax": The device-dax character device interface is a
 	  statically allocated / raw access analogue of filesystem-dax
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
