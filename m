Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931131;
	b=Bv2ZHou+qyyvSM0So3gyyfYZSzFOm7ycAEJj5MyfquHnG/7+w3L8ON6jAStJez0tfN2n
	 hkGTfQKwojZ5i27f9c/GXjLVDD3PKayDvuIPN1KvmXCDQl6RtJ1jVKAYAVQQy3tdNEaBr
	 m1JDKW5i8xmZ2U9/y/tKneDBXryZs4FFIkCSu5ziSol5DKu/ldirJCNO9x8qpaUh9uRUr
	 T1shtqn3eRYI2qM4oMTrDmBcqn8gB99898YGZ39M5T06iggqMg8XQaNbFkD+2s1sBpZpt
	 liN5ecop891K6P+eZnL0s1gxiRBlzEY4hajbfmj5IUylnip16wF1Mcu0OIW9TUqe1zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931131;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=SH3B96UoxOckJWmgiMFdQXZ6He/d2a60d40nEzWGR/Y=;
	b=jodd0c2ArCc6hwuwIMhqb2vsmyIXrHdn0HCc7vFolSnqJqtYN8Esg15a7gazx/zkpeXj
	 UvRx2EYBB+yBTynjyQZfxwnwxT2+fKTOWDVbdabSZkTc5p9jGXmrtW8GM+YtfOd+bwIX5
	 3+47Bh8+pZuDhXyyW7SO1QHvp5ycvFSMLOtCEAhmxF/1QSD6IOXuXg22Gp1X7SksXtp/h
	 dn6I/IFzXzT5r5iwilN7bW0Dneobfo82x+fMHayUqAshx82S/lYNCoXHyHU4SDxH/xYKX
	 9X083imsGG3rzmnPqluZhWKN/+5GqMqsUwCxVNLiEjGKYCfo0FRqONu9VsVuRKivJKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aiNgqNJC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DA5606A31C;
	Tue, 17 Nov 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aiNgqNJC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91E21F000C8;
	Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931131;
	bh=SH3B96UoxOckJWmgiMFdQXZ6He/d2a60d40nEzWGR/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aiNgqNJCBDq75GpvSOEPsFj3zOzPEJ3ehg7/ZUjkX5SOrdNtkq1McDKKzKFSV8aAo
	 WRtOVxAyES7+rdGx3KU0uqhEP2sz14f8ArxZjkHc5ESuPKR+ydPlRhhwnuCQew7tzB
	 L8ll6paqcwd3yyCmEupFz1TFeQp9Jng+5VadnP5xKjCCvvsxpy/uqo0OBJZHdce+Os
	 jfOdqz+rZfJBCmNfxfJdUseOQzECZpfrChosWk/L0DL7bF7Ig8aOBIZ0qQ1XPMrGdt
	 YbvdpQz5OulOc/7+sbj0UHxhTExEHBmGYFNza4SLbyyiwk2imMiUJ8VgZmSaKAL9Iy
	 C5sw+ZRl5fPsA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:34 +0200
Subject: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev

On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
maps a page, compares its PFN with the page being inserted and upgrades
the PTE to writable.

Since guard regions are allowed in file-backed mappings,
MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
after the DAX fault handler found that PTE empty and before it inserts
the page.

vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
expected on access to a guard region:

  WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
  RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
  Call Trace:
   <TASK>
   insert_page+0x6f/0xc0
   vmf_insert_page_mkwrite+0x31/0x60
   dax_fault_iter+0x3be/0x5f0
   dax_iomap_pte_fault+0x1b8/0x390
   ext4_dax_huge_fault+0x1a4/0x2f0
   __do_fault+0x34/0xc0
   do_fault+0x179/0x610
   __handle_mm_fault+0x8ca/0x1250
   handle_mm_fault+0xb4/0x290
   do_user_addr_fault+0x15f/0x730
   exc_page_fault+0x83/0x190
   asm_exc_page_fault+0x26/0x30

Return -EBUSY for non-present PTEs on write faults like it's done for read
faults, so that the fault is retried and handle_pte_marker() deals with
the marker.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 66ad58429967..a80925c61706 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 		return 0;
 	}
 
-	if (!mkwrite)
+	if (!mkwrite || !pte_present(pteval))
 		return -EBUSY;
 
 	/*

-- 
2.53.0

