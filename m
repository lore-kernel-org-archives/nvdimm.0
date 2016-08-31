Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from andre.telenet-ops.be (andre.telenet-ops.be
 [IPv6:2a02:1800:120:4::f00:15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 395941A1E3D
 for <linux-nvdimm@lists.01.org>; Wed, 31 Aug 2016 02:45:27 -0700 (PDT)
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] [trivial] nvdimm: Spelling s/unacknoweldged/unacknowledged/
Date: Wed, 31 Aug 2016 11:45:25 +0200
Message-Id: <1472636725-27686-1-git-send-email-geert+renesas@glider.be>
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
To: Dan Williams <dan.j.williams@intel.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index c5e3196c45b02cc5..6b0449bd7720b7c0 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -294,7 +294,7 @@ static bool __nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
 		if (strcmp(res->name, label_id.id) != 0)
 			continue;
 		/*
-		 * Resources with unacknoweldged adjustments indicate a
+		 * Resources with unacknowledged adjustments indicate a
 		 * failure to update labels
 		 */
 		if (res->flags & DPA_RESOURCE_ADJUSTED)
-- 
1.9.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
