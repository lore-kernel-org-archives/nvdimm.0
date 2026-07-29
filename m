Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C9A414A21
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 07:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785311068; cv=none; b=HHgMqG9X8K5wUBHj4/n0EAG/aEP099gved+uJlxNCfTSeoPWKnpkNaelbGt+VsssSEg9oA941/ZBtjeyRuzbsTYGSpPtNXN9bEVcqsWQESXqJmJNMpMikqAOfXMNKvKc02dcLPT708YrjtHowYDAmLrFkcnTYXK2Gs8aTYGmmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785311068; c=relaxed/simple;
	bh=rYeLgXCdhfnNNeVJns9MlpVDy5pFD2GcZyCG1B9V20g=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ow5B844pVkqQ1B8YrI7q7RGevB8zpKkdM2emwlqijI71Wz7bKUtVNDXMsvk5JhQASzxL8FR+6vG2wwCEjKJ91TLuRrS1IwEQdzTD5ih5T4+OpHfo1o6RQf/RLPtd0xvuaVVZas34Cscb3RJSVMh8sNp24GemQ8H++cnRc9c+L6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jyPTQRaD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyPTQRaD"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ceb096e675so9454775ad.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 00:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785311053; x=1785915853; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GFo23DlEukdy9lN+LbcVlWdhG+g8KVl+rLHto+ZpnsA=;
        b=jyPTQRaDClt/kUpdMhdOpTwhSa5PLyEe3mCNUXaLaiWLTOjDSYZJB7EiNQQbmVWoLz
         iUoBkcuazlnkfuj1xDtU3LTdZINi+Rmn/2V/yO+XVC+ztpQnDV+DLQXP3Y+2Ha1T7JWY
         X0GgF3qtb7MdOb+b5LCo51YWzliQl/3kdTOl0gl1bvtWQvokLf/Qg0pAGqVC9xGvwlQ/
         mcMFUCruLe8kEasrFsKe0W/RorqGjlki13FOV4NbvrSX48bDEO8UMJBWX7mm+kbypOnS
         mWeU2//lDzgHz4oJM27XxatrxfHupMKOLCs97zsc2Va5tgvCPrfIzwVYUEUSGGN4ZSg0
         1JtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785311053; x=1785915853;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GFo23DlEukdy9lN+LbcVlWdhG+g8KVl+rLHto+ZpnsA=;
        b=e2jeo9njsnttlQksXv0X78sOQq3z1T/OXAW1Ci12ZN1tA3i14PM1EzyQtl3ZXdNTO4
         xp6UjU25QqLxA9B7kpacNCGWY+OrPYCEs5zJ2PsvSyu2xuPSKM1pX6sfD7eCIGWSQcyx
         gJYQBiHV+nOkT67C/eKNG6dQeZ4j+fWuCrLenBNK+HaIigexuPV/i1h9x9WD/YIF++Qe
         THA1W6iHwAyF3FQr8Hml8lFZhrv/EvB6T7qL1PZiK4XTbE6iUFSPJEskLwVQDPXSXuH7
         ZLUp4XzzxRsp2WeJHsI/ou5qtEOO57b9aZSIyCZ7H7jBOkLu5VTjUbmgSi0scr97Jr6T
         55eQ==
X-Forwarded-Encrypted: i=1; AHgh+RpAgerdeYr+vzy0H9K4JcFB8ymILbwRcPTvEiYnIx4TCNcp/m7w1FCgCpCUXf4OPMgh57Ef6gI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDOJYMQuzy2BRr4gR1QoJth1cX3fSR1lNH5rpXcN28zO9olI8q
	h25YYT7KWKG8L8yPgzCwvn9Bs5mNuF+HE6+QlBimleVLYdncozF/i8xz
