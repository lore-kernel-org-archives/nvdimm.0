Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 14/25] toshiba laptop: replace ioremap_cache with ioremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:39:17 -0400
Message-ID: <20150725023917.8664.5278.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Buzzard <jonathan@buzzard.org.uk>, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

With ioremap_cache being replaced with memremap there is no longer a
guarantee that a mapping will silently fall back to an uncached mapping.
Explicitly use a vanilla ioremap() for this short lived mapping.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Buzzard <jonathan@buzzard.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/char/toshiba.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/toshiba.c b/drivers/char/toshiba.c
index 014c9d90d297..f5a45d887a37 100644
--- a/drivers/char/toshiba.c
+++ b/drivers/char/toshiba.c
@@ -430,7 +430,7 @@ static int tosh_probe(void)
 	int i,major,minor,day,year,month,flag;
 	unsigned char signature[7] = { 0x54,0x4f,0x53,0x48,0x49,0x42,0x41 };
 	SMMRegisters regs;
-	void __iomem *bios = ioremap_cache(0xf0000, 0x10000);
+	void __iomem *bios = ioremap(0xf0000, 0x10000);
 
 	if (!bios)
 		return -ENOMEM;

