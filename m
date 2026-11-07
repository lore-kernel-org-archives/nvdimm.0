Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071147;
	b=yqd8sNjZ4kc1Uk6s2+hDouNLv9sJ+XlYqxnfor1HE3QMMwl1hhG2CKV9Uzo8POVdY8yT
	 rOBzQ+YLw6aJCYwALLVDE4mpdrYSmtSnL1DuOa6/Y9tEC2Jw3zOW1mfqm7cD6nkdLdKPA
	 5fFpuycCUJSDkY0R5OjR/wByCgFj5PLrxEtsYDG4Uy+HVGddjjB3MApCLjKpBVPwJaVrd
	 Rnh9fIGBVSYcGxsAPRUtNp4Zec7e/QKt7WwcWvid9Tvk3DSfN43cyvWlt53mzzMkiQFkh
	 ukPqjZYxZ/P/dCE6/PL98HzbwiUULJIkzrj8Q2N8ttQu6A3rvEoMZuK4LzHt9SJZ+wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071147;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iJmGchz1AX0vrnO9zoYnlDu0hojN7QEExY5Nx/DdNy0=;
	b=EBy+/T+WlW2M7yAIzUiYbTRiwlOvBKKt3ZiPs+rI+Ycpkzem36qeW9jwIcfsYV/+8vYd
	 nwdBpWulvVJTQJtNekUCaxAnhyu0KrOz8goiIrGJFA7CHM0s3fJP/MgzNtK+M+CJFgqJY
	 Bq0wZuFAcFsrAOMWNCLi4k4TVKnjHmfcQujqi3tNwz3vMJzC+kSUqylEW+Ls44rCF4D0i
	 EdjqwvKLv1Ed2Bu5Y+yYNuKzIVk3OX0k/R2X4i2TczL7rHhdhN8MHxALPwOncKAcW7Pgn
	 fdoFMZmHAUrlxyg4+oKY3iFuyjfJfA047J9+NjSM4Crzw+GVSpJFMT3jUQ8cxqWjJJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jU+yyG/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04800606A326
	for <nvdimm@lists.linux.dev>; Sat,  7 Nov 2026 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jU+yyG/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEFD1F0089F;
	Sat,  7 Nov 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794071146;
	bh=iJmGchz1AX0vrnO9zoYnlDu0hojN7QEExY5Nx/DdNy0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jU+yyG/X1Uzp0VTQ2A3quFIHuu14tHMl3Pf0hihLFfwdzxrcfX9N9xa9d22lSOVxY
	 /fg5qR9/SPU++x0HAyXzUsN6Ui/H4L7tvWRm+FgCrde3mxfgxlW6ybd66MBb+iD98T
	 dH4pHXyLdOLFUYu4jYqOC1+HvGo8I0SRAw0xr+iETVRjHsQzRnyjOu7A+jv5LhNjnG
	 J0+Uqs1YHFD+N/34Ku5G8C6uVefMmaRod/JgO8+pt97UvInc3B1iq0M04cf9M/460T
	 U/WiWlPPO/MlB+oj7eDZhimuapdqqXD/Wup2hhNNolmBKod8NnKYwlsboprhpogy8w
	 mukvWZnbIVV+A==
Message-ID: <sashiko-outbox-203086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "Dan
 Williams" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 17:05:45 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: hardware A/D bits discarded for PUD folios in
  zap_huge_pud() [1]
--

commit a6bb79712598f2da7fdcc94c9b1b5f8b9aad8851
Author: Konstantin Khorenko <khorenko@virtuozzo.com>

mm/huge_memory: use folio_dup_file_rmap_pud() in copy_huge_pud()

This commit adds folio_dup_file_rmap_pud() to duplicate file rmap mapcounts
at the PUD level and uses it in copy_huge_pud() instead of
folio_add_file_rmap_pud().

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d0e19d9e6b651..13caf81cb51af 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2100,7 +2100,7 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, s=
truct vm_area_struct *src_vma
>  		 * TODO: once we support anonymous pages, use
>  		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
>  		 */
> -		folio_add_file_rmap_pud(folio, page, dst_vma);
> +		folio_dup_file_rmap_pud(folio, page, dst_vma);
>  		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
>  	}

[Severity: Medium]
This problem wasn't introduced by this patch, but does zap_huge_pud()
discard hardware accessed and dirty bits on the PUD folio [1]?

mm/huge_memory.c:zap_huge_pud() {
	...
	orig_pud =3D pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
	...
	} else {
		...
		page =3D pud_page(orig_pud);
		folio =3D page_folio(page);
		folio_remove_rmap_pud(folio, page, vma);
		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
	...
}

Unlike zap_huge_pmd(), which checks the cleared entry and calls
folio_mark_accessed() and folio_mark_dirty(), zap_huge_pud() removes the
PUD rmap without propagating the young and dirty bits from orig_pud to the
folio.  When unmapping a refcounted Device DAX PUD mapping, those hardware
A/D bits are lost, leaving the folio with stale access and dirty state.

[1] https://sashiko.dev/#/bug/linux-d2fca843-ce3d-48bf-9ef3-bf87872ea6ec

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-khorenko-v=
stor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com?part=3D1
