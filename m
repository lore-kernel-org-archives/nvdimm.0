Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/6] nfit: Fix up address spaces, sparse warnings
Date: Thu, 28 May 2015 16:35:49 -0600
Message-Id: <1432852553-24865-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-ID: <linux-nvdimm@lists.01.org>

Fix a couple of sparse warnings (duplicate const, incorrect address
space), and go back to using memcpy() instead of memcpy_toio() and
memcpy_fromio() when talking to our block apertures.  Instead, include a
union to alias mmio->base and mmio->aperture so that we can continue to
reuse common code for ioremapping and deinterleaving.  mmio->base still
has the __iomem annotation and is used via readq() and writeq() for the
control and status registers.  mmio->aperture is used via normal
memcpy() for aperture I/O.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/nfit.c | 10 +++++-----
 drivers/acpi/nfit.h |  5 ++++-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 34f879808ada..df14652ea13e 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -60,7 +60,7 @@ static int acpi_nfit_ctl(struct nd_bus_descriptor *nd_desc,
 		unsigned int buf_len)
 {
 	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
-	const struct nd_cmd_desc const *desc = NULL;
+	const struct nd_cmd_desc *desc = NULL;
 	union acpi_object in_obj, in_buf, *out_obj;
 	struct device *dev = acpi_desc->dev;
 	const char *cmd_name, *dimm_name;
@@ -895,7 +895,7 @@ static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
 
 static u64 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
-	struct nfit_blk_mmio __iomem *mmio = &nfit_blk->mmio[DCR];
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
 	u64 offset = nfit_blk->stat_offset + mmio->size * bw;
 
 	if (mmio->num_lines)
@@ -908,7 +908,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 		resource_size_t dpa, unsigned int len, unsigned int write)
 {
 	u64 cmd, offset;
-	struct nfit_blk_mmio __iomem *mmio = &nfit_blk->mmio[DCR];
+	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
 
 	enum {
 		BCW_OFFSET_MASK = (1ULL << 48)-1,
@@ -959,9 +959,9 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk, void *iobuf,
 		}
 
 		if (write)
-			memcpy_fromio(mmio->base + offset, iobuf + copied, c);
+			memcpy(mmio->aperture + offset, iobuf + copied, c);
 		else
-			memcpy_toio(iobuf + copied, mmio->base + offset, c);
+			memcpy(iobuf + copied, mmio->aperture + offset, c);
 
 		copied += c;
 		len -= c;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index e462214f94cd..b882a22ee7bb 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -115,7 +115,10 @@ enum nd_blk_mmio_selector {
 
 struct nfit_blk {
 	struct nfit_blk_mmio {
-		void __iomem *base;
+		union {
+			void __iomem *base;
+			void *aperture;
+		};
 		u64 size;
 		u64 base_offset;
 		u32 line_size;
-- 
1.9.3