X-Gm-Gg: AR+sD12AVd1yLx/AepadZ+SYCAmi4DGUPBOemm4o48an+KbmZAFChC5QKcNLru7MihF
	2FoHu0stv7a5iWp4GaZnKXfbJpDIPNGqWHmAXVVl9CGIsRexWg0rIBrJQbAgGvnUVV2VyCavJkD
	TRIzpChWbVJUO09L3bjwK8A6yjfRzLrnMSFjK1edVXk3B8cU31EhMbhq3bbKj/hlMdel5ss45aF
	iHLXoU9UoB7ky5F1swLcIupvkttDuXdNlmKhfCTtA3FYVQDN8sYjNyKwJb75WMzpRtTtWT0XcEJ
	fnm5fSW6Kswmg6tN27yJ8urU2g5R6tCOhZglSapTyig081eVTxqAlrxz+kolTNyYAVHvJ0SSASp
	5KcFy2zi2RKSZIIFAJCyYLw5dhA0xbB0wjSDa9ULN2y4E7N7DvOa2s+iOZzA2H4QalOVMnod7X5
	db9ixN3zn3qC9xnrBpH/tI8oRiPvQ11nKhDL1/S3gEybJEnJXmFx/6XAIM0H6ZMrqfLEMaa+MRX
	AqeT7a1P6ur/XsfWoAfL/cEamU/k39dnZy69EIBw9km
X-Received: by 2002:a17:903:b90:b0:2cc:76fd:6537 with SMTP id d9443c01a7336-2d015c92f0bmr65800605ad.2.1785311053170;
        Wed, 29 Jul 2026 00:44:13 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a15199sm7241925ad.17.2026.07.29.00.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:44:12 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 29 Jul 2026 00:44:10 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v11 14/31] cxl/extent: Handle DC Add Capacity events
Message-ID: <ammvSl_vKiz7swo2@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-15-anisa.su@samsung.com>
 <20260625181636.208D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625181636.208D41F000E9@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:16:35PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential issue(s) to consider:
> - [High] Use-after-free in `cxlr_dax_classify_extent` due to lockless XArray iteration.
Real -- fixed with RCU-deferred free + rcu_read_lock()

> - [High] Fully duplicate Add-Capacity groups are erroneously dropped without sending an Add-DC-Response.
False Positive -- 1 response is always sent for each chain even if
empty.

> - [High] Failed extents unconditionally send Release DC commands on error paths, violating the skip_device_release protocol.
Real -- fixed with a minor caveat.

> - [High] Manual `xa_erase()` before `put_device()` creates a race condition that clobbers re-allocated IDs.
Real -- drop redundant manual xa_erase().

> - [High] Concurrent teardown causes a data race on `group->nr_extents`, leading to a permanent resource leak.
False Positive -- teardown is never concurrent. group->nr_extents only
released serially.

> - [High] Recovered extents are permanently leaked to the device if their individual tracking allocation fails.
False Positive -- Rcovered extents ARE released to device on failure.

> - [High] Tag groups spanning multiple DAX regions are silently grouped under the first region, corrupting HPA ranges.
False Positive -- subsequent patches robustify partition and tag-group
semantics; tag groups spanning multiple partitions are rejected by
cxl_check_group_partition().

