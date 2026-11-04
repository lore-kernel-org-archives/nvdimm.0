Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793835282;
	b=ZICsTnKFSwUFvTbFoHKb//zJUjWo5PWmL+owXNgmPJv03+CYEajhSV2TU/ISY85R8E3s
	 0PM49FR/YUUDpQljfBhIH3KxwT5yABBL3IM07bqPoInOnWPBrtMyfFDXaPa3DTyFPSqty
	 h7+9562b77EOx90Xz7Qo8kqizjLQ/n5p0bw0lTTO1HZm94cBF90qILhBI5oAeoMi6JEFz
	 ksGjbtCInFkNnbBbUZCMStZqX4U0Nf2NAloWp1slu1eNtFJ7EzTdraYFw9LYW5r8/bYln
	 Lu4A1YWk33RHwvMkdpTbbFAmFDusA8quzlXXfu8UCujWsix3u9s/NGOx41cKSJCmnXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835282;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NKQXDTnVZ38FCgugTgx3yJHFeA9cExyni1nysWYEqNw=;
	b=ix+8BpTEIkiqRAQDx3OikvNcmYS9D4IKhJDMbgj2yytbVv3WhGaFOr3YXqpH6oA7rT29
	 D9ZQ7VVirejQsOccq2dxqaCZqASQ7Y7k9V9eWhVGD5Kp4XRlMcgMqnfj4ga6DJfLzU6KX
	 2uN86dxqdDqfWphxQA2WKWKHLMmPzZgbxlFvWdhWqFDVRo9SZUN18u7NEAwp+Skwdadk4
	 unSqZugE6H4KxPEbJH8A3fC+NNk9ahEIgbFb9Kam6pv6uKlDT/Mpy3nKkpGqKh2QmaQwc
	 utYnkIlqrTSjp7Qb76ncMIr2EqdfgEjR0KPFB640R61NfVlyEbyA1Ic9f5YFgwuwkvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b6f1sdh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BDD606A326;
	Wed,  4 Nov 2026 23:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b6f1sdh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5CA1F000C1;
	Wed,  4 Nov 2026 23:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793835281;
	bh=NKQXDTnVZ38FCgugTgx3yJHFeA9cExyni1nysWYEqNw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b6f1sdh+8EhuVR+/IVSsuj2arV8vDC/hdfWxIFogqfKWhhBUL/Be6r8aBlJRRF2PV
	 3CaGKIL1vN0cb8F4QjZp0jJvMs7o69GeRncKW2tZM0lAWYInd035S31ZcbL1BGJ6ic
	 taJ6QnlAsP24RGE+XETANGskLHDt8gg6A0u+DJ2fu0nnBa5dj+poRXE2hdSX6nNfPZ
	 lQYu9yANllXW8KSj3YAWaIQNmtRb7X1Sb1gOuTqjqBsVfbDPDwIwUsIJScLz4FwfuK
	 O8nWmIwRhK2+yYDx7AiDCzP1+Je1kJS3Ka69j7T+2tsH7GrVGWOa9JF+SnVvKxpd9T
	 DLuL54wr8fxFg==
Message-ID: <sashiko-outbox-198300@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 06/14] cxl/extent: Handle DC Add Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-7-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-7-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:34:41 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] cxl/mbox: unrolled online tag groups in cxl_add_pending() on respo=
nse failure
- [High] cxl/extent: unsynchronized nr_extents refcount and deferred releas=
e race
- [High] cxl/extent: missing intra-group overlap and region checks in cxl_a=
dd_extent()
- [High] cxl/extent: missing cxlmd device lock around cxl_dpa_to_region()
- [High] cxl/extent: UAF and NULL deref of cxled and mds in memdev_release_=
group()
--

commit f4748dabe1962c23e99c77520895fa0832cc59a0
Author: Ira Weiny <iweiny@kernel.org>

cxl/extent: Handle DC Add Capacity events

This commit implements the Dynamic Capacity Add Capacity event pipeline by
validating pending extents, grouping and sorting them by tag and sequence
number, registering tag_group, untagged, and extent devices under cxlr_dax,
and sending the CXL_MBOX_OP_ADD_DC_RESPONSE mailbox command.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> new file mode 100644
> index 0000000000000..8afb18e7ae5a2
> --- /dev/null
> +++ b/drivers/cxl/core/extent.c
> @@ -0,0 +1,513 @@

[ ... ]

