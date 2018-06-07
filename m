Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27E5E2110396D
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 15:31:25 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH 4/5] machine: fix some misspelled words
Date: Thu,  7 Jun 2018 16:31:10 -0600
Message-Id: <20180607223111.27792-4-ross.zwisler@linux.intel.com>
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

Normally this might not be worth fixing, but several of these are strings
which are displayed to users.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 hw/core/machine.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 617e5f8d75..a21269fa39 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -609,7 +609,7 @@ static void machine_class_init(ObjectClass *oc, void *data)
         machine_get_igd_gfx_passthru, machine_set_igd_gfx_passthru,
         &error_abort);
     object_class_property_set_description(oc, "igd-passthru",
-        "Set on/off to enable/disable igd passthrou", &error_abort);
+        "Set on/off to enable/disable igd passthru", &error_abort);
 
     object_class_property_add_str(oc, "firmware",
         machine_get_firmware, machine_set_firmware,
@@ -633,7 +633,7 @@ static void machine_class_init(ObjectClass *oc, void *data)
         machine_get_memory_encryption, machine_set_memory_encryption,
         &error_abort);
     object_class_property_set_description(oc, "memory-encryption",
-        "Set memory encyption object to use", &error_abort);
+        "Set memory encryption object to use", &error_abort);
 }
 
 static void machine_class_base_init(ObjectClass *oc, void *data)
@@ -806,7 +806,7 @@ void machine_run_board_init(MachineState *machine)
         for (i = 0; machine_class->valid_cpu_types[i]; i++) {
             if (object_class_dynamic_cast(class,
                                           machine_class->valid_cpu_types[i])) {
-                /* The user specificed CPU is in the valid field, we are
+                /* The user specified CPU is in the valid field, we are
                  * good to go.
                  */
                 break;
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