> --
> 
> commit c1287602ad57e47bb90d02808a1f908fcb287a89
> Author: Ira Weiny <iweiny@kernel.org>
> Subject: cxl/extent: Handle DC Add Capacity events
> 
> Replace the empty-response stub in handle_add_event() with the real
> add pipeline. This commit fills in the logic for processing the pending list
> and adds basic validation for extents before they are added to the
> device model as a child of the cxlr_dax region.
> 
> > diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> > new file mode 100644
> > index 0000000000000..6e67e787d14de
> > --- /dev/null
> > +++ b/drivers/cxl/core/extent.c
> > @@ -0,0 +1,411 @@
> [ ... ]
> > +static void dc_extent_release(struct device *dev)
> > +{
> > +	struct dc_extent *dc_extent = to_dc_extent(dev);
> > +	struct cxl_dc_tag_group *group;
> > +
> > +	if (!dc_extent)
> > +		return;
> > +
> > +	group = dc_extent->group;
> > +	cxled_release_extent(dc_extent->cxled, dc_extent);
> > +	xa_erase(&group->cxlr_dax->dc_extents, dc_extent->dev.id);
> > +	xa_erase(&group->dc_extents, dc_extent->seq_num);
> > +	group->nr_extents--;
> > +	if (!group->nr_extents)
> > +		free_tag_group(group);
> 
> [Severity: High]
> Is it safe to decrement group->nr_extents without a lock? Since multiple
> extents in the same group can be released concurrently, couldn't this
> non-atomic decrement cause a data race, leading to a permanent memory leak
> of the cxl_dc_tag_group and its pinned cxlr_dax->dev reference?
> 
A tag group is torn down by a single memdev's event
thread so the tag group's extents are released serially: either through
the release event or during teardown under cxl_rwsem.region held for
write.

> > +	kfree(dc_extent);
> > +}
> [ ... ]
> > +static enum cxl_extent_class
> > +cxlr_dax_classify_extent(struct cxl_dax_region *cxlr_dax,
> > +			 struct cxl_endpoint_decoder *cxled,
> > +			 const struct range *ext_range)
> > +{
> > +	struct dc_extent *entry;
> > +	unsigned long i;
> > +
> > +	xa_for_each(&cxlr_dax->dc_extents, i, entry) {
> > +		if (entry->cxled != cxled)
> 
> [Severity: High]
> Is this iteration safe against concurrent teardown? xa_for_each drops the
> internal RCU read lock between iterations, leaving the returned entry
> unprotected. If online_tag_group fails concurrently or there is a
> parallel release, couldn't accessing entry->cxled trigger a use-after-free?
> 
Correct. cxlr_dax->dc_extents is per-region and shared across
memdevs, whereas log_lock is per-memdev, so two memdevs' event threads can
walk and free the xarray concurrently while each holds only cxl_rwsem.region
for read. Note that this only applies to interleaved regions spanning >=
2 memdevs. Single memdev regions were protected by the memdev's
log_lock.

The fix is to make the free RCU-deferred.
- rcu_head is added to struct dc_extent
- we call kfree_rcu() in dc_extent_release()
- guard(rcu) called before xa_for_each() in this function
- Patch 18 introduces cxl_rm_extent(), which also walks
  cxlr_dax->dc_extents to find the right extent to release. This also
  needs guard(rcu)
  	- specifically, it calls scoped_guard(rcu){} to unlock before
	the call to cxl_region_invalidate_memregion() which can sleep. 

> > +			continue;
> > +		if (range_contains(&entry->dpa_range, ext_range))
> > +			return CXL_EXT_DUPLICATE;
> [ ... ]
> > +static int cxlr_add_extent(struct cxl_memdev_state *mds,
> > +			   struct cxl_dax_region *cxlr_dax,
> > +			   struct dc_extent *dc_extent)
> > +{
> > +	struct cxl_dc_tag_group **group = &mds->add_ctx.group;
> > +	int rc;
> > +
> > +	if (*group && !uuid_equal(&(*group)->uuid, &dc_extent->uuid)) {
> > +		kfree(dc_extent);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!*group) {
> > +		dev_dbg(&cxlr_dax->dev, "Alloc new tag group\n");
> > +		*group = alloc_tag_group(cxlr_dax, &dc_extent->uuid);
> > +		if (IS_ERR(*group)) {
> > +			rc = PTR_ERR(*group);
> > +			*group = NULL;
> > +			kfree(dc_extent);
> > +			return rc;
> > +		}
> > +	} else {
> > +		dev_dbg(&cxlr_dax->dev, "Append dc_extent to tag group\n");
> > +	}
> > +
> > +	dc_extent->group = *group;
> 
> [Severity: High]
> What happens if extents in the same tag group (sharing a UUID) map to
> different endpoint decoders and thus different DAX regions? This logic
> appears to allocate the tag group using the cxlr_dax of the first extent
> and blindly links subsequent extents to it. Could this cause cross-region
> extents to be parented to the wrong region and corrupt their HPA mapping
> offsets?
> 
False Positive.

Subsequent patches "cxl/mem: Enforce tag-group semantics" and
"cxl/extent: Validate DC extent partition", reject a tagged group
spanning multiple partitions via cxl_check_group_partition()

> > +
> > +	/*
> [ ... ]
> > +int online_tag_group(struct cxl_dc_tag_group *group, bool skip_release)
> > +{
> [ ... ]
> > +		rc = dev_set_name(dev, "extent%d.%d", cxlr_dax->cxlr->id,
> > +				  dev->id);
> > +		if (rc) {
> > +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> > +			put_device(dev);
> > +			break;
> > +		}
> > +
> > +		rc = device_add(dev);
> > +		if (rc) {
> > +			xa_erase(&cxlr_dax->dc_extents, dev->id);
> > +			put_device(dev);
> > +			break;
> > +		}
> 
> [Severity: High]
> Does the manual xa_erase() before put_device() create a double-erase race
> condition?
> 
> put_device(dev) synchronously calls dc_extent_release(), which performs a
> second xa_erase() for the same ID. If a concurrent thread allocates an ID
> between the first and second erase, wouldn't the second erase silently
> clobber the new valid allocation?
> 
Yes, for regions interleaved across >= memdevs, so it can possibly
have 2 event threads handling a DC add event concurrently.

The manual xa_erase in both error paths here are deleted.

> [Severity: High]
> Additionally, does this error path violate the skip_device_release protocol?
> At this point, group->skip_device_release has not been set yet. Because it
> is false, won't dc_extent_release() unconditionally send a Release DC command
> to the hardware for capacity the host never formally accepted?
> 
Fixed.

Setting/clearing skip_device_release is managed by the caller --
cxl_realize_group().

So in cxl_realize_group():

tag_group->skip_device_release = !existing;   // (1) set before onlining
rc = online_tag_group(tag_group);	// err paths honor flag
  ...
rc = cxlr_notify_extent(...DCD_ADD_CAPACITY...); 
if (rc) { rm_tag_group(tag_group); return rc; }    // honors flag

tag_group->skip_device_release = false;       // (2) clear after notifying dax layer


Since skip_device_release is managed by the caller, remove the skip_release
param from this function.


Caveat: in cxl_add_pending(): cxl_realize_group() is called right before
cxl_send_dc_response(), but the fully "correct" behavior would be to set
it only after cxl_send_dc_response() returns 0.

cxl_add_pending(...) {
	while(pending_list !empty) {
		extract_tag_group()

		cnt = cxl_realize_group(tag_group) <--- set/clear skip_device_release
		if (cnt < 0) {
			drop_extent_group(&group);
			continue;
		}

		list_splice_tail_init(&group, &accepted);
		total_accepted += cnt;
	}

	list_splice(&accepted, pending);

	/*
	 * Recovered (already-accepted) extents must not be re-reported in an
	 * Add-DC-Response: the device rejects a DPA range already added by a
	 * previous response (CXL r4.0 8.2.10.9.9.3, Invalid Physical Address).
	 */
	if (existing)
		return 0;

	return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
				    pending, total_accepted);
}

This is a best-effort fix. Outside of the while loop, we don't have a
reference to the tag_groups, and would need to re-extract every tag
group in order to set the flag after cxl_send_dc_response. Additionally, nothing between
cxl_realize_group() and cxl_send_dc_response() affects the
skip_device_release flag, so the gap is small. The device also simply
rejects spurious Release responses with Invalid Physical Address, which
is benign.


The "true" fix would be to modify cxl_send_dc_response to extract
all tag_groups from the extent list (pending).

Then in each error scenario:

1. Fail to alloc response:

struct cxl_mbox_dc_response *response __free(kfree) =
						kzalloc(pl_size, GFP_KERNEL);
if (!response) {

	*** set each tag group's skip_device_release = true ***

	/* Refuse all extents rather than stall the device. */
	struct cxl_mbox_dc_response empty = { };

	return send_one_response(cxl_mbox, &empty, opcode, 0, 0);
}

2. If the extent list is too long and must be split across multiple
responses, we further have to track which tag groups were successfully
accepted or even partially accepted, since the response orders extents
in arrival order, and are not necessarily grouped by tag.

IMO the additional complexity to handle these edge cases is not
justifiable.


> > +
> > +		dev_dbg(dev, "dc_extent HPA %pra (%pU)\n",
> [ ... ]
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 4e887b5cdc3ed..08f51b8807c06 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> [ ... ]
> > +static int cxl_realize_group(struct cxl_memdev_state *mds, const uuid_t *tag,
> > +			     struct list_head *group, bool existing)
> > +{
> > +	struct device *dev = mds->cxlds.dev;
> > +	struct cxl_extent_list_node *pos, *tmp;
> > +	struct cxl_dc_tag_group *tag_group;
> > +	int group_cnt = 0;
> > +	int rc;
> > +
> > +	list_for_each_entry_safe(pos, tmp, group, list) {
> > +		/*
> > +		 * Pass the device-stamped 0-based shared_extn_seq through
> > +		 * unchanged as the dax-side @seq_num (0..n-1).
> > +		 */
> > +		u16 seq = le16_to_cpu(pos->extent->shared_extn_seq);
> > +
> > +		if (cxl_add_extent(mds, pos->extent, seq) < 0) {
> > +			dev_dbg(dev,
> > +				"Tag %pUb: failed to add extent DPA:%#llx LEN:%#llx\n",
> > +				tag,
> > +				le64_to_cpu(pos->extent->start_dpa),
> > +				le64_to_cpu(pos->extent->length));
> > +			delete_extent_node(pos);
> > +			continue;
> > +		}
> 
> [Severity: High]
> If cxl_add_extent() fails during initialization of existing extents
> (e.g., under memory pressure), we simply delete the node and continue.
> Because the extent is never added to a tag group, the teardown error path
> cannot see it. Does this permanently strand the capacity on the device since
> no Release DC command is sent?
> 
False Positive.
Existing extents never set skip_device_release so on failure, they are
released back to the device.

The skip_device_release flags and logic only applies to fresh extents.
> > +		group_cnt++;
> > +	}
> > +
> > +	tag_group = mds->add_ctx.group;
> > +	mds->add_ctx.group = NULL;
> > +	if (!tag_group)
> > +		return -ENXIO;
> 
> [Severity: High]
> If an Add Capacity event contains only extents that the host has already
> accepted (duplicates), cxl_add_extent() succeeds but returns 0, and
> mds->add_ctx.group is never allocated. Does this erroneously fail the
> entire group with -ENXIO, causing cxl_add_pending() to drop it without
> sending an Add-DC-Response, thereby stalling the device?
> 
False Positive. 

cxl_add_pending() unconditionally calls cxl_send_dc_response() at the
end. If every extent in a group is a duplicate, an empty response is
sent.

-ENXIO is returned here and in cxl_add_pending():

while(!list_empty(pending)){

	cnt = cxl_realize_group(mds, &tag, &group, shareable, existing);
	if (cnt < 0) {
		drop_extent_group(&group);
		continue;
	}
		list_splice_tail_init(&group, &accepted);

	total_accepted += cnt;
}
list_splice(&accepted, pending);

/*
 * Recovered (already-accepted) extents must not be re-reported in an
 * Add-DC-Response: the device rejects a DPA range already added by a
 * previous response (CXL r4.0 8.2.10.9.9.3, Invalid Physical Address).
 */
if (existing)
	return 0;

return cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
				    pending, total_accepted);


^total_accepted is never incremented so the response is empty.

> > +
> > +	rc = online_tag_group(tag_group, !existing);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=14
