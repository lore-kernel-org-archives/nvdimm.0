Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8BE46AA7B
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786634328; cv=none; b=gIUOfSKbNCGiiti131DveqcQSg1FKe8a36pnwqaSLsEtu6s3q738LdaFf9PMp/DcXgNjYV2xMYqvVANYOB0PVNRSCKszjT+Wi7qC9ztZ6v5QgHKc4KWi6Z4pQoV9IOhVhQqdI7I5PBjlHqmBnRDnP+ieuKZXtRLYzyVRioKuPw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786634328; c=relaxed/simple;
	bh=yuDC1gRxHvrdCLXoPP0tdkI+BRFORJkxV2MDo3+744w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNS0SsE4mWvjPxyLrz3mDsi0v5Tfzo+ypDrUbKk0sVCJgakqoNjUHHcG3HfC1rMfUdp6Hsd1kSL9nruyRlqOnT1DaUR4gFHTrhu11uun2aplEQeXBTsWUQ8vCpf5wMC7ZVR41BjNp6zHilU3qq+8/cqBYJUKsnptW4iZoxdK/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAX7O9T4H1qDWZ5BQ--.56168S2;
	Thu, 13 Aug 2026 23:18:44 +0800 (CST)
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
Subject: [PATCH v2 4/5] ACPI: NFIT: validate control region extent
Date: Thu, 13 Aug 2026 23:18:43 +0800
Message-ID: <20260813151843.24305-1-pengpeng@iscas.ac.cn>
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
X-CM-TRANSID:qwCowAAX7O9T4H1qDWZ5BQ--.56168S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tryrZF1Dtry8tr1DJF13Jwb_yoW8Ary8pF
	4Ut3sxArn7ta15Aw12kw45Zay5Zan3AF47C397J342kr9akw1UJF90yFyYqayUJrs7GrW3
	CF4ktF95AF98Ar7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

A control region with no block windows may legally stop before the
window-size fields, so sizeof_dcr() first reads the windows count from
the shortened fixed portion. When the count is nonzero, however, the
helper returns sizeof(*dcr) without checking that the advertised
subtable contains the remaining fields.

add_dcr() then copies that full size. A malformed subtable that ends
immediately after a nonzero windows count can therefore make the copy
read beyond the control region.

Compute the required size from the windows count and require that size
to fit in the advertised subtable before returning it.

Fixes: b94d5230d06e ("libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bf4ddc56494e..84c70f1941c5 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -817,12 +817,20 @@ EXPORT_SYMBOL_GPL(nfit_get_smbios_id);
  */
 static size_t sizeof_dcr(struct acpi_nfit_control_region *dcr)
 {
+	size_t size;
+
 	if (dcr->header.length < offsetof(struct acpi_nfit_control_region,
 				window_size))
 		return 0;
 	if (dcr->windows)
-		return sizeof(*dcr);
-	return offsetof(struct acpi_nfit_control_region, window_size);
+		size = sizeof(*dcr);
+	else
+		size = offsetof(struct acpi_nfit_control_region, window_size);
+
+	if (size > dcr->header.length)
+		return 0;
+
+	return size;
 }
 
 static bool add_dcr(struct acpi_nfit_desc *acpi_desc,
-- 
2.50.1 (Apple Git-155)

