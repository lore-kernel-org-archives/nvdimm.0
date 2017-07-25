Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 0C47421C91254
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 03:54:09 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 1/6] arm64: mm: Fix set_memory_valid() declaration
Date: Tue, 25 Jul 2017 11:55:38 +0100
Message-Id: <a7b0cd687d7d2ee9315db4fc9a86b8dff2892875.1500397441.git.robin.murphy@arm.com>
In-Reply-To: <cover.1500397441.git.robin.murphy@arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
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
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Clearly, set_memory_valid() has never been seen in the same room as its
declaration... Whilst the type mismatch is such that kexec probably
wasn't broken in practice, fix it to match the definition as it should.

Fixes: 9b0aa14e3155 ("arm64: mm: add set_memory_valid()")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/arm64/include/asm/cacheflush.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index d74a284abdc2..4d4f650c290e 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -150,6 +150,6 @@ static inline void flush_cache_vunmap(unsigned long start, unsigned long end)
 {
 }
 
-int set_memory_valid(unsigned long addr, unsigned long size, int enable);
+int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 #endif
-- 
2.12.2.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
