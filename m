Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A6751A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 23 Jun 2016 02:52:45 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] libnvdimm: initialize struct blk_integrity with 0
Date: Thu, 23 Jun 2016 11:52:04 +0200
Message-Id: <20160623095204.32167-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Initialize struct blk_integrity with 0 as blk_integrity_register() takes the
then unitialized struct blk_integrity::flags and ORs it to the resulting block
integrity structure.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvdimm/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index be89764..32e4fe2 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -601,7 +601,8 @@ int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 	if (meta_size == 0)
 		return 0;
 
-	bi.profile = NULL;
+	memset(&bi, 0, sizeof(bi));
+
 	bi.tuple_size = meta_size;
 	bi.tag_size = meta_size;
 
-- 
2.8.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
