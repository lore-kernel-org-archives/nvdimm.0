Return-Path: <linux-kernel-owner@vger.kernel.org>
From: yalin wang <yalin.wang2010@gmail.com>
Subject: [PATCH] nvdimm: change to use generic kvfree()
Date: Thu, 20 Aug 2015 18:00:09 +0800
Message-Id: <1440064809-26036-1-git-send-email-yalin.wang2010@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Cc: yalin wang <yalin.wang2010@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
---
 drivers/nvdimm/dimm_devs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c05eb80..651b8d1 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -241,10 +241,7 @@ void nvdimm_drvdata_release(struct kref *kref)
 		nvdimm_free_dpa(ndd, res);
 	nvdimm_bus_unlock(dev);
 
-	if (ndd->data && is_vmalloc_addr(ndd->data))
-		vfree(ndd->data);
-	else
-		kfree(ndd->data);
+	kvfree(ndd->data);
 	kfree(ndd);
 	put_device(dev);
 }
-- 
1.9.1

