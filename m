Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 507B1223CCF17
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 00:34:00 -0800 (PST)
Subject: [PATCH] libnvdimm, namespace: make min namespace size 4K
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Feb 2018 00:30:32 -0800
Message-ID: <151756023262.24612.12933966286242265340.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Cheng-mean Liu <soccerl@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

The arbitrary 4MB minimum namespace size turns out to be too large for
some environments. Quoting Cheng-mean Liu:

    In the case of emulated NVDIMM devices in the VM environment, there
    are scenarios that NVDIMM device with much smaller sizes are
    desired, for example, we might use a single enumerated NVDIMM DAX
    device for representing each container layer, which in some cases
    could be just a few KBs size.

PAGE_SIZE is the minimum where we can still support DAX of at least
a single page.

Cc: Matthew Wilcox <willy@infradead.org>
Reported-by: Cheng-mean Liu <soccerl@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/uapi/linux/ndctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 30ef1236aafa..7e27070b9440 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -209,7 +209,7 @@ enum nd_driver_flags {
 };
 
 enum {
-	ND_MIN_NAMESPACE_SIZE = 0x00400000,
+	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
 };
 
 enum ars_masks {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