> +static void dc_extent_release(struct device *dev)
> +{
> +	struct dc_extent *dc_extent =3D to_dc_extent(dev);
> +	struct cxl_dc_tag_group *group;
> +
> +	if (!dc_extent)
> +		return;
> +
> +	group =3D dc_extent->group;
> +	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
> +	xa_erase(&group->dc_extents, dc_extent->seq_num);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +	kfree_rcu(dc_extent, rcu);
> +}

[ ... ]

> +static int cxl_validate_extent(struct cxl_memdev_state *mds,
> +			       struct cxl_extent *extent,
> +			       struct cxl_endpoint_decoder **out_cxled,
> +			       struct cxl_dax_region **out_cxlr_dax,
> +			       struct range *out_ext_range)
> +{
> +	u64 start_dpa =3D le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd =3D mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_region *cxlr;
> +	struct range ext_range =3D (struct range) {
> +		.start =3D start_dpa,
> +		.end =3D start_dpa + le64_to_cpu(extent->length) - 1,
> +	};
> +	struct range ed_range;
> +
> +	cxlr =3D cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
> +	if (!cxlr || !cxlr->cxlr_dax)
> +		return -ENXIO;

[Severity: High]
Is device_lock(&cxlmd->dev) needed around the cxl_dpa_to_region() call here
(or in cxl_add_pending() before acquiring cxl_rwsem.region and
cxl_rwsem.dpa)?

In drivers/cxl/core/region.c, cxl_dpa_to_region() reads port =3D
cxlmd->endpoint, checks if (!cxlmd->dev.driver) return NULL, and then
dereferences port in cxl_num_decoders_committed(port) and
device_for_each_child(&port->dev, ...):

  struct cxl_port *port =3D cxlmd->endpoint;
  ...
  if (!cxlmd->dev.driver)
          return NULL;
  ...
  if (cxl_num_decoders_committed(port))
          device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);

Neither cxl_mem_probe() nor delete_endpoint() acquires cxl_rwsem.region or
cxl_rwsem.dpa when updating cxlmd->endpoint:

1. During probe or re-probe, really_probe() sets cxlmd->dev.driver before
   calling cxl_mem_probe(), while cxlmd->endpoint is still ERR_PTR(-ENXIO) =
or
   NULL until devm_cxl_add_endpoint() -> cxl_port_add() assigns
   cxlmd->endpoint =3D port.

2. During unbind, device_unbind_cleanup() runs devres_release_all() ->
   delete_endpoint(), which sets cxlmd->endpoint =3D NULL and drops the fin=
al
   reference on endpoint->dev before clearing cxlmd->dev.driver.

In cxl_event_trace_record(), guard(device)(&cxlmd->dev) is taken before
cxl_rwsem.region, cxl_rwsem.dpa, and cxl_dpa_to_region(). Without holding
device_lock(&cxlmd->dev) in thecxl_event_thread() -> cxl_mem_get_records_lo=
g()
-> cxl_handle_dcd_event_records() -> handle_dcd_chain_event() ->
cxl_add_pending() -> cxl_realize_group() -> cxl_add_extent() ->
cxl_validate_extent() path, can a concurrent cxl_mem probe or unbind cause
cxl_dpa_to_region() to dereference ERR_PTR(-ENXIO), NULL, or a freed
cxl_port?

