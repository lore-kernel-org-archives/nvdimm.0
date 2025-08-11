Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A732D23B2
	for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 11:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754911600; cv=none; b=k1pdQADBb+dtBz8N02+Ylh0Dp01yFQUOB49ifTszVihMFF1pL9vRyU/bWUcRcqJZOxMzMJiBfUPB5c/Vlu0e5irIJepqpRS8M0ftZDqrkttfiqTEZ2OLmwA7GuWHR0eYumN4q23RKP9aX10Y+VNlKl23Q7HMkO2J8My60hO4YWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754911600; c=relaxed/simple;
	bh=r4Efa03mYkk7DOGkh2EZFFjHiYB++ydzXwMc/S5d8gE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=vGoN9j3oxt4SMvUvuKEKm8CWOjprSeJicR2WOTdN7JWAgcV4BNIyjPf4dLRyigkNsVQ04aJnV3qcnrhfKyDBHdTw6iIV8iPYOXnJus8QpW9ySOeouXpmdsBspZkKNX4l4H7TWe4SJh9GAZarQEbsd81xQ2n7LitbREP7n1hji20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b9N4yw0q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9N4yw0q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gjYKWewbFPIH0RV/ky7WxO7hTalH23xVuPMUQKkA/fk=;
	b=b9N4yw0qMi0C8VmE0T8CzhuELAtoRudiBaBzoe2QxuU0jGyQZeVcsguuEgSKWiNTzYZlmD
	Qqbex8QzN7gqvjsJMa1MbWNJJr0hHw1MEWUxVgVlR8Fn/+nFpClSj6NhO3CuAgGkWx+0UA
	FR0tB7Bn/9Vw2hKooJuAhpDPIVgwpUo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-rODslhPTOfGPA3eN9SSvBg-1; Mon, 11 Aug 2025 07:26:36 -0400
X-MC-Unique: rODslhPTOfGPA3eN9SSvBg-1
X-Mimecast-MFC-AGG-ID: rODslhPTOfGPA3eN9SSvBg_1754911595
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b780da0ab6so2167112f8f.0
        for <nvdimm@lists.linux.dev>; Mon, 11 Aug 2025 04:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911595; x=1755516395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjYKWewbFPIH0RV/ky7WxO7hTalH23xVuPMUQKkA/fk=;
        b=WK6h+T3+rsYcOcZY/om5HmXX6HdwV9xcO0rzv5vHn5AXAY022r1IBN2YWY+pTGpE9P
         qRE1IuqZ5/1u3K9V8ly1wBv0foptex1EuWIcTpiIH2ir+RiAk+HWUbAtRghTVNW04llf
         V5VE06In0YLR72lmnctl7FxhDD/n/Xqb/29DPVL7m7pa45IQUoiW0NMoV4bnwKfmE+nb
         w/bKrVDmzWm3MKQxXd0WRIZtUdd2rewTXkmqs15IOGErdWOcnckA9YQwClBl9ehmjg3s
         C53aZAYFr9EuM5N6m+5lcgPnZ97U7H8os4EEFAIzVCcD0mbIRVb8O5AJEYIvICNg3Ig9
         H3Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUMFU9B7At8ZsTgSMYFwcFn7eJbUylccdRUh6WAwx0hHbbpOFWgZ0ZyDe3l7E9MSUb65zKvidQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxmZ7SKe/9JGDuu2uoBSlgt+8SZjlElTLHd1/yxJakoG2gPFnL
	EMvsmOe3OE0e6tPQUf7tvKpZ6THM0omR3Ih68nASccwdCnmYEOnO0Fc3wOIv40ucmIkA3EPIutD
	VHIyHrJfIP5OPshtojzc49siWOrFeZJ0N+JP9ruDAjsXb/hk7sCg+rvtItQ==
X-Gm-Gg: ASbGncsadN76ubIK08JJ575tX9f51GYNJDA9pSaqJbTqe9BMZrn09A9NDiJZbDlm+7M
	fqm0zpy9CkID1hvjQrqrJBRP3FKVY2ud5p0Pq3iVwqsv0Q/df1GyQrGMblAg4plKmFgxIqBCS5D
	LvVIyDroLPXTObbn25kcF06Vah3v7ZSv+95UeKXfGcasxtOJL9swcdPkZwU1PIp5l3QI0zZT7gB
	XBwECTC1swyS0RXWxDj9RCgQD8TB91XilZfZUNzG1MSqdmQtmu+mt0RALk7XLFcIRwd9WbxV8tq
	V8wSO9y9DdLavtQcH2/dagAF1wSobxHZCUAmiZVxj6G0jxKM2JL/52GgDCrvsdIr6DmDFCzqiB5
	9WTJwtlMGv9jHShiZyEe3Hix4
X-Received: by 2002:a05:6000:2f85:b0:3b7:8d70:e0ad with SMTP id ffacd0b85a97d-3b900b4d8c1mr8490173f8f.32.1754911594892;
        Mon, 11 Aug 2025 04:26:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdQyxmL2k0hEit4q6ggWaLK63vDyy/XYp/bptTEvLLiDZ4Kssrq6afY7SHtzCWpxX9HX5tXQ==
