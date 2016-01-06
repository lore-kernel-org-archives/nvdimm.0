Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v5 1/6] ACPI / util: Fix acpi_evaluate_dsm() argument type
Date: Wed,  6 Jan 2016 16:03:38 -0700
Message-Id: <37cf7fc6c93496b84fa3984d94d689d8337a176b.1452121277.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1452121277.git.jerry.hoemann@hpe.com>
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1452121277.git.jerry.hoemann@hpe.com>
References: <cover.1452121277.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

The ACPI spec speicifies that arguments "Revision ID" and
"Function Index" to a _DSM are type "Integer."  Type Integers
are 64 bit quantities.

The function evaluate_dsm specifies these types as simple "int"
which are 32 bits.  Correct type passed to acpi_evaluate_dsm
and its callers and derived callers to pass correct type.

acpi_check_dsm and acpi_evaluate_dsm_typed had similar issue
and were corrected as well.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/acpi/utils.c    | 4 ++--
 include/acpi/acpi_bus.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 475c907..049cba4 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -628,7 +628,7 @@ acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
  * some old BIOSes do expect a buffer or an integer etc.
  */
 union acpi_object *
-acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, int rev, int func,
+acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 func,
 		  union acpi_object *argv4)
 {
 	acpi_status ret;
@@ -677,7 +677,7 @@ EXPORT_SYMBOL(acpi_evaluate_dsm);
  * functions. Currently only support 64 functions at maximum, should be
  * enough for now.
  */
-bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs)
+bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs)
 {
 	int i;
 	u64 mask = 0;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index ad0a5ff..8e6abcf 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -61,12 +61,12 @@ bool acpi_ata_match(acpi_handle handle);
 bool acpi_bay_match(acpi_handle handle);
 bool acpi_dock_match(acpi_handle handle);
 
-bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs);
+bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs);
 union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid,
-			int rev, int func, union acpi_object *argv4);
+			u64 rev, u64 func, union acpi_object *argv4);
 
 static inline union acpi_object *
-acpi_evaluate_dsm_typed(acpi_handle handle, const u8 *uuid, int rev, int func,
+acpi_evaluate_dsm_typed(acpi_handle handle, const u8 *uuid, u64 rev, u64 func,
 			union acpi_object *argv4, acpi_object_type type)
 {
 	union acpi_object *obj;
-- 
1.7.11.3

