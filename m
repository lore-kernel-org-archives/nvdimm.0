Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 310D121BADAB2
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 05:08:51 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id z8-v6so5777537qto.9
 for <linux-nvdimm@lists.01.org>; Fri, 03 Aug 2018 05:08:51 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH] libnvdimm, bus: check id immediately following ida_simple_get
Date: Fri,  3 Aug 2018 08:08:33 -0400
Message-Id: <1533298113-17495-1-git-send-email-oceanhehy@gmail.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

The id check was not executed immediately following ida_simple_get. Just
change the codes position, without function change.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/nvdimm/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 27902a8..ab28e7c 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -350,12 +350,12 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
-	mutex_init(&nvdimm_bus->reconfig_mutex);
-	badrange_init(&nvdimm_bus->badrange);
 	if (nvdimm_bus->id < 0) {
 		kfree(nvdimm_bus);
 		return NULL;
 	}
+	mutex_init(&nvdimm_bus->reconfig_mutex);
+	badrange_init(&nvdimm_bus->badrange);
 	nvdimm_bus->nd_desc = nd_desc;
 	nvdimm_bus->dev.parent = parent;
 	nvdimm_bus->dev.release = nvdimm_bus_release;
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
