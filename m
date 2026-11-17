Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931127;
	b=JHUCPEznY97yYXV6wZvmYD4t9ya299zLFz/X5G93B9uzZUlySgXwCk4hWOhcl44iQFAl
	 E08fJsueyRz+3O1riJHTi8KUdt6j03N71wsizMDQjcMaDuxWAs+I28wUMZhMFNWTIUwLQ
	 xU/9FHKiwlqex57mi4Ht759Jv8YYKSDHToV69mYn7IWaQl53cvJbP86+ZMfCYayiq8SpC
	 diqjbOTBT1U9IPKatipyV+SyOG5ug/JINoKht/p+MrINzFEAqM4bw3ziGkbAvqnEb1AQG
	 mqogkWs75eoI78g+qcWGi1DPtk4E9FAZIJo2qgKA8FGC2s37JJ04aYTYKtq4DE2Kp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931127;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=GI4ugfB0NhERLBcfl6RxPS7mnQ8nFflwnbD21DK5LkY=;
	b=Q079WZHhexFU4k0ioY+uVLRxBzibcaiZwQjfzk/jUnlb1rdm6nMJ+5o2acZ1YPRFwPke
	 19/fGwTmJfyf0Oat5B/106R2UO+hGc0Rbzvkas4TBag//hhshlnbcv3Ffk926Adbs3raa
	 SF57WE+i9PBcvcqeDOZs7IczYoRYhm0Bkn+kZqgcoU2vqZ96MNYNQnvO+eDQgjsw9AtYz
	 mPedSg5Nprtme2BLjXn5L9e4oXSmXIorClb7uNL+VeLpve+rThnxOWZCmlTF2v10zAAaw
	 PRj8SCxEv7nMTQCJkcXBNQzPnUIdEnQoPUZ0PpqFY3uxQJaVuPvEjJnIzms5toEa62A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YehFc1te;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9194F606A32A;
	Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YehFc1te
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0424A1F000C5;
	Tue, 17 Nov 2026 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931127;
	bh=GI4ugfB0NhERLBcfl6RxPS7mnQ8nFflwnbD21DK5LkY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YehFc1teF7lgykIn6zq9Yqg92QRiGkaofJEJhHVhBokkAX8uW89aySOAkjns0nV9T
	 Vx9Tu2PAgGPFSEcwtuEHfiiw+2q84OhVlQzZjITWfm08mwB/PI6xPajjoQvcEpZQ00
	 v/xG6IZFc4JdjN1P0EYGBEqi1kELFgmHm136qTFfIl9vHeMig+UMckDUTCRO9xjTD7
	 //34LXR+3xB/loSMa8AiKDJxUgESpU+DH8AZXhL+vfhVDfMJ5yHin2KQ9cQ23GCJDr
	 tuM3cfl+q5Irlta/6AcUL4JT/AcGX2kgKORTrTLj3UBNpmqkSTdZD1mQNC8bfU78E3
	 DQ/G7eoeSZ2kg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:33 +0200
Subject: [PATCH 2/3] mm/memory: replace uffd-wp markers in
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
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
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

With UFFD_FEATURE_WP_ASYNC userfaultfd write protection can be enabled
for DAX mappings. Write protecting an empty PTE in such a mapping installs
a uffd-wp PTE marker, and so does zapping a write-protected PTE.

A fault on such a PTE gets to the DAX fault handler via do_pte_missing(),
which eventually calls insert_page_into_pte_locked():

  handle_pte_marker()
    pte_marker_handle_uffd_wp()
      do_pte_missing()
        ext4_dax_huge_fault() -> dax_iomap_fault() -> dax_fault_iter()
          vmf_insert_page_mkwrite()
            insert_page_into_pte_locked()

But insert_page_into_pte_locked() treats the marker as an existing entry.

On a read fault it returns -EBUSY, the marker stays in place and the
access refaults forever.

On a write fault it extracts a PFN from the marker and fails the fault
with SIGBUS:

  WARNING: mm/memory.c:2486 at insert_page_into_pte_locked+0x401/0x410, CPU#1: repro/151
  RIP: 0010:insert_page_into_pte_locked+0x401/0x410
  Call Trace:
   <TASK>
   insert_page+0x6f/0xc0
   vmf_insert_page_mkwrite+0x31/0x60
   dax_fault_iter+0x3be/0x5f0
   dax_iomap_pte_fault+0x1b8/0x390
   ext4_dax_huge_fault+0x1a4/0x2f0
   __do_fault+0x34/0xc0
   do_fault+0x179/0x610
   __handle_mm_fault+0x943/0x1250
   handle_mm_fault+0xb4/0x290
   do_user_addr_fault+0x15f/0x730
   exc_page_fault+0x83/0x190
   asm_exc_page_fault+0x26/0x30

Replace uffd-wp markers with the new PTE and keep the page
write-protected by setting the uffd-wp bit in it, like set_pte_range()
does for other file mappings.

Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
Reported-by: Jingyi Sun <1045704958@qq.com>
Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index f927f2241e40..66ad58429967 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2452,8 +2452,9 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 {
 	struct folio *folio = page_folio(page);
 	pte_t pteval = ptep_get(pte);
+	bool uffd_wp_marker = pte_is_uffd_wp_marker(pteval);
 
-	if (pte_none(pteval)) {
+	if (pte_none(pteval) || uffd_wp_marker) {
 		pteval = mk_pte(page, prot);
 		if (unlikely(is_zero_folio(folio))) {
 			pteval = pte_mkspecial(pteval);
@@ -2467,6 +2468,8 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
 			folio_add_file_rmap_pte(folio, page, vma);
 		}
+		if (uffd_wp_marker && userfaultfd_wp(vma))
+			pteval = pte_mkuffd(pteval);
 		set_pte_at(vma->vm_mm, addr, pte, pteval);
 		return 0;
 	}

-- 
2.53.0

