Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D662DFF06
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175054; cv=none; b=UKHCJ87M63iHpImRvrgxlRz7GbO9lfLw5/kKe5MjjqOLeNVwkDTvcNVcxueSiZ8y+9na0HW5pXkt+nUO/YWq1FQBfWWJrr4HkDjbYtG7J4mWv36uZ1Yw7DZIQF7Yv0FNUNDgsPrD0IZnhLp38BNFO/ut4DAN3Sv0FZCn/aY6sFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175054; c=relaxed/simple;
	bh=8LbU7WHsSEUDC9XyX0d6DQNa5JIUja8IK4JgIC3/fqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=UZDtWo/uzgR/XgYZ3R0/jWZOpZUIPaVpXZNDCSPfAyHBWd8AzSsfnB0pnM6faclS4Bm1pa5PQInnKyiVTlDr6Q5Mz+0HaGrzKoq/GzFkHbKqFS5vULAGRgL8FsQNDpZtXv1cTnJRsHg4MUV1wQyEL/rAzLrSL09dGnWhJb2QFrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OqiiKPJg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqiiKPJg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPSX3LBtUNEGTHSkguHJQ+rqsVYvGpTDP2rR8uKdQH8=;
	b=OqiiKPJgGjwJvnyHCQ9bW3pWGxsDQtnzRHGZtpFpkrAwwPysza+JZG6oLXQWYs4kI0gQkM
	DfkyVnH8cUEG4SsVxJRqMjIctx6eX3XIOUM8htIhr5od94Ud/KRB60yMMyPpSLNVyhc2ko
	FklImE9++mn4oreUwQt4CgL4aFspaJE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-d6XGxU7vNo-GiAJWUDR6VQ-1; Tue, 17 Jun 2025 11:44:10 -0400
X-MC-Unique: d6XGxU7vNo-GiAJWUDR6VQ-1
X-Mimecast-MFC-AGG-ID: d6XGxU7vNo-GiAJWUDR6VQ_1750175049
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso3623599f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:44:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175049; x=1750779849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPSX3LBtUNEGTHSkguHJQ+rqsVYvGpTDP2rR8uKdQH8=;
        b=X8a3au9IVHj+LjbedU8STGD5Y2LxKllolAYAcospysb7zyKvokWOiEkOMBxI2puui1
         rrzt8cU4mUYEaFbUDa+Dhfh2o5FrxdE2sxHowrQ9bps6yKj4xgkCij3pZ9j4V38Sup6g
         EErEYWUX/nysni1k591QP4H3VUwRY5iXO5a+6s4SpC9rhpSzRrfFzz62MFocfREaNzbF
         jEbM3vtXKZOkQ1rK/SYqnCH6jeqWaYq7+y1Km7+JsuClGAkmTSacj52o+ddtDXRtdo63
         kvuQAqaM4AL6DSsu3B0qU5Uj2WdeQKODLyBxxmfSulcTkyQdiu+Og0d7k2EtxPyxIJIu
         eB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVlbexAfmD/cZf5rdlMvggktqQZY9xiNENaH7NU9eWDuF6Tdb88ZoeNHzxQ0FZ1Y3tkmr1xXvQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxuz+JCjSGd6hixilWOPNo8JYsS/fzaKlm1+wTKR3wrixy5irn9
	NVTkBAWonbLDCJzTOTlTS0AegpUZFJqDhqUFCiuyMifuwjDsktr7W026Qy1dveICBCOHafiGFZB
	Tyj+SPpm8pSBEELHiTgmNlJMihfL/lcQElksfspF1Ce+0j5sSDia8kXi+GQ==
X-Gm-Gg: ASbGnctqaUp0vNO8S4mcfP6/8aHgUeGB6dqV6RgkDKlhwlwFx3wx6kY2wjC+C9+80Bz
	YV39YkEnP/A/Q8a6rKs+pKREYOEtEZvupOQFR22TqSFhf/RiV3HTt7qKAM6L78GYez10GUzNxUu
	62p9+xdMefcz4DOg6W3HWEWP2kk3zax00Or1GbiCQ8ONMP4BzBFNhqF9awUtXWHWTdprSkNPEPx
	bCM8Ox0z64xFEb8l540Pd1KD/TLqHcFrWF3oW4DgpE2/2B5j5ul4XCi4QJm3o1EGJsoOdlZuHbJ
	HQ1WPVnx8NCYGhJ7T7An9X9rF/vktT+cI2qIbOOOL+G7xL9aBIDZz4iHlT6QC7iFIV8tebfb6nm
	WSIDOpQ==
X-Received: by 2002:a5d:64c5:0:b0:3a5:2670:e220 with SMTP id ffacd0b85a97d-3a572e6b9ffmr8898795f8f.32.1750175049008;
        Tue, 17 Jun 2025 08:44:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM5m+wJRDUa8DrC/K/257QBXTR6G19KsTYyK8OpbCkrMRqwW7zfUBGXG+Jg5gfXSGV5z4C0A==
X-Received: by 2002:a5d:64c5:0:b0:3a5:2670:e220 with SMTP id ffacd0b85a97d-3a572e6b9ffmr8898776f8f.32.1750175048645;
        Tue, 17 Jun 2025 08:44:08 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568b1eb9bsm14491105f8f.69.2025.06.17.08.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:44:08 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH RFC 09/14] mm/memory: introduce is_huge_zero_pfn() and use it in vm_normal_page_pmd()
Date: Tue, 17 Jun 2025 17:43:40 +0200
Message-ID: <20250617154345.2494405-10-david@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617154345.2494405-1-david@redhat.com>
References: <20250617154345.2494405-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sYk2wYQUMPk6Mp5QBxKOIdgQsaydlVdK7Awh16p8fqg_1750175049
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Let's avoid working with the PMD when not required. If
vm_normal_page_pmd() would be called on something that is not a present
pmd, it would already be a bug (pfn possibly garbage).

While at it, let's support passing in any pfn covered by the huge zero
folio by masking off PFN bits -- which should be rather cheap.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/huge_mm.h | 12 +++++++++++-
 mm/memory.c             |  2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 35e34e6a98a27..b260f9a1fd3f2 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -483,9 +483,14 @@ static inline bool is_huge_zero_folio(const struct folio *folio)
 	return READ_ONCE(huge_zero_folio) == folio;
 }
 
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return READ_ONCE(huge_zero_pfn) == (pfn & ~(HPAGE_PMD_NR - 1));
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
-	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
+	return pmd_present(pmd) && is_huge_zero_pfn(pmd_pfn(pmd));
 }
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
@@ -633,6 +638,11 @@ static inline bool is_huge_zero_folio(const struct folio *folio)
 	return false;
 }
 
+static inline bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return false;
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
 	return false;
diff --git a/mm/memory.c b/mm/memory.c
index ef277dab69e33..b6c069f4ad11f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -669,7 +669,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 		}
 	}
 
-	if (is_huge_zero_pmd(pmd))
+	if (is_huge_zero_pfn(pfn))
 		return NULL;
 
 	/*
-- 
2.49.0

