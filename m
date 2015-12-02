Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
Subject: [PATCH] nvdimm: do not show pfn_seed for non pmem regions
Date: Wed,  2 Dec 2015 09:39:29 +0300
Message-Id: <1449038369-752-1-git-send-email-krivenok.dmitry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

This simple change hides pfn_seed attribute for non pmem
regions because they don't support pfn anyway.

Signed-off-by: Dmitry V. Krivenok <krivenok.dmitry@gmail.com>
---
 drivers/nvdimm/region_devs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 529f3f0..3d730d1 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -406,6 +406,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	int type = nd_region_to_nstype(nd_region);
 
+	if (!is_nd_pmem(dev) && a == &dev_attr_pfn_seed.attr)
+		return 0;
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;
-- 
2.6.2

