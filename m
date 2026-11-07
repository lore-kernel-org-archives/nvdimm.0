Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087830;
	b=2GfSJGrYSt3YF89p+OHJ5IzQ3reabeYA9l0+7I4VMXYcwVgcE9UtXqfkUiH8NOPwYqFb
	 MB+d02CvR6FlLEzjQ+3RI44S7fzJIT8ZlfwoUid0NwHY2JpafU/k7h1rtW5UhzPzejoYI
	 RjQ6fROl+0ZAf0xz4ivgwEMQ6lAaHgiUe7+l9LNfWf5YLwLyhfZ43eHerxJKT3MaXWKlB
	 71ZixI4egPrWru5Dj+pE+d3hbt3WWxbIiMaAmXRXx9WkUjBoUaJ/9LpnNg+SHIm4oa1dN
	 1riU9YzqMKCJd9p4IS7EKEYjMD4zOzKnLc3j3E420pneQ/c+Ej9qb7zmmfgKccCGJrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087830;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=N78A/tFJL2MmiAzsL6G/70rStLyxim8xc/oVb8tqpuU=;
	b=zPWLxnkjrBJjzdkf5C0jcOQq1fko/y3jO4PTBt/SfA7FOjCkfwQChlE1ew0tELM5CfL5
	 34N2bjdGIRvvnfXgyZUspEt/WC2Gg/HkCpEH+kaubkEJcI/85Z9lXRJl5E7n3xkokL/hW
	 F0RZ/Xc4g5XvA9vyYwNXojGQP8OJBFcKsqA7TUzgELRPa8OrmRXRqZMA/TABroMrF+7Gw
	 1844Mq2gFtZi2qLUPW7uITGnfnoYDYO8IN8wcpbhtotrvqnyw3+fih5rBldIMr0X7tfAe
	 /UykFNZ1Ka9bujN3XtR8k6fpog9ZMuvL2ZPMOzhvt8vI9joA2fTqEIP573oNP9aQP5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bs7EKf1N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27BF606A326
	for <nvdimm@lists.linux.dev>; Sat,  7 Nov 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bs7EKf1N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE20C1F0089F;
	Sat,  7 Nov 2026 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087829;
	bh=N78A/tFJL2MmiAzsL6G/70rStLyxim8xc/oVb8tqpuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bs7EKf1NrquqVcdeffxNtsF57wBEJNKPQoJVKMNVOjRqdcAKIsmjhcGLpML3JIb4Y
	 7IiPJGfF9omV+XCSkmQ2P04ceU9CB+2NyUbD44tmFC+8Qnv9YrRbuQbSrmY/SKOft5
	 TOcPUaWzCBL4MnDJjLXoQ68VO32RnL06KQO/I6edx/PcWl7Uv5o9c8XJY02qpGuq3P
	 kU++2vSg9WWjzaDlMrfUyoyAHbk0MLABnxK9SBNBKBdgsIftvfpPGe3IIToE3hG/eL
	 HJFlQBsq9eWr6Y1+Ow4jqUhpZuRKb+4EQbzZTJE3LWo/Gd3VbEQioWJL6x3lqrRL8A
	 ackYIt2vyboRA==
Message-ID: <sashiko-outbox-203344@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/truncate: unmap DAX entries before invalidating them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zi Yan" <ziy@nvidia.com>, "Dan Williams" <djbw@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "John
 Groves" <John@Groves.net>, "Miklos Szeredi" <miklos@szeredi.hu>, "Darrick
 J. Wong" <djwong@kernel.org>, "Carlos Maiolino" <cem@kernel.org>, nvdimm@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
References: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 21:43:48 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] mm/truncate: unmap full DAX_PMD range in
  invalidate_inode_pages2_range()
- [High] fs/dax: premature disassociation of shared folios in
  dax_can_disassociate()
- [High] fs/dax: stale i_pages entry when __dax_invalidate_entry() skips
  busy folio
