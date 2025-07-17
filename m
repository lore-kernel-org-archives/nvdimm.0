Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2269129ACF5
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 11:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753141; cv=none; b=FqMfXotNxbo8w4Wie9tSk2LJ56a8ErABxN9K3OFf48trT8hkwHhgtzw5oQQPeEZWXvpCNLgM/2BpIc2Qiqm1di4Nl2cuoitpO7ssoNBFhqN8/3tuzl38FueCO0R9K2P6C/rSJSDbgm+30d2bNXmNvIyWsV3oKew/O1SZ3LmtOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753141; c=relaxed/simple;
	bh=dtRUOAXiN1/I2SpevfA/V6KnAReUthh4YQsh0CcAkEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=RwwSI5R46B+ALwly0rJCWqSaQjHW5rFFG9FYGOhrWUXGOBRAoZ7/td7X1fSnGtup8AjsWNTNOJX8/WWxlz+DqmtkGlvJ9TF1nY6RGbh9DH93Mqwywtm3I3ebxv5wgqErojEQN7tQIGc13xTyOyqJ3bDOHYxqdxLYrRZ26zG+o8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=auEQdSC7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="auEQdSC7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752753138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8sA1/7fJchUOMEyFR6/9XGM4JcADGMS+VMGQR+LVY98=;
	b=auEQdSC7ScenFmFdRGu7qIfq7qLkHTPRvtZEaByl726V40loiUtyRGU84zoYoaO69KlyAD
	lyazOEbaFepDjypGIEoQ3tDW3wDeMn+LT6FYjQhR0Dx3hn/5bIjJTDNqBdvAY1GC5lsUB6
	rUylP161O3blAQ1cAIuWPVOzBHnXeRA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-nilblUm8OHieLWB-soQxjA-1; Thu, 17 Jul 2025 07:52:16 -0400
X-MC-Unique: nilblUm8OHieLWB-soQxjA-1
X-Mimecast-MFC-AGG-ID: nilblUm8OHieLWB-soQxjA_1752753136
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso7505395e9.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 04:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753135; x=1753357935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8sA1/7fJchUOMEyFR6/9XGM4JcADGMS+VMGQR+LVY98=;
        b=Sosso8sHIiRXllO7TRVzg8MNq+IyKuSwpTI78EBgUxZ8ODvwFj8rZhwRPKxgeTgn8P
         M9/YB0wdC4AfYweToH1WAOij4HdCUqsIu/dgpOLcJcVRf66m1qxiJ6iX9pQOa5+U12Sk
         qysk52sa1+zuovLFpPEmptx8BpqIMzGCMiqqjLmLL1kjrBnqcPb4pGyOLZgWyMF06obg
         rpOoTuFoKnrtuxbXEUurdor7Eqi1nly5rcDMdJGRWazUxVbdcFRB4xygH9AxVwnqvUyI
         BZxqmpRZJ9neaBMwGb8CbUKFxdvjjDkkCl2S1wlFI0mSRbTA8bPDMcr8WqCmWttPZdZU
         VuNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKl+2iL2rBQTebWnKx5AZ+1il7RRjILQ9t5g6K3X9ENkXOY3npj9/gO31xv6vgW7FzAiVoikA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSWRdC7ZWfIoYgmMIy9qfJs19q00p4oHAIzbWIXfL3U84HDRhs
	q6LqDWTgNOPUdA60nmdn0qOnZ0kZd6PpNV4zZJkQXnMlz3kCBPHsRTrBQg9ywm0lgmXoXdEkhF3
	inF/98167j30K4oGczrqsn5k5qho8lPN77+kzo3h1JAaMMazLKgNFypfeTGPqIwO4WIi4
X-Gm-Gg: ASbGncs4V6UYmhe3nkDPSLMtd5GGZ+CndQY6sRvBLIb5YteqfcHx3s3reEcEhzXPNnw
	fC8YMBrPmJvJ+0Wn0254sXCdTLbincOBBNhvvNDxrmWAw+SGK2LBa30wYWKVhI5CLwrwfoT3DAZ
	qLoJkNYyAlMG1so5zvQ1rp+ZVpD54ub+RjwzxfgG8G7Dap9SdQxGtFlvLBdPmtgqtL+5mu0VENO
	WTuQFkBY7AuG3uFkPa/xb5V36BmyOuBW/ezBNGuHSwmup0nLAu9KKOckBGRKk349ywhIhOvYEJP
	x/5yLFcmN1V0WrSX6IKa7Puivr9xTa0Nj4upkFPBrsSJ5RazZWgmoISJrCyssCQpkVKX3OaP/iE
	7Q0RBAlTgrEfntl/3ernXULs=
X-Received: by 2002:a05:600c:3b15:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-4562e36c7b1mr56529645e9.20.1752753135439;
        Thu, 17 Jul 2025 04:52:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/rOiDh/w9bPyIOHiP0sGPa++157liovsPLJqB62Hs3kS1lvQT8E6z4/Thjm3n+RdALYGJuQ==
X-Received: by 2002:a05:600c:3b15:b0:43c:eeee:b713 with SMTP id 5b1f17b1804b1-4562e36c7b1mr56529205e9.20.1752753134877;
        Thu, 17 Jul 2025 04:52:14 -0700 (PDT)
Received: from localhost (p200300d82f1f36000dc826ee9aa9fdc7.dip0.t-ipconnect.de. [2003:d8:2f1f:3600:dc8:26ee:9aa9:fdc7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45634f85fd1sm20282385e9.25.2025.07.17.04.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 04:52:14 -0700 (PDT)
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
Subject: [PATCH v2 0/9] mm: vm_normal_page*() improvements
Date: Thu, 17 Jul 2025 13:52:03 +0200
Message-ID: <20250717115212.1825089-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dUuFWreahv6d-fqlDeSZjEp_oCYMoL0MZu-K7UdDa-I_1752753136
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on mm/mm-new from today that contains [2].

Cleanup and unify vm_normal_page_*() handling, also marking the
huge zerofolio as special in the PMD. Add+use vm_normal_page_pud() and
cleanup that XEN vm_ops->find_special_page thingy.

There are plans of using vm_normal_page_*() more widely soon.

Briefly tested on UML (making sure vm_normal_page() still works as expected
without pte_special() support) and on x86-64 with a bunch of tests.
Cross-compiled for a variety of weird archs.

[1] https://lkml.kernel.org/r/20250617154345.2494405-1-david@redhat.com
[2] https://lkml.kernel.org/r/cover.1752499009.git.luizcap@redhat.com

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

David Hildenbrand (9):
  mm/huge_memory: move more common code into insert_pmd()
  mm/huge_memory: move more common code into insert_pud()
  mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
  fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
  mm/huge_memory: mark PMD mappings of the huge zero folio special
  mm/memory: convert print_bad_pte() to print_bad_page_map()
  mm/memory: factor out common code from vm_normal_page_*()
  mm: introduce and use vm_normal_page_pud()
  mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()

 drivers/xen/Kconfig              |   1 +
 drivers/xen/gntdev.c             |   5 +-
 fs/dax.c                         |  47 +----
 include/linux/mm.h               |  20 +-
 mm/Kconfig                       |   2 +
 mm/huge_memory.c                 | 119 ++++-------
 mm/memory.c                      | 346 ++++++++++++++++++++++---------
 mm/pagewalk.c                    |  20 +-
 tools/testing/vma/vma_internal.h |  18 +-
 9 files changed, 343 insertions(+), 235 deletions(-)


base-commit: 760b462b3921c5dc8bfa151d2d27a944e4e96081
-- 
2.50.1