> +
> +	ed_range =3D (struct range) {
> +		.start =3D cxled->dpa_res->start,
> +		.end =3D cxled->dpa_res->end,
> +	};
> +	if (!range_contains(&ed_range, &ext_range)) {
> +		dev_err_ratelimited(&cxled->cxld.dev,
> +				    "DC extent DPA %pra (%pU) is not fully in ED %pra\n",
> +				    &ext_range, extent->uuid, &ed_range);
> +		return -ENXIO;
> +	}
> +
> +	*out_cxled =3D cxled;
> +	*out_cxlr_dax =3D cxlr->cxlr_dax;
> +	*out_ext_range =3D ext_range;
> +	return 0;
> +}
> +
> +enum cxl_extent_class {
> +	CXL_EXT_NEW,
> +	CXL_EXT_DUPLICATE,
> +	CXL_EXT_OVERLAP,
> +};
> +
> +/*
> + * Stage 2: classify @ext_range against extents already accepted on this
> + * cxlr_dax+cxled.  Walks cxlr_dax->dc_extents once: a stored extent that
> + * fully contains @ext_range means the device re-offered accepted capaci=
ty;
> + * a stored extent that only overlaps means an inconsistent offer.
> + */
> +static enum cxl_extent_class
> +cxlr_dax_classify_extent(struct cxl_dax_region *cxlr_dax,
> +			 struct cxl_endpoint_decoder *cxled,
> +			 const struct range *ext_range)
> +{
> +	struct dc_extent *entry;
> +	unsigned long i;
> +
> +	/* kfree_rcu() defers the free; hold RCU so entries stay live while wal=
ked */
> +	guard(rcu)();
> +	xa_for_each(&cxlr_dax->dc_extents, i, entry) {
> +		if (entry->cxled !=3D cxled)
> +			continue;
> +		if (range_contains(&entry->dpa_range, ext_range))
> +			return CXL_EXT_DUPLICATE;
> +		if (range_overlaps(&entry->dpa_range, ext_range))
> +			return CXL_EXT_OVERLAP;
> +	}
> +	return CXL_EXT_NEW;
> +}
> +
> +/*
> + * Stage 3: allocate and populate a dc_extent for an already-validated,
> + * already-classified-as-new @ext_range.  Only -ENOMEM can fail here.
> + */
> +static struct dc_extent *
> +dc_extent_build(struct cxl_endpoint_decoder *cxled,
> +		struct cxl_dax_region *cxlr_dax,
> +		struct cxl_extent *extent,
> +		const struct range *ext_range, u16 seq_num)
> +{
> +	resource_size_t dpa_offset =3D ext_range->start - cxled->dpa_res->start;
> +	resource_size_t hpa =3D cxled->cxld.hpa_range.start + dpa_offset;
> +	struct dc_extent *dc_extent;
> +
> +	dc_extent =3D kzalloc_obj(*dc_extent);
> +	if (!dc_extent)
> +		return ERR_PTR(-ENOMEM);
> +
> +	dc_extent->cxled =3D cxled;
> +	dc_extent->dpa_range =3D *ext_range;
> +	dc_extent->hpa_range.start =3D hpa - cxlr_dax->hpa_range.start;
> +	dc_extent->hpa_range.end =3D dc_extent->hpa_range.start +
> +				   range_len(ext_range) - 1;
> +	dc_extent->seq_num =3D seq_num;
> +	import_uuid(&dc_extent->uuid, extent->uuid);
> +	return dc_extent;
> +}
> +
> +/*
> + * Stage 4: insert @dc_extent into the pending tag group.  All extents in
> + * one More-chain group share a UUID =E2=80=94 enforced here as the grou=
p is
> + * either being created (first extent) or appended to.  On any failure
> + * the dc_extent is freed.
> + *
> + * Returns 0 on success, <0 on error.
> + */
> +static int cxlr_add_extent(struct cxl_memdev_state *mds,
> +			   struct cxl_dax_region *cxlr_dax,
> +			   struct dc_extent *dc_extent)
> +{
> +	struct cxl_dc_tag_group **group =3D &mds->dc_chain.group;
> +	int rc;
> +
> +	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
> +		kfree(dc_extent);
> +		return -EINVAL;
> +	}

[Severity: High]
What happens if two extents within the same tag group have duplicate or
overlapping DPA ranges, or resolve to different cxl_dax_region instances on
the same DC partition?

In cxl_realize_group(), cxl_add_extent() is called for every extent in the
group before online_tag_group() is invoked:

1. cxlr_dax_classify_extent() only walks cxlr_dax->dc_extents, which is not
   populated until online_tag_group() runs after the loop finishes, and does
   not check extents already staged in mds->dc_chain.group->dc_extents. If a
   tag group contains duplicate or overlapping extents, both are classified
   as CXL_EXT_NEW, onlined into cxlr_dax->dc_extents, and sent together in
   CXL_MBOX_OP_ADD_DC_RESPONSE (which the device rejects per CXL r4.0 Secti=
on
   8.2.10.9.9.3 after the group is already online).

2. Multiple endpoint decoders on the same memdev can allocate disjoint DPA
   ranges from the same DC partition and attach to different cxl_region (and
   cxl_dax_region) instances. Even with cxl_check_group_partition() in the
   subsequent commit "cxl/mem: Enforce tag-group semantics", two extents in
   the same tag group that resolve to different endpoint decoders in the sa=
me
   DC partition pass partition validation. In dc_extent_build(), the second
   extent's hpa_range is calculated relative to the second region's
   cxlr_dax->hpa_range.start, while cxlr_add_extent() only checks
   uuid_equal() and does not verify (*group)->cxlr_dax =3D=3D cxlr_dax. That
   inserts the second extent into the first region's tag group and
   cxlr_dax->dc_extents with an HPA offset relative to the second region, a=
