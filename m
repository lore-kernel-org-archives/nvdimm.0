Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x241.google.com (mail-pg0-x241.google.com
 [IPv6:2607:f8b0:400e:c05::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B11A21BBC430
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 03:27:32 -0700 (PDT)
Received: by mail-pg0-x241.google.com with SMTP id u36so3796832pgn.3
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 03:29:02 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [RFC 1/4] libnvdimm: add to_{nvdimm,nd_region}_dev()
Date: Tue, 27 Jun 2017 20:28:48 +1000
Message-Id: <20170627102851.15484-1-oohall@gmail.com>
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
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

struct device contains the ->of_node pointer so that devices can be
assoicated with the device-tree node that created them on DT platforms.
libnvdimm hides the struct device for regions and nvdimm devices inside
of an opaque structure so this patch adds accessors for each to allow
the of_nvdimm driver to set the of_node pointer.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 drivers/nvdimm/dimm_devs.c   | 6 ++++++
 drivers/nvdimm/region_devs.c | 6 ++++++
 include/linux/libnvdimm.h    | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index f0d1b7e5de01..cbddac011181 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -227,6 +227,12 @@ struct nvdimm *to_nvdimm(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm);
 
+struct device *to_nvdimm_dev(struct nvdimm *nvdimm)
+{
+	return &nvdimm->dev;
+}
+EXPORT_SYMBOL_GPL(to_nvdimm_dev);
+
 struct nvdimm *nd_blk_region_to_dimm(struct nd_blk_region *ndbr)
 {
 	struct nd_region *nd_region = &ndbr->nd_region;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index cbaab4210c39..6c3988135fd5 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -182,6 +182,12 @@ struct nd_region *to_nd_region(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_region);
 
+struct device *to_nd_region_dev(struct nd_region *region)
+{
+	return &region->dev;
+}
+EXPORT_SYMBOL_GPL(to_nd_region_dev);
+
 struct nd_blk_region *to_nd_blk_region(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 550761477005..10fbc523ff95 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -139,6 +139,8 @@ struct nd_region *to_nd_region(struct device *dev);
 struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);
+struct device *to_nvdimm_dev(struct nvdimm *nvdimm);
+struct device *to_nd_region_dev(struct nd_region *region);
 const char *nvdimm_name(struct nvdimm *nvdimm);
 struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
