Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D32BD58C
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753154; cv=none; b=RzpXWqFNvxF4NR9mc3kaWaD9uDNCpBjevDxjH/zGeqaRSTl5JeEftpDUGEMLeqrYcfISffhC8AzPspOT6W4NK1drhr2nxxxWLWdHbXie5g2tfD4YGXG4cJu6DmZZQsmaGtN5OiBjZ27AnZVPjPbvd1Nx1sRYCqfcaeum7r0T8sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753154; c=relaxed/simple;
	bh=op/fn/eil8uW4Lqi0nNtrKr+hAEgKQCdVXv87J2C3Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=coVHot3oZvOx7AqKzB7P3ssTJa738zgeC5sCh8xHo9HgeGKqlXGOUn3b+qoN2SiFMLps8+6Rnf/JGZfweRyTcsRBegF/HJ7PQ8PnMUln/kuyfaa7bbo2wR2AxuSzZ9DcLW6kOpod1PIBhSQkIwR2/0DiZ7x7/n8WHt8hOW+sTNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MWk2dF2l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MWk2dF2l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WXxbBdWkSFir8qoOw7q+QMZqWjLZWA9TcFjO3xeUJH4=;
	b=MWk2dF2ljdmuOWNGU+SwKMuC7oghAi81ijNKVba+3gIo7UnXgk/zXzwimrHCuGh/XeMKv+
	8nxGh7Eo0NDrZMF4WUrRlwFjix8KoMwghqgwnKssp7lnq3pKuP2qRG2As6oEhDJCQC5U6h
	QNsJxQXXyw0Y9+KHmqL1F6GnI+mDJwo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-Uw8WRYQCN1CeP6r-aiLkzA-1; Thu, 17 Jul 2025 07:52:28 -0400
X-MC-Unique: Uw8WRYQCN1CeP6r-aiLkzA-1
X-Mimecast-MFC-AGG-ID: Uw8WRYQCN1CeP6r-aiLkzA_1752753148
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso431635f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753147; x=1753357947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXxbBdWkSFir8qoOw7q+QMZqWjLZWA9TcFjO3xeUJH4=;
        b=wn82Hrhc2CngfCaXhGt3zA4KAFAMoJIkEycQRX0f32tVSiUQ/3khLrAfspa8lR9W3n
         mUdcfkxLYF+EBBeZJlj6zICFwQmUAlmcKxb/ncifPgN8E9hIATjHai+mowNpu9KdyqBU
         u8s+3lBOuyUYGCc855eXacexzEk/7SEE2l1y4vS6mptH6vBfvSjH4zd0wWSBfInHIXay
         XU6ZGcb+17ESFn6N8+OhhlMNwvUdPBPGMSY2oto2VoIcllCGvDIB8gjULjWtNpltmD6E
         wdsEOLdoHt+pJOX2ajymbIAGheM0h+O1+PMyMSX99U+M/9O6lt5IQgKmrV+apbBLtaAj
         i7mw==
X-Forwarded-Encrypted: i=1; AJvYcCW9mV4xU2ewk+1XSPMVtbzSuIv6DVAyM+oJgiybOLTb6a7rGfxFaFoCa0EOhszN1RMAGFsCwpQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuWLBpmv9/qecguUSZOx2DT/UrzWwKqrfAre5aL4gEJqoo2K6o
	xgn9h6rLe6O50AqcabpkU6lb4CnRnhw6KgI0tBWhL4hL6S71xjz94zMCwUySMK6FFIPsBTlG79N
	dI/IQa9GZfAxsIMCFFEwGUec3B+3JyMyzl2fRoky/RgyttriLQXK1FPzy5g==
X-Gm-Gg: ASbGncu4Zew2R9JoNA99Dwx9aOkvkAiC4VkvMca0z5QAbdpZ3eW+vYAzDXbhipSMti/
	LQ4giW3hECfIA7N/HZQhQq9FWJmQSEXNsbpeXChmIsrvjlUqr4tm/Yuvx53TItTAaee2mtMGs/a
	+NR+ytDU1x1ijOVAuImQME7SPeXpOVteBf1fbiiAR9YKjLtZFZ83Y0PAx7gOkxUseloXdccrNf5
	27lzzxiGRNoLDAIyKPL5d63KkHjA9HK65y8hliWJ7mVnQOodxo4n3dIFCVh+mwMCo2IKQ0yEwSK
	cvVXgi1UakZ1nRjVxPo5lB4MKq4X6wy/NtECuJyR3wKLsrXpeT6ySIpr/IaVegX0Bm/AQZf3dbf
	CA3jtiBjq3bfzIi0mbUumR2s=
