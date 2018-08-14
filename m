Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7293421959CB2
 for <linux-nvdimm@lists.01.org>; Tue, 14 Aug 2018 16:06:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] ndctl,
 list: fix the verbosity level formatting in the man page
Date: Tue, 14 Aug 2018 17:05:54 -0600
Message-Id: <20180814230555.3498-2-vishal.l.verma@intel.com>
In-Reply-To: <20180814230555.3498-1-vishal.l.verma@intel.com>
References: <20180814230555.3498-1-vishal.l.verma@intel.com>
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

The docbook->markdown rendering for the list verbosity options ate up
the newlines. Fix by forcing it into a bulleted list.

Cc: Keith Busch <keith.busch@intel.com>
Fixes: b2c9a47f474f ("ndctl: Add 'list' verbose options")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-list.txt | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index c823493..e24c8f4 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -207,13 +207,14 @@ include::xable-region-options.txt[]
 	multiple times to be even more verbose on the informational and
 	miscellaneous output, and can be used to override omitted flags
 	for showing specific information. +
-*-v*
-In addition to the enabled namespaces default output, show the numa_node,
-raw_uuid, and bad block media errors. +
-*-vv*
-Everything '-v' provides, plus automatically enable --dimms, --buses, and --regions. +
-*-vvv*
-Everything '-vv' provides, plus --health, --idle, and --firmware.
+	- *-v*
+	  In addition to the enabled namespaces default output, show the
+	  numa_node, raw_uuid, and bad block media errors. +
+	- *-vv*
+	  Everything '-v' provides, plus automatically enable --dimms,
+	  --buses, and --regions. +
+	- *-vvv*
+	  Everything '-vv' provides, plus --health, --idle, and --firmware.
 
 include::human-option.txt[]
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
