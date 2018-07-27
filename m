Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23131210C0CF8
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 11:06:39 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 documentation: document the label-version option for init-labels
Date: Fri, 27 Jul 2018 12:06:33 -0600
Message-Id: <20180727180633.9460-1-vishal.l.verma@intel.com>
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

Add the missing --label-verison option to the ndctl init-labels man
page.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-init-labels.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/ndctl/ndctl-init-labels.txt b/Documentation/ndctl/ndctl-init-labels.txt
index 736d52d..733ef0e 100644
--- a/Documentation/ndctl/ndctl-init-labels.txt
+++ b/Documentation/ndctl/ndctl-init-labels.txt
@@ -83,6 +83,11 @@ include::labels-options.txt[]
 	be an existing / valid namespace index.  Warning, this will
 	destroy all defined namespaces on the dimm.
 
+-V::
+--label-version::
+	Initialize with a specific version of labels from the namespace
+	label specification. Defaults to 1.1
+
 include::../copyright.txt[]
 
 SEE ALSO
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