X-Received: by 2002:a05:6000:4b05:b0:3a4:e4ee:4ca9 with SMTP id ffacd0b85a97d-3b60dd72378mr5333940f8f.23.1752753147606;
        Thu, 17 Jul 2025 04:52:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVug96IdPAxHxRCwLhhCK8Tw1f2oOZhwD0absH2YXaDMF3tjDXL2HLEbyWszstU7d4tmbzEQ==
X-Received: by 2002:a05:6000:4b05:b0:3a4:e4ee:4ca9 with SMTP id ffacd0b85a97d-3b60dd72378mr5333908f8f.23.1752753147033;
        Thu, 17 Jul 2025 04:52:27 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b5e8e25e75sm20438446f8f.87.2025.07.17.04.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:26 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 5/9] mm/huge_memory: mark PMD mappings of the huge zero folio special
Date: Thu, 17 Jul 2025 13:52:08 +0200
Message-ID: <20250717115212.1825089-6-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250717115212.1825089-1-david@redhat.com>
References: <20250717115212.1825089-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SIVI7-6_mV7a8PF4sqPzZSBahHnt8SOtOGVYNw990Nc_1752753148
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The huge zero folio is refcounted (+mapcounted -- is that a word?)
differently than "normal" folios, similarly (but different) to the ordinary
shared zeropage.

For this reason, we special-case these pages in
vm_normal_page*/vm_normal_folio*, and only allow selected callers to
still use them (e.g., GUP can still take a reference on them).

vm_normal_page_pmd() already filters out the huge zero folio. However,
so far we are not marking it as special like we do with the ordinary
shared zeropage. Let's mark it as special, so we can further refactor
vm_normal_page_pmd() and vm_normal_page().

While at it, update the doc regarding the shared zero folios.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c |  5 ++++-
 mm/memory.c      | 14 +++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index db08c37b87077..3f9a27812a590 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1320,6 +1320,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 {
 	pmd_t entry;
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
+	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
@@ -1429,7 +1430,9 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		if (!is_huge_zero_folio(fop.folio)) {
+		if (is_huge_zero_folio(fop.folio)) {
+			entry = pmd_mkspecial(entry);
+		} else {
 			folio_get(fop.folio);
 			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
 			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
diff --git a/mm/memory.c b/mm/memory.c
index 92fd18a5d8d1f..173eb6267e0ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -537,7 +537,13 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
- * case, NULL is returned here. "Normal" mappings do have a struct page.
+ * case, NULL is returned here. "Normal" mappings do have a struct page and
+ * are ordinarily refcounted.
+ *
+ * Page mappings of the shared zero folios are always considered "special", as
+ * they are not ordinarily refcounted. However, selected page table walkers
+ * (such as GUP) can still identify these mappings and work with the
+ * underlying "struct page".
  *
  * There are 2 broad cases. Firstly, an architecture may define a pte_special()
  * pte bit, in which case this function is trivial. Secondly, an architecture
@@ -567,9 +573,8 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  *
  * VM_MIXEDMAP mappings can likewise contain memory with or without "struct
  * page" backing, however the difference is that _all_ pages with a struct
- * page (that is, those where pfn_valid is true) are refcounted and considered
- * normal pages by the VM. The only exception are zeropages, which are
- * *never* refcounted.
+ * page (that is, those where pfn_valid is true, except the shared zero
+ * folios) are refcounted and considered normal pages by the VM.
  *
  * The disadvantage is that pages are refcounted (which can be slower and
  * simply not an option for some PFNMAP users). The advantage is that we
@@ -649,7 +654,6 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/* Currently it's only used for huge pfnmaps */
 	if (unlikely(pmd_special(pmd)))
 		return NULL;
 
-- 
2.50.1

