Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C135D21161680
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 20:35:12 -0700 (PDT)
From: GuangZhe Fu <fugz2012@zoho.com>
Subject: [PATCH] libnvdimm,
 namespace: Drop the repeat assignment for variable dev->parent
Date: Mon,  1 Oct 2018 23:35:00 -0400
Message-Id: <20181002033500.3383-1-fugz2012@zoho.com>
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
To: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: fugz2012@zoho.com, GuangZhe Fu <fugz1@lenovo.com>
List-ID: <linux-nvdimm@lists.01.org>

From: GuangZhe Fu <fugz1@lenovo.com>

The variable dev-parent is assigned twice with the same &nd_region->dev. I think we could drop the second one.

Signed-off-by: GuangZhe Fu <fugz1@lenovo.com>
---
 drivers/nvdimm/namespace_devs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index cb322f2..db0abf1 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2099,7 +2099,6 @@ static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
 		return NULL;
 	}
 	dev_set_name(dev, "namespace%d.%d", nd_region->id, nspm->id);
-	dev->parent = &nd_region->dev;
 	dev->groups = nd_namespace_attribute_groups;
 	nd_namespace_pmem_set_resource(nd_region, nspm, 0);
 
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
