Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C215E2194D387
 for <linux-nvdimm@lists.01.org>; Sun, 27 Jan 2019 16:31:15 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 3/5] libnvdimm,
 label: return nd_label directly instead of calculating it again
Date: Mon, 28 Jan 2019 08:30:16 +0800
Message-Id: <20190128003018.4087-3-richardw.yang@linux.intel.com>
In-Reply-To: <20190128003018.4087-1-richardw.yang@linux.intel.com>
References: <20190128003018.4087-1-richardw.yang@linux.intel.com>
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
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In nd_label_active(), we get nd_label from label area. While it is not
necessary to calculate it a second time.

This patch return nd_label directly.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 750dbaa6ce82..63b7d40fe9d4 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -587,7 +587,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 			continue;
 
 		if (n-- == 0)
-			return to_label(ndd, slot);
+			return nd_label;
 	}
 
 	return NULL;
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
