Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCA0521959CB2
 for <linux-nvdimm@lists.01.org>; Sun, 27 Jan 2019 16:31:13 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 2/5] libnvdimm,
 namespace: remove special handling when count == 0
Date: Mon, 28 Jan 2019 08:30:15 +0800
Message-Id: <20190128003018.4087-2-richardw.yang@linux.intel.com>
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

This is reasonable to continue directly when count == 0, while this case
could be merged in following for loop.

  count == 0, j == 0 => j >= count, loop continues.

This patch just removes the special handling to make the code look more
neat.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 234c0c79726a..0d64c4b38a56 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2485,8 +2485,6 @@ static int init_active_labels(struct nd_region *nd_region)
 
 		count = nd_label_active_count(ndd);
 		dev_dbg(ndd->dev, "count: %d\n", count);
-		if (!count)
-			continue;
 		for (j = 0; j < count; j++) {
 			struct nd_namespace_label *label;
 
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
