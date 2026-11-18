Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017547;
	b=RBYdMkSE2WqN6H6jrO344HfU2YjTMugDWCOa3jJzVSUEIVZo6y9kJPj4QatKIasxSsrc
	 UkYz+mt0hZjjJIiX6vocb0nSa9VbYD2kWgdh/jdLbTvp1bD8jlHE4z72XKDBwuYfsvJHe
	 XjKW6bPpE2Z4lThsMJFMw7CwTDmJ5BTH7myvOOZ6NKXO8+4Pu3PadlYehNE7P9G9F8pkN
	 rGr9HBQwiFqcJr3NwKr/Hc7i2rCWDEEWOaStyQ9nY0InWsnx6ZQopPem2010lWoF5sm1j
	 QgGSUUK77skXd+ia9q6/Jkf4VMdV2PUHUeovx5qOpeiMWhtYwlKgxfHjOJiCfr3xh7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017547;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4eYjkyW3i82Rheb3jflbwVIOwIt4h9ILc15rP8EiaRc=;
	b=4r0YRnsOWqc8UuF6d/YNxXIP+vb5+oa//yNUnCtMiYlHSt0o0tJSGL54JVn7FfQmovCM
	 nY0nR81G9ZM2eGwl45IYh3JtYB5s5hr12L1T4Ywb2cGKKu3MgL6WTnaZelbW9Tcoyte3Y
	 CtpMHCZxjlQnYXUc3fPJKNAAGbBQEPnjyXRjEt0FJdtZgOPlL2KQkVlj2erpzwYiZFok6
	 qmWZQpCn4wLHIDxnbaztgT/XvHGBmUNwhvv6gix3osqtVOgapeAGv8wRISKgpmjj+QOq5
	 AxkT0yLSKD28clvGSQjdwbHLtYXPpI5HddP2IRreCzp91XuA69KXz/kw2qsWWKWudmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUl1Sy6w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0602C606A330
	for <nvdimm@lists.linux.dev>; Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bUl1Sy6w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6BB1F000C5;
	Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017546;
	bh=4eYjkyW3i82Rheb3jflbwVIOwIt4h9ILc15rP8EiaRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bUl1Sy6w8s1GIA2EqOed33vRd9QmF4UYhZwvLeLyScwpKxBovGIcZ4dThGLNXvMSK
	 Qu+EjcRnVDccFe1edUmhR4VSGhLWFnFlhq8PoKP9tdA9nBq+/KHB627GUNdkGYzvwi
	 O8vwBcMrf1O2e6SHRrWwfYi7LOMAu7lIqdglO6q2fJsLJgfUO2R1Ge1Ew485N+Jv7r
	 AKlywCTOaF0/QVFy3YT8wO69NumyfwjHudep0Rkxg4cvNaPZGjFdOQv6g7imAG2nOt
	 aLHIVgS094mSZKXrVNqNqGaoDp+Pj1YBM6M1dMCuPiMQzkiM8HR5l2PYqsZv+05Udx
	 D9STrD34hnSDw==
Message-ID: <sashiko-outbox-221397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jingyi Sun" <1045704958@qq.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Muhammad
 Usama Anjum" <usama.anjum@arm.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:59:05 +0000
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
- [Medium] mm/memory: insert_page_into_pte_locked() upgrades uffd-wp
  PTEs to writable
--

commit 62002bc33a7233bf10217f5cd96cf7d78e384960
Author: Mike Rapoport (Microsoft) <rppt@kernel.org>

mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()

This commit changes insert_page_into_pte_locked() to return -EBUSY when
encountering a non-present PTE on a write fault so that PTE markers are
retried through handle_pte_marker() instead of being upgraded in place.

> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967e..a80925c61706d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_ar=
ea_struct *vma, pte_t *pte,
>  		return 0;
>  	}
> =20
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;

[Severity: Medium]
Can this still upgrade a present PTE that is write-protected by
userfaultfd-wp in place?

When two threads fault concurrently on a PTE_MARKER_UFFD_WP entry in a
shared DAX mapping, the first fault installs a present read-only PTE with
pte_mkuffd() set, and the second write fault then sees a present PTE and
upgrades it with maybe_mkwrite():

CPU0 (read fault)                 CPU1 (write fault, mkwrite =3D true)
dax_iomap_pte_fault()             dax_iomap_pte_fault()
  vmf_insert_page()                 vmf_insert_page_mkwrite()
    insert_page_into_pte_locked()
      /* uffd_wp_marker is true */
      pteval =3D pte_mkuffd(pteval)
      set_pte_at(..., pteval)
                                      insert_page_into_pte_locked()
                                        /* pte_present(pteval) is true */
                                        pteval =3D maybe_mkwrite(pteval, vm=
a)
                                        ptep_set_access_flags(..., pteval, =
1)
                                          <-- pte_uffd() && pte_write()

Because maybe_mkwrite() sets the writable bit without clearing the uffd-wp
bit, this installs a present PTE with both pte_uffd() and pte_write() set.
That triggers the WARN_ON_ONCE(pte_uffd(pte) && pte_write(pte)) in
page_table_check_pte_flags() and allows subsequent writes to bypass
do_wp_page(), losing userfaultfd-wp write tracking.

Should this check also return -EBUSY when userfaultfd_pte_wp(vma, pteval)
is true so the fault retries through do_wp_page()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-uffd-dax-a=
sync-wp-fix-v1-0-c9a30f27f452@kernel.org?part=3D3
