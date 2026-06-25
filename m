Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50E243387;
	Thu, 25 Jun 2026 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411398; cv=none; b=Q4hRgzAsYVfDNd5zmMTP07rN0kl/Rno4bRIdngCn/oA8KZod96gTHB0NE4PqYFa+fVlzOOaTNfvFp07lrD7E9LQeYjuPmm/RcJ8HEXGsbpGPBRzpVAG9H6/S63hN0lmYMhgu6XgB1lfAyCorP0ZGldTZF1ykX7OsFiCpXrXUfP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411398; c=relaxed/simple;
	bh=PC5UkhSvQVtAhmE9pz/ZSiLRhGTtIuE2UbAr+ilnsf0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GPv460PoH+K/bhn9TGsyGMSPbMFX/GjhmpstHEr3xXHa8+5q7vOv2VQlH06y8kCZFB6sOuwP/p+Enz8ub5zNYi22KhlQPfer8E21fITIiJH57UraQ02HWiFEeROkGZ+MACYSHEUz2missZCT0aLazI/Aw/lgY7mx02s/acM3TKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVAkXtjq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVAkXtjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208D41F000E9;
	Thu, 25 Jun 2026 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411396;
	bh=MB6rPNyNq20kL/qXAS5lrYmNWP+nUS0sweTYrYO8IY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KVAkXtjqRm3A0+N19nIIORtWFTVK3N+jqYRFVBMZx+RR84ztRXGX0WBiO0NGBQ73r
	 BUXbmudkIf6Td52zz4EmmLrHYISD9Aswmq6G7zit+7DrHdTIdEaHlCI7cELDL91X5U
	 roKboIwkLqz5H7xlPWbcdxJ5g9JYPH8Qpx/bz32lakSKgmfHcusGwKQvlaWKQEqJfw
	 ENoxBN+Ae0AsVfmD7SjpCxwfscgF5NAIXLqI7pLPsVdE9ENTZFdim7c1eHVYOYVln0
	 OL+yj3XfY6qa57BiQEcAjGGytSs5ZKZnU2qs7j+eiXEchusP30zScHjq3KZPmIm6jW
	 qrBuIj1jGInNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 14/31] cxl/extent: Handle DC Add Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-15-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-15-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:16:35 +0000
Message-Id: <20260625181636.208D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] Use-after-free in `cxlr_dax_classify_extent` due to lockless XArra=
y iteration.
- [High] Fully duplicate Add-Capacity groups are erroneously dropped withou=
t sending an Add-DC-Response.
- [High] Failed extents unconditionally send Release DC commands on error p=
aths, violating the skip_device_release protocol.
- [High] Manual `xa_erase()` before `put_device()` creates a race condition=
 that clobbers re-allocated IDs.
- [High] Concurrent teardown causes a data race on `group->nr_extents`, lea=
ding to a permanent resource leak.
- [High] Recovered extents are permanently leaked to the device if their in=
dividual tracking allocation fails.
- [High] Tag groups spanning multiple DAX regions are silently grouped unde=
r the first region, corrupting HPA ranges.
--

commit c1287602ad57e47bb90d02808a1f908fcb287a89
Author: Ira Weiny <iweiny@kernel.org>
Subject: cxl/extent: Handle DC Add Capacity events

Replace the empty-response stub in handle_add_event() with the real
add pipeline. This commit fills in the logic for processing the pending list
and adds basic validation for extents before they are added to the
device model as a child of the cxlr_dax region.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> new file mode 100644
> index 0000000000000..6e67e787d14de
> --- /dev/null
> +++ b/drivers/cxl/core/extent.c
> @@ -0,0 +1,411 @@
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
> +	cxled_release_extent(dc_extent->cxled, dc_extent);
> +	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
> +	xa_erase(&group->dc_extents, dc_extent->seq_num);
> +	group->nr_extents--;
> +	if (!group->nr_extents)
> +		free_tag_group(group);

[Severity: High]
Is it safe to decrement group->nr_extents without a lock? Since multiple
extents in the same group can be released concurrently, couldn't this
non-atomic decrement cause a data race, leading to a permanent memory leak
of the cxl_dc_tag_group and its pinned cxlr_dax->dev reference?

