Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017545;
	b=mclxv1EPWLLZO3dmB1UFaclCSAuQwiTIwyRZ2YMwuMWXVmjmG7WlYRmRc62h6cG7Kls2
	 Vqr0FK1xCHnhzQnNuTeZ09MeuqXaIu3HPsPcWuwI42u4Z2QoJZc5htYRYaba0ru1Eskz7
	 dJkimoe71EQoaP/hyO23+XAvtNpdRhMO6coxUGGdxrPlJ+JJOIA/1HL7melOuE33r2Nvv
	 D+RiplLyzllCwhXSS3ejaMep86k8SyGUHSUft+9024bYtRG8aPg5izbZCG0E/ZrWx/6hE
	 sJFPlisO1wop6SaD4muMPiC8W9rbtshdRIcqt2mr+0wrSiYiAoMJtObD6urF2mOAkIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017545;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pWrk6vf2k3AbshFjf0BbK/R6P7Yi6LZ89zMfgvqB8b4=;
	b=UCqRClkk5V24ZJjPfzE7TX9cbIAuyM8yheAfl58Qn/ot02po+HEk/jiQV/u6kl2IvIO5
	 rEstZ/xFfVx2OKqVxAUbYDMKdfFJVr7emWF5bYgdVwZo+I6Qn1g7/9QPV1QWnSLhsOX98
	 8nNzwLFNIHszygVboUN1+AqKRS37Jra+hqmbzFWteJb90IWbjVAqqLCrtVo7qEKSjIPRw
	 V841BnNeY7zeTAjCyjZFNRvmBtId9nDj9m/4200mWgS3lynDfQUyiIhDJwKe6PI6dE/Zf
	 +7CCVTVDL+4PjsAFEstMkEU00xUvYulDWyFKqJCIxzSd1lnTxLyWn8WxkJizAyFWDbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9zFQRMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BADA606A31C
	for <nvdimm@lists.linux.dev>; Wed, 18 Nov 2026 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9zFQRMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59491F000C7;
	Wed, 18 Nov 2026 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017545;
	bh=pWrk6vf2k3AbshFjf0BbK/R6P7Yi6LZ89zMfgvqB8b4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q9zFQRMFQ6HhV2DEkrOYaXCITbUEUnPtKJBsai1kVu/Su8CzrFDxpoHwiKFUxINLH
	 LOKZzygkh6GiLluWkTubijMFRzzPeK7okMJDYTzhGAxoRteJHi77VXtTbQ9lcoADxu
	 XaOIgVc4FuKCLi6tqtfSaNR3DC0n83CUUJfzS5DHLagjkZ9XmUxdPnUDh2Y8QozkPw
	 +54+NQ8NQovsa4UNy88VbvQlsbMmpnrW4sET3T8H9nWlnglf6MXz+ocH/NCS8I4+pg
	 TL9tptDlaSbSzx2TNLWTLZhLt5p3rFqIXZov7pO9ZLdQu5514XYnTLRwOLzP7jJbnD
	 Qx8aWT80MYjIA==
Message-ID: <sashiko-outbox-221396@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] mm/memory: replace uffd-wp markers in
 insert_page_into_pte_locked()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jingyi Sun" <1045704958@qq.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Muhammad
 Usama Anjum" <usama.anjum@arm.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-2-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:59:04 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: uffd-wp bit not checked on mkwrite in
  insert_page_into_pte_locked()
--

commit 6bd6838d9e7f98f448f46bdb05cc4400045f49f7
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()

This commit updates insert_page_into_pte_locked() to replace uffd-wp PTE
markers with a new PTE that preserves the uffd-wp bit when handling faults
on DAX mappings.

> diff --git a/mm/memory.c b/mm/memory.c
> index f927f2241e404..66ad58429967e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2452,8 +2452,9 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  {
>  	struct folio *folio =3D page_folio(page);
>  	pte_t pteval =3D ptep_get(pte);
> +	bool uffd_wp_marker =3D pte_is_uffd_wp_marker(pteval);
> =20
> -	if (pte_none(pteval)) {
> +	if (pte_none(pteval) || uffd_wp_marker) {
>  		pteval =3D mk_pte(page, prot);
>  		if (unlikely(is_zero_folio(folio))) {
>  			pteval =3D pte_mkspecial(pteval);
> @@ -2467,6 +2468,8 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
>  			folio_add_file_rmap_pte(folio, page, vma);
>  		}
> +		if (uffd_wp_marker && userfaultfd_wp(vma))
> +			pteval =3D pte_mkuffd(pteval);
>  		set_pte_at(vma->vm_mm, addr, pte, pteval);
>  		return 0;
>  	}

[Severity: Medium]
Can a concurrent write fault in insert_page_into_pte_locked() mark a
present uffd-wp PTE writable without clearing the uffd-wp bit?

DAX fault handlers serialize on the DAX mapping entry lock in
grab_mapping_entry() and only acquire the page table lock inside
vmf_insert_page_mkwrite() -> insert_page() ->
insert_page_into_pte_locked().  If a read fault and a write fault race on
the same uffd-wp PTE marker:

CPU0 (read fault)                 CPU1 (write fault, mkwrite =3D true)
dax_iomap_pte_fault()             dax_iomap_pte_fault()
  grab_mapping_entry()
  dax_fault_iter()
    vmf_insert_page()
      insert_page_into_pte_locked()
        /* replaces marker with
         * present RO uffd-wp PTE
         */
        pteval =3D pte_mkuffd(pteval)
        set_pte_at(..., pteval)
  dax_unlock_entry()
                                    grab_mapping_entry()
                                    dax_fault_iter()
                                      vmf_insert_page_mkwrite()
                                        insert_page_into_pte_locked()
                                          /* pte_none() and uffd_wp_marker
                                           * are both false
                                           */
                                          pteval =3D maybe_mkwrite(pteval, =
vma)
                                          ptep_set_access_flags(..., pteval=
, 1)
                                            <-- pte_write() && pte_uffd()

In the existing-PTE path of insert_page_into_pte_locked(), maybe_mkwrite()
sets the writable bit without checking userfaultfd_pte_wp(vma, pteval):

mm/memory.c:insert_page_into_pte_locked() {
    ...
	if (pte_pfn(pteval) !=3D page_to_pfn(page)) {
		WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
		return -EFAULT;
	}
	pteval =3D maybe_mkwrite(pteval, vma);
	pteval =3D pte_mkyoung(pteval);
	if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
		update_mmu_cache(vma, addr, pte);
}

This leaves the present PTE with both pte_write() and pte_uffd() set,
which triggers WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte)) in
page_table_check_pte_flags() when CONFIG_PAGE_TABLE_CHECK is enabled and
breaks UFFD_FEATURE_WP_ASYNC write tracking because hardware writes no
longer trap into do_wp_page() while pagemap_scan sees pte_uffd() still
set.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-uffd-dax-a=
sync-wp-fix-v1-0-c9a30f27f452@kernel.org?part=3D2
