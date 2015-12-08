Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH -mm 15/25] frv: fix compiler warning from definition of
 __pmd()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 07 Dec 2015 17:33:55 -0800
Message-ID: <20151208013355.25030.47151.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151208013236.25030.68781.stgit@dwillia2-desk3.jf.intel.com>
References: <20151208013236.25030.68781.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Take into account that the pmd_t type is a array inside a struct, so it
needs two levels of brackets to initialize.  Otherwise, a usage of __pmd
generates a warning:

include/linux/mm.h:986:2: warning: missing braces around initializer [-Wmissing-braces]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/frv/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/frv/include/asm/page.h b/arch/frv/include/asm/page.h
index 52ace96a4f55..ec5eebce4fb3 100644
--- a/arch/frv/include/asm/page.h
+++ b/arch/frv/include/asm/page.h
@@ -31,7 +31,7 @@ typedef struct page *pgtable_t;
 #define pgprot_val(x)	((x).pgprot)
 
 #define __pte(x)	((pte_t) { (x) } )
-#define __pmd(x)	((pmd_t) { (x) } )
+#define __pmd(x)	((pmd_t) { { (x) } } )
 #define __pud(x)	((pud_t) { (x) } )
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
