Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495332D5C76
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911627; cv=none; b=HxPcSYsOAtv/2QderoZiU2vPuTyFmSPOTHwzRQURzTAyd7WcwleqZUXaEm5kylFVE7BDtDmRQq0f8q7CtqwZIMSqvSRbirKVkASMa6T42EGWGb+FtFuuypBw0MHy7uAT6GR8ccxMts63zGhTAyv7YM8NW2DSAqjvBWriwdvt9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911627; c=relaxed/simple;
	bh=NTySCngo3UWUnMxAnrpDZ1TAAIskqhgdVbp26lbNG38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VKwqv/sRQLwhgEOt+jiDcAMH1nhtyEi0+JBmkZavBtT5rr+950h1rvYnFj1NWgMxWpt0SdXuSROTFzn+dQGOt4guLWJpTi4vtgL1L7dJLAnbd4hKmAYoRttN4MhU++0MlT4uWBUBLCkT+x34xIMBglWcFjyj8jjfsKfIZ0GCx2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6UPJZWd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6UPJZWd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DfX1fQMnvUejv+2+JWwebv5CirI4aCq8/b8BncrLfY4=;
	b=Z6UPJZWd5FPTum1LTY8qHlNYBbhCsACa7aXpNV6Cf6vnuW9oQpCBIJj8pVTeG2iUPoAPxJ
	ktf1jAtkDqdEKWwDGwbX6Lx4DSyoNTJYI1q9vcqaL4fKPbFPUNQOf34mta+sIRHeTJvqd6
	tO4UaUwGrlW6aYh/nZzxp1zsJCZlnF0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-7iRVW4Y2NZSEpHPmxOldKw-1; Mon, 11 Aug 2025 07:27:01 -0400
X-MC-Unique: 7iRVW4Y2NZSEpHPmxOldKw-1
X-Mimecast-MFC-AGG-ID: 7iRVW4Y2NZSEpHPmxOldKw_1754911620
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458c0c8d169so25192435e9.3
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911620; x=1755516420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DfX1fQMnvUejv+2+JWwebv5CirI4aCq8/b8BncrLfY4=;
        b=PBUMPMZP+9GNqWz6b/iK2J2gzzsGp6H9SuYfuzLRsg3voItOcDzEOm+5Tw1Tbq5Etw
         SJpAVyDtYsscnTjCbNdDXr07gEhtWcR0kUJjgJplKaromM/x4A2zDk4RHeGg0rK/wOl1
         Z1lwrxNevu6XrJKtftOcAfs1Z1uvgm6a3k3m+UsWk9PZKfAGqP3RzFGYUKb6NiM4SkEe
         JxxipXU72wSDCPscMIcV/GpxKc60/83sVWWqnxmUT3/8i/7G99lATzfNZWht3+xY5EWM
         nrnHLEbth8a6K1B0MZGn5+aaudQ/Gt86vjtBM+X83UFA9VRaMNbTVCru6GFMbAkCjYCM
         c0UA==
X-Forwarded-Encrypted: i=1; AJvYcCWjQjOzopr6gLY+l0PI1d/dPqq/4RSl5AbyfUW+AebeEObLUVJsmPZ12whMECjodx8K7F668+0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yywn/NViF0uMJ1C1x+PSI7ran2cbbUoxcL+4AR2894vN3aE7Ogi
	g6i8uIQBXBHIcvNkgSZrRo5v8XTpID0Q5hOHqVRA5JbBil6kqlvcbhF10ahO88ZyPIjd5+6Y0tz
	7rclxYYyi6y39yLbl31kOdPEs2hEP/0Na3DZDMBgXgS/dLICdesViKOr4zA==
X-Gm-Gg: ASbGncvNxYVRUQHQvTIOTQBRh4E1nCBPV2IdnJF4obpsrmRheZPNnqEpAhJqjP0276Q
	2JwRzi5RF4P2RCfYIIvxHlIrCxTifBJP9y3lTCV28Hc0zdhojHBuxcMlcJ9BMhWgzVdNLMDkgTJ
	hZoSbEpuM1YnIp0g5mVwFKYmb9Vsw2K+lx3H6i+hIuZI+zAqc8C6aF7zStUtIFXiT0PDhP+WCSy
	jO5n3vJyvbR7IO1dvsxX+WxS+EGgAcgqswTwKmFarzTqKb6YaZXQsecjvqpOLtxhff6g5DVzNmu
	1tyVAWsMDRqE+ZqvNpNTx7+SsqGE+LlBcrA3zInxz2SkZRsbCVajkF+JIPle/F4dYS+muPZi7T6
	Ge5CbDy3bVjVjbx3h2Meu2gVZ
