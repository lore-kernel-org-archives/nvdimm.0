Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1457B1A1E3A
 for <linux-nvdimm@lists.01.org>; Sat, 15 Oct 2016 08:32:19 -0700 (PDT)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] libnvdimm: fix dereference on null devs on error exit path
Date: Sat, 15 Oct 2016 16:32:14 +0100
Message-Id: <20161015153214.26783-1-colin.king@canonical.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Colin Ian King <colin.king@canonical.com>

If devs cannot be allocated then the error exit path jumps to
a cleanup loop that iterates over a null array of devs which
is incorrect.  Fix this by jumping instead to the end of the
function where NULL is returned.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nvdimm/namespace_devs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3509cff..5d2755a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2125,7 +2125,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
 		if (!devs)
-			goto err;
+			goto err_ret;
 		if (is_nd_blk(&nd_region->dev)) {
 			struct nd_namespace_blk *nsblk;
 
@@ -2182,6 +2182,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		else
 			namespace_pmem_release(devs[i]);
 	kfree(devs);
+ err_ret:
 	return NULL;
 }
 
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
