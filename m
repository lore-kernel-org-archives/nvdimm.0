Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EF4384CF9;
	Wed,  3 Jun 2026 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509540; cv=none; b=HGZBhaZzx6QksHKVEB+B5uEJWWfg7Y1zQQEX9U/niUdyXTGzrS7oThlj+U+n5iDHX2WIRQc68SUCuEKFEnACLPJ/G80BBLElpE6bYUhiyXqXTj7lAQ66jKEjdTF5VAMaQuW5DjwBsWvEOKnOddSVbTh8mp+kYDswAEupOboR1Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509540; c=relaxed/simple;
	bh=gHYcGZKGQFmrhKN3CIWZ5K3pEvs1kOfJ9reTlXEzT40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsZenPZwjMtjju78v7kDnL7DMKVENg/hJmBYOF6FWemfmDOf1+mlstZieA/jKIpOSnRTMqCES/XIYROvr9JRY3AobGn5stGB+SwmKSrKYVbxLXiF+impVCaSQyODE8jriQ+3TJXcsDl7ZDDlhd7fwA5LQ7WQyNsBmFbI8DZ2izw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuF0TzKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuF0TzKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01EE1F00893;
	Wed,  3 Jun 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509538;
	bh=RRFoaZdh3TCur9BWj/GCnt098ZC08juHUcTL3qFFvoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuF0TzKAyF+AMonUpGG5DbqWZPZobDnLpBnCGNDihG+ZnFhVNIeLaO/cWk728KQBs
	 Ox8ZxmGw0ph34vcKlnDM+Y6ggiRbvhmcd5nH9vUQDt/0rpjOvGBrY9MQRYPcS0/ws9
	 lc4//8UrCyYiMuWepgHUVe6q+V0gRIKBESzYBjORInZ6kE5VTO4ILX1t2RYhsTLIhL
	 NJ6+oc83BUInXjix9yG+mgvaSUn0kaWuqg2O8mciF4KnleTZ63uuP7/khRWFCdBxf9
	 MBKxDmJaiOfcEQHpl2Muyx1NcQBpQHK4EChk/dig2Q6NY7+ujG4c7rQ2jPu/ualnMa
	 +b2kEh34RVM9Q==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 3/4] ACPI: NFIT: core: Eliminate redundant local variable
Date: Wed, 03 Jun 2026 19:57:36 +0200
Message-ID: <14028918.uLZWGnKmhe@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <5110904.31r3eYUQgx@rafael.j.wysocki>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Eliminate local variable acpi_desc from __acpi_nvdimm_notify() because it
is redundant (its value is only checked against NULL once and the value
assigned to it may be checked directly instead) and update the subsequent
comment to reflect the code change.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/nfit/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 01c73be0bd00..aaa84ae7a20e 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1680,7 +1680,6 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 void __acpi_nvdimm_notify(struct device *dev, u32 event)
 {
 	struct nfit_mem *nfit_mem;
-	struct acpi_nfit_desc *acpi_desc;
 
 	dev_dbg(dev->parent, "%s: event: %d\n", dev_name(dev),
 			event);
@@ -1691,12 +1690,11 @@ void __acpi_nvdimm_notify(struct device *dev, u32 event)
 		return;
 	}
 
-	acpi_desc = dev_get_drvdata(dev->parent);
-	if (!acpi_desc)
+	if (!dev_get_drvdata(dev->parent))
 		return;
 
 	/*
-	 * If we successfully retrieved acpi_desc, then we know nfit_mem data
+	 * If the parent's driver data pointer is not NULL, then nfit_mem data
 	 * is still valid.
 	 */
 	nfit_mem = dev_get_drvdata(dev);
-- 
2.51.0




