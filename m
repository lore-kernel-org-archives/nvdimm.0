Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B8DE802B3
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 14:18:19 -0800 (PST)
Subject: [PATCH] x86,
 mm: fix NOHIGHMEM && X86_PAE build config for native_pud_clear()
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 15:18:18 -0700
Message-ID: <148883869853.70777.12180810304957921737.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: akpm@linux-foundation.org
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, jack@suse.com, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Looks like a 32bit x86 build failure case where X86_PAE and NOHIMEM
are on. This was reported by kbuild test bot.

   In file included from include/linux/mm.h:68:0,
                    from include/linux/highmem.h:7,
                    from include/linux/bio.h:21,
                    from include/linux/writeback.h:205,
                    from include/linux/memcontrol.h:30,
                    from include/linux/swap.h:8,
                    from include/linux/suspend.h:4,
                    from arch/x86/kernel/asm-offsets.c:12:
   arch/x86/include/asm/pgtable.h: In function 'native_local_pudp_get_and_clear':
>> arch/x86/include/asm/pgtable.h:888:2: error: implicit declaration of function 'native_pud_clear' [-Werror=implicit-function-declaration]
     native_pud_clear(pudp);
     ^~~~~~~~~~~~~~~~

Fixes: a00cc7d9dd93d ("mm, x86: add support for PUD-sized transparent
hugepages")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 arch/x86/include/asm/pgtable-3level.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 72277b1..d337738 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -121,8 +121,9 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	*(tmp + 1) = 0;
 }
 
-#if !defined(CONFIG_SMP) || (defined(CONFIG_HIGHMEM64G) && \
-		defined(CONFIG_PARAVIRT))
+#if !defined(CONFIG_SMP) || \
+	(defined(CONFIG_HIGHMEM64G) && defined(CONFIG_PARAVIRT)) || \
+	(defined(CONFIG_NOHIGHMEM) && defined(CONFIG_X86_PAE))
 static inline void native_pud_clear(pud_t *pudp)
 {
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
