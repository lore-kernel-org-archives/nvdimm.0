Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 177DB20348610
 for <linux-nvdimm@lists.01.org>; Mon, 21 May 2018 09:32:11 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH v4 3/4] nvdimm, acpi: support NFIT platform capabilities
Date: Mon, 21 May 2018 10:32:02 -0600
Message-Id: <20180521163203.26590-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
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

Add a machine command line option to allow the user to control the Platform
Capabilities Structure in the virtualized NFIT.  This Platform Capabilities
Structure was added in ACPI 6.2 Errata A.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 docs/nvdimm.txt         | 27 +++++++++++++++++++++++++++
 hw/acpi/nvdimm.c        | 45 +++++++++++++++++++++++++++++++++++++++++----
 hw/i386/pc.c            | 31 +++++++++++++++++++++++++++++++
 include/hw/i386/pc.h    |  1 +
 include/hw/mem/nvdimm.h |  5 +++++
 5 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/docs/nvdimm.txt b/docs/nvdimm.txt
index e903d8bb09..8b48fb4633 100644
--- a/docs/nvdimm.txt
+++ b/docs/nvdimm.txt
@@ -153,3 +153,30 @@ guest NVDIMM region mapping structure.  This unarmed flag indicates
 guest software that this vNVDIMM device contains a region that cannot
 accept persistent writes. In result, for example, the guest Linux
 NVDIMM driver, marks such vNVDIMM device as read-only.
+
+Platform Capabilities
+---------------------
+
+ACPI 6.2 Errata A added support for a new Platform Capabilities Structure
+which allows the platform to communicate what features it supports related to
+NVDIMM data durability.  Users can provide a capabilities value to a guest via
+the optional "nvdimm-cap" machine command line option:
+
+    -machine pc,accel=kvm,nvdimm,nvdimm-cap=2
+
+This "nvdimm-cap" field is an integer, and is the combined value of the
+various capability bits defined in table 5-137 of the ACPI 6.2 Errata A spec.
+
+Here is a quick summary of the three bits that are defined as of that spec:
+
+Bit[0] - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
+Bit[1] - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
+         Note: If bit 0 is set to 1 then this bit shall be set to 1 as well.
+Bit[2] - Byte Addressable Persistent Memory Hardware Mirroring Capable.
+
+So, a "nvdimm-cap" value of 2 would mean that the platform supports Memory
+Controller Flush on Power Loss, a value of 3 would mean that the platform
+supports CPU Cache Flush and Memory Controller Flush on Power Loss, etc.
+
+For a complete list of the flags available and for more detailed descriptions,
+please consult the ACPI spec.
diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
index 59d6e4254c..87e4280c71 100644
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
@@ -351,7 +366,23 @@ static void nvdimm_build_structure_dcr(GArray *structures, DeviceState *dev)
                                          JEDEC Annex L Release 3. */);
 }
 
-static GArray *nvdimm_build_device_structure(void)
+/*
+ * ACPI 6.2 Errata A: 5.2.25.9 NVDIMM Platform Capabilities Structure
+ */
+static void
+nvdimm_build_structure_caps(GArray *structures, uint32_t capabilities)
+{
+    NvdimmNfitPlatformCaps *nfit_caps;
+
+    nfit_caps = acpi_data_push(structures, sizeof(*nfit_caps));
+
+    nfit_caps->type = cpu_to_le16(7 /* NVDIMM Platform Capabilities */);
+    nfit_caps->length = cpu_to_le16(sizeof(*nfit_caps));
+    nfit_caps->highest_cap = 31 - clz32(capabilities);
+    nfit_caps->capabilities = cpu_to_le32(capabilities);
+}
+
+static GArray *nvdimm_build_device_structure(AcpiNVDIMMState *state)
 {
     GSList *device_list = nvdimm_get_device_list();
     GArray *structures = g_array_new(false, true /* clear */, 1);
@@ -373,6 +404,10 @@ static GArray *nvdimm_build_device_structure(void)
     }
     g_slist_free(device_list);
 
