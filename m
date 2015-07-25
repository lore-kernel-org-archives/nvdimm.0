Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 20/25] sfi: switch from ioremap_cache to memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:50 -0400
Message-ID: <20150725023950.8664.40556.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for deprecating ioremap_cache() convert its usage in sfi
to memremap.  It's a bit awkward that we go and add back a fake __iomem
annotation, but this is to keep consistency with early_ioremap() which
does not have a 'memremap' flavor.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/sfi/sfi_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 296db7a69c27..1cccf31dfccc 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -101,7 +101,7 @@ static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
 		return NULL;
 
 	if (sfi_use_ioremap)
-		return ioremap_cache(phys, size);
+		return (void __iomem *) memremap(phys, size, MEMREMAP_CACHE);
 	else
 		return early_ioremap(phys, size);
 }
@@ -112,7 +112,7 @@ static void __ref sfi_unmap_memory(void __iomem *virt, u32 size)
 		return;
 
 	if (sfi_use_ioremap)
-		iounmap(virt);
+		memunmap((void __force *) virt);
 	else
 		early_iounmap(virt, size);
 }

