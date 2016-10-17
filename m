Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62A3A1A1E30
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 09:35:56 -0700 (PDT)
Received: by mail-pf0-x244.google.com with SMTP id r16so13087644pfg.3
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 09:35:56 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] libnvdimm: fix error return code in __blk_label_update()
Date: Mon, 17 Oct 2016 16:35:48 +0000
Message-Id: <1476722148-22795-1-git-send-email-weiyj.lk@gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENXIO from the nd_label_alloc_slot() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/nvdimm/label.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index fac7cab..ab2927c 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -710,8 +710,10 @@ static int __blk_label_update(struct nd_region *nd_region,
 		if (is_old_resource(res, old_res_list, old_num_resources))
 			continue; /* carry-over */
 		slot = nd_label_alloc_slot(ndd);
-		if (slot == UINT_MAX)
+		if (slot == UINT_MAX) {
+			rc = -ENXIO;
 			goto abort;
+		}
 		dev_dbg(ndd->dev, "%s: allocated: %d\n", __func__, slot);
 
 		nd_label = nd_label_base(ndd) + slot;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
