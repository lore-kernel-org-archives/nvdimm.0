Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E12EE607
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175040; cv=none; b=BIbu2f+fZQq8SxtRWRlGMzcIZxY7hFY781cmnBkAq5h/Oz6Pz+wZtTR1JqEfuMOCDyojPUeBVrrG5dS9aHDTR3Urf60kguEzjpXicAwjG6gLqAtGXjZJmK+g6UQ4Z2E9UhPU3BOx6RrEODZ6ACHSCicnIe8gpBlx4nr4tqsMopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175040; c=relaxed/simple;
	bh=N+sqTwgnUIZg4czKbr4/JT7TGmW4bJe3WXX3qzBFdJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=QM9Tv5uwYAnLLNgkyvtG18oTqPi1WQpBoOIepnH5qArjNhKknNKk8z+ULBndYz/fle9i+KHT/MkzbK3/Fe12FTd3uJhFSg6R8/iUJ+LcQZrFcFlI3pwDxiDetHjUEqqK2ti7BZv67NPFtjD8jSKCIReUDejJ0GGAbc9a9boWQ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4X3q4+t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4X3q4+t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n+enD/DBO3lH97hAndG2Fd7ZdK35XEPxGRz1KxKwpT4=;
	b=E4X3q4+tNi27+DtzxEdW8SQpaVXkLEkXxhtHVjQyJkuWGtA9gxIN56EIHCWlR+Qq0heaY6
	p76znf7oKnt/BMScs90mo+jZIaN1ipMRaXsIbv5HznAoS0KHJSYKdz7rIY/2P12d3KNhYS
	hlhr9tmEPRVjWPHtVVw7nDrI2cCbWaE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-57xpEUD4MTG8QFfpQTmmIg-1; Tue, 17 Jun 2025 11:43:53 -0400
X-MC-Unique: 57xpEUD4MTG8QFfpQTmmIg-1
X-Mimecast-MFC-AGG-ID: 57xpEUD4MTG8QFfpQTmmIg_1750175032
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450d57a0641so41837715e9.3
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175032; x=1750779832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+enD/DBO3lH97hAndG2Fd7ZdK35XEPxGRz1KxKwpT4=;
        b=cuZKwUM+Lc4jgzjy87JZaEBITl+aaR3Y3bGfWt/KoDL6yIHK4Al0aBJGpQc38XZtoi
         y65n3HRCeeLB1NRedOXrUoRK3XqUDV7U8xPpYtjSiQoj1ywYwzyQ98mYeB8utHcCKD9G
         rBvoB9wfEZc8Vj/BV4xabeDht6QsSro2iOZEUOTg6wbXgCp7XpzwXXSWYnuEprTKHkor
         BSQ8t6bLJ2f2CtJ8kxiS3nNNi7WCpUcsvIiFhUP5a7/5ZSWRK+YGlGpCcsmJMxXPlWoZ
         0Xl3SuPXPHKU2nhNIlGHLSchJwAGZPUZ5phxLaSC8GRYyat6xh3nrB6JAfVsxQlZKMbs
         5REQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMu0CVuRiVHgdOXi/qssCPwxrA5k84nRjesCiZXIzKEoEA7mCRPqW2mUQIKs3GIVekkAO0b3I=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywq0apRsLtnkuNLQ9ZAIqm1H48fSq8iNKVSigSkmd9yf34lEelc
	vpocyYi526P2EkWVQfsuaoMPkj/6hXGRS31JFZv8c/ka0RjB0S2Ji+Lfkpnk8nlDYRa0KJVbodO
	JgroMjxiYHa/3GASKaIj+SWbj6zxJuJfracVWymwXzwnKr92uAR9NJa6QEQ==
X-Gm-Gg: ASbGnct6v/9DlrW5TGAgMe3Q64QzuzPqbU2TtnpQFR+XvIOQO3kGZ6F6Wwkn3/nL4Jy
	SAJ1+IJ4k1jY4Jy40BUjoilbWOK2bYYr5dR8aq/S7K21WQmz7goiuGUdb9T12dWV29fTWE5i+wm
	GhID3aNU2rvAxgeaWmjsH81L7iey+58uYEpHQyDl9/0sNyLbYgdaO2bPBJr1mevMSN4zSpMvkZg
	RtjFKCSGBKq/CjK/cwiQcruy8XXjJ4PTc5kFq8G1qzMznJlX5Is55Q7geSIBfbkW/Em4Zp7nJ1e
	DYjUDWKP4Y2tlwgb8UyJmR+krLlHG9n/69+neqtRBDKLCZHSE/Evm6mG43db/o4MZ2HGzZ5Jm8c
	OscBqQg==
X-Received: by 2002:a5d:5847:0:b0:3a5:1c0d:85e8 with SMTP id ffacd0b85a97d-3a57237797bmr10355621f8f.22.1750175032033;
        Tue, 17 Jun 2025 08:43:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgGKPI0HPFQFNSDiU1UoCT4KWg9jjW+HS33TdpBy2263RBIYIhTEc5b/vsOH/vxH2erO7KQw==
X-Received: by 2002:a5d:5847:0:b0:3a5:1c0d:85e8 with SMTP id ffacd0b85a97d-3a57237797bmr10355602f8f.22.1750175031623;
        Tue, 17 Jun 2025 08:43:51 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a568a547ecsm14548596f8f.17.2025.06.17.08.43.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:51 -0700 (PDT)
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
Subject: [PATCH RFC 02/14] mm: drop highest_memmap_pfn
Date: Tue, 17 Jun 2025 17:43:33 +0200
Message-ID: <20250617154345.2494405-3-david@redhat.com>
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
X-Mimecast-MFC-PROC-ID: 9vaTr4sWg8TSJomicRFfKXC_-mJCO7Djcd2qYFSJvZ4_1750175032
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Now unused, so let's drop it.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 2 --
 mm/memory.c   | 2 --
 mm/mm_init.c  | 3 ---
 mm/nommu.c    | 1 -
 4 files changed, 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f519eb7217c26..703871905fd6d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -503,8 +503,6 @@ static inline bool folio_needs_release(struct folio *folio)
 		(mapping && mapping_release_always(mapping));
 }
 
-extern unsigned long highest_memmap_pfn;
-
 /*
  * Maximum number of reclaim retries without progress before the OOM
  * killer is consider the only way forward.
diff --git a/mm/memory.c b/mm/memory.c
index 188b84ebf479a..a1b5575db52ac 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -146,8 +146,6 @@ __setup("norandmaps", disable_randmaps);
 unsigned long zero_pfn __read_mostly;
 EXPORT_SYMBOL(zero_pfn);
 
-unsigned long highest_memmap_pfn __read_mostly;
-
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b2..1dac66c209984 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -881,9 +881,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 	unsigned long pfn, end_pfn = start_pfn + size;
 	struct page *page;
 
-	if (highest_memmap_pfn < end_pfn - 1)
-		highest_memmap_pfn = end_pfn - 1;
-
 #ifdef CONFIG_ZONE_DEVICE
 	/*
 	 * Honor reservation requested by the driver for this ZONE_DEVICE
diff --git a/mm/nommu.c b/mm/nommu.c
index 38c22ea0a95c6..cd9ddbfe1af80 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -42,7 +42,6 @@
 #include <asm/mmu_context.h>
 #include "internal.h"
 
-unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
 
 atomic_long_t mmap_pages_allocated;
-- 
2.49.0

