Received: from mail-oo1-f100.google.com (mail-oo1-f100.google.com [209.85.161.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F2313E03
	for <nvdimm@lists.linux.dev>; Fri,  1 May 2026 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777678780; cv=none; b=QC3mJuqJJQp/2gnPDN8uHEIfmYdQFFHhfiesvSsr8Fv0MJmWshXoyGJrjmeEkAwAHhVehHXVNF+YWXEiJts4gixMQwih7kH0a2YS9q8aLihZRznmNoYaI5IIa0Rgpamc0d3C6+/LHLsvB9KsclaqD+GcP3QCbxJysalrpEykEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777678780; c=relaxed/simple;
	bh=MQlW50n380xfH4YSLTJFu5splwcmM0wqWdXlHGJpjXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZLsIE85EJj1rMc2EYqMVmzqd5DQd7dp/gcTmKesM/1Zq4PjCBGkZVf+x1cJXmG7zdaERCfyIfsdUgLlby9pXk7MvjD/62hNa0NMMHTtvhDgJG5yfZIjO9WCREmrvyLZM2kFqCp9VotaFttFgZSnM4OralSAk3FojAXxzIz/j+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com; spf=pass smtp.mailfrom=amlalabs.com; dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b=EBuLSD3B; arc=none smtp.client-ip=209.85.161.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b="EBuLSD3B"
Received: by mail-oo1-f100.google.com with SMTP id 006d021491bc7-685017d0fbcso1308568eaf.3
        for <nvdimm@lists.linux.dev>; Fri, 01 May 2026 16:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1777678778; x=1778283578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2qFO2NeB0Skobdzpthr8c1Mn9L79Z6O0Ds9iXE6n6s0=;
        b=EBuLSD3BQ6122uCisigsTAJoQHDDlnd5MGEKMMNQ4J6ZRHM5eh08UBU5O1QrbjY276
         LALRHZZn8rsK9UB1f8nWVgEVrH4gRcmbfZ2wDZDrJbVg80vzK33lrFLd3slyaESRUSP4
         XPVGaAbZsDjZylZpiUYjX46E75wUWi4GMpJWYohNx3n+6/7beFkmMLEPnCrotZTcqGi+
         4gHmX39BhRXUFytdSTsb/zye7ohRGr24b5Q7FHoXKS20whHO1hkDvhitArwQPvsAaXMG
         y5pbDjdnc8lc5qp05Qu2s3Xlyec+NMc+OZ6L8VXuPmmDVOuqH3uEoYB6OrB6JDC5xOnB
         GxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777678778; x=1778283578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qFO2NeB0Skobdzpthr8c1Mn9L79Z6O0Ds9iXE6n6s0=;
        b=k//a2C7LTcdi2/P0PLHk6ek5MhlbOEVSbYVwq3r+XtpKvD+Ov2ij3hRd18CDizm9h+
         yUAxBgZtQL0mpCeZ0t4zzCA9d+expRzYHuPr3ZopbIaOOMYTkbVYBqJuVvEWL5DLujN3
         IwMQWNYtVHtmc1D+lAzGoWIjUKcYOuJKDeF3lsWpN3IEUsGCWMUl1n2VR5C/0e7R9Fbq
         hl/3puzSfQklgUFxPkwrIV6nvzQrB+d/eBuWtg9JGSe13TLxE/7TWnFL0aZfu+WI44ce
         NJmbcg7uBn1QH3g9UErHT3DYRqxw78mDLPT6qxT9l0b6Rtm7My0WtlA+1HUyNzV5sjjc
         pmmA==
X-Forwarded-Encrypted: i=1; AFNElJ/P+KtD4mxxc48vXfZW0gO6mVPlVv4Sa4haP2hFwvjOmJY0P8fpGPdjVxM2ClDc689F2Eolu1w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPAcLnfrWtdjDgWT15fvzpgRWnJxwYz/eHCK0w55NvTBPkUoQW
	/Zaus/tNwwAqLUHRVQ4w7Z6DlFCxFaiIdiSaNrOulygw2vwPzDH64Shv7XLs/ehnEqcKy5P/Vk2
	RStUj0L7AkX09DOMQ1qGz3kcrjtCCipRBq+UD/qc=
X-Gm-Gg: AeBDiesla2KOdiUtxcPLGartuXlEUeTgA+ppwxkNWnG+dgkKozazibW9OcXBPCmBNV6
	NZ/7fssct1mPR4l2UFQBNhvzPgh2R1ngbvcBdEbtoZHFV44vfusCEXqLdx0AVKysRdeAC5Ca4xa
	pARP3MXb4L8AUUY4Fvmv4NwnE06qnmB/O3yWpcWd6EmNPBFVxaICdvAuPqnr9ZVNAsPPq3f6m3/
	HR4p03svu2TIKNP1KAxiPXTnr126JQTDylorLW9hN90sQO3vLhMtLcrRRSBzkW4vZHwF1Ipk71w
	GJEAwSqTuCZuk1a/KJEjkIO9syUFRrF/K+25qF/DbRVzOYdnGqQKR6iHPOEFLbcwUYsEp87607k
	Z1pFi6E1KFqzSOwdNHjl3rCtSpWblO+/wIR3lW+uixHdd+D7lgr2N5+HX1xKMIIq8K7ipFGJU9b
	SpGkUs1J5d
X-Received: by 2002:a05:6820:61e:b0:67e:160c:36ba with SMTP id 006d021491bc7-69697d6a089mr608506eaf.48.1777678778004;
        Fri, 01 May 2026 16:39:38 -0700 (PDT)
Received: from amlalabs.com (104-10-255-95.lightspeed.sntcca.sbcglobal.net. [104.10.255.95])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-434549400e9sm365539fac.5.2026.05.01.16.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 16:39:38 -0700 (PDT)
X-Relaying-Domain: amlalabs.com
From: Souvik Banerjee <souvik@amlalabs.com>
To: dan.j.williams@intel.com
Cc: willy@infradead.org,
	jack@suse.cz,
	apopple@nvidia.com,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Souvik Banerjee <souvik@amlalabs.com>
Subject: [PATCH] fs/dax: check for empty/zero entries before calling pfn_to_page()
Date: Fri,  1 May 2026 23:39:33 +0000
Message-ID: <20260501233933.2614302-1-souvik@amlalabs.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
added zero/empty-entry early returns to dax_associate_entry() and
dax_disassociate_entry(), but placed them *after* the
`struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
performs READ_ONCE(page->compound_head) -- a real dereference of the
struct page pointer derived from a bogus PFN extracted from the
empty/zero XA value.

On systems where vmemmap covers all of RAM that dereference reads
garbage and is harmless: the early return then discards the result.
On virtio-pmem with altmap (vmemmap stored inside the device), only
the real device PFN range is mapped, so the dereference triggers a
kernel paging fault from the truncate / invalidate path and from the
PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
freed:

  Unable to handle kernel paging request at
  virtual address ffff_fdff_bf00_0008 (vmemmap region)
  Call trace:
   dax_disassociate_entry.isra.0+0x20/0x50
   dax_iomap_pte_fault
   dax_iomap_fault
   erofs_dax_fault

Close the residual gap by moving the dax_to_folio() call after the
zero/empty guard in dax_disassociate_entry().  Apply the same
treatment to dax_busy_page(), which has the identical pattern but
was not touched by the prior fix.

Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org # v6.15+
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
---
 fs/dax.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..6878473265bb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	dax_folio_put(folio);
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else
-- 
2.51.1