nd
   later release lookups in cxl_resolve_extent() will look in the second
   region's cxlr_dax and fail to find it.

Should cxlr_dax_classify_extent() (or cxlr_add_extent()) also check against
extents already staged in mds->dc_chain.group->dc_extents, and verify that
(*group)->cxlr_dax =3D=3D cxlr_dax?

[ ... ]

> +/* Unregister every member; the group is freed with its last extent */
> +static void unregister_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	struct dc_extent *dc_extent;
> +	unsigned long index;
> +
> +	/*
> +	 * Pin @group across the walk: unregistering a dc_extent drops its
> +	 * last reference and fires dc_extent_release(), which frees @group
> +	 * on the final nr_extents decrement.  Without the pin the next
> +	 * iteration's xa_find_after() dereferences a freed xarray.
> +	 */
> +	group->nr_extents++;
> +	xa_for_each(&group->dc_extents, index, dc_extent) {
> +		dev_dbg(&dc_extent->dev, "DAX region rm extent HPA %pra\n",
> +			&dc_extent->hpa_range);
> +		device_unregister(&dc_extent->dev);
> +	}
> +	dc_tag_group_del(group);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +}

[ ... ]

> +int online_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	struct cxl_dax_region *cxlr_dax =3D group->cxlr_dax;
> +	struct device *parent =3D &cxlr_dax->untagged;
> +	struct dc_extent *dc_extent;
> +	unsigned long index;
> +	int rc =3D 0;
> +
> +	/*
> +	 * Seed nr_extents with the full group size plus a +1 pin held by
> +	 * this function.  The size counts every dc_extent that might
> +	 * decrement nr_extents on cleanup; the pin keeps @group alive
> +	 * across the body even if every dc_extent release fires in the
> +	 * unwind (e.g. a devm_add_action() failure with a single extent).
> +	 * The pin is dropped at the end of the function.
> +	 */
> +	xa_for_each(&group->dc_extents, index, dc_extent)
> +		group->nr_extents++;
> +	group->nr_extents++;
> +
> +	/* A tagged group parents its extents; untagged ones share @untagged */
> +	if (!uuid_is_null(&group->uuid)) {
> +		rc =3D dc_tag_group_add(group);
> +		if (rc)
> +			goto unwind;
> +		parent =3D &group->dev;
> +	} else {
> +		rc =3D cxl_dax_untagged_add(cxlr_dax);
> +		if (rc)
> +			goto unwind;
> +	}
> +
> +	xa_for_each(&group->dc_extents, index, dc_extent) {
> +		struct device *dev =3D &dc_extent->dev;
> +		u32 id;
> +
> +		device_initialize(dev);
> +		device_set_pm_not_required(dev);
> +		dev->parent =3D parent;
> +		dev->type =3D &dc_extent_type;
> +
> +		rc =3D xa_alloc(&cxlr_dax->dc_extents, &id, dc_extent,
> +			      xa_limit_32b, GFP_KERNEL);
> +		/*
> +		 * put_device() fires dc_extent_release().  On xa_alloc failure
> +		 * dev->id is still its invalid init value (0), but the xarray is
> +		 * declared XA_FLAGS_ALLOC1 so 0 is never a valid id and erasing
> +		 * it cannot remove another extent.
> +		 */
> +		if (rc < 0) {
> +			put_device(dev);
> +			break;
> +		}
> +		dev->id =3D id;
> +
> +		rc =3D dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
> +				  dev->id);
> +		if (rc) {
> +			put_device(dev);
> +			break;
> +		}
> +
> +		rc =3D device_add(dev);
> +		if (rc) {
> +			put_device(dev);
> +			break;
> +		}
> +
> +		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
> +			&dc_extent->hpa_range, &group->uuid);
> +	}
> +
> +	/* Give the capacity back when the region goes away */
> +	if (!rc)
> +		rc =3D devm_add_action(&cxlr_dax->dev, dc_tag_group_teardown, group);
> +
> +unwind:
> +	if (rc) {
> +		/*
> +		 * Unwind every remaining dc_extent in the group.  The pin
> +		 * above keeps @group alive across this walk.  Onlined
> +		 * dc_extents are unregistered; pending ones were never
> +		 * initialized as devices.
> +		 */
> +		xa_for_each(&group->dc_extents, index, dc_extent) {
> +			if (device_is_registered(&dc_extent->dev))
> +				device_unregister(&dc_extent->dev);
> +			else
> +				cleanup_pending_dc_extent(dc_extent);
> +		}
> +		dc_tag_group_del(group);
> +	}
> +
> +	/* Drop the pin; if nothing else still references @group, free it. */
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);
> +	return rc;
> +}

