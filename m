Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE2042034C8AF
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 14:53:53 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] nvdimm, acpi: add NFIT platform capabilities
Date: Fri, 27 Apr 2018 15:53:13 -0600
Message-Id: <20180427215314.23168-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
References: <20180427215314.23168-1-ross.zwisler@linux.intel.com>
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
To: Haozhong Zhang <haozhong.zhang@intel.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Add support for the NFIT Platform Capabilities Structure, newly added in
ACPI 6.2 Errata A.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 hw/acpi/nvdimm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
index 59d6e4254c..859b390e07 100644
--- a/hw/acpi/nvdimm.c
+++ b/hw/acpi/nvdimm.c
@@ -169,6 +169,21 @@ struct NvdimmNfitControlRegion {
 } QEMU_PACKED;
 typedef struct NvdimmNfitControlRegion NvdimmNfitControlRegion;
 
+/*
+ * NVDIMM Platform Capabilities Structure
+ *
+ * Defined in section 5.2.25.9 of ACPI 6.2 Errata A, September 2017
+ */
+struct NvdimmNfitPlatformCaps {
+    uint16_t type;
+    uint16_t length;
+    uint8_t highest_cap;
+    uint8_t reserved[3];
+    uint32_t capabilities;
+    uint8_t reserved2[4];
+} QEMU_PACKED;
+typedef struct NvdimmNfitPlatformCaps NvdimmNfitPlatformCaps;
+
 /*
  * Module serial number is a unique number for each device. We use the
  * slot id of NVDIMM device to generate this number so that each device
@@ -351,6 +366,21 @@ static void nvdimm_build_structure_dcr(GArray *structures, DeviceState *dev)
                                          JEDEC Annex L Release 3. */);
 }
 
+/*
+ * ACPI 6.2 Errata A: 5.2.25.9 NVDIMM Platform Capabilities Structure
+ */
+static void
+nvdimm_build_structure_caps(GArray *structures)
+{
+    NvdimmNfitPlatformCaps *nfit_caps;
+
+    nfit_caps = acpi_data_push(structures, sizeof(*nfit_caps));
+
+    nfit_caps->type = cpu_to_le16(7 /* NVDIMM Platform Capabilities */);
+    nfit_caps->length = cpu_to_le16(sizeof(*nfit_caps));
+    nfit_caps->highest_cap = 1;
+    nfit_caps->capabilities = cpu_to_le32(2 /* memory controller */);
+}
 static GArray *nvdimm_build_device_structure(void)
 {
     GSList *device_list = nvdimm_get_device_list();
@@ -373,6 +403,8 @@ static GArray *nvdimm_build_device_structure(void)
     }
     g_slist_free(device_list);
 
+    nvdimm_build_structure_caps(structures);
+
     return structures;
 }
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
