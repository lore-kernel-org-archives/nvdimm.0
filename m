Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAB70203BBB9F
 for <linux-nvdimm@lists.01.org>; Wed, 16 May 2018 22:00:33 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH v2 1/4] nvdimm: fix typo in label-size definition
Date: Wed, 16 May 2018 23:00:21 -0600
Message-Id: <20180517050024.20101-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
References: <20180517050024.20101-1-ross.zwisler@linux.intel.com>
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
To: Igor Mammedov <imammedo@redhat.com>, qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: commit da6789c27c2e ("nvdimm: add a macro for property "label-size"")
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Cc: Haozhong Zhang <haozhong.zhang@intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/mem/nvdimm.c         | 2 +-
 include/hw/mem/nvdimm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/mem/nvdimm.c b/hw/mem/nvdimm.c
index acb656b672..4087aca25e 100644
--- a/hw/mem/nvdimm.c
+++ b/hw/mem/nvdimm.c
@@ -89,7 +89,7 @@ static void nvdimm_set_unarmed(Object *obj, bool value, Error **errp)
 
 static void nvdimm_init(Object *obj)
 {
-    object_property_add(obj, NVDIMM_LABLE_SIZE_PROP, "int",
+    object_property_add(obj, NVDIMM_LABEL_SIZE_PROP, "int",
                         nvdimm_get_label_size, nvdimm_set_label_size, NULL,
                         NULL, NULL);
     object_property_add_bool(obj, NVDIMM_UNARMED_PROP,
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index 7fd87c4e1c..74c60332e1 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -48,7 +48,7 @@
 #define NVDIMM_GET_CLASS(obj) OBJECT_GET_CLASS(NVDIMMClass, (obj), \
                                                TYPE_NVDIMM)
 
-#define NVDIMM_LABLE_SIZE_PROP "label-size"
+#define NVDIMM_LABEL_SIZE_PROP "label-size"
 #define NVDIMM_UNARMED_PROP    "unarmed"
 
 struct NVDIMMDevice {
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
