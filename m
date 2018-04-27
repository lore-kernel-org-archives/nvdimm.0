Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F21C22034C8AD
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 14:53:53 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] nvdimm: platform capabilities command line option
Date: Fri, 27 Apr 2018 15:53:14 -0600
Message-Id: <20180427215314.23168-3-ross.zwisler@linux.intel.com>
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

Add a device command line option to allow the user to control the Platform
Capabilities Structure in the virtualized NFIT.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 docs/nvdimm.txt         | 22 ++++++++++++++++++++++
 hw/acpi/nvdimm.c        | 29 +++++++++++++++++++++++++----
 hw/mem/nvdimm.c         | 28 ++++++++++++++++++++++++++++
 include/hw/mem/nvdimm.h |  6 ++++++
 4 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/docs/nvdimm.txt b/docs/nvdimm.txt
index e903d8bb09..13a2c15b70 100644
--- a/docs/nvdimm.txt
+++ b/docs/nvdimm.txt
@@ -153,3 +153,25 @@ guest NVDIMM region mapping structure.  This unarmed flag indicates
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
+the optional "cap" device command line option:
+
+ -device nvdimm,id=nvdimm1,memdev=mem1,cap=3
+
+As of ACPI 6.2 Errata A, the following values are valid for the bottom two
+bits:
+
+2 - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
+3 - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
+
+For a complete list of the flags available please consult the ACPI spec.
+
+These platform capabilities apply to the entire virtual platform, so it is
+recommended that only one "cap" device command option be given per virtual
+machine.  This value will apply to all NVDIMMs in the virtual platform.
diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
index 859b390e07..375237c96c 100644
--- a/hw/acpi/nvdimm.c
+++ b/hw/acpi/nvdimm.c
@@ -370,7 +370,7 @@ static void nvdimm_build_structure_dcr(GArray *structures, DeviceState *dev)
  * ACPI 6.2 Errata A: 5.2.25.9 NVDIMM Platform Capabilities Structure
  */
 static void
-nvdimm_build_structure_caps(GArray *structures)
+nvdimm_build_structure_caps(GArray *structures, uint32_t capabilities)
 {
     NvdimmNfitPlatformCaps *nfit_caps;
 
@@ -378,13 +378,31 @@ nvdimm_build_structure_caps(GArray *structures)
 
     nfit_caps->type = cpu_to_le16(7 /* NVDIMM Platform Capabilities */);
     nfit_caps->length = cpu_to_le16(sizeof(*nfit_caps));
-    nfit_caps->highest_cap = 1;
-    nfit_caps->capabilities = cpu_to_le32(2 /* memory controller */);
+    nfit_caps->highest_cap = 2;
+    nfit_caps->capabilities = cpu_to_le32(capabilities);
 }
+
+static uint32_t nvdimm_get_capabilities(DeviceState *dev)
+{
+    static uint32_t capabilities = 0;
+    uint32_t this_cap = object_property_get_uint(OBJECT(dev),
+                                            NVDIMM_CAPABILITIES_PROP, NULL);
+
+    if (this_cap && !capabilities)
+        capabilities = this_cap;
+
+    if (this_cap && this_cap != capabilities)
+        nvdimm_debug("WARNING: multiple capabilities (%d and %d) defined\n",
+                this_cap, capabilities);
+
+    return capabilities;
+}
+
 static GArray *nvdimm_build_device_structure(void)
 {
     GSList *device_list = nvdimm_get_device_list();
     GArray *structures = g_array_new(false, true /* clear */, 1);
+    uint32_t capabilities = 0;
 
     for (; device_list; device_list = device_list->next) {
         DeviceState *dev = device_list->data;
@@ -400,10 +418,13 @@ static GArray *nvdimm_build_device_structure(void)
 
         /* build NVDIMM Control Region Structure. */
         nvdimm_build_structure_dcr(structures, dev);
+
+        capabilities = nvdimm_get_capabilities(dev);
     }
     g_slist_free(device_list);
 
-    nvdimm_build_structure_caps(structures);
+    if (capabilities)
+        nvdimm_build_structure_caps(structures, capabilities);
 
     return structures;
 }
diff --git a/hw/mem/nvdimm.c b/hw/mem/nvdimm.c
index 4087aca25e..923364e190 100644
--- a/hw/mem/nvdimm.c
+++ b/hw/mem/nvdimm.c
@@ -87,6 +87,31 @@ static void nvdimm_set_unarmed(Object *obj, bool value, Error **errp)
     error_propagate(errp, local_err);
 }
 
+static void nvdimm_get_capabilities(Object *obj, Visitor *v, const char *name,
+                                  void *opaque, Error **errp)
+{
+    NVDIMMDevice *nvdimm = NVDIMM(obj);
+    uint32_t value = nvdimm->capabilities;
+
+    visit_type_uint32(v, name, &value, errp);
+}
+
+static void nvdimm_set_capabilities(Object *obj, Visitor *v, const char *name,
+                                  void *opaque, Error **errp)
+{
+    NVDIMMDevice *nvdimm = NVDIMM(obj);
+    Error *local_err = NULL;
+    uint32_t value;
+
+    visit_type_uint32(v, name, &value, &local_err);
+    if (local_err)
+        goto out;
+
+    nvdimm->capabilities = value;
+out:
+    error_propagate(errp, local_err);
+}
+
 static void nvdimm_init(Object *obj)
 {
     object_property_add(obj, NVDIMM_LABEL_SIZE_PROP, "int",
@@ -94,6 +119,9 @@ static void nvdimm_init(Object *obj)
                         NULL, NULL);
     object_property_add_bool(obj, NVDIMM_UNARMED_PROP,
                              nvdimm_get_unarmed, nvdimm_set_unarmed, NULL);
+    object_property_add(obj, NVDIMM_CAPABILITIES_PROP, "uint32",
+                        nvdimm_get_capabilities, nvdimm_set_capabilities,
+                        NULL, NULL, NULL);
 }
 
 static MemoryRegion *nvdimm_get_memory_region(PCDIMMDevice *dimm, Error **errp)
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index 74c60332e1..68af64ff46 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -50,6 +50,7 @@
 
 #define NVDIMM_LABEL_SIZE_PROP "label-size"
 #define NVDIMM_UNARMED_PROP    "unarmed"
+#define NVDIMM_CAPABILITIES_PROP "cap"
 
 struct NVDIMMDevice {
     /* private */
@@ -83,6 +84,11 @@ struct NVDIMMDevice {
      * the guest write persistence.
      */
     bool unarmed;
+
+    /*
+     * Platform capabilities, section 5.2.25.9 of ACPI 6.2 Errata A
+     */
+    uint32_t capabilities;
 };
 typedef struct NVDIMMDevice NVDIMMDevice;
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
