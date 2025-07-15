Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D722E4246
	for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585845; cv=none; b=Nco7onzj1bLn5qn0WwWk7d5PE5FlIESShzIK0WAQiFIc7mU3FWMENPbXAwqF6KotrJ5ohkfVKMRMyoqukKLMKE/F7EqMbKmW11vvkkD77VZLGUg61WI0U7/wySp+6DHayNf/odf4RdQL5TfxAgXAMUrQlht2IvCIZaFxDUE8Q3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585845; c=relaxed/simple;
	bh=2xbQ3r+7QPHP9nmWWSES1W7hjLDjnCzsHuStzPREuqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=SgTB6DMxL3tWkKxIUyQatZtKiroWUwqjZnr2WedXapCJ1JpCgm081KtM68KBpKZSraW9QYqoqA93xdIlFBkLm6NhD29Ya9YhZpzHAXk5LNS0qCxScY7/cmudq9lMBFzWBE8Q7eW9FoSlEb4Pzj1sHz6rIfEoe4u+VU+3Gw92S/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ES2DbM6k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ES2DbM6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752585842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p0W1gu/DbwB3HO+Ik7b3ciKtc0XnhekWlhthG95RGc8=;
	b=ES2DbM6k93F7He+Avf+w57uFeYf9327Rd04uycw+lYlG8X1QjXtz2KUliQqIw32kYIMa2J
	cg/juIaruktU7VTfLoZ2J5XYAE+ojhrdnpmpog5Uq5FazBuUjTRegU1sXZctVrdZ+15r1S
	Yn9EXoU/GLagiPOFa+acXjowP6lgX+I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-cJUnBnCWNCe7j4XVK8XVng-1; Tue, 15 Jul 2025 09:24:01 -0400
X-MC-Unique: cJUnBnCWNCe7j4XVK8XVng-1
X-Mimecast-MFC-AGG-ID: cJUnBnCWNCe7j4XVK8XVng_1752585840
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4561dfd07bcso10962985e9.1
        for <nvdimm@lists.linux.dev>; Tue, 15 Jul 2025 06:24:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585840; x=1753190640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p0W1gu/DbwB3HO+Ik7b3ciKtc0XnhekWlhthG95RGc8=;
        b=KXlvshj2MysFyjXq8os3aC4lTg7r/M2LAr2uZ+9+FfpYkD1guSIMO0tgWK5SP1LnXe
         wGSygbTkjuA0UqPID+mAm3TLelOQrGBygNNbA4TiLMKxKtsCO4RBjNZs0xd4J//wgKNb
         MXXuAwHDNZqyFQhw6WywyPoa2n0exLuo/Qt1hQiLdjkWVafV/3WiZu62bEjtb1Wj7l5v
         3t0I6EGOWu1RqdB4qX3rTk8LqaINH1lbicwucij4c3Op+wE/SD16Md3eCr98RpN/fCGv
         Q4nD+9EyKoPurUNqBhUuGqW39hd9h3neT4dUrS5NtO8SjOroWZtsS8lSN42ksyufuyAu
         +Hpg==
X-Forwarded-Encrypted: i=1; AJvYcCV/66LY30dbAzKNZyPbJNhnvno0fFh1uZ5qeThGscriY0bdcMSD9NekXo1H/uZ6F+Czt74n+Pk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHEcvd6uiccrttr334D9sNCNLTF1BQ08SxQfF6uXsGWcsxrrjn
	r5nC06J+eSDJDJsxHJGMWADv7DqCEOvbGUqAs3zoSXZLbSalLSfX0gv7vsDHdunMPJx3KrIAAvQ
	i4T2+uvCDbDlqqgBfhb0wLtn1BjuKL4LUNkdir+HD4ATINYB8KNeOxFXeYqlsQ89NcD32
X-Gm-Gg: ASbGncuOBgtBnwiqrXS0LgPwZyhOa25IfnQQT/8EktFCAIzuwQX836lfiw4qdcQ41xN
	QkbeWBfC8bkrMoaZk3GgDVQjxuP3BeQQeq5ERWx9M4GM4X947o6VigIKhcwq9qpriyYNyLie1Ag
	RuCDiuwXdBqbNN+MurQ/HiAvaXTE5tZsv4MzVXfJVUR5zIxmD1h9aW/CRuB+2VARbnVeZlixYNX
	3elnYlY+y/I+/C2Wn6YDP/Lu1jbCgGgzoP9AXhXfgZ3EgU9TqZAnbfajJv3lUlGMLEx07t/mU4W
	P7ZfY1o3rWF/SD9wvGDGGL9CvWssoFbea2KfHlCZc+d2SVYzluC4IFGkWk4hcwKMTVGEnb2qIXZ
	4j4dD/U2UH7RwwToGxYS3SIyn
X-Received: by 2002:a05:600c:5387:b0:456:76c:84f2 with SMTP id 5b1f17b1804b1-456076c88c8mr137334175e9.30.1752585839883;
        Tue, 15 Jul 2025 06:23:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYbWegCM0S6a5gfkNemwi6OlAVodA9645Tyw+PVXIOkDyOGbitNWxrBtqQg62ekGoPNGMvNw==
X-Received: by 2002:a05:600c:5387:b0:456:76c:84f2 with SMTP id 5b1f17b1804b1-456076c88c8mr137333805e9.30.1752585839359;
        Tue, 15 Jul 2025 06:23:59 -0700 (PDT)
Received: from localhost (p200300d82f2849002c244e201f219fbd.dip0.t-ipconnect.de. [2003:d8:2f28:4900:2c24:4e20:1f21:9fbd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45617f18d99sm69437455e9.8.2025.07.15.06.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:23:58 -0700 (PDT)
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
Subject: [PATCH v1 3/9] mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
Date: Tue, 15 Jul 2025 15:23:44 +0200
Message-ID: <20250715132350.2448901-4-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715132350.2448901-1-david@redhat.com>
References: <20250715132350.2448901-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s-3WkRW_mX4a6V61R8YF8Qp1bcuP69cEHxBIW5CXmRY_1752585840
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
index 1c4a42413042a..9ec7f48efde09 100644
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

