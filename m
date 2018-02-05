Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4527B2215BD96
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 06:06:14 -0800 (PST)
From: Colin King <colin.king@canonical.com>
Subject: [PATCH] libnvdimm: remove redundant assignment to pointer 'dev'
Date: Mon,  5 Feb 2018 14:08:52 +0000
Message-Id: <20180205140852.14110-1-colin.king@canonical.com>
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
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer dev is being assigned a value that is never read, it is being
re-assigned the same value later on, hence the initialization is redundant
and can be removed.

Cleans up clang warning:
drivers/nvdimm/pfn_devs.c:307:17: warning: Value stored to 'dev' during
its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nvdimm/pfn_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index f5c4e8c6e29d..2f4d18752c97 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -304,7 +304,7 @@ static const struct attribute_group *nd_pfn_attribute_groups[] = {
 struct device *nd_pfn_devinit(struct nd_pfn *nd_pfn,
 		struct nd_namespace_common *ndns)
 {
-	struct device *dev = &nd_pfn->dev;
+	struct device *dev;
 
 	if (!nd_pfn)
 		return NULL;
-- 
2.15.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
