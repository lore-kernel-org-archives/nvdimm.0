Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A22425891
	for <nvdimm@lists.linux.dev>; Fri, 24 Jul 2026 10:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889436; cv=none; b=s9I7w2C36IE6CdUiTSCcGhyHFn70en3iT1ERUmSjpr0sI3gFvyFga53eWf3OUtXumt/NUA04HOUkvzVRXf39nc6MUKRmlfCy379cBkFcqHtEnbdKwObv1fGwsTWpHv5vamm1SX3K5wgn7pLEm5yvWLnapvZ+luJdvCY9q4cJr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889436; c=relaxed/simple;
	bh=TjDExxgf4LB6ZA4BUUci5QUmx9ripnHPSRkKc9ariGo=;
	h=From:To:Subject:CC:Date:Message-ID:MIME-Version:Content-Type; b=LHnLQUE1VSEojXmnclNTefWfp/zqyg6OvUAZFDNnDIbgtooOcWYfcxQVixZ8EorbU/GfKUOL1lfZNTK0cSPrcWsZyqxR4GTxC8HxD/eHFA3oOYveDwu6yjwLIuuQLv6sjKYZy0x/oWK58v6l/Ca0Wwx9fBdlh/Xl+1q6i1VSplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C0SchXJI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C0SchXJI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A71101477;
	Fri, 24 Jul 2026 03:37:08 -0700 (PDT)
Received: from GX9GF4H4XN (unknown [10.1.22.151])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7190F3F66F;
	Fri, 24 Jul 2026 03:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784889432; bh=TjDExxgf4LB6ZA4BUUci5QUmx9ripnHPSRkKc9ariGo=;
	h=From:To:Subject:CC:Date:From;
	b=C0SchXJILxNgW6LdqAkK05uiM7/6P8/WnBRxsk3ydzatru9U9+tcNAi1KviLXDp2+
	 9cF8ERuP+ehAH7fwEj/Tvh7mbh2UJv2BNxGaNP1mOJ/MOnhP/8d9MRRJTvMxrDSDOu
	 zKyesSKwj4wdMgMD8ntYLZBKq3FZLg9kx5YUfQj4=
From: Seunguk Shin <seunguk.shin@arm.com>
To: <linux-kernel@vger.kernel.org>, <djbw@kernel.org>
Subject: [PATCH v4] fs/dax: check zero or empty entry before converting
 xarray entry
User-Agent: Gnus/5.13 (Gnus v5.13)
CC: <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <jack@suse.cz>, <willy@infradead.org>, <Nick.Connolly@arm.com>,
 <ffidencio@nvidia.com>, <seunguk.shin@arm.com>
Date: Fri, 24 Jul 2026 11:37:07 +0100
Message-ID: <m2jyqk7jxo.fsf@arm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

dax_associate_entry(), dax_disassociate_entry(), and dax_busy_page()
call dax_to_folio(entry) before checking whether entry is a zero or
empty xarray entry.

That ordering is wrong because zero and empty entries are not folio
entries. Commit 98c183a4fccf ("fs/dax: don't disassociate zero page
entries") added guards in the associate and disassociate paths, but the
guards still come after dax_to_folio(entry), and dax_busy_page() still
has the same problem.

Move the zero/empty checks before dax_to_folio(entry) in all three helpers.

Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Signed-off-by: Seunguk Shin <seunguk.shin@arm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
---
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
