Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B4B68211280F3
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 15:31:25 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH 5/5] nvdimm: make persistence option symbolic
Date: Thu,  7 Jun 2018 16:31:11 -0600
Message-Id: <20180607223111.27792-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Replace the "nvdimm-cap" option which took numeric arguments such as "2"
with a more user friendly "nvdimm-persistence" option which takes symbolic
arguments "cpu" or "mem-ctrl".

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
---
 docs/nvdimm.txt          | 31 ++++++++++++-------------------
 hw/acpi/nvdimm.c         |  4 ++--
 hw/i386/pc.c             | 35 +++++++++++++++++------------------
 include/hw/i386/pc.h     |  2 +-
 include/hw/mem/nvdimm.h  |  3 ++-
 tests/bios-tables-test.c |  2 +-
 6 files changed, 35 insertions(+), 42 deletions(-)

diff --git a/docs/nvdimm.txt b/docs/nvdimm.txt
index 8b48fb4633..24b443b655 100644
--- a/docs/nvdimm.txt
+++ b/docs/nvdimm.txt
@@ -154,29 +154,22 @@ guest software that this vNVDIMM device contains a region that cannot
 accept persistent writes. In result, for example, the guest Linux
 NVDIMM driver, marks such vNVDIMM device as read-only.
 
-Platform Capabilities
----------------------
+NVDIMM Persistence
+------------------
 
 ACPI 6.2 Errata A added support for a new Platform Capabilities Structure
 which allows the platform to communicate what features it supports related to
-NVDIMM data durability.  Users can provide a capabilities value to a guest via
-the optional "nvdimm-cap" machine command line option:
+NVDIMM data persistence.  Users can provide a persistence value to a guest via
+the optional "nvdimm-persistence" machine command line option:
 
-    -machine pc,accel=kvm,nvdimm,nvdimm-cap=2
+    -machine pc,accel=kvm,nvdimm,nvdimm-persistence=cpu
 
-This "nvdimm-cap" field is an integer, and is the combined value of the
-various capability bits defined in table 5-137 of the ACPI 6.2 Errata A spec.
+There are currently two valid values for this option:
 
-Here is a quick summary of the three bits that are defined as of that spec:
+"mem-ctrl" - The platform supports flushing dirty data from the memory
+             controller to the NVDIMMs in the event of power loss.
 
-Bit[0] - CPU Cache Flush to NVDIMM Durability on Power Loss Capable.
-Bit[1] - Memory Controller Flush to NVDIMM Durability on Power Loss Capable.
-         Note: If bit 0 is set to 1 then this bit shall be set to 1 as well.
-Bit[2] - Byte Addressable Persistent Memory Hardware Mirroring Capable.
-
-So, a "nvdimm-cap" value of 2 would mean that the platform supports Memory
-Controller Flush on Power Loss, a value of 3 would mean that the platform
-supports CPU Cache Flush and Memory Controller Flush on Power Loss, etc.
-
-For a complete list of the flags available and for more detailed descriptions,
-please consult the ACPI spec.
+"cpu"      - The platform supports flushing dirty data from the CPU cache to
+             the NVDIMMs in the event of power loss.  This implies that the
+             platform also supports flushing dirty data through the memory
+             controller on power loss.
diff --git a/hw/acpi/nvdimm.c b/hw/acpi/nvdimm.c
index 87e4280c71..27eeb6609f 100644
--- a/hw/acpi/nvdimm.c
+++ b/hw/acpi/nvdimm.c
@@ -404,8 +404,8 @@ static GArray *nvdimm_build_device_structure(AcpiNVDIMMState *state)
     }
     g_slist_free(device_list);
 
-    if (state->capabilities) {
-        nvdimm_build_structure_caps(structures, state->capabilities);
+    if (state->persistence) {
+        nvdimm_build_structure_caps(structures, state->persistence);
     }
 
     return structures;
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index f3befe6721..5bba9dcf5a 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -2181,31 +2181,30 @@ static void pc_machine_set_nvdimm(Object *obj, bool value, Error **errp)
     pcms->acpi_nvdimm_state.is_enabled = value;
 }
 
