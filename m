Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D79246E009;
	Tue, 21 Jul 2026 18:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658779; cv=none; b=aRAbjBWVuVhz7AaavhPG3AF8TB0ATBK3xL3QRvrOJnCxlbg5+F7QiYZQOQDYzC7mO5lYpYvPjOqUVjZrG4vOHXKUZg2nleI6jUYWVRsFIEl5F3JxLBAxQtj5aV3tNSUo5tliXlgjTeZX+khQZF1BnbKcNutD4kmGg8g737rDPcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658779; c=relaxed/simple;
	bh=OOkaL4lpnS5Qw/UTmYERzFjvfDzV56Qm/AhTQUM20ZE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EBLukwwoSCkatKdh9el0tUMmrqBTIuuByzu/tf7STi/aXKY9ropVchw0F7WtalsTHlxILjI+gk9CmqeytcnRCb+njXvp1M5p8DO26asqOZSsxynrwrpiWGAU+k1/yXMlUxS69JOio3R2KYE2/U5490b3QwRpTz0nhNjNaYY7T54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGcKoeJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGcKoeJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706661F000E9;
	Tue, 21 Jul 2026 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658777;
	bh=mO7/ZkRxP9TPkZGsiKEGrJQZq6dmwkd/IEXmOTMYits=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGcKoeJBVi3CKeUe2IGhl/gd/FgeYKmKN24UXxwosINLc7x+TNHCFNtr/74fqkqSJ
	 SXTQ5Acgj6NhHO/sA3igZdaH6zoXrCwyu73mLawktx6urTFyzQ5/ImOlFR+M6MMhe3
	 ixg3qJOfNDYGgEOT5dKwArLcuPjHAtCIyneyO+gkfSTacbvUw4+G0eHDSH+1PJPuKx
	 FzPlecLqzqI09WJjhvqlbAW2iHhV43tW8UkrkPNRnA2fMZK6xY0JyMDpCKyY9jpYuh
	 9zInChsmzDYB7oj4soY/ZkL68tBv27mQAVsN48CS581nrBj10QiJsuysrccLtvrshA
	 aM3TERmEhGG2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/36] mm/migrate: disallow userland driven migration
 for private nodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, kvm@vger.kernel.org, mkoutny@suse.com, damon@lists.linux.dev, tj@kernel.org, hannes@cmpxchg.org
In-Reply-To: <20260720193431.3841992-10-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-10-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:32:56 +0000
Message-Id: <20260721183257.706661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Incomplete replacement of `zone_device` checks allows uncoordinate=
d background migrations of private node memory.
- [High] node_private_unregister() permanently returns -EBUSY for private n=
odes because offline_pages() never clears N_MEMORY_PRIVATE.

Pre-existing issues:
- [High] User-space addresses are not stripped of memory tags (e.g., ARM64 =
MTE) before VMA lookup in do_pages_stat_array(), causing valid tagged addre=
sses to fail with -EFAULT.
--

--- Patch [9]: [PATCH v5 09/36] mm/migrate: disallow userland driven migrat=
ion for private nodes ---
commit 7ed55bccdffe7ca2bf917693b091b54ebe294b02
Author: Gregory Price <gourry@gourry.net>

mm/migrate: disallow userland driven migration for private nodes

Use the same filter locations as zone_device folios to disallow
userland driven migration requests for private node memory.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index a8a86141dbb54..d20674c07b947 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2268,7 +2268,7 @@ static int __add_folio_for_migration(struct folio *=
folio, int node,
>  	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
>  		return -EFAULT;
> =20
> -	if (folio_is_zone_device(folio))
> +	if (folio_is_private_managed(folio))

[Severity: High]
By updating these filters, do we also need to update similar checks in
uncoordinated background migration paths?

If background tasks encounter a private node folio, they will evaluate
folio_is_zone_device() or is_zone_device_page() as false. Could this allow
NUMA balancing, KSM, or khugepaged to silently migrate private node memory
to general-purpose nodes?

For example, in NUMA balancing:

mm/memory.c:do_numa_page() {
    ...
    if (!folio || folio_is_zone_device(folio))
        goto out_map;
    ...
}

In THP collapse:

mm/khugepaged.c:khugepaged_scan_pmd() {
    ...
    if (WARN_ON_ONCE(page && is_zone_device_page(page)))
        page =3D NULL;
    ...
}

And in KSM:

mm/ksm.c:get_mergeable_page() {
    ...
    if (!folio_is_zone_device(folio) &&
        folio_test_anon(folio)) {
    ...
}

>  		return -ENOENT;
> =20
>  	if (folio_nid(folio) =3D=3D node)
> @@ -2477,7 +2477,7 @@ static void do_pages_stat_array(struct mm_struct *m=
m, unsigned long nr_pages,
>  		if (folio) {
>  			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
>  				err =3D -EFAULT;
> -			else if (folio_is_zone_device(folio))
> +			else if (folio_is_private_managed(folio))

[Severity: High]
This isn't a bug introduced by this patch, but does do_pages_stat_array() f=
ail
to handle tagged pointers?

When a user-space program passes an array of tagged pointers to move_pages
with nodes =3D=3D NULL, the pointers are cast directly to unsigned long wit=
hout
being sanitized by untagged_addr_remote():

mm/migrate.c:do_pages_stat_array() {
    ...
    unsigned long addr =3D (unsigned long)(*pages);
    struct vm_area_struct *vma;
    // ...
    vma =3D vma_lookup(mm, addr);
    ...
}

Could this cause vma_lookup() to treat the tag bits as part of the virtual
address, causing valid tagged addresses (like those used with ARM64 MTE) to
fail with -EFAULT?

>  				err =3D -ENOENT;
>  			else
>  				err =3D folio_nid(folio);

[Severity: High]
On a related note regarding private node teardown, does offline_pages() need
to clear N_MEMORY_PRIVATE?

If a driver attempts to teardown a device and offline its memory,
offline_pages() clears N_MEMORY but omits N_MEMORY_PRIVATE:

mm/memory_hotplug.c:offline_pages() {
    ...
    if (node_arg.nid >=3D 0)
        node_clear_state(node, N_MEMORY);
    ...
}

Will this cause node_private_unregister() to evaluate node_is_private(nid)
as true and permanently return -EBUSY?

drivers/base/node.c:node_private_unregister() {
    ...
    if (node_is_private(nid)) {
        mem_hotplug_done();
        mutex_unlock(&node_private_lock);
        return -EBUSY;
    }
    ...
}

Could this permanent -EBUSY prevent drivers using the N_MEMORY_PRIVATE
feature from cleanly unloading?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720193431.3841=
992-1-gourry@gourry.net?part=3D9
