Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FDB2D3759
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911607; cv=none; b=quMnNiwNjoMYoFebgzJSdEhrJXsL6+TTYCqPjYzJnVsrpqOTSYhIXMHGysND+kt9a0sEp3SvS3an4zZltGcvtujy8rkXA5reYtHxJtKk1d+dO8JA1TusI1IToPWlQmeUhSkM+/iINd5XLRuBU/iS6uvQTqXAxBk3KVZZdvFK7zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911607; c=relaxed/simple;
	bh=Two6z2c+eu7eJRnlv4eH9xLpdr8pvhEq/q43/f0xNIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tc1zhepyNOf6qa+zQ9uzNoAhimTwmTQ2HvH5afAg8e2MuG7Ak+JHxoUqniSdsbPAdWUSqav+rjM8IjWL3BxG6ZzMp6PQfrLo7BbinX9jZc3SKsWr8fb+7qs8j+afUvesDpHVa9eP8/TQmTaj0SbOAfJ8me4XXyJeUvo1XwVhIcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MHIgDDer; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MHIgDDer"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OPzS7A0H2JYY/4bVoDqq5vs7hjaSrgBmC9jJDJzHOMU=;
	b=MHIgDDercPLuz7pteul5tWFHjneuoapL5+LHdKKsGx/LVYDv8WWTlu0eatfgXf8yOiFYi9
	fubb/gj2MmuibpOIlWSpHbJqsNH/zWt97BArdZXWX8psJpsCOWalF4ZtFzOyVvTZ6TNn+2
	QXLLtrj5s8q5WQ5dfYehsejmXfWo0iQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-B8GSAtPYP8izaj4hWbWF7w-1; Mon, 11 Aug 2025 07:26:44 -0400
X-MC-Unique: B8GSAtPYP8izaj4hWbWF7w-1
X-Mimecast-MFC-AGG-ID: B8GSAtPYP8izaj4hWbWF7w_1754911603
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459d7ae12b8so30614045e9.1
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911603; x=1755516403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OPzS7A0H2JYY/4bVoDqq5vs7hjaSrgBmC9jJDJzHOMU=;
        b=iDOkZldgN8s40+kyVx9cB4H5c4br8eI7GQk0jyxcCjaWyN3N7jicWOEP2iOQxx+cKS
         0c706MRAlgWf7E5X2tNOuLeDFjmW9plz5Z8Dsc+nijr51mSN5K+41CfnikcZgtjzV4F/
         ZwM5bh2Aq3De1oBMc+Pt7YSInim2vW4aeveHdgnqRyAJ0Yt8hXjbbhNpMnJdiM5KOn0+
         On7l7saN4NdYo/6C4/59Evere/6XuUPBvxAxyT/wtgPsryQthzFLNXyj4TL2qSoxgcy2
         Q3kUu57Wih2/DyWddEtzRdYQZykstbnZh2tqI8KpOWJj7tKdTjwo67E732ZMbJllxJNP
         sXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjbVjPRsvnxGJO6Upw7BzMIRs75pS+F+KAx9guwKUgEkQM9PlLgFusIamJf2M03OrWkIGd3EE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmlbPC4p2u4FjEnhN5JO1/Yi/mjQT3yF4wwFlrIX3tpwf8J7Mg
	E19Ajrw1lJbT41Hs4tQJBXy/fFZwwzk1toBUCTbwnqkLu0lR6CRhPqd2/5UrQrsxHbQ3kUZ7LZC
	Bghc5aXWWw85o3cIZsYQDfveG8A2pdGZbctSLFyhzEd/e8FeZa5wc7G7Px1+gKzgo3Q==
X-Gm-Gg: ASbGncsloGQ2Lm9Kgi+D7CudWlEY1JyO++khuRiLsZNDBD3COxn0SQwJzMOBdIdcx7U
	3EgVJumfq7FDJzNTU8uztvc3XVpKooQkB4uhW1Uuzb3p1sKF367LRzkRgIpQy1z+1ag4Juw7iuS
	8pWycyQVzZhAbpcqo+4HWbkHJczn9lwWRw1Et9VTIj/mxllYYnjNskURc+AVBGFwo9xwVt6LtHW
	QfRpri3bTteih0ndLHaWyjkG3pSNdKDAcOXU3zwDPkW9x+Vwn7IY+v8+eQw8WpolnU4Zapjgigj
	+mTBsUBdI3pK0BTwh3WwnDfQY9BXefNiCEXQe32bY44s0TeiaoGUOlfDxbiVKSZCl2j3RKWzrZE
	1mX8uOcAckv8Rn5e54JQTdlbR
X-Received: by 2002:a05:600c:4ec7:b0:459:e398:ed89 with SMTP id 5b1f17b1804b1-459f4ea2167mr89525575e9.1.1754911602500;
        Mon, 11 Aug 2025 04:26:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2VXT8eja0G/6oYjAzMox3Wj/YsLa0WXg9I30LI+rqq9mj5h9Avu9edvonRgK7PI+OIDYPVA==
X-Received: by 2002:a05:600c:4ec7:b0:459:e398:ed89 with SMTP id 5b1f17b1804b1-459f4ea2167mr89525255e9.1.1754911602063;
        Mon, 11 Aug 2025 04:26:42 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e6dcdbbbsm122068765e9.7.2025.08.11.04.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:41 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
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
	Lance Yang <lance.yang@linux.dev>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 03/11] mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Mon, 11 Aug 2025 13:26:23 +0200
Message-ID: <20250811112631.759341-4-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mplOydnC9HWHhvTDGnvNSezXaEkfYLyjQqLGl-JIaDc_1754911603
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
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7933791b75f4d..ec89e0607424e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1418,9 +1418,11 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
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

