Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6EA48167A
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634179; cv=none; b=ZWLOXn/LXQ0McY3vKUMA9KlnGsNg1n9Qh7YmdwFe6MURgFY7pQ8cfDaTs3BrWEfuOVB+BHKOIq15wX38msJ8+w52PissoDI4y71p42hl49dX4wM0I9H5KKHwTt9GdgAKJRR7+/6F0GhPJIupoM3yAmqcQHNwfnQvhqShbGPRNXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634179; c=relaxed/simple;
	bh=xdf0t7m7Bhn3KmbAQhElZb+68JO5fpEcRK1bl1cz6yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2RSlIRa3jXhhCDNDr4dAcWHE96Dvy7JM4ru7WGwNZE05995ZT4C24KPFRG4ERgrC+wcOZ+Xkw3jd+/gQgKNM4nYCWpIrbktTHe4PcRGFmgC3wpT+jXYS23NeTSToAF1A16SYcKRdijfot/F4bNwMgj0UC8lj5vaXLiH8oeqbN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAB3Se29331qEEx5BQ--.9196S2;
	Thu, 13 Aug 2026 23:16:14 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	Ross Zwisler <zwisler@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 3/5] ACPI: NFIT: validate interleave and flush array extents
Date: Thu, 13 Aug 2026 23:16:12 +0800
Message-ID: <20260813151612.21777-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3Se29331qEEx5BQ--.9196S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF45CF4xur1UurW5Zw4fZrb_yoW8ury5pF
	40gasFyr4xJr13G3y3tw4rAw45Aan3AF12yFy8Ca43A3Zakr4UGF4rKFyYqFy5Xrn3Cw43
	uF4kKa45uFWkZr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8Jw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoq2MUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

Interleave and flush subtables carry a fixed header followed by arrays
whose element counts come from firmware. sizeof_idt() and sizeof_flush()
derive the copy size from those counts but do not require the result to
fit in the subtable's advertised length.

A short subtable with a large line_count or hint_count can consequently
make add_idt() or add_flush() copy beyond the subtable. The outer NFIT
extent check cannot catch this because the following subtable bytes are
still inside the enclosing ACPI table.

Use struct_size() for both variable arrays and reject a derived size that
exceeds the current subtable.

Fixes: b94d5230d06e ("libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f68edfe64952..bf4ddc56494e 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -882,9 +882,16 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
 
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
@@ -921,9 +928,16 @@ static bool add_idt(struct acpi_nfit_desc *acpi_desc,
 
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
-- 
2.50.1 (Apple Git-155)