+    if (state->capabilities) {
+        nvdimm_build_structure_caps(structures, state->capabilities);
+    }
+
     return structures;
 }
 
@@ -381,16 +416,18 @@ static void nvdimm_init_fit_buffer(NvdimmFitBuffer *fit_buf)
     fit_buf->fit = g_array_new(false, true /* clear */, 1);
 }
 
-static void nvdimm_build_fit_buffer(NvdimmFitBuffer *fit_buf)
+static void nvdimm_build_fit_buffer(AcpiNVDIMMState *state)
 {
+    NvdimmFitBuffer *fit_buf = &state->fit_buf;
+
     g_array_free(fit_buf->fit, true);
-    fit_buf->fit = nvdimm_build_device_structure();
+    fit_buf->fit = nvdimm_build_device_structure(state);
     fit_buf->dirty = true;
 }
 
 void nvdimm_plug(AcpiNVDIMMState *state)
 {
-    nvdimm_build_fit_buffer(&state->fit_buf);
+    nvdimm_build_fit_buffer(state);
 }
 
 static void nvdimm_build_nfit(AcpiNVDIMMState *state, GArray *table_offsets,
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index d768930d02..1b2684c549 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -2182,6 +2182,33 @@ static void pc_machine_set_nvdimm(Object *obj, bool value, Error **errp)
     pcms->acpi_nvdimm_state.is_enabled = value;
 }
 
+static void pc_machine_get_nvdimm_capabilities(Object *obj, Visitor *v,
+                                               const char *name, void *opaque,
+                                               Error **errp)
+{
+    PCMachineState *pcms = PC_MACHINE(obj);
+    uint32_t value = pcms->acpi_nvdimm_state.capabilities;
+
+    visit_type_uint32(v, name, &value, errp);
+}
+
+static void pc_machine_set_nvdimm_capabilities(Object *obj, Visitor *v,
+                                               const char *name, void *opaque,
+                                               Error **errp)
+{
+    PCMachineState *pcms = PC_MACHINE(obj);
+    Error *error = NULL;
+    uint32_t value;
+
+    visit_type_uint32(v, name, &value, &error);
+    if (error) {
+        error_propagate(errp, error);
+        return;
+    }
+
+    pcms->acpi_nvdimm_state.capabilities = value;
+}
+
 static bool pc_machine_get_smbus(Object *obj, Error **errp)
 {
     PCMachineState *pcms = PC_MACHINE(obj);
@@ -2395,6 +2422,10 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     object_class_property_add_bool(oc, PC_MACHINE_NVDIMM,
         pc_machine_get_nvdimm, pc_machine_set_nvdimm, &error_abort);
 
+    object_class_property_add(oc, PC_MACHINE_NVDIMM_CAP, "uint32",
+        pc_machine_get_nvdimm_capabilities,
+        pc_machine_set_nvdimm_capabilities, NULL, NULL, &error_abort);
+
     object_class_property_add_bool(oc, PC_MACHINE_SMBUS,
         pc_machine_get_smbus, pc_machine_set_smbus, &error_abort);
 
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 2a98e3ad68..e9b22f929c 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -76,6 +76,7 @@ struct PCMachineState {
 #define PC_MACHINE_VMPORT           "vmport"
 #define PC_MACHINE_SMM              "smm"
 #define PC_MACHINE_NVDIMM           "nvdimm"
+#define PC_MACHINE_NVDIMM_CAP       "nvdimm-cap"
 #define PC_MACHINE_SMBUS            "smbus"
 #define PC_MACHINE_SATA             "sata"
 #define PC_MACHINE_PIT              "pit"
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index 74c60332e1..3c82751bab 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -134,6 +134,11 @@ struct AcpiNVDIMMState {
 
     /* the IO region used by OSPM to transfer control to QEMU. */
     MemoryRegion io_mr;
+
+    /*
+     * Platform capabilities, section 5.2.25.9 of ACPI 6.2 Errata A
+     */
+    int32_t capabilities;
 };
 typedef struct AcpiNVDIMMState AcpiNVDIMMState;
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
