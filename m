Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D60486621
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634026; cv=none; b=uqstdvHXe3Vqq3iLaC4Ow2EIgN5Eq7vT5PNQGpeE+WhjDbvB4Iw38/RfVkw1kJByoNLV2Ynveiwq5NTdSNfGrWxma+jBDaK5pNN+PPnR4XDM+qa5gm9l3oemFguU0uHrAIJD0mIRjKnbNm8WsFKRZseB/VqnylwrHEs9leSPzbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634026; c=relaxed/simple;
	bh=Uqnv31TYchVuebYUHgIZFHrFafrbMUbdtChxqy5njbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uu9g2d6DRWn34L7AaSdB3BmXM+ort0q8T1C824KrxxdEFhShuKzFcraxAw6uuWQ4+3WFDM/fFjFMogfnCULjYGRkca35/JrmMIndMw0Z9a+yi5Y+q9vusSgu05xzB3Wf58g8RmCCl44jEIcToD6LVFwMe+0vuNRLpHnlMWKXt24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAHofQk331qCzZ5BQ--.20056S2;
	Thu, 13 Aug 2026 23:13:41 +0800 (CST)
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
Subject: [PATCH v2 2/5] ACPI: NFIT: accept SPA structures with an unused location cookie
Date: Thu, 13 Aug 2026 23:13:40 +0800
Message-ID: <20260813151340.20276-1-pengpeng@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAAHofQk331qCzZ5BQ--.20056S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGryUGr1UXF4UJF17tw4ktFb_yoW5WF15pF
	sIka4SyF9rJr47CF43Ww45J34Ykwn7ZF48ArZrC34qy3Z3Xr12kFn7KFyYqFyrtrWv9w43
	CF4ktFW5CrWqvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ACPI 6.4 extended the System Physical Address Range Structure from 56
to 64 bytes by appending an eight-byte location cookie. The cookie-valid
flag describes whether that field contains usable data; it does not
select the structure length.

sizeof_spa() instead derives the expected length from the flag. It
therefore rejects a valid 64-byte ACPI 6.4 structure when the cookie is
present but not valid. It can also compare 64 bytes against a previously
saved 56-byte structure without first checking that the saved allocation
has the same length.

Accept either the legacy 56-byte layout or the ACPI 6.4 64-byte layout.
Require the cookie-valid flag to be clear for the legacy layout, and
compare saved entries only when their validated lengths match.

Fixes: e9cfd259c6d3 ("ACPI: NFIT: Fix support for variable 'SPA' structure size")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 4428adb6a1ab..f68edfe64952 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -705,9 +705,20 @@ int nfit_spa_type(struct acpi_nfit_system_address *spa)
 
 static size_t sizeof_spa(struct acpi_nfit_system_address *spa)
 {
+	size_t legacy_size = offsetof(struct acpi_nfit_system_address,
+				      location_cookie);
+	size_t size = spa->header.length;
+
+	if (size == sizeof(*spa))
+		return size;
+
+	if (size != legacy_size)
+		return 0;
+
 	if (spa->flags & ACPI_NFIT_LOCATION_COOKIE_VALID)
-		return sizeof(*spa);
-	return sizeof(*spa) - 8;
+		return 0;
+
+	return size;
 }
 
 static bool add_spa(struct acpi_nfit_desc *acpi_desc,
@@ -716,23 +727,26 @@ static bool add_spa(struct acpi_nfit_desc *acpi_desc,
 {
 	struct device *dev = acpi_desc->dev;
 	struct nfit_spa *nfit_spa;
+	size_t size = sizeof_spa(spa);
 
-	if (spa->header.length != sizeof_spa(spa))
+	if (!size)
 		return false;
 
 	list_for_each_entry(nfit_spa, &prev->spas, list) {
-		if (memcmp(nfit_spa->spa, spa, sizeof_spa(spa)) == 0) {
+		if (sizeof_spa(nfit_spa->spa) != size)
+			continue;
+
+		if (memcmp(nfit_spa->spa, spa, size) == 0) {
 			list_move_tail(&nfit_spa->list, &acpi_desc->spas);
 			return true;
 		}
 	}
 
-	nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa) + sizeof_spa(spa),
-			GFP_KERNEL);
+	nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa) + size, GFP_KERNEL);
 	if (!nfit_spa)
 		return false;
 	INIT_LIST_HEAD(&nfit_spa->list);
-	memcpy(nfit_spa->spa, spa, sizeof_spa(spa));
+	memcpy(nfit_spa->spa, spa, size);
 	list_add_tail(&nfit_spa->list, &acpi_desc->spas);
 	dev_dbg(dev, "spa index: %d type: %s\n",
 			spa->range_index,
-- 
2.50.1 (Apple Git-155)

