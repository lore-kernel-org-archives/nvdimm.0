Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660A72ED154
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175034; cv=none; b=rdI9TE9Lrirnzf/0lgTNcKgoTFXz8fDTrFYpSr1aDwx1sYr9zDFANH/eV1cY8258IB6Q6jqyvP7rU7qNfikOHyi/xWe0To1sljWzfn2wfI+jPu9rrdOfZKknPDJUl77qqqzFAmEcwEECOFmaSx+CR6OnxA9FmSidXBCkJul3s64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175034; c=relaxed/simple;
	bh=2ze2ECfE4GnTjyP6rEsgveirYn78B01WAaefPYHCdcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=u4wkRBiwu33pS7+Wv/6fHgEwfSlRE/a4gw5cXceXf1dgOkm6Ak1xxWlzptRApezTyIehkf8lRw+0R7zq8Sr2qeselLVljhXcR69lpR8mGSTk8hgDLoFVx/QPdI4F+isE6ZuqKzoMIF+R+Q9nOcyvzKohxNLStVxjm4L27mp7umM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPKWQF1A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPKWQF1A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750175030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S9sktOEUA0QA+KblClROqq+S/PHaRyGhmuWOY3/6T7Q=;
	b=aPKWQF1A5qiXo0ECsTwmNMFFjogae4F0POpAza99obTQzVwJQmIfPF+pleZJ7E8MP3AGMD
	wkU3XpWiyUEJMbVeVTZ61Cnuw5EY4Y2LlkvrwUWQqPnc8wiDi0YISZ8kxpm6dQH+dGbznJ
	dOtWET6hZk+Udnf+hsHukFT3aAPn6yI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-Kv6dGvirMuWYwCTh6vbrJA-1; Tue, 17 Jun 2025 11:43:49 -0400
X-MC-Unique: Kv6dGvirMuWYwCTh6vbrJA-1
X-Mimecast-MFC-AGG-ID: Kv6dGvirMuWYwCTh6vbrJA_1750175028
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-453080e4741so48147035e9.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 08:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750175028; x=1750779828;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S9sktOEUA0QA+KblClROqq+S/PHaRyGhmuWOY3/6T7Q=;
        b=POpoW34HcOO0731tQH9Xh60ymowZJaHieVKidDILC5sqkof3/XTVcYB97bl3Izq0Z0
         +50zeBaB/CYEX11yU9it1yUhgLtXNYkyw9aPjruRilXmWd9/F2NJpqUOKPakV2YKgbmJ
         Ixm/IZX6Ggu11n8mm49BtKx+BMZrpXhd/Gg+vBOIBghhfiIZdQjNTkPEUVWdSz9no/dZ
         qwZl0JlN1FcBXZmZ2IJ2T4abeMon/uQdxBXOuAX/BWwqd4HHfqsbAbsS6CuGLmQ8pUL4
         7ipaZkMjKwpvO9VJEmC4Dv8Gh/viWXBIMvkc+YuLzbKCU63mI+pDYLpxzg3hwkeQCqfH
         AwEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/aU0dsetxPhqfSNnTyCVrWT6XZ7Hm0eqLN+rr6hIByl9NzorQ1H2ONyNPoZve1dSZ+PT6zdk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6gBYkSVdnrhVpR/ae9NQRRCjb9OxEjAiMmtxS9lZnNHElX0sO
	1ZRM0memZalTyJVNSC4i+XdqsRiipKDd+8zt8nwGx0ofpnGUAVhlcFLKX75rb0E2YITPLWcSG0Z
	SuTHVzwjgiBJ3fxp2/fI/fSkrdEM7C/43mVNNyZBlgZPzEiaP6UHjCoDDqg==
X-Gm-Gg: ASbGncuD6DykkL3gxz/7sVpBZoGqt4s07Pm97t4HNz9qSIpoc2cO5BglvmW6PRtpr/Z
	ecGCxTFVOmKuKO/LLmEGM82IaAKeNlFcyE9OIr+keEbu3vobIfYTeMGX5B0vFC1wpriSwmWGYXe
	L3qnigE5/9CTHiFoAuOj+O+QKF3Vl8NvNjVsdGYOHqCp/wfIgS/KlMM/zNAe7PNHZIsgb9NBxyA
	6kcp1j7o3MfKmWqMLdcOYfyc5vGkZM60tA2x0X3mqI8AbXg/+qYahWslZzPMmitab03s3yvi47x
	N4iwPH4VKR5wpfvVhHyLzk13oCERxJZ2L9LeVubhf1j5OxiIJgmzKUZZ05GiFJUA1vCWGleo7bT
	TCiaWNg==
