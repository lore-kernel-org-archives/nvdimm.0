Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6216.austin.hp.com (g1t6216.austin.hp.com [15.73.96.123])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74DA71A1F7F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:17:01 -0800 (PST)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v6 1/8] ACPI / util: Fix acpi_evaluate_dsm() argument type
Date: Fri, 11 Mar 2016 14:16:25 -0700
Message-Id: <4ba7d479bbdca8f70a58b5bea882410eb25c6246.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1457730736.git.jerry.hoemann@hpe.com>
References: <cover.1457730736.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
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
index f2f9873..87bd54d 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -629,7 +629,7 @@ acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
  * some old BIOSes do expect a buffer or an integer etc.
  */
 union acpi_object *
-acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, int rev, int func,
+acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 func,
 		  union acpi_object *argv4)
 {
 	acpi_status ret;
@@ -678,7 +678,7 @@ EXPORT_SYMBOL(acpi_evaluate_dsm);
  * functions. Currently only support 64 functions at maximum, should be
  * enough for now.
  */
-bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs)
+bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, u64 rev, u64 funcs)
 {
 	int i;
 	u64 mask = 0;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 14362a8..f092cc6 100644
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
