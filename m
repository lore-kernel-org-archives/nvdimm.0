Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB420C472
	for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744276229; cv=none; b=C7Jl7OchOp92Z+vxcVFSf0jLPZ1fSLOVueLMKKJ7RjIShTT6pVPS6oEqMk2+tXudNqsQKjN5kdr8bxyZmlBb8ijSPpG7+VEHfvsOdeRDKljEzYCtvMm8MUDXvf3oiGJvFbYsqMVVSH0AR8Vb8SHZpZxKJZS743Ti+WLRiv4vfRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744276229; c=relaxed/simple;
	bh=S4gD+3ui7K1tm6lBvIKO/M5DULRUHhtuzWDJL/fuqYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=sOMxj5Bsf4ZI4g+4LfyW8iOamMV8yWN/QA/l8S9iCKQqh4fhisH7YjhnXGt7Se2ycQbdALG8yK9qQEbK/ADE+S72wmseXiO308HqsaBvp/JoDHFBt2Omd++w8jdxAGEiLCeuVxgf7LMSnk/3di4JYsQGzA0mYHDaAcn/yn8NfyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcpyv67e; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcpyv67e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744276226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=27eNNzuEQxbmkvmFUCfr+IytzedlUHGjPUYmckfSXUM=;
	b=dcpyv67epyUG6nGhx7JL+bCxyMjCzA9t+UH/Ygj852d8vGEEe/oegK8QoAhbEajWnzdvom
	UMtf8Zo7j7vZlKCk+OFnp7Q5lxqVHRzH/JSkaCrY2l1VWz2R55BDKs31UuFhvlGdRfHE+y
	Mv7tbbOUG7SD5rXD865Om+q9QbwPjr4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-plPFJCdxNpm_HMfnGq3QiQ-1; Thu, 10 Apr 2025 05:10:24 -0400
X-MC-Unique: plPFJCdxNpm_HMfnGq3QiQ-1
X-Mimecast-MFC-AGG-ID: plPFJCdxNpm_HMfnGq3QiQ_1744276223
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d733063cdso5379185e9.0
        for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 02:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744276223; x=1744881023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27eNNzuEQxbmkvmFUCfr+IytzedlUHGjPUYmckfSXUM=;
        b=t5nAbAPWxptEgkmMFTwMtJRkIKRaFrzpVAc3FuDQpsXB7/25lxBdJv4b42DU0nmkgP
         nIKzYMqfDNaUDdzf2+iOF1kVb5Aw5zbnYKW3T5vMDRupBVTJ+gtlCXnOMXDNtu+QCJgt
         Dx3Yw+cMbbEf031AieTEZSISjA3Grv7x2B9tRAqcsNjO6wa5DW2cIL2dKmqbCupoGc/r
         4nMap2qCBgxMDACVmm9BteBxYemq/CdWR61Z+6GYUtofdRoWvtyrlD0SMwh9PAfpG3OO
         +KCbKm1u+3SKGeIsyM/n6YrlyCEnyu2Rf0n9Ma8/e6dCbsE6q0hFBWsWRR8BoL5hKw68
         eBGw==
X-Forwarded-Encrypted: i=1; AJvYcCV/8+pVNN8gXn9b26+x7QZ2Mj5hzuv6MSafeuUyp4efNlMbk5nxzgCtOqrIcNmGe5sQTWItTWs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVmz7mef8yfKtD8WsP/x6TXG/ZYhClpZdCY51eZfhvVviIUud9
	HveAkT5Y1ZXdozEpvftSuMass04YJK1ZmO8kuYKLU1d5FPL0hVqVqbE9dO0FJcJH3r7TKFNL+Ro
	d/uho0XF6wpd0PA4jn6PahlAMKLG2VnxlrN4EEUsf49FvE1wvBDVkng==
X-Gm-Gg: ASbGnctqAcTL/AsBf0VclobbBoj3TlNwRj/4bODFUT2PZUKvw+phOtb788NYS6bPKw1
	HnA3ozMtFKUWMHlbk3yvwEJtGcC8jwpgTcxsX4Wp5L8tDIn3ZCS3B2ntfsVWQyzkmcb9EsxyxPL
	zw/rd0ibICsMWf8URQ0foycWLKYk/Vdwbodm6qzlWoTh97JCZhLUQP4lT2iGKpnHw2sdFnrXphw
	EXRfj3qbFFmt0mzxPiQRXp7YJ1RFXFRkY8RZeNrQK+TlCv8eAkVv/7LmLCewl9pWmSriJXPQk6M
	L1ii4krbdIjRpZtPxUS6n7t0eX+GxOwbxcNxF9cHnbINL/W5sYg6NgtbneAovSqFIO5baeJy
X-Received: by 2002:a5d:59ad:0:b0:39c:13fa:3eb with SMTP id ffacd0b85a97d-39d8f4e43c0mr1524414f8f.39.1744276223376;
        Thu, 10 Apr 2025 02:10:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9o//1YdnfQaWfNqnIWzI/WV2dN54LX94NnfwgJ3jSA+I3+tbjCeuQrP5snslAD47XW4PEGg==
X-Received: by 2002:a5d:59ad:0:b0:39c:13fa:3eb with SMTP id ffacd0b85a97d-39d8f4e43c0mr1524393f8f.39.1744276222986;
        Thu, 10 Apr 2025 02:10:22 -0700 (PDT)