- [Medium] dax: cross-file TOCTOU and data race on folio->share in
  dax_can_disassociate()
--

commit cd725b6545b68d39f6ee84c70fd91581edad91be
Author: Zi Yan <ziy@nvidia.com>

mm/truncate: unmap DAX entries before invalidating them

This commit unmaps DAX ranges before invalidating entries in
invalidate_inode_pages2_range() and skips disassociating clean DAX entries
whose last association still has elevated folio references.

> diff --git a/fs/dax.c b/fs/dax.c
> index 94ba41273347c..e448552d8080d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -527,6 +527,24 @@ static struct page *dax_busy_page(void *entry)
>  		return NULL;
>  }
> =20
> +/*
> + * Determine if an entry can be disassociated. It cannot be if it is its=
 folio's
> + * last association and the folio still has a reference.
> + */
> +static bool dax_can_disassociate(void *entry)
> +{
> +	struct folio *folio;
> +
> +	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> +		return true;
> +
> +	folio =3D dax_to_folio(entry);
> +	if (dax_folio_is_shared(folio) && folio->share > 1)
> +		return true;
> +
> +	return !folio_ref_count(folio);
> +}

[Severity: High]
Can returning true whenever folio->share > 1 allow a shared PMD folio to be
dissolved while it is still PMD-mapped?

During a CoW write on file A, xfs_file_dax_write() holds XFS_IOLOCK_EXCL
without XFS_MMAPLOCK_EXCL, so a read fault on file A can refault the shared
PMD between the initial unmap_mapping_pages() and __dax_invalidate_entry():

CPU0 (CoW write on file A)        CPU1 (fault on A / truncate on B)
invalidate_inode_pages2_range(A)
  unmap_mapping_pages(A)
                                  xfs_dax_read_fault(A)
                                    dax_fault_iter()
                                      vmf_insert_folio_pmd()
                                      (refcount =3D=3D 1, mapcount =3D=3D 1)
  __dax_invalidate_entry(A)
    dax_can_disassociate()
      folio->share =3D=3D 2 -> true
    dax_disassociate_entry()
      --folio->share (now 1)
                                  dax_break_layout(B)
                                    unmap_mapping_pages(B)
                                    dax_busy_page() -> NULL
                                      (refcount - mapcount =3D=3D 0)
                                    dax_delete_mapping_entry(B)
                                      --folio->share (now 0)
                                      dax_folio_reset_order()
  unmap_mapping_pages(A)
    folio_remove_rmap_pmd()  <-- corrupts dissolved tail page

In addition, if file A holds a GUP pin on the shared folio,
dax_can_disassociate() removes the entry from file A's i_pages while
folio->share > 1, so a later dax_break_layout() on file A will no longer fi=
nd
the entry in i_pages or wait for the GUP pin.

[Severity: Medium]
Can concurrent invalidations on two files sharing a folio race on
folio->share in dax_can_disassociate()?

__dax_invalidate_entry() only holds the current mapping's i_pages lock:

CPU0 (file A)                     CPU1 (file B)
__dax_invalidate_entry(A)         __dax_invalidate_entry(B)
  xas_lock_irq(&A->i_pages)         xas_lock_irq(&B->i_pages)
  dax_can_disassociate()            dax_can_disassociate()
    folio->share =3D=3D 2 -> true         folio->share =3D=3D 2 -> true
  dax_folio_put()                   dax_folio_put()
    --folio->share                    --folio->share (reaches 0)
                                      dax_folio_reset_order()  <-- folio bu=
sy

Both callers bypass the folio_ref_count(folio) check when folio->share =3D=
=3D 2
and then non-atomically decrement folio->share in dax_folio_put(), which can
either corrupt folio->share (a data race) or dissolve a referenced compound
folio when the second decrement reaches 0.

