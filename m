Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A9C821A07A82
 for <linux-nvdimm@lists.01.org>; Wed, 24 Jul 2019 14:43:50 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] Documentation/ndctl: fix a typo in ndctl(1)
Date: Wed, 24 Jul 2019 15:41:13 -0600
Message-Id: <20190724214113.14454-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargal <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Fix 'namspaces' to 'namespaces' in the ndctl(1) man page.

Link: https://github.com/pmem/ndctl/issues/100
Reported-by: Steve Scargal <steve.scargall@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
index b33e277..c2919de 100644
--- a/Documentation/ndctl/ndctl.txt
+++ b/Documentation/ndctl/ndctl.txt
@@ -30,7 +30,7 @@ message interface for platform NVDIMM resources like those defined by
 the ACPI 6.0 NFIT (NVDIMM Firmware Interface Table).  Operations
 supported by the tool include, provisioning capacity (namespaces), as
 well as enumerating/enabling/disabling the devices (dimms, regions,
-namspaces) associated with an NVDIMM bus.
+namespaces) associated with an NVDIMM bus.
 
 include::../copyright.txt[]
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
