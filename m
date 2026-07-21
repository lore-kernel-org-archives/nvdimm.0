Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CCC402444;
	Tue, 21 Jul 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654499; cv=none; b=I7NMMlWeQn+Qcs2+kw9Uj3VeX7c6o4o9QOzuIrLp5qrGYqsI8f/DXDytXo1LVDHbkOoDRmMJn8cNs9quAEoeSxNda0aoWVM50NZnl1vITL8uMh5sZii3YPPZZs2+7mcGSjpIRHGeMqIZXgTLL3oJExS+MJBWhrEDPTHHu1Y9OAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654499; c=relaxed/simple;
	bh=v+O6DCg017osjdXkYRxZqI8KZ4Pwkj28m+9VwW7AK5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCbB4x6pyhOgTbATtEHDY7/cChO2HnfTilU4KN/GLyVUKTrnOn0DLqkUoSmb0rVEfnoaZUpZeAYkQon+P0FV8HI2GRREHmdZewNWu+l2bWiXtqj0sw0QgXZvJUzkydUWcFbgpvLvYsrPdHkTQWl6lMBgzTtgjwgaGwDN6LMooX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4F/VGaDn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4F/VGaDn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2PanDyh4Jk+ezjdi1IGNlbZs6yQEs9jrhEGvhCUhgZg=; b=4F/VGaDn5OI+rStNrfVWEK9VuE
	P+zk4bzWEo7F/UHcgMiCh/EgG/VPhVJELYa6sdMjf1cha9RJa/ZzpSO3+r2BL5Ahw9lNZdNqtRgU5
	w7y+tqJ6KsVdLg8DO8/ccM3izU0y6kgBDdGupwgHZtcR6A6ioxcX1PY2yr0VkBwxRc7MURUinfuR+
	a+GiBc2qI+1ZJKCMgTqIRik6WDR16VDTKH2Zr60kO0hP5Xdk/hgzZ56+vKsflnjZZasF/PYX5OV0r
	QkwsjfoiBDK0d+GAZKwsMJ4hxADaqoFDzqakXfUDluY0fmG6ys4QIm+G8AFWZWdDJMjzAvzvsRzjY
	4vN+PHHA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmE9u-0000000A2ll-2Kgi;
	Tue, 21 Jul 2026 17:21:34 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	nvdimm@lists.linux.dev
Subject: [PATCH 2/2] nvdimm-btt: clean up kernel-doc warnings
Date: Tue, 21 Jul 2026 10:21:32 -0700
Message-ID: <20260721172132.3718892-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721172132.3718892-1-rdunlap@infradead.org>
References: <20260721172132.3718892-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add one missing kernel-doc description and drop one that shouldn't be
here in order to avoid kernel-doc warnings:

Warning: ./drivers/nvdimm/btt.h:232 struct member 'nd_region' not described in 'btt'
Warning: ./drivers/nvdimm/btt.h:232 Excess struct member 'lanes' description in 'btt'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <djbw@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev

 drivers/nvdimm/btt.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20260720.orig/drivers/nvdimm/btt.h
+++ linux-next-20260720/drivers/nvdimm/btt.h
@@ -210,7 +210,7 @@ struct badblocks;
  * @lbasize:		LBA size as requested and presented to upper layers.
  *			This is sector_size + size of any metadata.
  * @sector_size:	The Linux sector size - 512 or 4096
- * @lanes:		Per-lane spinlocks
+ * @nd_region:		&struct nd_region pointer
  * @init_lock:		Mutex used for the BTT initialization
  * @init_state:		Flag describing the initialization state for the BTT
  * @num_arenas:		Number of arenas in the BTT instance
