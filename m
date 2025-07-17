Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA3429E0F0
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753147; cv=none; b=k7+yDCFN+Rv9o283OtH78/qqpa37OqM5hdnZJbfMhZi9csT6nZHRXwxP0phJ/86HIv7Q0WjlEhpTT1KirRTkujWSnTnq1OnMSSQYwc7v75C8InMxvr/QvzhxaLVi9ciU9oiSaqsvoW8V7YlbHIwT52qNF/gG7q7UmbxARa6Gcv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753147; c=relaxed/simple;
	bh=Dg+vKZ/RO8UXSK7n9DU1KLHAEhb+/0cG5UKKUXsdZOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Fd6MggcognXb97jxJztopzyvHWAnbpemnk8JVVgVSrK0Ip6db9DQRy5Tcbsn2IOkfgDS/pk5h2cCQXp4+3f8kSvbqrzMwK5ZeBSAGP1LzkKt+MjSCCkob9VSO5JdW0suruCoKI4z+l/HQDFHASSwEDhLxXlUNpafK/lz5pwR/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cXkgX3c9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cXkgX3c9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAAYYXy+5qwpASBfNrlxr8guN8G2i706wjpGFlltV74=;
	b=cXkgX3c9kYjIW2OQGo/wqayiiTYVOHyMGs1vJq0Q0kyxiYk83lt5EFK5/a8OeJr99xrkim
	giqobNuLupMLeKB6LX3w0nG1SKLwOhr82IyegJrUTsbk7UX0XiMa0FE28V3/MJahcEKhfo
	DwzI/O1o1iWPc+S1jUd9GiFC5hVJkMI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-pQ9gKXW-PZqmoLKuL3-HAw-1; Thu, 17 Jul 2025 07:52:24 -0400
X-MC-Unique: pQ9gKXW-PZqmoLKuL3-HAw-1
X-Mimecast-MFC-AGG-ID: pQ9gKXW-PZqmoLKuL3-HAw_1752753143
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so412288f8f.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753143; x=1753357943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oAAYYXy+5qwpASBfNrlxr8guN8G2i706wjpGFlltV74=;
        b=oulPLq5UKaR+P0k4eUc3sMXcnK5KZe9R/nzXzqgztRHRNODoPdf5S9nGk7BMz0qASH
         z7CXyEjDFvPLMxIFYEx3UC4FAlflapcTH8n+Ri0I86PFLDm5VtPrNwZicx8MvK5Hj63h
         1+c94Ea69lfWsptsSNxAKhLqRPaBQAUDWgKJ9l9lKrSpBMcLnI4VeA/rRqNNZJiDFIyX
         esua8YfBmKKhYcQzCkCFovxUGQS4JL28qEnz9mTID3Z6D+HvkwBAwOGF+DwmTCwYIxCu
         Ir62LOQ1NXVmLYp+UhwVt/EMYRi8zv585Iz7HrZMqTvIjWOOeMJAY2xlfIRsT3EOibth
         1+dA==
X-Forwarded-Encrypted: i=1; AJvYcCXUJvIaJatp//XxlakXIARK716RnfcJv62TLbQqCMe0FHxAEFkN4AlFE93iXbmaBU3XXIr5UZs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4Hajz00iYsNFcK69IBJRDxd6Xcx1GZT7yzjNpV4OxefI2+BTt
	Lf3NVWRL8M7pWD/PnBJkuHueoeEalMmB9J4DHwcRFSUNpKj2bUlMmvnvtcBKgrLdaXfgrUVUJj3
	ZS0BrYNQ7MegWzogJ+49yFHuuCnyMaFCXBCjynrD9t9B/K4ckbZGi40uPWg==
X-Gm-Gg: ASbGnct4Vs+6eCZfCKFdlyGZmUPhKrlFkJi9V1Zzjo9GO1cUL3XgGZGN3u+B9AhSg3Y
	h3c0Z14TuPaxCtiOsB5PVaVuM9s1edU2RqsmQ5gqZNu2RsBE3hqM4VKL39IxpFbT/Xli+0J7ikW
	hSSW4euzdbrqQKfxWyJNvQDxJECkFrtZrPQl7V1ayLmquvXOGkEgOdf/ckokFXOgONhfy0r4LuZ
	kZXCad5ic/p0n91z2gV4St6995VGHcu7d4nmwr+oq1yGegyPzEXo0cNqdTpAyaiRndt+Prm5Akj
	WSBR2VfjtunkaTAgm6f8JLFPRQsBHgYfaLM13xZsIHL4V0Oe30gRL7K5ArXVv0Rp3Sktzojy94N
	jsOXGxBIY7ms/yTULdR2YURo=
X-Received: by 2002:a05:6000:23c8:b0:3a6:d95c:5e8 with SMTP id ffacd0b85a97d-3b60dd7aac2mr3879049f8f.35.1752753142610;
        Thu, 17 Jul 2025 04:52:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLqq0HSziphIF4gY7jkSa/7zMDAewp7/5b6DkIKpjYL1yIcxKWQwPQ10nRUjdRU/WgBdtqyw==
X-Received: by 2002:a05:6000:23c8:b0:3a6:d95c:5e8 with SMTP id ffacd0b85a97d-3b60dd7aac2mr3879028f8f.35.1752753142142;
        Thu, 17 Jul 2025 04:52:22 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45634f4c546sm20298345e9.7.2025.07.17.04.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:21 -0700 (PDT)
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
Subject: [PATCH v2 3/9] mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Thu, 17 Jul 2025 13:52:06 +0200
Message-ID: <20250717115212.1825089-4-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: YE1JVcjBXfpOl2u-l6RM5UNBhDnFoEAog6VXxh77vx4_1752753143
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Just like we do for vmf_insert_page_mkwrite() -> ... ->
insert_page_into_pte_locked() with the shared zeropage, support the
huge zero folio in vmf_insert_folio_pmd().

When (un)mapping the huge zero folio in page tables, we neither
adjust the refcount nor the mapcount, just like for the shared zeropage.

For now, the huge zero folio is not marked as special yet, although
vm_normal_page_pmd() really wants to treat it as special. We'll change
that next.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 849feacaf8064..db08c37b87077 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1429,9 +1429,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		folio_get(fop.folio);
-		folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		if (!is_huge_zero_folio(fop.folio)) {
+			folio_get(fop.folio);
+			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+		}
 	} else {
 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
 		entry = pmd_mkspecial(entry);
-- 
2.50.1