Received: from localhost (p200300cbc71a5900d1064706528a7cd5.dip0.t-ipconnect.de. [2003:cb:c71a:5900:d106:4706:528a:7cd5])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39d893773a0sm4135334f8f.25.2025.04.10.02.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Apr 2025 02:10:22 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v1] fs/dax: fix folio splitting issue by resetting old folio order + _nr_pages
Date: Thu, 10 Apr 2025 11:10:20 +0200
Message-ID: <20250410091020.119116-1-david@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _Zr9kJhSJPv6aX-aZa9BSFjc-MrqctoaKxDCsSXWUCQ_1744276223
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Alison reports an issue with fsdax when large extends end up using
large ZONE_DEVICE folios:

[  417.796271] BUG: kernel NULL pointer dereference, address: 0000000000000b00
[  417.796982] #PF: supervisor read access in kernel mode
[  417.797540] #PF: error_code(0x0000) - not-present page
[  417.798123] PGD 2a5c5067 P4D 2a5c5067 PUD 2a5c6067 PMD 0
[  417.798690] Oops: Oops: 0000 [#1] SMP NOPTI
[  417.799178] CPU: 5 UID: 0 PID: 1515 Comm: mmap Tainted: ...
[  417.800150] Tainted: [O]=OOT_MODULE
[  417.800583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  417.801358] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
[  417.801948] Code: ...
[  417.803662] RSP: 0000:ffffc90002be3a08 EFLAGS: 00010206
[  417.804234] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000002
[  417.804984] RDX: ffffffff815652d7 RSI: 0000000000000000 RDI: ffffffff82a2beae
[  417.805689] RBP: ffffc90002be3a28 R08: 0000000000000000 R09: 0000000000000000
[  417.806384] R10: ffffea0007000040 R11: ffff888376ffe000 R12: 0000000000000001
[  417.807099] R13: 0000000000000012 R14: ffff88807fe4ab40 R15: ffff888029210580
[  417.807801] FS:  00007f339fa7a740(0000) GS:ffff8881fa9b9000(0000) knlGS:0000000000000000
[  417.808570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  417.809193] CR2: 0000000000000b00 CR3: 000000002a4f0004 CR4: 0000000000370ef0
[  417.809925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  417.810622] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  417.811353] Call Trace:
[  417.811709]  <TASK>
[  417.812038]  folio_add_file_rmap_ptes+0x143/0x230
[  417.812566]  insert_page_into_pte_locked+0x1ee/0x3c0
[  417.813132]  insert_page+0x78/0xf0
[  417.813558]  vmf_insert_page_mkwrite+0x55/0xa0
[  417.814088]  dax_fault_iter+0x484/0x7b0
[  417.814542]  dax_iomap_pte_fault+0x1ca/0x620
[  417.815055]  dax_iomap_fault+0x39/0x40
[  417.815499]  __xfs_write_fault+0x139/0x380
[  417.815995]  ? __handle_mm_fault+0x5e5/0x1a60
[  417.816483]  xfs_write_fault+0x41/0x50
[  417.816966]  xfs_filemap_fault+0x3b/0xe0
[  417.817424]  __do_fault+0x31/0x180
[  417.817859]  __handle_mm_fault+0xee1/0x1a60
[  417.818325]  ? debug_smp_processor_id+0x17/0x20
[  417.818844]  handle_mm_fault+0xe1/0x2b0
[...]

The issue is that when we split a large ZONE_DEVICE folio to order-0
ones, we don't reset the order/_nr_pages. As folio->_nr_pages overlays
page[1]->memcg_data, once page[1] is a folio, it suddenly looks like it
has folio->memcg_data set. And we never manually initialize
folio->memcg_data in fsdax code, because we never expect it to be set at
all.

When __lruvec_stat_mod_folio() then stumbles over such a folio, it tries to
use folio->memcg_data (because it's non-NULL) but it does not actually
point at a memcg, resulting in the problem.

Alison also observed that these folios sometimes have "locked"
set, which is rather concerning (folios locked from the beginning ...).
The reason is that the order for large folios is stored in page[1]->flags,
which become the folio->flags of a new small folio.

Let's fix it by adding a folio helper to clear order/_nr_pages for
splitting purposes.

Maybe we should reinitialize other large folio flags / folio members as
well when splitting, because they might similarly cause harm once
page[1] becomes a folio? At least other flags in PAGE_FLAGS_SECOND should
not be set for fsdax, so at least page[1]->flags might be as expected with
this fix.

From a quick glimpse, initializing ->mapping, ->pgmap and ->share should
re-initialize most things from a previous page[1] used by large folios
that fsdax cares about. For example folio->private might not get
reinitialized, but maybe that's not relevant -- no traces of it's use in
fsdax code. Needs a closer look.

Another thing that should be considered in the future is performing similar
checks as we perform in free_tail_page_prepare() -- checking pincount etc.
-- when freeing a large fsdax folio.

Fixes: 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lkml.kernel.org/r/Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/dax.c           |  1 +
 include/linux/mm.h | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index af5045b0f476e..676303419e9e8 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -396,6 +396,7 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	order = folio_order(folio);
 	if (!order)
 		return 0;
+	folio_reset_order(folio);
 
 	for (i = 0; i < (1UL << order); i++) {
 		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b7f13f087954b..bf55206935c46 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1218,6 +1218,23 @@ static inline unsigned int folio_order(const struct folio *folio)
 	return folio_large_order(folio);
 }
 
+/**
+ * folio_reset_order - Reset the folio order and derived _nr_pages
+ * @folio: The folio.
+ *
+ * Reset the order and derived _nr_pages to 0. Must only be used in the
+ * process of splitting large folios.
+ */
+static inline void folio_reset_order(struct folio *folio)
+{
+	if (WARN_ON_ONCE(!folio_test_large(folio)))
+		return;
+	folio->_flags_1 &= ~0xffUL;
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+	folio->_nr_pages = 0;
+#endif
+}
+
 #include <linux/huge_mm.h>
 
 /*
-- 
2.48.1

