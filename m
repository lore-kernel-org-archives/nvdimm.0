Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4854223FCF51
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 12:55:30 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 documentation: remove '...' from label-options.txt
Date: Thu, 15 Mar 2018 14:01:51 -0600
Message-Id: <20180315200151.27568-1-vishal.l.verma@intel.com>
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

The '...' in label-options.txt ended up getting rendered as an ellipsis
character in the online man pages, and made filtering for certain things
a little harder. Remove it since the plural already indicates multiple
devices can be passed.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/labels-options.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ndctl/labels-options.txt b/Documentation/ndctl/labels-options.txt
index f39c213..e13cdc5 100644
--- a/Documentation/ndctl/labels-options.txt
+++ b/Documentation/ndctl/labels-options.txt
@@ -1,4 +1,4 @@
-<memory device(s)>...::
+<memory device(s)>::
 	One or more 'nmemX' device names. The keyword 'all' can be specified to
 	operate on every dimm in the system, optionally filtered by bus id (see
         --bus= option).
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
