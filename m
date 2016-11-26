Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.polytechnique.org (mx1.polytechnique.org [129.104.30.34])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDB6281F20
 for <linux-nvdimm@lists.01.org>; Sat, 26 Nov 2016 11:19:00 -0800 (PST)
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] libnvdimm, namespace: fix the type of name variable
Date: Sat, 26 Nov 2016 20:18:04 +0100
Message-Id: <20161126191804.21349-1-nicolas.iooss_linux@m4x.org>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In create_namespace_blk(), the local variable "name" is defined as an
array of NSLABEL_NAME_LEN pointers:

    char *name[NSLABEL_NAME_LEN];

This variable is then used in calls to memcpy() and kmemdup() as if it
were char[NSLABEL_NAME_LEN]. Remove the star in the variable definition
to makes it look right.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index abe5c6bc756c..7569ba70cdde 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1997,7 +1997,7 @@ struct device *create_namespace_blk(struct nd_region *nd_region,
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_namespace_blk *nsblk;
-	char *name[NSLABEL_NAME_LEN];
+	char name[NSLABEL_NAME_LEN];
 	struct device *dev = NULL;
 	struct resource *res;
 
-- 
2.10.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