> @@ -853,9 +871,14 @@ static int __dax_invalidate_entry(struct address_spa=
ce *mapping,
>  	entry =3D get_next_unlocked_entry(&xas, 0);
>  	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
>  		goto out;
> +	/*
> +	 * Removing the last association of a folio releases the folio, so make
> +	 * sure the folio has no reference.
> +	 */
>  	if (!trunc &&
>  	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
> -	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
> +	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE) ||
> +	     !dax_can_disassociate(entry)))
>  		goto out;
>  	dax_disassociate_entry(entry, mapping, trunc);
>  	xas_store(&xas, NULL);

[Severity: High]
What happens when dax_can_disassociate() returns false during a CoW write a=
nd
leaves the old DAX entry in mapping->i_pages?

If the folio has an elevated refcount (for example from a short-term GUP pin
or a racing fault), __dax_invalidate_entry() skips the entry and
invalidate_inode_pages2_range() returns -EBUSY.  dax_iomap_iter(),
dax_unshare_iter() and dax_zero_iter() ignore that return value and complete
the CoW remap to a new unshared extent while the old entry remains in
mapping->i_pages.

On a subsequent fault to the now-unshared extent (shared =3D=3D false),
dax_insert_entry() sees a non-empty entry and neither replaces it nor calls
dax_associate_entry() on the new PFN:

fs/dax.c:dax_insert_entry() {
    ...
	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
		struct folio *folio =3D pfn_folio(pfn);
    ...
}

dax_fault_iter() then takes a reference on the old folio from *entry while
passing the uninitialized, zero-refcount new PFN to vmf_insert_folio_pmd() =
or
vmf_insert_page_mkwrite(), which fails with VM_FAULT_SIGBUS.  Meanwhile, the
stale entry left in the first file's i_pages still points to the physical
folio now owned exclusively by the other reflinked file, so truncating or
evicting the first file later calls dax_folio_put() ->
dax_folio_reset_order() on the second file's live PMD folio.

[ ... ]

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 9e9bf029635cf..b03cd99c4bba8 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -732,6 +732,15 @@ int invalidate_inode_pages2_range(struct address_spa=
ce *mapping,
>  	if (mapping_empty(mapping))
>  		return 0;
> =20
> +	/*
> +	 * Invalidating a DAX entry can release its folio, so unmap DAX entries
> +	 * before invalidating them. dax_invalidate_mapping_entry_sync() skips
> +	 * the last association of a folio that still has references, e.g.
> +	 * because it was faulted in again in the meantime.
> +	 */
> +	if (dax_mapping(mapping))
> +		unmap_mapping_pages(mapping, start, end - start + 1, false);
> +
>  	folio_batch_init(&fbatch);
>  	index =3D start;

[Severity: High]
Does unmapping only [start, end] leave PTE mappings in place when [start, e=
nd]
partially overlaps an order-9 DAX_PMD entry in mapping->i_pages?

grab_mapping_entry() and dax_insert_entry() keep an existing storage-backed
DAX_PMD entry in mapping->i_pages when servicing PTE faults (such as in a
smaller or unaligned VMA).  When a sub-PMD write calls
invalidate_inode_pages2_range(mapping, start, end), unmap_mapping_pages()
only unmaps [start, end], whereas dax_invalidate_mapping_entry_sync() ->
__dax_invalidate_entry() disassociates and removes the entire 2MB DAX_PMD
entry covering [index & ~PG_PMD_COLOUR, index | PG_PMD_COLOUR].

If the PMD folio is not shared (or this is its last share), the un-zapped P=
TEs
outside [start, end] keep folio_ref_count(folio) > 0, so
dax_can_disassociate() deterministically fails with -EBUSY and leaves the
stale DAX_PMD entry in i_pages after CoW remapping.  If folio->share > 1,
dax_can_disassociate() succeeds and drops this file's share while those PTEs
outside [start, end] remain mapped, so when the other file drops the last
share, dax_folio_put() dissolves the order-9 folio while its tail pages are
still mapped via PTEs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-fix-dax-in=
validate-mapped-v1-1-292ce5958d67@nvidia.com?part=3D1
