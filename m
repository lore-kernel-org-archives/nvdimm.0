Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65FB821DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:12 -0700 (PDT)
Subject: [ndctl PATCH 2/6] Documentation, list: add --device-dax,
 -X description to man page
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:14:02 -0700
Message-ID: <149074284233.18735.14242091635636742934.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Document the new option added in commit 10663a60d723 "ndctl, list: add
'--device-dax' option".

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 2e362e818bbc..bb7db47e7af8 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -105,6 +105,29 @@ include::xable-region-options.txt[]
   }
 }
 
+-X::
+--device-dax::
+	Include device-dax ("daxregion") details when a namespace is in
+	"dax" mode.
+[verse]
+{
+  "dev":"namespace0.0",
+  "mode":"dax",
+  "size":4225761280,
+  "uuid":"18ae1bbb-bb62-4efc-86df-4a5caacb5dcc",
+  "daxregion":{
+    "id":0,
+    "size":4225761280,
+    "align":2097152,
+    "devices":[
+      {
+        "chardev":"dax0.0",
+        "size":4225761280
+      }
+    ]
+  }
+}
+
 -R::
 --regions::
 	Include region info in the listing

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