> +	kfree(dc_extent);
> +}
[ ... ]
> +static enum cxl_extent_class
> +cxlr_dax_classify_extent(struct cxl_dax_region *cxlr_dax,
> +			 struct cxl_endpoint_decoder *cxled,
> +			 const struct range *ext_range)
> +{
> +	struct dc_extent *entry;
> +	unsigned long i;
> +
> +	xa_for_each(&cxlr_dax->dc_extents, i, entry) {
> +		if (entry->cxled !=3D cxled)

[Severity: High]
Is this iteration safe against concurrent teardown? xa_for_each drops the
internal RCU read lock between iterations, leaving the returned entry
unprotected. If online_tag_group fails concurrently or there is a
parallel release, couldn't accessing entry->cxled trigger a use-after-free?

> +			continue;
> +		if (range_contains(&entry->dpa_range, ext_range))
> +			return CXL_EXT_DUPLICATE;
[ ... ]
> +static int cxlr_add_extent(struct cxl_memdev_state *mds,
> +			   struct cxl_dax_region *cxlr_dax,
> +			   struct dc_extent *dc_extent)
> +{
> +	struct cxl_dc_tag_group **group =3D &mds->add_ctx.group;
> +	int rc;
> +
> +	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
> +		kfree(dc_extent);
> +		return -EINVAL;
> +	}
> +
> +	if (!*group) {
> +		dev_dbg(&cxlr_dax->dev, "Alloc new tag group\n");
> +		*group =3D alloc_tag_group(cxlr_dax, &dc_extent->uuid);
> +		if (IS_ERR(*group)) {
> +			rc =3D PTR_ERR(*group);
> +			*group =3D NULL;
> +			kfree(dc_extent);
> +			return rc;
> +		}
> +	} else {
> +		dev_dbg(&cxlr_dax->dev, "Append dc_extent to tag group\n");
> +	}
> +
> +	dc_extent->group =3D *group;

[Severity: High]
What happens if extents in the same tag group (sharing a UUID) map to
different endpoint decoders and thus different DAX regions? This logic
appears to allocate the tag group using the cxlr_dax of the first extent
and blindly links subsequent extents to it. Could this cause cross-region
extents to be parented to the wrong region and corrupt their HPA mapping
offsets?

> +
> +	/*
[ ... ]
> +int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release)
> +{
[ ... ]
> +		rc =3D dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
> +				  dev->id);
> +		if (rc) {
> +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> +			put_device(dev);
> +			break;
> +		}
> +
> +		rc =3D device_add(dev);
> +		if (rc) {
> +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> +			put_device(dev);
> +			break;
> +		}

[Severity: High]
Does the manual xa_erase() before put_device() create a double-erase race
condition?

put_device(dev) synchronously calls dc_extent_release(), which performs a
second xa_erase() for the same ID. If a concurrent thread allocates an ID
between the first and second erase, wouldn't the second erase silently
clobber the new valid allocation?

[Severity: High]
Additionally, does this error path violate the skip_device_release protocol?
At this point, group->skip_device_release has not been set yet. Because it
is false, won't dc_extent_release() unconditionally send a Release DC comma=
nd
to the hardware for capacity the host never formally accepted?

> +
> +		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
[ ... ]
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 4e887b5cdc3ed..08f51b8807c06 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
[ ... ]
> +static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t =
*tag,
> +			     struct list_head *group, bool existing)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_extent_list_node *pos, *tmp;
> +	struct cxl_dc_tag_group *tag_group;
> +	int group_cnt =3D 0;
> +	int rc;
> +
> +	list_for_each_entry_safe(pos, tmp, group, list) {
> +		/*
> +		 * Pass the device-stamped 0-based shared_extn_seq through
> +		 * unchanged as the dax-side @seq_num (0..n-1).
> +		 */
> +		u16 seq =3D le16_to_cpu(pos->extent->shared_extn_seq);
> +
> +		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
> +			dev_dbg(dev,
> +				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
> +				tag,
> +				le64_to_cpu(pos->extent->start_dpa),
> +				le64_to_cpu(pos->extent->length));
> +			delete_extent_node(pos);
> +			continue;
> +		}

[Severity: High]
If cxl_add_extent() fails during initialization of existing extents
(e.g., under memory pressure), we simply delete the node and continue.
Because the extent is never added to a tag group, the teardown error path
cannot see it. Does this permanently strand the capacity on the device since
no Release DC command is sent?

> +		group_cnt++;
> +	}
> +
> +	tag_group =3D mds->add_ctx.group;
> +	mds->add_ctx.group =3D NULL;
> +	if (!tag_group)
> +		return -ENXIO;

[Severity: High]
If an Add Capacity event contains only extents that the host has already
accepted (duplicates), cxl_add_extent() succeeds but returns 0, and
mds->add_ctx.group is never allocated. Does this erroneously fail the
entire group with -ENXIO, causing cxl_add_pending() to drop it without
sending an Add-DC-Response, thereby stalling the device?

> +
> +	rc =3D online_tag_group(tag_group, !existing);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D14