[Severity: High]
Can asynchronous execution of dc_extent_release() race on group->nr_extents
and group->dc_extents when a sysfs/udev reader holds a reference to
dc_extent->dev or when CONFIG_DEBUG_KOBJECT_RELEASE=3Dy is enabled?

1. In struct cxl_dc_tag_group, nr_extents is a plain unsigned int modified
   with non-atomic increments and decrements. Once device_add(&dc_extent->d=
ev)
   publishes the extent in sysfs and emits KOBJ_ADD, userspace (such as ude=
vd
   or sysfs readers) can hold a kobject reference across device_unregister()
   in unregister_tag_group() or online_tag_group() unwind (or
   CONFIG_DEBUG_KOBJECT_RELEASE=3Dy can defer kobject_cleanup() to a delayed
   workqueue). When that reference is dropped asynchronously on another CPU,
   dc_extent_release() performs an unlocked group->nr_extents-- and checks
   if (!group->nr_extents) free_tag_group(group), racing with sibling
   dc_extent_release() calls and with unregister_tag_group() or
   online_tag_group() and risking either a leaked group (and its
   cxlr_dax->dev reference) or a double free_tag_group(group).

2. In online_tag_group(), if xa_alloc(), dev_set_name(), or device_add()
   fails after device_initialize(dev), put_device(dev) is called and the lo=
op
   breaks to unwind:. If dc_extent_release() is deferred (for instance under
   CONFIG_DEBUG_KOBJECT_RELEASE=3Dy), the failed dc_extent is still present=
 in
   group->dc_extents with device_is_registered(&dc_extent->dev) =3D=3D fals=
e. The
   unwind loop then calls cleanup_pending_dc_extent(dc_extent) on that same
   extent, decrementing group->nr_extents a second time and calling
   kfree_rcu(dc_extent, rcu) before the delayed kobject release runs.

3. Because xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id) is ins=
ide
   dc_extent_release() rather than performed synchronously before
   device_unregister() or put_device(), any deferred dc_extent_release()
   leaves unregistered or failed extents visible in cxlr_dax->dc_extents wh=
ere
   cxlr_dax_classify_extent() continues to match them.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index fea910e6c5108..18044f216de58 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +/* Give @group's capacity back to the device with a Release DC response =
*/
> +void memdev_release_group(struct cxl_dc_tag_group *group)
> +{
> +	unsigned long idx =3D 0;
> +	struct dc_extent *dc_extent =3D xa_find(&group->dc_extents, &idx,
> +					      ULONG_MAX, XA_PRESENT);
> +	struct cxl_memdev_state *mds;
> +	LIST_HEAD(acks);
> +	int cnt;
> +
> +	if (!dc_extent)
> +		return;
> +	/* A DC region is not interleaved: every member shares one memdev */
> +	mds =3D cxled_to_mds(dc_extent->cxled);
> +
> +	cnt =3D stage_group_release(group, &acks);
> +	if (cnt < 0 ||
> +	    cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &acks, cnt))
> +		dev_dbg(mds->cxlds.dev, "Failed to release tag %pUb\n",
> +			&group->uuid);
> +	drop_extent_group(&acks);
> +}

[Severity: High]
Could dc_tag_group_teardown() -> memdev_release_group() dereference a freed
dc_extent->cxled or a NULL/freed mds if the region target is detached while
the endpoint and memdev are concurrently unbound?

When a committed region's target is detached via target0_store() ->
store_targetN() -> detach_target() -> cxl_decoder_detach(cxlr, NULL, pos,
DETACH_ONLY), __cxl_decoder_detach() runs under cxl_rwsem.region and clears
cxled->cxld.region =3D NULL via cxl_port_detach_region() -> free_region_ref=
()
-> cxl_rr_free_decoder(), and then cxl_decoder_detach() drops
cxl_rwsem.region before calling device_release_driver(&detach->dev).

If the endpoint decoder and memdev/PCI driver are concurrently unbound duri=
ng
that window, cxld_unregister() calls cxl_decoder_detach(NULL, cxled, -1,
DETACH_INVALIDATE), sees cxled->cxld.region =3D=3D NULL in
__cxl_decoder_detach(), and returns NULL without waiting for
device_release_driver(&cxlr->dev):

