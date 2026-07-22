Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1723EC2EA
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 04:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784693903; cv=none; b=MFM8nb8UZtIqdyoECaHUJ8Bn3zwTQDdtXvzEYcx7QxUDP9D5HHwUBuQUjRJ61DPiZTE8JawPipXrBIr5+TMxvzAdWSumiJvmuUv+hayEP/ZxTIzO+XV0p6nQsgVe94tJ58RljmC4koL5gMDoPjld2vUDGBQjfTnAZCjQMV7bjM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784693903; c=relaxed/simple;
	bh=orKjr1q4HTe+iPvesztvSaXQcj6Xct3e1j/Uzr0AKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j2eSqb/aXaZgF/Y6oWL4ORX+NnTm+Crpjfd/soMytWp2CVnOYWxOmrNHJnW5Rx+Lh/wRcL5VaPA54mPl2H08uAlCeTsh62UIf8e/S0b3N4tkTI6ljC8niAxqhVt3XaI++vnnFAx6tZ7sHUAVYGBEXTI4pMqJeSwNGjmYpFO/Jik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowABXiEKIRGBq6ze7AA--.34712S2;
	Wed, 22 Jul 2026 12:18:16 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] ACPI: NFIT: validate subtable extents before parsing
Date: Wed, 22 Jul 2026 12:17:01 +0800
Message-ID: <20260722041701.21078-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXiEKIRGBq6ze7AA--.34712S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCFWxKr43GF4rtrykKF47CFg_yoW5KF1rpF
	48Ka43tws5Gr47tws3Jw4rtr15Aa9ayFy7XrW8G343Cw4fuw4UKF1rKa4Yqas8Jr93uw43
	ZF4vya45CF4kZr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9S14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F
	4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JV
	W5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr
	1UYxBIdaVFxhVjvjDU0xZFpf9x0JUDOz3UUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

add_table() reads an NFIT subtable header after checking only that the
cursor is before the end of the table. It then advances by the advertised
subtable length without proving that either the header or the full
subtable is present.

The interleave and flush helpers also derive copy lengths from entry
counts without ensuring those arrays fit in the current subtable.

Validate the fixed header and advertised length before dispatch. Ensure
the variable interleave and flush arrays fit their subtables, and prove the
SPA flags and capabilities fields are present before reading them. Reject a
capability index that cannot be represented by the 32-bit capability mask.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cb771d9cadb2a..711ab639cb147 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -705,6 +705,10 @@ int nfit_spa_type(struct acpi_nfit_system_address *spa)
 
 static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
 {
+	if (spa->header.length <
+	    offsetof(struct acpi_nfit_system_address, reserved))
+		return 0;
+
 	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
 		return sizeof(*spa);
 	return sizeof(*spa) - 8;
@@ -868,9 +872,16 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
 
 static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
 {
+	size_t size;
+
 	if (idt->header.length < sizeof(*idt))
 		return 0;
-	return sizeof(*idt) + sizeof(u32) * idt->line_count;
+
+	size = struct_size(idt, line_offset, idt->line_count);
+	if (size > idt->header.length)
+		return 0;
+
+	return size;
 }
 
 static bool add_idt(struct acpi_nfit_desc *acpi_desc,
@@ -907,9 +918,16 @@ static bool add_idt(struct acpi_nfit_desc *acpi_desc,
 
 static size_t sizeof_flush(struct acpi_nfit_flush_address *flush)
 {
+	size_t size;
+
 	if (flush->header.length < sizeof(*flush))
 		return 0;
-	return struct_size(flush, hint_address, flush->hint_count);
+
+	size = struct_size(flush, hint_address, flush->hint_count);
+	if (size > flush->header.length)
+		return 0;
+
+	return size;
 }
 
 static bool add_flush(struct acpi_nfit_desc *acpi_desc,
@@ -951,7 +969,16 @@ static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	u32 mask;
 
-	mask = (1 << (pcap->highest_capability + 1)) - 1;
+	if (pcap->header.length < sizeof(*pcap))
+		return false;
+	if (pcap->highest_capability > 31)
+		return false;
+
+	if (pcap->highest_capability == 31)
+		mask = U32_MAX;
+	else
+		mask = (1U << (pcap->highest_capability + 1)) - 1;
+
 	acpi_desc->platform_cap = pcap->capabilities & mask;
 	dev_dbg(dev, "cap: %#x\n", acpi_desc->platform_cap);
 	return true;
@@ -963,14 +990,18 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	struct acpi_nfit_header *hdr;
 	void *err = ERR_PTR(-ENOMEM);
+	size_t table_len;
 
 	if (table >= end)
 		return NULL;
+	table_len = end - table;
+	if (table_len < sizeof(*hdr))
+		return NULL;
 
 	hdr = table;
-	if (!hdr->length) {
-		dev_warn(dev, "found a zero length table '%d' parsing nfit\n",
-			hdr->type);
+	if (hdr->length < sizeof(*hdr) || hdr->length > table_len) {
+		dev_warn(dev, "invalid table length %u for type %u parsing nfit\n",
+			 hdr->length, hdr->type);
 		return NULL;
 	}
 
-- 
2.50.1 (Apple Git-155)