-static void pc_machine_get_nvdimm_capabilities(Object *obj, Visitor *v,
-                                               const char *name, void *opaque,
-                                               Error **errp)
+static char *pc_machine_get_nvdimm_persistence(Object *obj, Error **errp)
 {
     PCMachineState *pcms = PC_MACHINE(obj);
-    uint32_t value = pcms->acpi_nvdimm_state.capabilities;
 
-    visit_type_uint32(v, name, &value, errp);
+    return g_strdup(pcms->acpi_nvdimm_state.persistence_string);
 }
 
-static void pc_machine_set_nvdimm_capabilities(Object *obj, Visitor *v,
-                                               const char *name, void *opaque,
+static void pc_machine_set_nvdimm_persistence(Object *obj, const char *value,
                                                Error **errp)
 {
     PCMachineState *pcms = PC_MACHINE(obj);
-    Error *error = NULL;
-    uint32_t value;
-
-    visit_type_uint32(v, name, &value, &error);
-    if (error) {
-        error_propagate(errp, error);
-        return;
+    AcpiNVDIMMState *nvdimm_state = &pcms->acpi_nvdimm_state;
+
+    if (strcmp(value, "cpu") == 0)
+        nvdimm_state->persistence = 3;
+    else if (strcmp(value, "mem-ctrl") == 0)
+        nvdimm_state->persistence = 2;
+    else {
+        error_report("-machine nvdimm-persistence=%s: unsupported option", value);
+        exit(EXIT_FAILURE);
     }
 
-    pcms->acpi_nvdimm_state.capabilities = value;
+    g_free(nvdimm_state->persistence_string);
+    nvdimm_state->persistence_string = g_strdup(value);
 }
 
 static bool pc_machine_get_smbus(Object *obj, Error **errp)
@@ -2421,9 +2420,9 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
     object_class_property_add_bool(oc, PC_MACHINE_NVDIMM,
         pc_machine_get_nvdimm, pc_machine_set_nvdimm, &error_abort);
 
-    object_class_property_add(oc, PC_MACHINE_NVDIMM_CAP, "uint32",
-        pc_machine_get_nvdimm_capabilities,
-        pc_machine_set_nvdimm_capabilities, NULL, NULL, &error_abort);
+    object_class_property_add_str(oc, PC_MACHINE_NVDIMM_PERSIST,
+        pc_machine_get_nvdimm_persistence,
+        pc_machine_set_nvdimm_persistence, &error_abort);
 
     object_class_property_add_bool(oc, PC_MACHINE_SMBUS,
         pc_machine_get_smbus, pc_machine_set_smbus, &error_abort);
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 04d1f8c6c3..fc8dedca12 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -76,7 +76,7 @@ struct PCMachineState {
 #define PC_MACHINE_VMPORT           "vmport"
 #define PC_MACHINE_SMM              "smm"
 #define PC_MACHINE_NVDIMM           "nvdimm"
-#define PC_MACHINE_NVDIMM_CAP       "nvdimm-cap"
+#define PC_MACHINE_NVDIMM_PERSIST   "nvdimm-persistence"
 #define PC_MACHINE_SMBUS            "smbus"
 #define PC_MACHINE_SATA             "sata"
 #define PC_MACHINE_PIT              "pit"
diff --git a/include/hw/mem/nvdimm.h b/include/hw/mem/nvdimm.h
index 3c82751bab..9340631cfc 100644
--- a/include/hw/mem/nvdimm.h
+++ b/include/hw/mem/nvdimm.h
@@ -138,7 +138,8 @@ struct AcpiNVDIMMState {
     /*
      * Platform capabilities, section 5.2.25.9 of ACPI 6.2 Errata A
      */
-    int32_t capabilities;
+    int32_t persistence;
+    char    *persistence_string;
 };
 typedef struct AcpiNVDIMMState AcpiNVDIMMState;
 
diff --git a/tests/bios-tables-test.c b/tests/bios-tables-test.c
index 9b5db1ee8f..b95d56aa4e 100644
--- a/tests/bios-tables-test.c
+++ b/tests/bios-tables-test.c
@@ -831,7 +831,7 @@ static void test_acpi_tcg_dimm_pxm(const char *machine)
     memset(&data, 0, sizeof(data));
     data.machine = machine;
     data.variant = ".dimmpxm";
-    test_acpi_one(" -machine nvdimm=on,nvdimm-cap=3"
+    test_acpi_one(" -machine nvdimm=on,nvdimm-persistence=cpu"
                   " -smp 4,sockets=4"
                   " -m 128M,slots=3,maxmem=1G"
                   " -numa node,mem=32M,nodeid=0"
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
