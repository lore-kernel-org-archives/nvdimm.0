Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834901;
	b=5lF6PWthZrVIbedBm70RYJa1IYpH8cZdQ0IIle83Qp8q2B9dbWOHzY4AiysSIKbNXswr
	 rRqSgiB21eg8B7i0/U7mlo2y2wtuw6wn8uWTA3YWWM0T26JU8bH37cmjtzcJ6Od3s1o/C
	 rL8IZlqS1cqLoGUL7DnnOyIZrCB5AG7a3b+lX2wTdCRzQJBR88Ct6ncrzifzBl4dVMi+c
	 HqXL4NUuxsxX9FOMpU7yRNPH7O7bwr2xdJuTRXGd7Z7r/hnPQD+zT2h7jkOBW9TT6t8Qp
	 ZB50yODyVgziam+DsziCyRMmWLGr+XxMFFPWql9aXusfu/QNINwx8+nOPaFBNOFIpBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834901;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GsWJGVvgmFNtxHpcuOshcVcS+zhK2nls+4JZvrlZzZM=;
	b=BJesmBPK9s0tHwzQZIhG4z1dBxqwU86wbG4Bn0zNOuNv4zWqsz9kTCqrfbFhTTKzfSJd
	 lbybsQ7P4PUk0a81GMVTwDIADEHmqHEv5eshS6eT3U7f/dBgg6myCYnafCKW4Kas+ML3E
	 XpsidAKxJT8Ymu4F8iG/1sPiPh71THkedctfcPp728WOHznWCx4pzT1EQMaAXmY/hIFR5
	 voubXv6zrR6TAejLFFlceE9laiUb5cI6KwKtUFqWHOucHWPcq1cKGZ+5EbGOH0AKcyrgq
	 QmDtDAlzeoQGW1yM4ziOEwn1aW+sxGfU4A/6FZDosW6ow0en1NCDvClvVPN/tTsGtsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BNKWpwMJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C63606A31B;
	Wed,  4 Nov 2026 23:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BNKWpwMJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62481F000C1;
	Wed,  4 Nov 2026 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834900;
	bh=GsWJGVvgmFNtxHpcuOshcVcS+zhK2nls+4JZvrlZzZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BNKWpwMJTBkDPMec6dD7P7a37/oXw3tsFms1lZAlbj47ZFiVyyKb6N2w60qg0bQVQ
	 apUhWvbJbDXKvEykMiR0Pd8uFYa74e8jiIDI2sMAwa8RSdz5va9wYQy18+8tWbaVLm
	 838dw4Qv2ui0PsSWV5pwF3XDWR8S/G+5tCj58w6ebqg7H6g1+aRtkNDSvsVAEW9aY8
	 u+ziu/S4OqMlqAGR1W6N6mMatNwZ5lHUvEX4cl7t4tI9teikbikgQjyeqU4Cd9AbBL
	 KPTKObwsdlrN5XZiywhubvPgZqUm2W+jEHWUYcYx846DQKSQmYoMBt1NDedNwWJbGf
	 xT3EmLHr3Byww==
Message-ID: <sashiko-outbox-198297@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 11/14] cxl/extent: Handle DC Release Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-12-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-12-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:28:20 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] cxl/extent: missing end < start range check in cxl_resolve_extent()
- [High] cxl/extent: cxl_resolve_extent() misses overlaps across decoder bo=
undaries
- [High] cxl/extent: deferred xa_erase() and unpinned group in cxl_rm_pendi=
ng()
- [High] cxl/extent: premature capacity release in cxl_rm_pending() during =
teardown
--

commit d32b383472a7ac06793ed19dcde742a2c32c23c3
Author: Ira Weiny <iweiny@kernel.org>

cxl/extent: Handle DC Release Capacity events

