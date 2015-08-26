Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2]: acpica/nfit: Rename not-armed bit definition
Date: Wed, 26 Aug 2015 10:20:24 -0600
Message-Id: <1440606024-29873-3-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com, rafael.j.wysocki@intel.com
Cc: robert.moore@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, elliott@hp.com, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
bit 3 as follows.

  Bit [3] set to 1 to indicate that the Memory Device is observed
  to be not armed prior to OSPM hand off. A Memory Device is
  considered armed if it is able to accept persistent writes.

This bit is currently defined as ACPI_NFIT_MEM_ARMED, which can be
confusing as if the Memory Device is armed when this bit is set.

Change the name to ACPI_NFIT_MEM_NOT_ARMED per the spec.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/nfit.c              |    6 +++---
 drivers/acpi/nfit.h              |    2 +-
 include/acpi/actbl1.h            |    2 +-
 tools/testing/nvdimm/test/nfit.c |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 6993ff2..1eb3654 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -705,7 +705,7 @@ static ssize_t flags_show(struct device *dev,
 		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
 		flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail " : "",
 		flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
-		flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "",
+		flags & ACPI_NFIT_MEM_NOT_ARMED ? "not_arm " : "",
 		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "",
 		flags & ACPI_NFIT_MEM_HEALTH_ENABLED ? "notify_enabled " : "");
 }
@@ -815,7 +815,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 			flags |= NDD_ALIASING;
 
 		mem_flags = __to_nfit_memdev(nfit_mem)->flags;
-		if (mem_flags & ACPI_NFIT_MEM_ARMED)
+		if (mem_flags & ACPI_NFIT_MEM_NOT_ARMED)
 			flags |= NDD_UNARMED;
 
 		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
@@ -839,7 +839,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
 		  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail ":"",
 		  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
-		  mem_flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "");
+		  mem_flags & ACPI_NFIT_MEM_NOT_ARMED ? "not_arm " : "");
 
 	}
 
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index f2c2bb7..de4a00d 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -24,7 +24,7 @@
 #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
 #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
 		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
-		| ACPI_NFIT_MEM_ARMED)
+		| ACPI_NFIT_MEM_NOT_ARMED)
 
 enum nfit_uuids {
 	NFIT_SPA_VOLATILE,
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index fcd5709..238754e 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -1012,7 +1012,7 @@ struct acpi_nfit_memory_map {
 #define ACPI_NFIT_MEM_SAVE_FAILED       (1)	/* 00: Last SAVE to Memory Device failed */
 #define ACPI_NFIT_MEM_RESTORE_FAILED    (1<<1)	/* 01: Last RESTORE from Memory Device failed */
 #define ACPI_NFIT_MEM_FLUSH_FAILED      (1<<2)	/* 02: Platform flush failed */
-#define ACPI_NFIT_MEM_ARMED             (1<<3)	/* 03: Memory Device observed to be not armed */
+#define ACPI_NFIT_MEM_NOT_ARMED         (1<<3)	/* 03: Memory Device observed to be not armed */
 #define ACPI_NFIT_MEM_HEALTH_OBSERVED   (1<<4)	/* 04: Memory Device observed SMART/health events */
 #define ACPI_NFIT_MEM_HEALTH_ENABLED    (1<<5)	/* 05: SMART/health events enabled */
 
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 28dba91..9495249 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -998,7 +998,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 	memdev->interleave_ways = 1;
 	memdev->flags = ACPI_NFIT_MEM_SAVE_FAILED | ACPI_NFIT_MEM_RESTORE_FAILED
 		| ACPI_NFIT_MEM_FLUSH_FAILED | ACPI_NFIT_MEM_HEALTH_OBSERVED
-		| ACPI_NFIT_MEM_ARMED;
+		| ACPI_NFIT_MEM_NOT_ARMED;
 
 	offset += sizeof(*memdev);
 	/* dcr-descriptor0 */
