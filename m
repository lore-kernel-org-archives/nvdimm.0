Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835405;
	b=uUKjdOxRgjHX/S6FEdeYhsdAnIZkfB1RdgH2IekUPPA39qMFJQBuYTePgvUD157dFZZI
	 MCv4uqlMU7Z4pnzt5h5pBFFryfqRhJ1PVNRvTK72WdVDD5NSNz66Bm97btMKipIID7f5J
	 KoOjfQQeDsIqRRHGWmZU9OQSBVbehlBpcdMMATlDWma2E5IIdwqHEpN/6ay7KKmgnOGJf
	 kuF3sR1kqLwKLQfq/nEr8gh9VcxjXEikB9W5M44UQZlXjaGmYomrcSURhkfdgZJve4tI6
	 YUmUaZ77tcsV1qpSXV6BA+7H5kbH8Gt+qdTbZCXVmbcrBBsNjS069Z8g9fREPPSoHCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835405;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=f7Haz8/IRygPuQn+3YQvOSr5/V7pHEjnqxK/JQTXWqM=;
	b=QI5eHz7h/79jmscz1ZUWzYqw14rA5lC8zplMHcByxcrD7dfRerBZ0sD206m9+IiZFcb/
	 wjTsjsEMUYKNFEvn/IBVXLpTrsYqCTl3BGffi09X38pWxsRA75qZ0vRJ92cNZItvIQP8z
	 K8sAx/AqWRjotyEHp1fD+oLY7c7zQEZoZA/fQ5vgM3Ks7z09NlMWGVD0iRdCeyI9LzsxR
	 AJmm6Bw6+JZ81mNkPT2jmeCUGAtI8bXQseBkX0hX5k0h8l3g66JBD1A/DpC3qWZPNia6z
	 zAjBKPfjOX4nm0+c6V6Z5tujVQstBvSpParQ1waCdwM/a/gcCE43M1dgjR9+9676l7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0+mbaRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABEF606A31B;
	Wed,  4 Nov 2026 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0+mbaRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030251F000C1;
	Wed,  4 Nov 2026 23:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793835404;
	bh=f7Haz8/IRygPuQn+3YQvOSr5/V7pHEjnqxK/JQTXWqM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O0+mbaRsB2KnBunouFIAndJVwG7sOYOHVAZP1+o01ZRMnz2uEJDi3SEY9jvyYAYgD
	 SbXw7bcF8LAD1xpVib3GfjaIvPhPhR2uHly1a9nJHe7F3Z9Hzm9FED1NMOMZ38Xm3F
	 lCc3jZoZOnT8eb231Y2SBpzNBrTRT2rBaAI41X62YwWwX57TGRdPJ5LRTAMA0Zz+Ha
	 XtAu8+BkYRORxtBh9vjqyxQeej/oBwMlD2uPJ6cEGItra8MZfcV7CNNvBHm9x3Mw4H
	 BWQJNIDErr14YCqlcH2NIFhsKSsT63cV6kCrpoT/nTBR/UpNKpDW24GxFrhI71wCr+
	 K5HcQet17arSg==
Message-ID: <sashiko-outbox-198302@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 12/14] cxl/region: Read existing extents on region
 creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-13-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-13-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:36:43 +0000
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
- [High] cxl/mbox: per-extent DPA filtering in cxl_read_extent_list() split=
s tag groups
- [High] cxl/mbox: cxl_release_recovered() releases already-onlined DPA cap=
acity
- [High] cxl/region: race in cxl_region_add_existing_extents() on concurren=
t detach
- [Medium] cxl/mbox: missing end < start check before range_contains() in e=
xtent scan
--

commit 6931a3e5d551f78995bded312bdac1337c547e3c
Author: Ira Weiny <iweiny@kernel.org>

cxl/region: Read existing extents on region creation

