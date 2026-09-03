Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1D847042C;
	Thu,  3 Sep 2026 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788439993; cv=none; b=eRQPO0iMg98geYUJonZhYVvJw0DzEDf6HJzEHbawK1Ng5S/p8uGmzD2Jj4OFkvMXVd+Pid6t2Xg8uxbtSHj/vIklTlC2gFjNPabhbEmUPfMODy9uI/G2Y0E2ywXbluJissrgY87ZCcamDpyARo5QojnolmHgAD7f0ZxaTfVFXuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788439993; c=relaxed/simple;
	bh=InjBWaZkjQmklu0Y26E14ZxF1FdIipsMm+k3KNFSKLU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q732zBLG0BqxVOhEGxio9Mss9obhS4pxYbNKzQxOkaPCtNkqFnkSJvQqN4wjFGVHjzeVE2bruBpReGWKEi6AMgyTu5EH6o9a8BeFtCBECiaR/QN3fQKWpYcfsv7qeswHG/adSNTuCtPKxhEarEBCToqTog5LlseuV5EoYYWvpG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy7GCVmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy7GCVmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B761F000E9;
	Thu,  3 Sep 2026 12:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788439992;
	bh=SNMGf5RHIOI/PD/7XCQtuNDgjgsKMP340kZEP0I53GQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Cy7GCVmXvdRha+BvtjSu0crtMmy/wOAwerPFT4tYphIdmJn455esAdgZktdaDFtfc
	 HLPQBWqTvcx7Gs9fJbdfl4wXr8qwgLoZXwMp7HaZlfBGSs3AEVoou7LiQQXIFR/g9V
	 J3CpwHiHUapJboNFq6420jhcweNpepv/oGcpNfys9EJVEofqxDfss1tm9OFeN1VgYa
	 JCcEtsTMASKP+jliCV+9d1XJUb0+AadKLUnHjqosbjSnMN2paZU0t0kYWuaEyhNtql
	 e76jj3fBNlLCxeAujTTZ8dy1Cje/qyOSIXnmI/VmmGgMi1PCzkvxU/lAHc2UZK2dS4
	 XAE+2F5R7adxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] fsdax: materialize pmem vmemmap metadata on faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260903122128.12264-5-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:53:11 +0000
Message-Id: <20260903125312.16B761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Global TLB flush broadcast inside global page table lock causing s=
evere lock contention.
- [High] PMD fault materialization failure incorrectly returns VM_FAULT_OOM=
 instead of falling back to PTE.
- [High] __vmemmap_materialize_page dereferences a potentially NULL PTE poi=
nter if the DAX device is concurrently hot-unplugged.
--

commit 9e2a623911317e382af87ef795b2fc34f1686554
Author: Muchun Song <muchun.song@linux.dev>

fsdax: materialize pmem vmemmap metadata on faults

This patch opts pmem FS-DAX into the shared read-only vmemmap mode and=20
materializes private metadata before inserting a PFN into a userspace=20
mapping. It shifts private vmemmap allocation from device registration=20
to the first DAX fault for each metadata page.

[ ... ]

> diff --git a/fs/dax.c b/fs/dax.c
> index 1fbba0d21c13d..89377301d51b0 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c

[ ... ]

> @@ -1877,6 +1878,10 @@ static vm_fault_t dax_fault_iter(struct vm_fault *=
vmf,
>  	if (err)
>  		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
> =20
> +	err =3D vmemmap_materialize_page(pfn_to_page(pfn), pmd ? PMD_ORDER : 0);

[Severity: High]
Is there a risk of severe lock contention and RCU stalls here?

When a PMD fault triggers vmemmap_materialize_page(), it loops 512 times.
Inside that loop, __vmemmap_materialize_page() acquires the global
init_mm.page_table_lock and performs a synchronous TLB flush:

mm/sparse-vmemmap.c:__vmemmap_materialize_page() {
    ...
    set_pte_at(&init_mm, addr, pte, mk_pte(candidate, PAGE_KERNEL));
    flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
    put_page(template);
out:
    spin_unlock(&init_mm.page_table_lock);
}

Could this cause the system to become unusable under load due to sequential
global IPI broadcasts while holding the global kernel page table lock?


[Severity: High]
Is there a race condition with DAX device hot-unplug here?

The prior call to dax_iomap_direct_access() acquires and then releases the
DAX SRCU read lock. By the time we call vmemmap_materialize_page(), there
is no lock preventing the DAX device from being hot-unplugged, which tears
down the vmemmap page tables.

If that happens concurrently, __vmemmap_materialize_page() will find
pmd_none(*pmd) is true in virt_to_kpte(), resulting in a NULL pte pointer.
Will the subsequent ptep_get(pte) dereference this NULL pointer and panic
the kernel?

> +	if (err)
> +		return dax_fault_return(err);

[Severity: High]
Does returning dax_fault_return(err) on a -ENOMEM error incorrectly trigger
an OOM kill for PMD faults?

dax_fault_return(err) translates -ENOMEM to VM_FAULT_OOM. If this
allocation fails during a PMD fault, shouldn't it return VM_FAULT_FALLBACK
instead, allowing the kernel to gracefully split the huge page and retry at
the PTE level (similar to how dax_iomap_direct_access() handles PMD fallback
just above this)?

> +
>  	*entry =3D dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903122128.1226=
4-1-songmuchun@bytedance.com?part=3D4
