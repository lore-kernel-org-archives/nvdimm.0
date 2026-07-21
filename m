Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AC046DFF5;
	Tue, 21 Jul 2026 18:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659013; cv=none; b=XR2I5mZUbgthk3QLLjUff7mH9IV0EfiQudOSOM9EgXIDRI4NE4tYIlNpIklCOhkvUaHDu0Tbxyepf70qx2k9oVdHxPvugbPUZ+i7q55oxgXj+2m1M5t6NvmS7XZ00XRGUEJMi+rr8MHTDwyCXi7VgC2ZXW6MCP54ZJd1riM+HKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659013; c=relaxed/simple;
	bh=zNkMUJ/QK10ZL2VShQAGwoST+HuXsxQcNLHYduACDtE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HEy76RjoYTk9dKnEkC7kSa7UVzCrY78ORV0DHVBQLYe9dyKJJ+dL0qzNCV4YKayLvNBfde3KraMi/3+Xl9XNXKfLUvjP+4gu2ezl5yDn1DSzKQTosJ9uof/vfouN2zmO1StToIkmRe6no+QWqJAsgxEFi9/w3pS5iBZDvJOHwbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjKbZ0bJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjKbZ0bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805EF1F00A3A;
	Tue, 21 Jul 2026 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659012;
	bh=hMY/tGkwNG8kcJqaF/AAePr2k7We2aykfTDZVGWlDAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NjKbZ0bJU86Jqi5iGzXlXKIn+RFfbExPq+yoTu5narwqZPFKx/FWEhbbXgFoL4FYP
	 UJMeUkO/UYoW2XiOIJTxRO6pbNLK9dlrx7EJqtHFQ/KHCDblJyg7hQUW8UStaedla8
	 /4cS97wv+5HYAhxM8jWUdTg6Ces77N9ehi+Z7Ni72ho/CYwDQ8wTX6cSm2qpTlGQcz
	 Z7OnX7F1wfwDsVggVLt1M6CpUgUyFgTlKNeuvfu3rbavVN4tsnAem1sqBLUjHbjig1
	 LvUkJTYKSMMOrodTrQPBcTMc6Cj256b713xToPXG1f+/IEgK7Wiiv8NfUKLUyeFGGl
	 asgESsnbHggMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/36] mm/khugepaged: skip private node folios when
 trying to collapse.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: damon@lists.linux.dev, hannes@cmpxchg.org, nvdimm@lists.linux.dev, kvm@vger.kernel.org, linux-cxl@vger.kernel.org, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20260720193431.3841992-17-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-17-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:36:51 +0000
Message-Id: <20260721183651.805EF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The replacement of `is_zone_device_page()` with `page_is_private_m=
anaged()` inside a `WARN_ON_ONCE` in `try_collapse_pte_mapped_thp()` trigge=
rs spurious kernel warnings and aborts PMD restoration for valid memory on =
private NUMA nodes.

Pre-existing issues:
- [Critical] Functions structurally modifying page tables under `mmap_write=
_lock()` fail to call `vma_start_write()`, leading to critical Use-After-Fr=
ee race conditions with concurrent per-VMA lock readers (like MADV_DONTNEED=
).
--

--- Patch [16]: [PATCH v5 16/36] mm/khugepaged: skip private node folios wh=
en trying to collapse. ---
commit c62053ea9e5edc37182a3d1e8367dfb0ed6fbf08
Author: Gregory Price <gourry@gourry.net>

mm/khugepaged: skip private node folios when trying to collapse.

A collapse operation causes new THP allocation to occur, and may
migrate memory from one node to another. Handle this the same as
zone_device for now (disallow collapse).

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 89ce6bcbc376b..fb4378cc17b10 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c

[ ... ]

> @@ -1944,7 +1944,7 @@ static enum scan_result try_collapse_pte_mapped_thp=
(struct mm_struct *mm, unsign
>  		}
> =20
>  		page =3D vm_normal_page(vma, addr, ptent);
> -		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
> +		if (WARN_ON_ONCE(page && page_is_private_managed(page)))

[Severity: High]
Does replacing is_zone_device_page() with page_is_private_managed() inside
this WARN_ON_ONCE trigger spurious warnings and abort PMD restoration?

When a user maps a file-backed THP on a private NUMA node, temporarily
splits the PMD into PTEs, and then triggers a PMD collapse, we reach
try_collapse_pte_mapped_thp(). Because page_is_private_managed() can be
true for valid memory on private nodes, won't this trigger the warning
and unintentionally set page to NULL?

If panic_on_warn is enabled, this could be used by an unprivileged user
to reliably crash the system.

[Severity: Critical]
This is a pre-existing issue, but does try_collapse_pte_mapped_thp() need
to ensure vma_start_write() is called to prevent a use-after-free with
concurrent per-VMA lock readers?

When a thread registers a uprobe via register_for_each_vma(), it acquires
the mmap_write_lock() and eventually calls into this function:

kernel/events/uprobes.c:register_for_each_vma() {
    ...
    mmap_write_lock(mm);
    if (check_stable_address_space(mm))
        goto unlock;
    vma =3D find_vma(mm, info->vaddr);
    ...
}

try_collapse_pte_mapped_thp() then clears PMDs and frees PTE pages under
the assumption of exclusive access:

mm/khugepaged.c:try_collapse_pte_mapped_thp() {
    ...
    result =3D find_pmd_or_thp_or_none(mm, haddr, &pmd);
    ...
    start_pte =3D pte_offset_map_lock(mm, pmd, haddr, &ptl);
    ...
}

However, if another thread concurrently executes a VMA-locked operation
like MADV_DONTNEED, it only holds the VMA read lock. Because
vma_start_write() was never called to drain these concurrent readers, the
two threads can race to free or access the same PTE page.

>  			page =3D NULL;
>  		/*
>  		 * Note that uprobe, debugger, or MAP_PRIVATE may change the

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D16
