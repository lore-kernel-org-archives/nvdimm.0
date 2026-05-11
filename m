Received: from mail-oi1-f227.google.com (mail-oi1-f227.google.com [209.85.167.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAADF37F72A
	for <nvdimm@lists.linux.dev>; Mon, 11 May 2026 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535662; cv=none; b=qazXQNxGayfXlNvZoa7vkEaW0r83TT+K12nXz8/4ucHncXASv3HrkQeF9mXbvnWDe1McIvrtGIEcIFFcJWeXxH1YC7QY5AvdZs3wcZ03dfBP/fp7wbmkZ/Z97qpfh0FDiottsQp7f/NYedhVkaP9UROLwyYBGV16YDOCyNGngBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535662; c=relaxed/simple;
	bh=ljekVeTJvDasxU8usBmBxCnDSxCzXGYcRwljfuuKbvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nk8A420Q1bXkpieK2PV57SQhhXZjqPNyfP534pWMxnAqzwrg9wo8LCi/fvXFtRetGNHzAyvJkglur+qr3yzDHydvgsZBe08iCdBbr0ce32eiIeOYOtFYzbNepWzAYY3dR+wS/Ny5whB/dVGx22xfbfI/poiVkFIQd9taJ59zy4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com; spf=pass smtp.mailfrom=amlalabs.com; dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b=S8accWS+; arc=none smtp.client-ip=209.85.167.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amlalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amlalabs-com.20251104.gappssmtp.com header.i=@amlalabs-com.20251104.gappssmtp.com header.b="S8accWS+"
Received: by mail-oi1-f227.google.com with SMTP id 5614622812f47-4670464029eso2795935b6e.2
        for <nvdimm@lists.linux.dev>; Mon, 11 May 2026 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1778535660; x=1779140460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OsyEmMEatHl5JGOKxvyMcGRrS7mW1Z+dscSdDt5bxRY=;
        b=S8accWS+1jpN27Wt9reMQ9Q3wwEmB+DE8e/ATDRFfslM3v2jXJurJgm1N51e6t7nH9
         NiRb5FNIDFs+nE/0eLykIVrbrglXDbFcdGyU+0wz8dUS5lc6zFUh5HXo0yFNHnJOxiok
         SZ/neu9uo07LfLAB2cOGXvx/GSV/kOJOLYTX2d94r7k9HaPZy8H1kXKi2rAS/psa2TO+
         Em+KjH3aV5rHZUwYHRfzqmAKQG2IyMQaV07sd+NeVdTv5WHCJwDioqCTIq8tJ/mk3pGe
         sxX2SrtnSgTHbyaxoAhFPuyml4ABcpPx6LJQNaleUoBEBnbZiWIpBb8iiBHtFlZCH+B3
         QMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535660; x=1779140460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsyEmMEatHl5JGOKxvyMcGRrS7mW1Z+dscSdDt5bxRY=;
        b=B1mBKjTZq+PTXRO5oKYGvF20U84cMprvHB5OYdTdDsiabLMte2EpNKMqyoc+ozIKho
         oh1kNsAJy3Dbgto6P7iHDuvdxHoN1OgVRf8ngqBPCo2ChmSARE8tK3vPF46DLtHBLfpz
         dZAaZ8P5aJqz62MEJhmAhd2vJAAWkDFmivLnebi6Dnk6T/q8zLvvTR65J5fDjZgZUXPd
         +zwObpF07w2PgyB9UPhMsyMhv6h61CwokAQ0EiijavvcN9P5+F595BzrNrqbPmsup7y0
         KckhsT/jGALEE656902a4t3ZZoT3nZzbE7fnLNMESrGcTGMhWsIs0Ix1QjJRSlihfJEm
         gpSg==
X-Forwarded-Encrypted: i=1; AFNElJ9sDuLr/De1OWDYKBzdh8upHIoR/rAyLQ8GVVEjtw3fLw6sXKY8lNLIS8KsW/u6s2dqEXf2ojg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+hLcLiw/JxQu6HAGZ9pYC/dFJu/9WKI0o8RY1M5tFhjzsTMld
	7UutOkAQhtbwoPO0E4Tfojmk0NNQrR7MP00PIgDsCSsC8l3OzClOpJVSoy++LOh5ed1rMZH4hay
	50RX0YFS4y9Gm5U/nRbbDKesJRtfpPxwSzSM9XYk=
X-Gm-Gg: Acq92OG+3LdRPFbIbjymF8NspKt3iRFthrDGF1+GZEMxGIeKoFHGwTO+NKA4MbKj1gl
	jL8ohT+TEFfump7YPeT3mMytfOOyppRS5et/YJnnxKcnEcDkJtwLrd3VILi9fscoWijIZpN0uVq
	Zyhyl90pZJf28NZra2WS2maWx26yjh+O/AUukRi9Tkp/W9dclOIXX4P/JKYP7z7/aWjDj4Ln//6
	iyJq5fqeXV1cYVFG2RWRLU5t3REczySW/5MPMd2rStTr2LzZeCOZFhJSgbxJK5QMerIgfQKqamV
	TGioBxPe+CRozb4gvpf2mLlndIjfJ3F2jnqy9W3LMYPGbqC+hsKPLFp85+0EYX5i1v9Oy7XyuTn
	ZLygN8FlF0Z4wly3ZeU6nEWRi5s3p8cBd4MlyTgs9Mzojfhn2QCurxiO5jvfBf3UFkaWv5kL7rw
	==
X-Received: by 2002:a05:6808:2e45:b0:47c:3415:3726 with SMTP id 5614622812f47-48297388e0fmr335122b6e.33.1778535659807;
        Mon, 11 May 2026 14:40:59 -0700 (PDT)
Received: from amlalabs.com (104-10-255-95.lightspeed.sntcca.sbcglobal.net. [104.10.255.95])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-435f250853csm538701fac.10.2026.05.11.14.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:40:59 -0700 (PDT)
X-Relaying-Domain: amlalabs.com
From: Souvik Banerjee <souvik@amlalabs.com>
To: djbw@kernel.org
Cc: david@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	apopple@nvidia.com,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Souvik Banerjee <souvik@amlalabs.com>
Subject: [PATCH v2] fs/dax: check for empty/zero entries before calling pfn_to_page()
Date: Mon, 11 May 2026 21:40:20 +0000
Message-ID: <20260511214020.208939-1-souvik@amlalabs.com>
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
expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
_compound_head() and performs READ_ONCE(page->compound_info) -- a real
dereference of the struct page pointer derived from a bogus PFN
extracted from the empty/zero XA value.

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
zero/empty guard in both dax_associate_entry() and
dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
which has the identical pattern but was not touched by the prior fix.
dax_associate_entry() is reachable with a zero entry via
dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
dax_busy_page() additionally see DAX_EMPTY entries created by
grab_mapping_entry().

The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
either guarded or only reachable on real-PFN entries, so this exhausts
the anti-pattern.

Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org # v6.15+
Cc: Alistair Popple <apopple@nvidia.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
---
Changes in v2:
  - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
    confirmed by Alistair Popple).  The same anti-pattern existed there:
    dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
    that path can carry DAX_ZERO_PAGE via dax_load_hole() /
    dax_pmd_load_hole(), so the dereference reads a struct page derived
    from the zero-page PFN before the early return discards it.
  - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
    no further instances of the pattern.
  - Updated the page_folio() expansion in the commit message to refer to
    the current field name (page->compound_info via _compound_head()).

v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/

 fs/dax.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..4bca6e2bc342 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 				unsigned long address, bool shared)
 {
 	unsigned long size = dax_entry_size(entry), index;
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
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

