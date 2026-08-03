Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686DA3C1D53
	for <nvdimm@lists.linux.dev>; Mon,  3 Aug 2026 12:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760502; cv=none; b=T5+KP9jT3pcSMbH9LRdCJKLiE0xCDoOzerNkmdcPTtjzEuQfqo0DMHu/q7BT4pGDYt3HGC88CHPifsMNeQwbs0JfI4pD7ihaVEaFp4GGTgiKdf0r7lKCiwlCcZTtjNcDAQ3heXXT8Ai8OPnIZaBZgkJW+Ai8yUEeHTUbskz85Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760502; c=relaxed/simple;
	bh=vIDx/sKwffmOGzvvzSDdizIEIENpZK4Ed4Y7Nq9b7XY=;
	h=From:To:Subject:CC:Date:Message-ID:MIME-Version:Content-Type; b=mvtW6nDZSigbozCyOSke/H238g2nlTPRaaq5cXHSvcBiyNsK7JAG9QMXeqGYb9dU65fsSb8KQFyp8GUmSdaDP6bDGdRGNPuAq4UAmdV/fIbPkhkFqCd8aE9zcchqF5b/eLaNZHBTzzxLfrCqauO0tx3vpqtlCGc9DJhIn/3d0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=m1J2hadM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="m1J2hadM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72BDE143D;
	Mon,  3 Aug 2026 05:34:55 -0700 (PDT)
Received: from GX9GF4H4XN (unknown [10.1.26.156])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15C713F66F;
	Mon,  3 Aug 2026 05:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785760499; bh=vIDx/sKwffmOGzvvzSDdizIEIENpZK4Ed4Y7Nq9b7XY=;
	h=From:To:Subject:CC:Date:From;
	b=m1J2hadMs/yUicqxnFSav0TkGwG+RSZ8wVP96U8BRzjcF8EFwOIN2wc7UIAHtpD4X
	 Y/jAr6sqTmSdGpIw60Gt3/aIx5qKG1w+9X2VymE3hUbg5gRI495jZQsHIrrJBWtPqb
	 LjkDlCN4sAsOEECGpoa/fIGsyix8QKpRiwxnY8mg=
From: Seunguk Shin <seunguk.shin@arm.com>
To: <linux-kernel@vger.kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH v5] fs/dax: check zero or empty entry before converting
 xarray entry
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <Nick.Connolly@arm.com>, <ffidencio@nvidia.com>, <seunguk.shin@arm.com>
Date: Mon, 03 Aug 2026 13:34:55 +0100
Message-ID: <m2y0enxtzk.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Calling dax_to_folio() with empty entry causes kernel panic below
when booting a VM with DAX enabled storage.

This patch checks empty entry before calling dax_to_folio() on
dax_associate_entry(), dax_disassociate_entry(), and dax_busy_page().

Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
added guards in the associate and disassociate paths, but the guards
still come after dax_to_folio(), and dax_busy_page() still has
the same problem.

