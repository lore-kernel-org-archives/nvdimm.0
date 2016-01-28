Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/2] pmem: Flush cache on unaligned request
Date: Thu, 28 Jan 2016 11:12:50 -0700
Message-Id: <1454004770-6318-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
References: <1454004770-6318-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@suse.de, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, vishal.l.verma@intel.com, micah.parrish@hpe.com, brian.boylston@hpe.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

arch_memcpy_to_pmem() calls __copy_user_nocache() to copy data
via non-temporal stores.  However, __copy_user_nocache() still
performs cached copy when a request is not naturally aligned or
is less then 4 bytes.

Call clflush_cache_range() to flush destination when a request
leads to cached copy.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/include/asm/pmem.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index c57fd1e..f135064 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -45,6 +45,17 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
 				__func__, dst, src, unwritten))
 		BUG();
+
+	/*
+	 * Flush the caches when the request is not naturally aligned.
+	 * Non-temporal stores are not used for unaligned copy.
+	 */
+	if (((n >= 8) &&
+		(!IS_ALIGNED((unsigned long)dst, 8) || !IS_ALIGNED(n, 8))) ||
+	    ((n <  8) &&
+		(!IS_ALIGNED((unsigned long)dst, 4) || (n != 4)))) {
+		clflush_cache_range(dst, n);
+	}
 }
 
 /**