X-Received: by 2002:a05:6000:2f85:b0:3b7:8d70:e0ad with SMTP id ffacd0b85a97d-3b900b4d8c1mr8490151f8f.32.1754911594303;
        Mon, 11 Aug 2025 04:26:34 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3c4beasm39217323f8f.30.2025.08.11.04.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:33 -0700 (PDT)
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
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 00/11] mm: vm_normal_page*() improvements
Date: Mon, 11 Aug 2025 13:26:20 +0200
Message-ID: <20250811112631.759341-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EwNtmW8BD4Q6ity6Dv9rHIUbCKw79bAO0GrrNicSnk4_1754911595
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on mm/mm-new from today.

Cleanup and unify vm_normal_page_*() handling, also marking the
huge zerofolio as special in the PMD. Add+use vm_normal_page_pud() and
cleanup that XEN vm_ops->find_special_page thingy.

There are plans of using vm_normal_page_*() more widely soon.

Briefly tested on UML (making sure vm_normal_page() still works as expected
without pte_special() support) and on x86-64 with a bunch of tests.
Cross-compiled for a variety of weird archs.

v2 -> v3:
* "mm/huge_memory: mark PMD mappings of the huge zero folio special"
 -> Extend vm_normal_page_pmd() comment + patch description
 -> Take care of copy_huge_pmd() checking for pmd_special().
* "powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel""
 -> Added
* "mm/rmap: convert "enum rmap_level" to "enum pgtable_level""
 -> Added
* "mm/memory: convert print_bad_pte() to print_bad_page_map()"
 -> Consume level so we can keep the level indication through
    pgtable_level_to_str().
 -> Improve locking comments
* "mm/memory: factor out common code from vm_normal_page_*()"
 -> Factor everything out into __vm_normal_page() and let it consume the
    special bit + pfn (and the value+level for error reporting purposes)
 -> Improve function docs
 -> Improve patch description

v1 -> v2:
* "mm/memory: convert print_bad_pte() to print_bad_page_map()"
 -> Don't use pgdp_get(), because it's broken on some arm configs
 -> Extend patch description
 -> Don't use pmd_val(pmdp_get()), because that doesn't work on some
    m68k configs
* Added RBs

RFC -> v1:
* Dropped the highest_memmap_pfn removal stuff and instead added
  "mm/memory: convert print_bad_pte() to print_bad_page_map()"
* Dropped "mm: compare pfns only if the entry is present when inserting
  pfns/pages" for now, will probably clean that up separately.
* Dropped "mm: remove "horrible special case to handle copy-on-write
  behaviour"", and "mm: drop addr parameter from vm_normal_*_pmd()" will
  require more thought
* "mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()"
 -> Extend patch description.
* "fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio"
 -> Extend patch description.
* "mm/huge_memory: mark PMD mappings of the huge zero folio special"
 -> Remove comment from vm_normal_page_pmd().
* "mm/memory: factor out common code from vm_normal_page_*()"
 -> Adjust to print_bad_page_map()/highest_memmap_pfn changes.
 -> Add proper kernel doc to all involved functions
* "mm: introduce and use vm_normal_page_pud()"
 -> Adjust to print_bad_page_map() changes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>

David Hildenbrand (11):
  mm/huge_memory: move more common code into insert_pmd()
  mm/huge_memory: move more common code into insert_pud()
  mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
  fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
  mm/huge_memory: mark PMD mappings of the huge zero folio special
  powerpc/ptdump: rename "struct pgtable_level" to "struct
    ptdump_pglevel"
  mm/rmap: convert "enum rmap_level" to "enum pgtable_level"
  mm/memory: convert print_bad_pte() to print_bad_page_map()
  mm/memory: factor out common code from vm_normal_page_*()
  mm: introduce and use vm_normal_page_pud()
  mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()

 arch/powerpc/mm/ptdump/8xx.c      |   2 +-
 arch/powerpc/mm/ptdump/book3s64.c |   2 +-
 arch/powerpc/mm/ptdump/ptdump.h   |   4 +-
 arch/powerpc/mm/ptdump/shared.c   |   2 +-
 drivers/xen/Kconfig               |   1 +
 drivers/xen/gntdev.c              |   5 +-
 fs/dax.c                          |  47 +----
 include/linux/mm.h                |  20 +-
 include/linux/pgtable.h           |  27 +++
 include/linux/rmap.h              |  60 +++---
 mm/Kconfig                        |   2 +
 mm/huge_memory.c                  | 122 +++++------
 mm/memory.c                       | 332 +++++++++++++++++++++---------
 mm/pagewalk.c                     |  20 +-
 mm/rmap.c                         |  56 ++---
 tools/testing/vma/vma_internal.h  |  18 +-
 16 files changed, 421 insertions(+), 299 deletions(-)


base-commit: 53c448023185717d0ed56b5546dc2be405da92ff
-- 
2.50.1

