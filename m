Return-Path: <owner-linux-mm@kvack.org>
Subject: [PATCH 03/15] frv: fix compiler warning from definition of __pmd()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Sep 2015 00:41:28 -0400
Message-ID: <20150923044128.36490.61862.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>
References: <20150923043737.36490.70547.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
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
index 8c97068ac8fc..688d8076a43a 100644
--- a/arch/frv/include/asm/page.h
+++ b/arch/frv/include/asm/page.h
@@ -34,7 +34,7 @@ typedef struct page *pgtable_t;
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