X-Received: by 2002:a05:600c:c493:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-459faf4758bmr80581225e9.11.1754911620230;
        Mon, 11 Aug 2025 04:27:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBm+6FX9Xdf6wc1nTSJlLqt7RXq7PC8peG73SnR2aY3/2U0Fhn5nWzADDyt5hVIbhoPtrtZw==
X-Received: by 2002:a05:600c:c493:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-459faf4758bmr80581015e9.11.1754911619781;
        Mon, 11 Aug 2025 04:26:59 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458be70c5f7sm376335155e9.26.2025.08.11.04.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:59 -0700 (PDT)
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
Subject: [PATCH v3 10/11] mm: introduce and use vm_normal_page_pud()
Date: Mon, 11 Aug 2025 13:26:30 +0200
Message-ID: <20250811112631.759341-11-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: iLTqoUm0wgfBDms_X7dWliY3Yaw42P-T3wvlkoIP1EU_1754911620
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's introduce vm_normal_page_pud(), which ends up being fairly simple
because of our new common helpers and there not being a PUD-sized zero
folio.

Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
structuring the code like the other (pmd/pte) cases. Defer
introducing vm_normal_folio_pud() until really used.

Note that we can so far get PUDs with hugetlb, daxfs and PFNMAP entries.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 19 +++++++++++++++++++
 mm/pagewalk.c      | 20 ++++++++++----------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b626d1bacef52..8ca7d2fa71343 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2360,6 +2360,8 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t pmd);
 struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t pmd);
+struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t pud);
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
diff --git a/mm/memory.c b/mm/memory.c
index 78af3f243cee7..6f806bf3cc994 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -809,6 +809,25 @@ struct folio *vm_normal_folio_pmd(struct vm_area_struct *vma,
 		return page_folio(page);
 	return NULL;
 }
+
+/**
+ * vm_normal_page_pud() - Get the "struct page" associated with a PUD
+ * @vma: The VMA mapping the @pud.
+ * @addr: The address where the @pud is mapped.
+ * @pud: The PUD.
+ *
+ * Get the "struct page" associated with a PUD. See __vm_normal_page()
+ * for details on "normal" and "special" mappings.
+ *
+ * Return: Returns the "struct page" if this is a "normal" mapping. Returns
+ *	   NULL if this is a "special" mapping.
+ */
+struct page *vm_normal_page_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t pud)
+{
+	return __vm_normal_page(vma, addr, pud_pfn(pud), pud_special(pud),
+				pud_val(pud), PGTABLE_LEVEL_PUD);
+}
 #endif
 
 /**
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 648038247a8d2..c6753d370ff4e 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -902,23 +902,23 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		fw->pudp = pudp;
 		fw->pud = pud;
 
-		/*
-		 * TODO: FW_MIGRATION support for PUD migration entries
-		 * once there are relevant users.
-		 */
-		if (!pud_present(pud) || pud_special(pud)) {
+		if (pud_none(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
-		} else if (!pud_leaf(pud)) {
+		} else if (pud_present(pud) && !pud_leaf(pud)) {
 			spin_unlock(ptl);
 			goto pmd_table;
+		} else if (pud_present(pud)) {
+			page = vm_normal_page_pud(vma, addr, pud);
+			if (page)
+				goto found;
 		}
 		/*
-		 * TODO: vm_normal_page_pud() will be handy once we want to
-		 * support PUD mappings in VM_PFNMAP|VM_MIXEDMAP VMAs.
+		 * TODO: FW_MIGRATION support for PUD migration entries
+		 * once there are relevant users.
 		 */
-		page = pud_page(pud);
-		goto found;
+		spin_unlock(ptl);
+		goto not_found;
 	}
 
 pmd_table:
-- 
2.50.1

