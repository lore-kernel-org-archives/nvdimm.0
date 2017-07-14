Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 698F42095D2BB
 for <linux-nvdimm@lists.01.org>; Fri, 14 Jul 2017 15:11:42 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 5/6] acpi: change memory allocations to GFP_NOIO
Date: Fri, 14 Jul 2017 16:11:47 -0600
Message-Id: <20170714221148.11232-6-vishal.l.verma@intel.com>
In-Reply-To: <20170714221148.11232-1-vishal.l.verma@intel.com>
References: <20170714221148.11232-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the ACPI NFIT 'DSM' methods, acpi can be called from IO paths.
Specifically, the DSM to clear media errors is called during writes, so
that we can provide a writes-fix-errors model.

However it is easy to imagine a scenario like:
 - write through the nvdimm driver
 - acpi allocation
 - writeback, causes more IO through the nvdimm driver
 - deadlock

Making the acpi allocations GPF_NOIO would ensure that it doesn't
trigger writeback, and avoids the above deadlock.

Cc: <linux-acpi@vger.kernel.org>
Cc: <linux-nvdimm@lists.01.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 include/acpi/platform/aclinuxex.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/acpi/platform/aclinuxex.h b/include/acpi/platform/aclinuxex.h
index efdff52..9bd54ec 100644
--- a/include/acpi/platform/aclinuxex.h
+++ b/include/acpi/platform/aclinuxex.h
@@ -83,12 +83,12 @@ acpi_status acpi_os_terminate(void);
  */
 static inline void *acpi_os_allocate(acpi_size size)
 {
-	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_NOIO);
 }
 
 static inline void *acpi_os_allocate_zeroed(acpi_size size)
 {
-	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_NOIO);
 }
 
 static inline void acpi_os_free(void *memory)
@@ -99,7 +99,7 @@ static inline void acpi_os_free(void *memory)
 static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 {
 	return kmem_cache_zalloc(cache,
-				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
+				 irqs_disabled()? GFP_ATOMIC : GFP_NOIO);
 }
 
 static inline acpi_thread_id acpi_os_get_thread_id(void)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
