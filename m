Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BC1221159C91
 for <linux-nvdimm@lists.01.org>; Sun, 10 Jun 2018 19:16:25 -0700 (PDT)
From: Zhang Yi <yi.z.zhang@linux.intel.com>
Subject: [Qemu-devel] [RFC PATCH 1/1] nvdimm: let qemu requiring section
 alignment of pmem resource.
Date: Mon, 11 Jun 2018 18:54:25 +0800
Message-Id: <e74aee54657de6f8d643a92ba21f467db149c2c8.1528714312.git.yi.z.zhang@linux.intel.com>
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
To: xiaoguangrong.eric@gmail.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, stefanha@redhat.com, yu.c.zhang@linux.intel.com
Cc: ehabkost@redhat.com, linux-nvdimm@lists.01.org, mst@redhat.com, qemu-devel@nongnu.org, Zhang Yi <yi.z.zhang@linux.intel.com>, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Nvdimm driver use Memory hot-plug APIs to map it's pmem resource,
which at a section granularity.

When QEMU emulated the vNVDIMM device, decrease the label-storage,
QEMU will put the vNVDIMMs directly next to one another in physical
address space, which means that the boundary between them won't
align to the 128 MB memory section size.

Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
---
 hw/mem/nvdimm.c         | 2 +-
 include/hw/mem/nvdimm.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/mem/nvdimm.c b/hw/mem/nvdimm.c
index 4087aca..ff6e171 100644
--- a/hw/mem/nvdimm.c
+++ b/hw/mem/nvdimm.c
@@ -109,7 +109,7 @@ static void nvdimm_realize(PCDIMMDevice *dimm, Error **errp)
     NVDIMMDevice *nvdimm = NVDIMM(dimm);
     uint64_t align, pmem_size, size = memory_region_size(mr);
 
-    align = memory_region_get_alignment(mr);
+    align = MAX(memory_region_get_alignment(mr), NVDIMM_ALIGN_SIZE);
 
     pmem_size = size - nvdimm->label_size;
     nvdimm->label_data = memory_region_get_ram_ptr(mr) + pmem_size;
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index 3c82751..1d384e4 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -41,6 +41,7 @@
  *    at least 128KB in size, which holds around 1000 labels."
  */
 #define MIN_NAMESPACE_LABEL_SIZE      (128UL << 10)
+#define NVDIMM_ALIGN_SIZE      (128UL << 20)
 
 #define TYPE_NVDIMM      "nvdimm"
 #define NVDIMM(obj)      OBJECT_CHECK(NVDIMMDevice, (obj), TYPE_NVDIMM)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
