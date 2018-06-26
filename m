Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCEA8211F889C
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 13:43:26 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [ndctl PATCH 2/2] ndctl: Add 'list' verbose documentation
Date: Tue, 26 Jun 2018 14:46:49 -0600
Message-Id: <20180626204649.7665-2-keith.busch@intel.com>
In-Reply-To: <20180626204649.7665-1-keith.busch@intel.com>
References: <20180626204649.7665-1-keith.busch@intel.com>
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
To: linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 Documentation/ndctl/ndctl-list.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index 13ebdcd..791638c 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -200,6 +200,18 @@ include::xable-region-options.txt[]
   ]
 }
 
+-v::
+--verbose::
+	Increase verbosity of the output. This can be specified
+	multiple times to be even more verbose on the informational and
+	miscellaneous output, and can be used to override the flags for
+	showing specific information.
+
+[verse]
+ndctl list -v
+ndctl list -vv
+ndctl list -vvv
+
 include::human-option.txt[]
 
 ----
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