1. In this commit, dc_extent_build() stores an unreferenced pointer in
   dc_extent->cxled, so cxld_unregister() can unregister and free cxled whi=
le
   device_release_driver(&cxlr->dev) -> cxlr_dax_unregister() ->
   device_release_driver(&cxlr_dax->dev) -> dc_tag_group_teardown() ->
   memdev_release_group() is still running and dereferences dc_extent->cxle=
d.

2. Even after the later commit "cxl/region: Read existing extents on region
   creation" pins cxlr_dax->cxled->cxld.dev in cxl_dax_region_alloc(), that
   reference only pins cxled and its parent endpoint cxl_port
   (cxled->cxld.dev.parent), not port->uport_dev (&cxlmd->dev) or mds. Once
   cxld_unregister() returns early, cxl_memdev_unregister() runs
   cxl_memdev_shutdown() (setting cxlmd->cxlds =3D NULL) and cxl_pci unbind
   frees mds via devres while memdev_release_group() calls
   mds =3D cxled_to_mds(dc_extent->cxled) and dereferences mds in
   cxl_send_dc_response().

[ ... ]

> +static int cxl_add_pending(struct cxl_memdev_state *mds,
> +			   struct list_head *pending)
> +{
> +	LIST_HEAD(accepted);
> +	int total_accepted =3D 0;
> +
> +	/*
> +	 * Held across validation, add and online so that cxlr_dax_unpublish()
> +	 * excludes a whole flush; cxl_dpa_to_region() also walks every dpa_res.
> +	 */
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	guard(rwsem_read)(&cxl_rwsem.dpa);
> +
> +	while (!list_empty(pending)) {
> +		struct cxl_extent_list_node *first;
> +		LIST_HEAD(group);
> +		uuid_t tag;
> +		int cnt;
> +
> +		first =3D list_first_entry(pending, struct cxl_extent_list_node,
> +					 list);
> +		import_uuid(&tag, first->extent->uuid);
> +		/*
> +		 * A null tag carries no allocation identity: surface each
> +		 * untagged extent as its own single-extent group rather than
> +		 * coalescing all untagged extents together.
> +		 */
> +		if (uuid_is_null(&tag))
> +			list_move_tail(&first->list, &group);
> +		else
> +			extract_tag_group(pending, &tag, &group);
> +
> +		/*
> +		 * Only a sharable allocation carries a meaningful per-extent
> +		 * shared_extn_seq; order those by it.  For non-sharable groups,
> +		 * the stable sort maintains arrival order.
> +		 */
> +		list_sort(NULL, &group, extent_seq_compare);
> +
> +		cnt =3D cxl_realize_group(mds, &tag, &group);
> +		if (cnt < 0) {
> +			drop_extent_group(&group);
> +			continue;
> +		}
> +
> +		list_splice_tail_init(&group, &accepted);
> +		total_accepted +=3D cnt;
> +	}
> +
> +	list_splice(&accepted, pending);
> +
> +	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> +				    pending, total_accepted);
> +}

[Severity: High]
Does cxl_add_pending() leave the onlined tag groups registered on the host =
if
cxl_send_dc_response() fails or refuses the extents?

In cxl_add_pending(), each group is onlined via cxl_realize_group() ->
online_tag_group() before cxl_send_dc_response(mds,
CXL_MBOX_OP_ADD_DC_RESPONSE, pending, total_accepted) is called.

Inside cxl_send_dc_response(), if kzalloc(pl_size, GFP_KERNEL) fails while
total_accepted > 0, it falls back to sending an empty response:

	if (!response) {
		struct cxl_mbox_dc_response empty =3D { };

		/* An empty Release DC is invalid (CXL r4.0 Table 8-352) */
		if (opcode =3D=3D CXL_MBOX_OP_RELEASE_DC)
			return -ENOMEM;
		/* Refuse all extents rather than stall the device. */
		return send_one_response(cxl_mbox, &empty, opcode, 0, 0);
	}

That empty CXL_MBOX_OP_ADD_DC_RESPONSE tells the device that the host refus=
ed
all offered extents (and returns 0 if the mailbox command succeeds), or
send_one_response() can fail with a mailbox error. Because the tag groups
onlined during the loop are not unwound with rm_tag_group(), won't the host
keep those refused extents online in cxlr_dax->dc_extents and sysfs (and la=
ter
send CXL_MBOX_OP_RELEASE_DC for them during region teardown) while the devi=
ce
treats the capacity as unaccepted?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D6
