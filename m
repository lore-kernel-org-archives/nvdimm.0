Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6D40244D;
	Tue, 21 Jul 2026 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654499; cv=none; b=pwNkGiJ8RL2QJDWzGJWaVm5wYbv3Mzkb9t8tkC5Vmi+vSUO2DTxLu2GirVGysVjZzpmm1/WH3DYKA5GP8CLXOU3lGD4eNREqqQ89euCmkafdqAtbFvgXlkttVztC7JQn331y02KVPr2cYaoCrziK1soxyZU3aQuBtQDR4HCGBAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654499; c=relaxed/simple;
	bh=CK7A11i6TYcFveOGObyyH6D0dNGP2+htIrQy276+Dgk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ID2LmiBKAJH3oLN1sIWT0CIwgOvIDK62nHEo0yu1AdRmrOCeRng4z/ae7WN/gsnde5H8rexd3CdgXegwsCCr3Fzv9TuIDrgoM2V0sc6GAM8A3VzwMcNqE49F7qQPy9UkXgOMniL07WRd34tVqqlCr3Iq2oGPUE4KJNt5Ui5TPPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gjEdTo34; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gjEdTo34"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xC389G4QcNLC3rr9WOTOnrSObpb4pgmGODJwu4FyGeM=; b=gjEdTo34GBsB99+Ie39GttK9yP
	Ntk+B9bzwL/RaVhl1lcV1ISohNlUsQyKigqr3m9Uefeyb7qQT8ArZ6JZ3RV2lN5MKTFGDRKHS8Ajq
	ysKAPMkT9Sv2d5WEL2ZSYkdK+zuJuC1waaYIGgcYXdVaejbQA+EAxAS8ZYTOcF4vlZE4zgEHBnQcX
	69EDLPKb2cn2AQ5BL5p+XArm+d6wgeimaW0PtOXldtmb5XAR/nZbu4fECl3fODQndUlvZCIsIsxth
	pUB5P/tAKE3g23tRtr+SiZxVnevtKCsG5L8kzqOGJ1SFIFp/f7snfLoikWaswjJ8WP130vThNFvvR
	55Zt6i9w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmE9u-0000000A2ll-182j;
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
Subject: [PATCH 1/2] libnvdimm: nd.h: clean up kernel-doc warnings
Date: Tue, 21 Jul 2026 10:21:31 -0700
Message-ID: <20260721172132.3718892-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing struct member, function parameters, and function return
values to eliminate all kernel-doc warnings:

Warning: include/linux/nd.h:124 struct member 'common' not described in 'nd_namespace_io'
Warning: include/linux/nd.h:124 Excess struct member 'dev' description in 'nd_namespace_io'
Warning: include/linux/nd.h:166 function parameter 'flags' not described in 'nvdimm_read_bytes'
Warning: include/linux/nd.h:166 No description found for return value of 'nvdimm_read_bytes'
Warning: include/linux/nd.h:185 function parameter 'flags' not described in 'nvdimm_write_bytes'
Warning: include/linux/nd.h:185 No description found for return value of 'nvdimm_write_bytes'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev

 include/linux/nd.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-next-20260720.orig/include/linux/nd.h
+++ linux-next-20260720/include/linux/nd.h
@@ -110,7 +110,7 @@ static inline struct nd_namespace_common
 
 /**
  * struct nd_namespace_io - device representation of a persistent memory range
- * @dev: namespace device created by the nd region driver
+ * @common: namespace device core infrastructure created by the nd region driver
  * @res: struct resource conversion of a NFIT SPA table
  * @size: cached resource_size(@res) for fast path size checks
  * @addr: virtual address to access the namespace range
@@ -158,8 +158,11 @@ static inline struct nd_namespace_pmem *
  * @offset: namespace-relative starting offset
  * @buf: buffer to fill
  * @size: transfer length
+ * @flags: process (0) or atomic (1) context
  *
  * @buf is up-to-date upon return from this routine.
+ *
+ * Returns: %0 on success or a negative error code on failure
  */
 static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
 		resource_size_t offset, void *buf, size_t size,
@@ -174,11 +177,14 @@ static inline int nvdimm_read_bytes(stru
  * @offset: namespace-relative starting offset
  * @buf: buffer to drain
  * @size: transfer length
+ * @flags: process (0) or atomic (1) context
  *
  * NVDIMM Namepaces disks do not implement sectors internally.  Depending on
  * the @ndns, the contents of @buf may be in cpu cache, platform buffers,
  * or on backing memory media upon return from this routine.  Flushing
  * to media is handled internal to the @ndns driver, if at all.
+ *
+ * Returns: %0 on success or a negative error code on failure
  */
 static inline int nvdimm_write_bytes(struct nd_namespace_common *ndns,
 		resource_size_t offset, void *buf, size_t size,