This patch reads pre-existing accepted dynamic capacity extents from the
device via CXL_MBOX_OP_GET_DC_EXTENT_LIST when probing a cxl_dax_region. It
filters extents by the endpoint decoder's DPA range, stages and onlines
recovered tag groups without sending an Add response, and gates new extent
add events until the initial scan completes.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index c3236fe9e7c5e..a18b41ff5d232 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
[ ... ]
> @@ -1627,6 +1641,10 @@ static int cxl_realize_group(struct cxl_memdev_sta=
te *mds, const uuid_t *tag,
>  	mds->dc_chain.group =3D NULL;
>  	if (tag_group)
>  		discard_tag_group(tag_group);
> +err_release:
> +	/* A fresh group is simply left out of the Add response */
> +	if (existing)
> +		cxl_release_recovered(mds, tag, group);
>  	return rc;
>  }
> =20
> @@ -1686,11 +1704,14 @@ static int cxl_validate_group(struct cxl_memdev_s=
tate *mds, const uuid_t *tag,
>   * list.
>   */
>  static int cxl_add_pending(struct cxl_memdev_state *mds,
> -			   struct list_head *pending)
> +			   struct list_head *pending, bool existing)
>  {
[ ... ]
> @@ -1727,11 +1748,13 @@ static int cxl_add_pending(struct cxl_memdev_stat=
e *mds,
>  		shareable =3D cxl_group_is_shareable(mds, &group);
> =20
>  		if (cxl_validate_group(mds, &tag, &group, shareable)) {
> +			if (existing)
> +				cxl_release_recovered(mds, &tag, &group);
>  			drop_extent_group(&group);
>  			continue;
>  		}
> =20
> -		cnt =3D cxl_realize_group(mds, &tag, &group, shareable);
> +		cnt =3D cxl_realize_group(mds, &tag, &group, shareable, existing);

[Severity: High]
Could calling cxl_release_recovered() on all validation and realization
failures release DPA capacity that is already online on the host?

During recovery (existing =3D=3D true), cxl_add_pending() processes groups
sequentially and onlines valid groups into cxlr_dax->dc_extents. If the
device's extent list contains a subsequent group whose tag is already
committed (cxl_tag_already_committed() returning true in
cxl_validate_group()) or whose extent DPA range duplicates or overlaps an
already-onlined dc_extent:

drivers/cxl/core/extent.c:cxl_add_extent() {
	...
	switch (cxlr_dax_classify_extent(cxlr_dax, cxled, &ext_range)) {
	case CXL_EXT_DUPLICATE:
		...
		return -EEXIST;
	case CXL_EXT_OVERLAP:
		return -ENXIO;
	case CXL_EXT_NEW:
		break;
	}
}

both error paths invoke cxl_release_recovered(), which sends
CXL_MBOX_OP_RELEASE_DC for every extent in the failing group. Wouldn't that
release physical capacity on the device that backs an active, already-onlin=
ed
dc_extent on the host?

> @@ -2439,6 +2471,180 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> =20
> +/*
> + * Stage the device's extents inside @dpa_range on @existing.  Returns
> + * -EAGAIN if the list changes while it is being read.
> + */
> +static int cxl_read_extent_list(struct cxl_memdev_state *mds,
> +				const struct range *dpa_range,
> +				struct list_head *existing)
> +{
[ ... ]
> +		for (int i =3D 0; i < nr_returned ; i++) {
> +			struct cxl_extent *extent =3D &extents->extent[i];
> +			struct range ext_range;
> +
> +			ext_range.start =3D le64_to_cpu(extent->start_dpa);
> +			ext_range.end =3D ext_range.start +
> +					le64_to_cpu(extent->length) - 1;
> +			dev_dbg(dev, "Processing extent %d/%d %pra (%pUb) seq %u\n",
> +				current_index + i, total_expected, &ext_range,
> +				extent->uuid,
> +				le16_to_cpu(extent->shared_extn_seq));
> +			/* Another region's, or an unmapped partition's: not ours */
> +			if (!range_contains(dpa_range, &ext_range))
> +				continue;
> +			rc =3D stage_pending_extent(existing, extent);

[Severity: Medium]
What happens in cxl_read_extent_list() if the device returns a malformed
extent where extent->length is 0 or start_dpa + length - 1 wraps around u64
such that ext_range.end < ext_range.start?

Because range_contains(r1, r2) only checks r1->start <=3D r2->start &&
r1->end >=3D r2->end, cxl_extent_dc_partition() explicitly guards against
ext_range->end < ext_range->start before calling range_contains(). Without a
similar check here, an extent with ext_range.start >=3D dpa_range->start (e=
ven
in a higher DPA partition) and a wrapped ext_range.end <=3D dpa_range->end
passes range_contains(dpa_range, &ext_range) and is staged onto existing.

If that malformed extent carries a UUID matching a valid tag group on this
region, extract_tag_group() will merge it into that group in
cxl_add_pending(), causing cxl_validate_group() to fail and
cxl_release_recovered() to release the entire valid group via
CXL_MBOX_OP_RELEASE_DC. Should cxl_read_extent_list() check
ext_range.end < ext_range.start before calling range_contains()?

[Severity: High]
Also in cxl_read_extent_list(), can filtering individual extents by
dpa_range before assembling tag groups split a multi-extent tag group that
spans or straddles the endpoint decoder's DPA boundary?

When cxl_read_extent_list() skips individual extents with
!range_contains(dpa_range, &ext_range), only the in-range subset of extents
is staged onto existing. When __cxl_process_extent_list() subsequently calls
cxl_add_pending(mds, &existing, true), extract_tag_group() forms each group
from only that pre-filtered subset:

1. For a non-shareable group (or a shareable group whose in-range extents
   happen to carry shared_extn_seq 0..k-1), cxl_validate_group() and
   cxl_realize_group() will succeed and online a truncated tag group,
   committing the tag UUID host-wide so the remaining extents cannot be add=
ed
   elsewhere.
2. For a shareable group whose in-range subset is missing earlier sequence
   numbers, cxl_check_group_seq() fails and cxl_release_recovered() sends
   CXL_MBOX_OP_RELEASE_DC for only the in-range subset, violating CXL r4.0
   Section 8.2.10.9.9.4 which requires shared tag groups to be released as a
   whole.

Should all extents be staged first (or grouped by tag first) so that a tag
group only partially contained in dpa_range is detected as a whole?

> diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
> index 790176a8aaddc..816386301b80e 100644
> --- a/drivers/cxl/core/region_dax.c
> +++ b/drivers/cxl/core/region_dax.c
[ ... ]
> @@ -79,6 +81,15 @@ static struct cxl_dax_region *cxl_dax_region_alloc(str=
uct cxl_region *cxlr)
>  	cxlr_dax->hpa_range.start =3D p->res->start;
>  	cxlr_dax->hpa_range.end =3D p->res->end;
> =20
> +	/*
> +	 * DC regions are not interleaved; the probe-time scan uses this decoder
> +	 * and may outlive its attachment to the region, so hold a reference.
> +	 */
> +	if (cxlr->mode =3D=3D CXL_PARTMODE_DYNAMIC_RAM)
> +		cxlr_dax->cxled =3D p->targets[0];
> +	if (cxlr_dax->cxled)
> +		get_device(&cxlr_dax->cxled->cxld.dev);
> +
>  	dev =3D &cxlr_dax->dev;
>  	cxlr_dax->cxlr =3D cxlr;
>  	cxlr->cxlr_dax =3D cxlr_dax;
> @@ -153,6 +164,42 @@ DEFINE_FREE(unpublish_cxl_dax_region, struct cxl_dax=
_region *,
>  		put_device(&_T->dev);
>  	})
> =20
> +/*
> + * Runs from cxl_dax_region_probe().  The region's parameters may not be
> + * read here: a concurrent detach clears p->targets[] under cxl_rwsem.re=
gion
> + * before it waits for this probe.  Use the decoder recorded at allocati=
on
> + * instead; cxlr_dax holds a reference on it.
> + */
> +int cxl_region_add_existing_extents(struct cxl_dax_region *cxlr_dax)
> +{
> +	struct cxl_endpoint_decoder *cxled =3D cxlr_dax->cxled;
> +	int rc;
> +
> +	rc =3D cxl_process_extent_list(cxled);

[Severity: High]
Can a concurrent region detach or reset while cxl_dax_region_probe() runs
cause cxl_region_add_existing_extents() to race with decoder reuse, memdev
teardown, or cache invalidation?

In cxl_decoder_detach(), __cxl_decoder_detach() runs under cxl_rwsem.region
write lock, disables the decoder, and clears cxled->cxld.region =3D NULL and
p->targets[0] =3D NULL before dropping cxl_rwsem.region and calling
device_release_driver(&detach->dev) -> cxlr_dax_unregister(), which waits on
device_lock(&cxlr_dax->dev) for cxl_dax_region_probe() to finish. Because
cxl_region_add_existing_extents() passes only cxled to
cxl_process_extent_list() and runs without cxl_rwsem.region held across the
scan, it looks like several races can occur once __cxl_decoder_detach()
drops cxl_rwsem.region:

1. If cxled is reattached to a new region (cxlr2 / cxlr_dax2) while the old
   cxlr_dax1 probe is in cxl_read_extent_list(), cxl_add_pending() ->
   cxl_realize_group() -> cxl_add_extent() -> cxl_validate_extent() resolves
   start_dpa via cxl_dpa_to_region(cxlmd, start_dpa, &cxled) to cxlr_dax2
   without checking that cxlr->cxlr_dax =3D=3D cxlr_dax1. Because existing =
is
   true, cxl_validate_extent() bypasses the extents_scanned gate and
   online_tag_group() attaches devres actions to cxlr_dax2->dev before
   cxlr_dax2 has probed, causing really_probe() on cxlr_dax2 to fail with
   -EBUSY ("Resources present before probing") and leak the tag groups.
2. Similarly, cxled->dpa_res can be freed and reallocated to a different DPA
   range via cxl_dpa_free() / cxl_dpa_alloc() before
   __cxl_process_extent_list() (or one of its -EAGAIN retries) reads
   cxled->dpa_res under cxl_rwsem.dpa, causing it to scan and release
   extents in the new DPA range via cxl_release_recovered().
3. Once detach_target() clears cxled->cxld.region =3D NULL, a concurrent
   memdev/PCI unbind running cxld_unregister() -> cxl_decoder_detach() sees
   cxled->cxld.region =3D=3D NULL and returns NULL without waiting for
   cxlr_dax1's probe. Holding get_device(&cxled->cxld.dev) only pins the
   decoder device, not cxlmd->cxlds, which cxl_memdev_shutdown() sets to
   NULL before cxl_pci devres frees mds while cxl_process_extent_list() is
   dereferencing cxled_to_mds(cxled).
4. During commit_store() reset (or cxl_decoder_detach()),
   cxlr_dax_unpublish() clears cxlr->cxlr_dax =3D NULL before waiting for
   cxl_dax_region_probe() (and in commit_store(), before
   cxl_region_decode_reset() invalidates CPU caches). When the in-flight
   scan sees !cxlr->cxlr_dax, cxl_validate_extent() returns -ENXIO and
   cxl_realize_group() calls cxl_release_recovered(), sending
   CXL_MBOX_OP_RELEASE_DC while CPU caches may still hold dirty lines or
   before the region teardown has finished.

Should cxl_region_add_existing_extents() pass cxlr_dax into the scan, verify
under cxl_rwsem.region and cxl_rwsem.dpa that cxled->cxld.region =3D=3D
cxlr_dax->cxlr and cxlr->cxlr_dax =3D=3D cxlr_dax, and avoid calling
cxl_release_recovered() when aborting due to a concurrent detach/unpublish?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D12