This commit replaces the Release Capacity ack-all stub with extent lookup a=
nd
tag group teardown, matching released extents by DPA range and tag and
acknowledging released capacity via CXL_MBOX_OP_RELEASE_DC.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 4a59db823af4f..1873a3dfe8e0b 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -449,6 +449,109 @@ int cxl_add_extent(struct cxl_memdev_state *mds, st=
ruct cxl_extent *extent,
>  	return cxlr_add_extent(mds, cxlr_dax, dc_extent);
>  }
> =20
> +/**
> + * cxl_resolve_extent() - locate the tag group a released extent belongs=
 to
> + * @mds: memdev state
> + * @extent: extent from a DC Release-Capacity record
> + * @cxlrp: returns the region owning the group
> + * @groupp: returns the matching tag group
> + *
> + * Pure lookup, no side effects.  A record names the dc_extent that cont=
ains
> + * its range: the host cannot split an extent.
> + *
> + * Return: 0 when @extent matches an extent the host owns.  -ENXIO when =
the
> + * extent doesn't match anything on the host (no region, no dax region, =
or a
> + * range that has no overlap with host-owned extents), so the release can
> + * simply be acknowledged.  -EINVAL when it overlaps owned capacity with=
out
> + * matching any single host-owned extent: it straddles multiple extents,=
 or
> + * the tag doesn't match.
> + */
> +int cxl_resolve_extent(struct cxl_memdev_state *mds, struct cxl_extent *=
extent,
> +		       struct cxl_region **cxlrp,
> +		       struct cxl_dc_tag_group **groupp)
> +{
> +	u64 start_dpa =3D le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd =3D mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct dc_extent *dc_extent;
> +	struct cxl_region *cxlr;
> +	struct range dpa_range;
> +	unsigned long idx;
> +	uuid_t tag;
> +
> +	*cxlrp =3D NULL;
> +	*groupp =3D NULL;
> +
> +	dpa_range =3D (struct range) {
> +		.start =3D start_dpa,
> +		.end =3D start_dpa + le64_to_cpu(extent->length) - 1,
> +	};

[Severity: High]
What happens in cxl_resolve_extent() if a DCD_RELEASE_CAPACITY event record
has extent->length =3D=3D 0, or if start_dpa + le64_to_cpu(extent->length) =
wraps
around 64 bits so that dpa_range.end < dpa_range.start?

In cxl_extent_dc_partition(), this case is explicitly checked:

drivers/cxl/core/extent.c:cxl_extent_dc_partition() {
	if (ext_range->end < ext_range->start) {
		dev_err_ratelimited(dev,
				    "DC extent DPA %pra (%pU) has invalid length (firmware bug)\n",
				    ext_range, extent->uuid);
		return NULL;
	}
}

Because range_overlaps() and range_contains() assume start <=3D end, an
inverted dpa_range where both start and end fall inside a host-owned
dc_extent->dpa_range satisfies both range_overlaps(&dc_extent->dpa_range,
&dpa_range) and range_contains(&dc_extent->dpa_range, &dpa_range), tearing
down a live tag group if the tag matches.

Conversely, if dpa_range.end wraps below dc_extent->dpa_range.start,
range_overlaps() evaluates to false and cxl_resolve_extent() returns -ENXIO,
causing cxl_rm_pending() to queue the malformed extent onto acks and send it
in CXL_MBOX_OP_RELEASE_DC. Should cxl_resolve_extent() reject
dpa_range.end < dpa_range.start before checking for overlaps?

> +
> +	cxlr =3D cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> +	if (!cxlr)
> +		return -ENXIO;
> +
> +	cxlr_dax =3D cxlr->cxlr_dax;
> +	if (!cxlr_dax)
> +		return -ENXIO;

[Severity: High]
Can a Release Capacity extent whose start_dpa lies outside a decoder (or in=
 a
preceding endpoint decoder) while dpa_range.end extends into a decoder and
overlaps a host-owned dc_extent be misclassified as -ENXIO here?

cxl_dpa_to_region(cxlmd, start_dpa, &cxled) only checks which endpoint
decoder contains the single address start_dpa, and the xarray walk below on=
ly
inspects extents where dc_extent->cxled =3D=3D cxled without verifying that
dpa_range is contained within cxled->dpa_res.

If start_dpa is in an unmapped DPA gap before cxled->dpa_res->start (or in =
an
earlier decoder on cxlmd) and dpa_range.end overlaps a live dc_extent in a
subsequent decoder, cxl_resolve_extent() returns -ENXIO instead of -EINVAL.
The first loop in cxl_rm_pending() then moves the extent onto acks and sends
CXL_MBOX_OP_RELEASE_DC for the range while the host still owns the
overlapping capacity.

> +
> +	import_uuid(&tag, extent->uuid);
> +
> +	/* RCU keeps entries live during the walk; teardown happens later. */
> +	scoped_guard(rcu) {
> +		xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
> +			if (dc_extent->cxled !=3D cxled)
> +				continue;
> +			if (!range_overlaps(&dc_extent->dpa_range, &dpa_range))
> +				continue;
> +			if (!range_contains(&dc_extent->dpa_range, &dpa_range))
> +				return -EINVAL;
> +			if (!uuid_equal(&dc_extent->group->uuid, &tag))
> +				return -EINVAL;
> +			*cxlrp =3D cxlr;
> +			*groupp =3D dc_extent->group;
> +			return 0;
> +		}
> +	}
> +	return -ENXIO;
> +}

