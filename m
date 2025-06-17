Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B522EE5FE
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175039; cv=none; b=Ybm+L7ZOxWJ0B3JaGST+QrmnaZhLbs/MLRAdI0QLg+2xo0/vymFqNX/OB18aWvnoZ4mOgx7tqBsb8pe14t5r/L2ykDlxB8zmsq6pv9llYmqPdUAYIhOKWf1uoNCQN6iKmH31+Z1xw50qLahyQXtuwmu4Eple5NsohRw4X6KhrRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175039; c=relaxed/simple;
	bh=QWNOR+1eFkXIAwi4188jXafhSE+uLJ9EpozLL4/g7bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=VS037c8PCyU5ov8NQvwuw3VnqI/19VoViqq7b5QzjFeh9XC7tberGj/j6mpDH7K+SO71LwtuUGvxwu1c1GJPNDd8usCW3qR8DBWi2IICitHui7Y15aIrjaiqVc4EYc510utgj3xjXuuRgPX3F66jsj48jyVjc84Pi3vsIhjw/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Upe+L7FX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Upe+L7FX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIojkghjiOfK3qS9mo4araH3tv/iIJHq9NK1Pu9RhVw=;
	b=Upe+L7FXOWJSuAHfnC8SjYfPi2mHvo953OYVlWaq36O87aI3ss3qyoJzh2jWdfjW8+nxgs
	YQRSi9RgA08otvj15Ohgfw8kmQYZgonAVt10PyjlMPA8eorYv6nMKnZS+bprVMpn1vHqAL
	cr/6HWgA4I6tTStXVzPQLuZkQTvCqJM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-N3_bsydLNdmfzDDEoyDuAg-1; Tue, 17 Jun 2025 11:43:55 -0400
X-MC-Unique: N3_bsydLNdmfzDDEoyDuAg-1
X-Mimecast-MFC-AGG-ID: N3_bsydLNdmfzDDEoyDuAg_1750175034
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso2412961f8f.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175034; x=1750779834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIojkghjiOfK3qS9mo4araH3tv/iIJHq9NK1Pu9RhVw=;
        b=cXT5GAmF/QsDZFNS8fIX9/DL59I9WNWcC84ODnJhm+QTCjiIwROvnPRAjY3Ee4LN5a
         UbB0v0r7rLsVCuBcHz4iyEqGIJw6wYyAuYYx59FhDXX+5iDcNNaRbz/z7MpvROGbOd9E
         6uX7a6IvoteeOJEvU48CF/C7bJNfMuMfUgZ85AAaHchdlaYq9Fjg47sBBl4C2VFRzdWw
         /3vc/F04WVagI8StSr0d5jjX7BGMhU0I8Nji6TfNY+vkmiNg9KkKzdZiymbgiegT5gHK
         uG1utLImyDuogs5XdLHyH9wTtMKrHzihOw17yha0JC7+3EMxNIdeaGg/WJBYgbTbRXDQ
         U+nw==
X-Forwarded-Encrypted: i=1; AJvYcCU3XsYMKL+508UDWobl8d5x8gCoafI8d9WOBlMwS98oWnt/g5FZAh8bfZ75BakiTaKsqpvAHZg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjPh8/tqHW2/ozeIsZ7USMjlXusB/APHUtGwlwLL+e3s3LXFdu
	YNkyRoK7JbqphOhWFLLSQYc0x/yVBstTnyn6M4XQOQjDAtSqczWbzHFFugzW5JIWbbeFsv5MqbZ
	4E4iRh8LR10LAiCjDoZ0jj+MGqwfkgsKvUlj1BTa6pefSoohBtW+nwHyI1A==
X-Gm-Gg: ASbGnct5IWgBl2GqagsF9eQKpu3EtZr+9nJomAgdykxLtua/71hVQt9r3ZRxsUM067I
	6FF2qz+gMQzKainiaOcIs1aVxIx33QU/TrjKz+wWXjzGVdbqHdgjy2hJYAy1a5C2iDKUZMbHMiE
	O91osMEvpjamdzKDmBjnvIhPyu2nBJ/Vbxfg1HvRQUwlhkSi4XiLxANhFrb8T3eEwZmUbXW5ltJ
	xIYwA+U+90slERBUIrSNFAKkdW8sZjRI8Lb6tyCqZ4dOym9yYB9GNfCbUX6JQ2Mrq0F+gzf2Uri
	F0YTteew/0WNiCdRtgRtSN/QUKDkd0e5K6zJsXwCBv+gYfykoJnqWvAXU9moIT6ySoMM/GU9uqe
	5QO8uVQ==
X-Received: by 2002:a05:6000:178e:b0:3a4:c909:ce16 with SMTP id ffacd0b85a97d-3a572e92862mr10792700f8f.49.1750175034351;
        Tue, 17 Jun 2025 08:43:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuUUJS22/cv8lxbktZwrzLsxc7yFEH6CvMGkxQ5Sx5aQp7V5zrRMyeFF5jQJ+MyIsqVh3uOw==
X-Received: by 2002:a05:6000:178e:b0:3a4:c909:ce16 with SMTP id ffacd0b85a97d-3a572e92862mr10792665f8f.49.1750175033907;
        Tue, 17 Jun 2025 08:43:53 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568a543d9sm14118342f8f.5.2025.06.17.08.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:53 -0700 (PDT)
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
Subject: [PATCH RFC 03/14] mm: compare pfns only if the entry is present when inserting pfns/pages
Date: Tue, 17 Jun 2025 17:43:34 +0200
Message-ID: <20250617154345.2494405-4-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: UccTI0S5LetYkI1uAKx9IQCZkjAoCH6HSHGu_wRatD4_1750175034
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Doing a pte_pfn() etc. of something that is not a present page table
entry is wrong. Let's check in all relevant cases where we want to
upgrade write permissions when inserting pfns/pages whether the entry
is actually present.

It's not expected to have caused real harm in practice, so this is more a
cleanup than a fix for something that would likely trigger in some
weird circumstances.

At some point, we should likely unify the two pte handling paths,
similar to how we did it for pmds/puds.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 4 ++--
 mm/memory.c      | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e0e3cfd9f223..e52360df87d15 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1392,7 +1392,7 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
-		if (write) {
+		if (write && pmd_present(*pmd)) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
 				return -EEXIST;
@@ -1541,7 +1541,7 @@ static void insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
-		if (write) {
+		if (write && pud_present(*pud)) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				return;
 			entry = pud_mkyoung(*pud);
diff --git a/mm/memory.c b/mm/memory.c
index a1b5575db52ac..9a1acd057ce59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2137,7 +2137,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	pte_t pteval = ptep_get(pte);
 
 	if (!pte_none(pteval)) {
-		if (!mkwrite)
+		if (!mkwrite || !pte_present(pteval))
 			return -EBUSY;
 
 		/* see insert_pfn(). */
@@ -2434,7 +2434,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 		return VM_FAULT_OOM;
 	entry = ptep_get(pte);
 	if (!pte_none(entry)) {
-		if (mkwrite) {
+		if (mkwrite && pte_present(entry)) {
 			/*
 			 * For read faults on private mappings the PFN passed
 			 * in may not match the PFN we have mapped if the
-- 
2.49.0

