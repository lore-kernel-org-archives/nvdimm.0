Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from invmail3.skhynix.com (exvmail3.skhynix.com [166.125.252.90])
 by ml01.01.org (Postfix) with ESMTP id 1B0F41A1F26
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 19:47:24 -0700 (PDT)
From: Kwangwoo Lee <kwangwoo.lee@sk.com>
Subject: [PATCH v3 2/3] arm64: mm: add mmio_flush_range() to support pmem
Date: Fri, 15 Jul 2016 11:46:21 +0900
Message-Id: <1468550782-14454-3-git-send-email-kwangwoo.lee@sk.com>
In-Reply-To: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
References: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
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
To: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Kwangwoo Lee <kwangwoo.lee@sk.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>
List-ID: <linux-nvdimm@lists.01.org>

To enable pmem in arm64, mmio_flush_range() is required to build
successfully. If NVDIMM is used as blk mode, not pmem , it is called in
acpi_nfit_blk_single_io() via nd_blk_make_request() on read with
NFIT_BLK_READ_FLUSH flag.

The function cleans and invalidates the cache lines using the argument -
addr and size. Thus, it can be mapped with __flush_dcache_area().

Signed-off-by: Kwangwoo Lee <kwangwoo.lee@sk.com>
---
 arch/arm64/Kconfig                  | 1 +
 arch/arm64/include/asm/cacheflush.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4f43622..12546ce 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -15,6 +15,7 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_MMIO_FLUSH
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 903a94f..fba18e4 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -134,6 +134,8 @@ static inline void __flush_icache_all(void)
  */
 #define flush_icache_page(vma,page)	do { } while (0)
 
+#define mmio_flush_range(addr, size)	__flush_dcache_area(addr, size)
+
 /*
  * Not required on AArch64 (PIPT or VIPT non-aliasing D-cache).
  */
-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
