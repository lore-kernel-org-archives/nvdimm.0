Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D09D313534;
	Thu, 25 Jun 2026 18:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411821; cv=none; b=G7YaLqvjAHmpjGpGijU7JAhRw4zI8B7ifR+KDb2MQ8X/7qlgYcj1skR8ekd87yC9IrWZa2l/ExGbeXJWG+udeBzFy8aoxA2waPJD78v4PhozEJoHJeZRHIgOmn6cusd4+/30x8sCB3MUNijntdCsKc2TzwsI94B2qVtnWAoJBiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411821; c=relaxed/simple;
	bh=0DteaYx7VQxQGaJhmiex9PmE5ROIwiBSINeeDfXJEh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FMPM8zdcnFBMYzanL1/UiqW8fnSa92ODM5hCIykOWY2p2JrBVMnUYZOTGucBik4+ZJq1lSJEx10SfZSOmHKutIU0e+W7r/H7De1upNHMuUE8nrs5gM9LHFbWbVezMpmD3b9K7cC8+fRooHXG+RZy494vG0Ll4+se4LwSK4sm9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7izsc5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7izsc5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A1F1F00A3A;
	Thu, 25 Jun 2026 18:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411820;
	bh=1xR3wA4l0Nt7Q+pGc0G0Nbh8J4QX5bOjWGUcEVXTFn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J7izsc5yboFDkguUxRcZz1VqV+eXXeQ7ZwRQxyiiaiX0KM15vlsx3TBX3hSlhXVLW
	 LYGas+ZZP8gHHHwvmt5Ro3a7SWqm0F0oacDgWBZfeAtwb+ptfyslq/h9xEtQn/Uxg5
	 iBxokjT1+wbKAARJngljyzWVGnWEEaJLy+Zl32XGXPydmKhKHYyUiA1Qu1K2w5KiqG
	 0ZhKYVcjjqeCLQsXpnu/arSNeTGDaHLsRJUS5IB5XCeqJPnDjPHUIYc2sRQy9YG9sY
	 fUQ0HTKds5WYnfcgaqYc7dmoA8BupgC3FXj0kI9h2DmzeYkiDlSWPMctjSwha8v9+N
	 s9lQoUyGGgY0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 18/31] cxl/extent: Handle DC Release Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-19-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-19-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:23:38 +0000
Message-Id: <20260625182339.95A1F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Lockless iteration over the shared `cxlr_dax->dc_extents` xarray l=
eads to Use-After-Free.
- [High] Unsynchronized non-atomic modifications to `group->nr_extents` lea=
d to lost decrements and tag group leak.
- [High] Multi-extent tag group releases incorrectly tear down the entire g=
roup on the first chunk, causing spurious errors and WARN_ON stack traces o=
n subsequent chunks.
--

commit 277b0b7ee1e3ee9199ddbac19db51d5566770cbb
Author: Ira Weiny <iweiny@kernel.org>

cxl/extent: Handle DC Release Capacity events
   =20
This commit replaces the no-op ack stub for cxl_rm_extent() with the real
teardown logic. It resolves the released DPA range to its region and endpoi=
nt
decoder, locates the matching dc_extent, and tears down the entire containi=
ng
tag group atomically.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 0ebb581ca8335..a590a89f35802 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
[ ... ]
> +static void rm_tag_group(struct cxl_dc_tag_group *group)
> +{
> +	struct device *region_dev =3D &group->cxlr_dax->dev;
> +	struct dc_extent *dc_extent;
> +	unsigned long index;
> +
> +	/*
> +	 * Pin @group across the walk: each devm_release_action runs the
> +	 * dc_extent_unregister action synchronously, which drops the last
> +	 * reference on the dc_extent device and fires dc_extent_release.
> +	 * The release decrements group->nr_extents and, on the final
> +	 * decrement, frees @group.  Without the pin the next iteration's
> +	 * xa_find_after() dereferences a freed xarray.
> +	 */
> +	group->nr_extents++;
> +	xa_for_each(&group->dc_extents, index, dc_extent)
> +		devm_release_action(region_dev, dc_extent_unregister, dc_extent);

[Severity: High]
What happens if a device releases a multi-extent tag group by sending multi=
ple
DCD release events (one per chunk)?

When the host processes the first event, cxl_rm_extent() resolves the group
and calls rm_tag_group(), which atomically unregisters all extents. If the
sysfs reference is > 0 (e.g. userspace has a file open), the extents remain
in the xarray.

When subsequent release events for the remaining chunks are processed,
cxl_rm_extent() finds the same group and calls rm_tag_group() again. Will
invoking devm_release_action() on already-removed actions trigger a
WARN_ON(!devres) stack trace?

> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);

[Severity: High]
Can this result in lost decrements and a tag group leak?

Since group->nr_extents is a plain unsigned int, a lockless decrement here
in rm_tag_group() could race with dc_extent_release(). If userspace holds
references to multiple extents in the same tag group via sysfs and closes
them concurrently, dc_extent_release() will run on multiple CPUs
simultaneously.

This would race with the decrement here, preventing the counter from reachi=
ng
zero and permanently leaking the cxl_dc_tag_group and its UUID.

> +}
> +
> +int cxl_rm_extent(struct cxl_memdev_state *mds, struct cxl_extent *exten=
t)
> +{
[ ... ]
> +	/*
> +	 * Find the dc_extent whose DPA range covers the released range and
> +	 * whose tag matches.  The release targets the entire containing
> +	 * tag group atomically; partial release is not supported.
> +	 */
> +	group =3D NULL;
> +	xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
> +		if (dc_extent->cxled !=3D cxled)

[Severity: High]
Is it safe to iterate the shared cxlr_dax->dc_extents xarray without RCU
protection or a write lock here?

cxl_rm_extent() and cxlr_dax_classify_extent() iterate over the shared
xarray using xa_for_each() while holding cxl_rwsem.region only for read. If
concurrent DCD events from different memdevs in the same interleaved region
trigger rm_tag_group() or a failed cxl_add_extent(), dc_extent objects can =
be
removed and synchronously freed via kfree() in dc_extent_release() by anoth=
er
thread.

Since xa_for_each() drops the internal RCU lock during the loop body, could
the iterating thread dereference a freed dc_extent pointer here?

> +			continue;
> +		if (!range_contains(&dc_extent->dpa_range, &dpa_range))
> +			continue;
> +		if (!uuid_equal(&dc_extent->group->uuid, &tag))
> +			continue;
> +		group =3D dc_extent->group;
> +		break;
> +	}
> +	if (!group) {
> +		dev_err(&cxlr_dax->dev,
> +			"release DPA %pra (%pU) matches no dc_extent\n",
> +			&dpa_range, &tag);

[Severity: High]
Could this error path be triggered spuriously on multi-chunk releases?

If a device sends multiple DCD release events for a multi-extent tag group,
the first chunk will cause rm_tag_group() to unregister all extents. If sys=
fs
references are zero, the extents are freed immediately.

When subsequent release events for the remaining chunks are processed, they
will fail to find the group here and print this spurious "matches no dc_ext=
ent"
error.

> +		return -EINVAL;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D18