X-Received: by 2002:a05:600c:1f86:b0:453:1e14:6387 with SMTP id 5b1f17b1804b1-4533f02bb07mr103882295e9.32.1750175027786;
        Tue, 17 Jun 2025 08:43:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW7WAxfMB8RzBFcIgkdMMOt5efROkEp4+2gW6BG8c/KNZ4GFdHI8tPJPW7/9sULqKMn/YZhQ==
X-Received: by 2002:a05:600c:1f86:b0:453:1e14:6387 with SMTP id 5b1f17b1804b1-4533f02bb07mr103881885e9.32.1750175027375;
        Tue, 17 Jun 2025 08:43:47 -0700 (PDT)
Received: from localhost (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4533fb97d88sm116092365e9.36.2025.06.17.08.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 08:43:46 -0700 (PDT)
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
Subject: [PATCH RFC 00/14] mm: vm_normal_page*() + CoW PFNMAP improvements
Date: Tue, 17 Jun 2025 17:43:31 +0200
Message-ID: <20250617154345.2494405-1-david@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VkHnu5HNAMVZ4w936Aj48c_mmQEozPMJF_Kw5gHAxeU_1750175028
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

RFC because it's based on mm-new where some things might still change
around the devmap removal stuff.

While removing support for CoW PFNMAPs is a noble goal, I am not even sure
if we can remove said support for e.g., /dev/mem that easily.

In the end, Cow PFNMAPs are pretty simple: everything is "special" except
CoW'ed anon folios, that are "normal".

The only complication is: how to identify such pages without pte_special().
Because with pte_special(), it's easy.

Well, of course, one day all architectures might support pte_special() ...
either because we added support for pte_special() or removed support for
... these architectures from Linux.

No need to wait for that day. Let's do some cleanups around
vm_normal_page()/vm_normal_page_pmd() and handling of the huge zero folio,
and remove the "horrible special case to handle copy-on-write behaviour"
that does questionable things in remap_pfn_range() with a VMA, simply by

... looking for anonymous folios in CoW PFNMAPs to identify anonymous
folios? I know, sounds crazy ;)

Of course, we add sanity checks that nobody dares installing PFNMAPs of
anonymous folios in these configs, that could trick us in assuming that
these are due to CoW.

We only have to do that without support for pte_special(); for
architectures that support pte_special(), nothing changes.

In the same process, add vm_normal_page_pud(), which is easy after the
cleanups, and improve our documentation. Well, and clarify that
"vm_ops->find_special_page" XEN thingy.

Briefly tested on UML (making sure vm_normal_page() still works as expected
without pte_special() support) and on x86-64 with a bunch of tests
(including ndctl, and cow.c which tests the huge zero folio).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>

David Hildenbrand (14):
  mm/memory: drop highest_memmap_pfn sanity check in vm_normal_page()
  mm: drop highest_memmap_pfn
  mm: compare pfns only if the entry is present when inserting
    pfns/pages
  mm/huge_memory: move more common code into insert_pmd()
  mm/huge_memory: move more common code into insert_pud()
  mm/huge_memory: support huge zero folio in vmf_insert_folio_pmd()
  fs/dax: use vmf_insert_folio_pmd() to insert the huge zero folio
  mm/huge_memory: mark PMD mappings of the huge zero folio special
  mm/memory: introduce is_huge_zero_pfn() and use it in
    vm_normal_page_pmd()
  mm/memory: factor out common code from vm_normal_page_*()
  mm: remove "horrible special case to handle copy-on-write behaviour"
  mm: drop addr parameter from vm_normal_*_pmd()
  mm: introduce and use vm_normal_page_pud()
  mm: rename vm_ops->find_special_page() to vm_ops->find_normal_page()

 drivers/xen/Kconfig              |   1 +
 drivers/xen/gntdev.c             |   5 +-
 fs/dax.c                         |  47 ++----
 fs/proc/task_mmu.c               |   6 +-
 include/linux/huge_mm.h          |  12 +-
 include/linux/mm.h               |  41 +++--
 mm/Kconfig                       |   2 +
 mm/huge_memory.c                 | 135 +++++++---------
 mm/internal.h                    |   2 -
 mm/memory.c                      | 261 ++++++++++++++++---------------
 mm/mm_init.c                     |   3 -
 mm/nommu.c                       |   1 -
 mm/pagewalk.c                    |  22 +--
 tools/testing/vma/vma_internal.h |  18 ++-
 14 files changed, 281 insertions(+), 275 deletions(-)


base-commit: 2f24ee10fe6d1959d674a4298d63b66f54508a68
-- 
2.49.0