[Severity: High]
Could a transient kobject/sysfs reference on a member dc_extent->dev cause
cxl_resolve_extent() and cxl_rm_pending() to see already-unregistered
siblings or trigger a use-after-free on struct cxl_dc_tag_group?

When a tag group is torn down via rm_tag_group() -> unregister_tag_group(),
unregister_tag_group() calls device_unregister(&dc_extent->dev) on each
member, while the xarray removals and group->nr_extents-- happen in the
device release callback:

drivers/cxl/core/extent.c:dc_extent_release() {
	group =3D dc_extent->group;
	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
	xa_erase(&group->dc_extents, dc_extent->seq_num);
	group->nr_extents--;
	if (!group->nr_extents)
		free_tag_group(group);
	kfree_rcu(dc_extent, rcu);
}

If a sysfs reader or udev holds a temporary reference on a sibling
dc_extent->dev when device_unregister() runs, dc_extent_release() is delaye=
d:

1. The sibling dc_extent remains in cxlr_dax->dc_extents, so when the second
   loop in cxl_rm_pending() resolves the next sibling in the release chain,
   cxl_resolve_extent() returns 0 instead of -ENXIO.

2. When the external reference to dc_extent->dev is later dropped on another
   CPU via put_device(), dc_extent_release() decrements the non-atomic
   group->nr_extents without synchronization and frees group via
   free_tag_group() -> put_device(&group->dev) -> dc_tag_group_release() ->
   kfree(group) without RCU deferral, while cxl_resolve_extent() reads
   dc_extent->group->uuid under RCU and returns an unpinned dc_extent->group
   pointer.

[ ... ]

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 0fa501f5800c9..c3236fe9e7c5e 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static int cxl_rm_pending(struct cxl_memdev_state *mds)
> +{
> +	struct list_head *pending =3D &mds->dc_chain.pending_extents;
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	LIST_HEAD(acks);
> +	int cnt =3D 0, rc;
> +
> +	/* cxl_resolve_extent() -> cxl_dpa_to_region() walks every decoder's dp=
a_res */
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	guard(rwsem_read)(&cxl_rwsem.dpa);
> +
> +	/* Untracked first, before a teardown below makes a sibling look untrac=
ked */
> +	list_for_each_entry_safe(pos, tmp, pending, list) {
> +		struct cxl_dc_tag_group *group;
> +		struct cxl_region *cxlr;
> +
> +		if (cxl_resolve_extent(mds, pos->extent, &cxlr, &group) !=3D -ENXIO)
> +			continue;
> +		list_move_tail(&pos->list, &acks);
> +		cnt++;
> +	}

[Severity: High]
If cxl_rm_pending() runs concurrently with region teardown, can this first
pass prematurely acknowledge a release before DAX teardown and CPU cache
invalidation complete?

During region teardown, cxlr_dax_unregister() clears cxlr->cxlr_dax and dro=
ps
cxl_rwsem.region before unbinding the DAX region driver:

drivers/cxl/core/region_dax.c:cxlr_dax_unregister() {
	cxlr_dax_unpublish(cxlr_dax);
	/* Unbind first: the driver's teardown empties untagged and the groups */
	device_release_driver(&cxlr_dax->dev);
	...
}

If cxl_rm_pending() acquires cxl_rwsem.region after cxlr_dax_unpublish() se=
ts
cxlr->cxlr_dax =3D NULL (or after __cxl_decoder_detach() clears
cxled->cxld.region =3D NULL) but before device_release_driver(&cxlr_dax->de=
v)
finishes running dc_tag_group_teardown(), cxl_resolve_extent() sees
!cxlr_dax (or !cxlr) and returns -ENXIO.

Because this loop treats -ENXIO as untracked capacity, cxl_rm_pending()
queues the extent onto acks and sends CXL_MBOX_OP_RELEASE_DC immediately
(bypassing the !rm_tag_group(group) check in cxl_release_tag_group()), befo=
re
child DAX devices are torn down and before cxl_region_invalidate_memregion()
flushes CPU caches, and dc_tag_group_teardown() will then send a second
CXL_MBOX_OP_RELEASE_DC for the same group.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D11