[    0.737679] EXT4-fs (pmem0p1): mounted filesystem 79676804-7c8b-491a-b2a6-9bae3c72af70 ro with ordered data mode. Quota mode: disabled.
[    0.737891] VFS: Mounted root (ext4 filesystem) readonly on device 259:1.
[    0.739119] devtmpfs: mounted
[    0.739476] Freeing unused kernel memory: 1920K
[    0.740156] Run /sbin/init as init process
[    0.740229]   with arguments:
[    0.740286]     /sbin/init
[    0.740321]   with environment:
[    0.740369]     HOME=/
[    0.740400]     TERM=linux
[    0.743162] Unable to handle kernel paging request at virtual address fffffdffbf000008
[    0.743285] Mem abort info:
[    0.743316]   ESR = 0x0000000096000006
[    0.743371]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.743444]   SET = 0, FnV = 0
[    0.743489]   EA = 0, S1PTW = 0
[    0.743545]   FSC = 0x06: level 2 translation fault
[    0.743610] Data abort info:
[    0.743656]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
[    0.743720]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.743785]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.743848] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000b9d17000
[    0.743931] [fffffdffbf000008] pgd=10000000bfa3d403, p4d=10000000bfa3d403, pud=1000000040bfe403, pmd=0000000000000000
[    0.744070] Internal error: Oops: 0000000096000006 [#1]  SMP
[    0.748888] CPU: 0 UID: 0 PID: 1 Comm: init Not tainted 6.18.4 #1 NONE
[    0.749421] pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.749969] pc : dax_disassociate_entry.constprop.0+0x20/0x50
[    0.750444] lr : dax_insert_entry+0xcc/0x408
[    0.750802] sp : ffff80008000b9e0
[    0.751083] x29: ffff80008000b9e0 x28: 0000000000000000 x27: 0000000000000000
[    0.751682] x26: 0000000001963d01 x25: ffff0000004f7d90 x24: 0000000000000000
[    0.752264] x23: 0000000000000000 x22: ffff80008000bcc8 x21: 0000000000000011
[    0.752836] x20: ffff80008000ba90 x19: 0000000001963d01 x18: 0000000000000000
[    0.753407] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[    0.753970] x14: ffffbf3154b9ae70 x13: 0000000000000000 x12: ffffbf3154b9ae70
[    0.754548] x11: ffffffffffffffff x10: 0000000000000000 x9 : 0000000000000000
[    0.755122] x8 : 000000000000000d x7 : 000000000000001f x6 : 0000000000000000
[    0.755707] x5 : 0000000000000000 x4 : 0000000000000000 x3 : fffffdffc0000000
[    0.756287] x2 : 0000000000000008 x1 : 0000000040000000 x0 : fffffdffbf000000
[    0.756871] Call trace:
[    0.757107]  dax_disassociate_entry.constprop.0+0x20/0x50 (P)
[    0.757592]  dax_iomap_pte_fault+0x4fc/0x808
[    0.757951]  dax_iomap_fault+0x28/0x30
[    0.758258]  ext4_dax_huge_fault+0x80/0x2dc
[    0.758594]  ext4_dax_fault+0x10/0x3c
[    0.758892]  __do_fault+0x38/0x12c
[    0.759175]  __handle_mm_fault+0x530/0xcf0
[    0.759518]  handle_mm_fault+0xe4/0x230
[    0.759833]  do_page_fault+0x17c/0x4dc
[    0.760144]  do_translation_fault+0x30/0x38
[    0.760483]  do_mem_abort+0x40/0x8c
[    0.760771]  el0_ia+0x4c/0x170
[    0.761032]  el0t_64_sync_handler+0xd8/0xdc
[    0.761371]  el0t_64_sync+0x168/0x16c
[    0.761677] Code: f9453021 f2dfbfe3 cb813080 8b001860 (f9400401)
[    0.762168] ---[ end trace 0000000000000000 ]---
[    0.762550] note: init[1] exited with irqs disabled
[    0.762631] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Signed-off-by: Seunguk Shin <seunguk.shin@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
---
Changes in v5:
- Update the commit message
- Link to v4: https://lore.kernel.org/all/m2jyqk7jxo.fsf@arm.com/
Changes in v4:
- Rebase on current upstream
- Link to v3: https://lore.kernel.org/all/m2jythetpj.fsf@arm.com/
Changes in v3:
- Rebase on current upstream
- Update the changelog for the current code state
- Link to v2: https://lore.kernel.org/all/m2jyv11mqe.fsf@arm.com/
Changes in v2:
- Add Fixes and Reviewed-by tags.
- Rebase on the latest.
- Link to v1: https://lore.kernel.org/all/18af3213-6c46-4611-ba75-da5be5a1c9b0@arm.com/
---
 fs/dax.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..4bca6e2bc342 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
                                unsigned long address, bool shared)
 {
        unsigned long size = dax_entry_size(entry), index;
-       struct folio *folio = dax_to_folio(entry);
+       struct folio *folio;

        if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
                return;

+       folio = dax_to_folio(entry);
        index = linear_page_index(vma, address & ~(size - 1));
        if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
                if (folio->mapping)
@@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
                                bool trunc)
 {
-       struct folio *folio = dax_to_folio(entry);
+       struct folio *folio;

        if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
                return;

+       folio = dax_to_folio(entry);
        dax_folio_put(folio);
 }

 static struct page *dax_busy_page(void *entry)
 {
-       struct folio *folio = dax_to_folio(entry);
+       struct folio *folio;

        if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
                return NULL;

+       folio = dax_to_folio(entry);
        if (folio_ref_count(folio) - folio_mapcount(folio))
                return &folio->page;
        else
--
2.43.0
