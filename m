Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B248167A
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634442; cv=none; b=B1liPjBDC63L73cZiy0crQfMVIEML7V0pZFTQamBJZXWU1eXGDynXTf4RCC6XEXzLEinjA/mUWAPHEUvCJqyLEyJlR5mCZGO1/ycozuflL+LkdPDl75OFKg2W01jc/CPtnov9M4NC/RhIoy0vVUQni8Ck43voqU3bSlB4y22Nj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634442; c=relaxed/simple;
	bh=I9t4BQUYK3njp/kCF9ay0weQak0qIG7++Gl7VIfpS1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSZuYN2o1ztgDMR7B645YFALGR5whKmGqEu8phk3DwFblaIjWymrgME+jbYlch/IQEu1dz6ESvbnLLBo7jE1pjG2BwAfzq5eMX0dmYrFt8yF16n5iYIByBBif+QZXPE5bg9yCPD4GsLYDScgWuakTZLuuVB3DtxRk6Rd8bX9rr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAn+ezG4H1qJHR5BQ--.54510S2;
	Thu, 13 Aug 2026 23:20:38 +0800 (CST)
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
Subject: [PATCH v2 5/5] ACPI: NFIT: bound the platform capability mask
Date: Thu, 13 Aug 2026 23:20:37 +0800
Message-ID: <20260813152037.25828-1-pengpeng@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAAn+ezG4H1qJHR5BQ--.54510S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJry7ur47GF45GF1DWw1ftFb_yoW8WF1rpr
	Z7K3W3K3ykWF4ayw4qyr40vFy5AasYvFy7GFW8W343uwnxu3WqyF1DCFyrtF1jyFnaga15
	AFZ2ya95uFWDZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

The platform capability subtable parser reads highest_capability and
capabilities without first requiring the fixed structure to be present.
It also shifts a signed integer by highest_capability + 1. Firmware can
therefore trigger an out-of-bounds read with a short subtable and an
undefined shift with a value at or above 31.

Require the fixed structure before reading either field. For capability
indices that cover all bits representable by the current u32 field, use
U32_MAX. This ignores capabilities beyond the implemented 32-bit field
rather than rejecting future firmware that advertises a higher index.

Fixes: 06e8ccdab15f ("acpi: nfit: Add support for detect platform CPU cache flush on power loss")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 84c70f1941c5..7638d4dc8c6d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -987,7 +987,14 @@ static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	u32 mask;
 
-	mask = (1 << (pcap->highest_capability + 1)) - 1;
+	if (pcap->header.length < sizeof(*pcap))
+		return false;
+
+	if (pcap->highest_capability >= 31)
+		mask = U32_MAX;
+	else
+		mask = (1U << (pcap->highest_capability + 1)) - 1;
+
 	acpi_desc->platform_cap = pcap->capabilities & mask;
 	dev_dbg(dev, "cap: %#x\n", acpi_desc->platform_cap);
 	return true;
-- 
2.50.1 (Apple Git-155)

