Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF12D94B5;
	Thu, 25 Jun 2026 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412325; cv=none; b=PqKJ8OKpTBbUzPkZ28l6u5M+9UgfBkaOzdErTO/Ryv8UPAwcSESzOGZSYDMZR0kvlrNmpALfVpjV82AponHBusreMNs+wp2XDRhSzAL/M4WARsPqvVKeVrYkzT9eb7rB9fX2srjhZTrIalo6dKDZe4AzvqXGXqNDicJ7Zw5rmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412325; c=relaxed/simple;
	bh=htYnye3sj1OGyyzJUooewtWOEq+Z9JA+lwBaLPTNmz4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZKwHMDTWQMysqRUXJCOGYFb2/Zd/8YjNy4JQdibpHxFeyB9ElYnxtjXBxBBON2l1EWJ07d1Yf9L13/Nkbxbp9pgowbNB4C1IVnjD7bNVdLRvzfhAdZ5npkAi2f7ZF5+NmofkH3Bh7+Cmry2UH4QEZBHfvZlFy/BTGupgPw+uSi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkqqGZd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkqqGZd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3042C1F000E9;
	Thu, 25 Jun 2026 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412323;
	bh=hr60yuCQ3FRSkQwbbsQ5sn5cTZrrHJUjI2Ulxr58Wuc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FkqqGZd4ALp7QFHZQ2V6YoNzscq0zIZv4Cwo54JJ9xROPMhIFNwEVSuMFUsiyuQFE
	 zGXvtVw4xc8cGNAJM9KDZgBPTNAEIMlRKhDGMy+9Big9Cx/hOWOaCAspfpp+goiOYj
	 77c/sXmY33l+RX6qJyUvag6fz1vE/xBNiu/egkQHkvXHMTNIRU8AYQnKCwIeX8Z0XR
	 0E5ZlsQuBdywHmgoezj/uOi/tUPakcQ30pRveje9DbWOUHl4lEtWbcTb+8Qs0mDox5
	 HREWuGUDtxGi9T7d0illxkQNH5qZ99GLXs8dc/2kvuUofAGkAPXFUF4o8ZudR8+bfT
	 7H0HWK6d/9Ehg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 27/31] cxl/region: Read existing extents on region
 creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-28-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-28-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:32:02 +0000
Message-Id: <20260625183203.3042C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] Cross-region lock assertion failure when processing existing exten=
ts.
- [High] Out-of-bounds read due to unvalidated `nr_returned` payload size.
- [High] Runtime DC add events are permanently dropped and lost during regi=
on probe, contradicting the design intent.
- [High] Permanent device capacity leak when existing extents are dropped.
- [High] AB-BA deadlock between `mds->add_ctx.lock` and `cxlr_dax->dev` loc=
k.
- [High] Shared `pending_extents` list corruption aborts in-flight runtime =
events.
- [Medium] Mixing `goto`-based error handling with `__free()` and `guard()`=
 violates subsystem cleanup guidelines.

Pre-existing issues:
- [High] Integer overflow in extent boundary calculation bypasses range val=
idation.
--

commit ae344fab96ea05c143bd5e8ab47ce8059fc778b6
Author: Ira Weiny <iweiny@kernel.org>
Subject: cxl/region: Read existing extents on region creation

Dynamic capacity device extents may be left in an accepted state on a
device due to an unexpected host crash. This patch reads the 'devices
extent list' during the asynchronous cxl_dax_region probe to reveal
previously accepted extents and add them to the new region, avoiding
races with probe.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c
> @@ -261,7 +261,7 @@ static int cxl_validate_extent(struct cxl_memdev_stat=
e *mds,
>  			       struct cxl_extent *extent,
>  			       struct cxl_endpoint_decoder **out_cxled,
>  			       struct cxl_dax_region **out_cxlr_dax,
> -			       struct range *out_ext_range)
> +			       struct range *out_ext_range, bool existing)
>  {
>  	u64 start_dpa =3D le64_to_cpu(extent->start_dpa);

[Severity: High]
This is a pre-existing issue, but could the extent boundary calculation
in cxl_validate_extent() overflow?

A few lines down from this signature change, the end boundary is calculated:

    struct range ext_range =3D (struct range) {
        .start =3D start_dpa,
        .end =3D start_dpa + le64_to_cpu(extent->length) - 1,
    };

If a device provides a massive start_dpa and a small length, could this
calculation wrap around and produce a small ext_range.end?

If so, the bounds check later in the function:

    if (!range_contains(&ed_range, &ext_range)) {

would evaluate r1->start <=3D r2->start && r1->end >=3D r2->end. With a wra=
pped
near-zero ext_range.end, the check might incorrectly pass, allowing
an out-of-bounds extent.

> [ ... ]
> @@ -300,6 +300,13 @@ static int cxl_validate_extent(struct cxl_memdev_sta=
te *mds,
>  	if (!cxlr || !cxlr->cxlr_dax)
>  		return -ENXIO;
> =20
> +	/*
> +	 * Pre-existing extents must be read before any new extent is added so a
> +	 * tag already in use is never added twice; defer new adds until then.
> +	 */
> +	if (!existing && !smp_load_acquire(&cxlr->cxlr_dax->extents_scanned))
> +		return -EBUSY;
> +

[Severity: High]
Does returning -EBUSY here cause runtime Add Capacity events to be permanen=
tly
lost?

If cxl_validate_extent() returns -EBUSY for a new runtime event, its caller
cxl_realize_group() treats it as a failure, logging an error and deleting t=
he
extent node:

    if (cxl_add_extent(mds, pos->extent, seq_num, existing) < 0) {
        dev_dbg(dev, "Tag %pUb: failed to add extent ...");
        delete_extent_node(pos);
        continue;
    }

Since the extent is destroyed rather than deferred, it seems it will be omi=
tted
from the ADD_DC_RESPONSE, meaning the host officially rejects it. Does this
prevent the runtime capacity from being added?

> [ ... ]
> @@ -376,16 +383,22 @@ dc_extent_build(struct cxl_endpoint_decoder *cxled,
>  	return dc_extent;
>  }
> =20
> -int cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
> -		       struct cxl_dc_tag_group *group)
> +/*
> + * Core notify: the caller must hold device_lock(&cxlr->cxlr_dax->dev). =
 Used by
> + * the existing-extent path that runs inside cxl_dax_region_probe(), whe=
re the
> + * async device-attach already holds the dax_region's device_lock =E2=80=
=94 taking it
> + * again (as cxlr_notify_extent() does) would deadlock the probe against=
 itself.
> + */
> +int __cxlr_notify_extent(struct cxl_region *cxlr, enum dc_event event,
> +			 struct cxl_dc_tag_group *group)
>  {
>  	struct device *dev =3D &cxlr->cxlr_dax->dev;
>  	struct cxl_notify_data notify_data;
>  	struct cxl_driver *driver;
> =20
> -	dev_dbg(dev, "Trying notify: type %d tag %pUb\n", event, &group->uuid);
> +	device_lock_assert(dev);

[Severity: High]
Could this lock assertion fail when processing extents from other regions?

When __cxl_process_extent_list() queries the device for existing extents,
the device returns all extents for all partitions, which may belong to
different regions.

For an extent belonging to a different region, cxl_realize_group() will call
__cxlr_notify_extent() targeting that other region. However, the probe thre=
ad
only holds the device lock for the region currently being probed. Will this
cause the assertion to fail for extents on other regions?

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1503,7 +1503,7 @@ static int cxl_realize_group(struct cxl_memdev_stat=
e *mds, const uuid_t *tag,
>  		else
>  			seq_num++;
> =20
> -		if (cxl_add_extent(mds, pos->extent, seq_num) < 0) {
> +		if (cxl_add_extent(mds, pos->extent, seq_num, existing) < 0) {

[Severity: High]
If cxl_add_extent() fails for an existing extent, could this cause a perman=
ent
capacity leak?

If existing=3Dtrue, but cxl_validate_extent() or cxl_add_extent() fails
(e.g., due to an overlap or memory allocation failure), the host drops the
extent by calling delete_extent_node(pos) inside cxl_realize_group().

Because existing=3Dtrue, cxl_add_pending() skips sending an ADD_DC_RESPONSE.
Since the device considers the extent accepted and the host never sends a
Release-DC command for the dropped extent, does the capacity remain leaked
until reboot?

> [ ... ]
> @@ -2199,6 +2209,145 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> =20
> +/* Return -EAGAIN if the extent list changes while reading */
> +static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
> +{
> +	u32 current_index, total_read, total_expected, initial_gen_num;
> +	struct cxl_memdev_state *mds =3D cxled_to_mds(cxled);
> +	struct cxl_mailbox *cxl_mbox =3D &mds->cxlds.cxl_mbox;
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_mbox_cmd mbox_cmd;
> +	u32 max_extent_count;
> +	int rc =3D 0;
> +	bool first =3D true;
> +
> +	struct cxl_mbox_get_extent_out *extents __free(kvfree) =3D
> +				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
> +	if (!extents)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Build and consume add_ctx.pending_extents under add_ctx.lock, the
> +	 * same lock the DC event path (handle_add_event()) holds, so the two
> +	 * cannot corrupt the shared pending list.
> +	 */
> +	guard(mutex)(&mds->add_ctx.lock);

[Severity: High]
Could this lock acquisition lead to an AB-BA deadlock between the
mds->add_ctx.lock and the region device lock?

In __cxl_process_extent_list(), the driver core is probing the region,
so the region's device lock is already held. Here we acquire mds->add_ctx.l=
ock,
establishing a (device_lock -> add_ctx.lock) ordering.

However, in the asynchronous event path (e.g., handle_add_event()), the dri=
ver
holds mds->add_ctx.lock, and then cxl_realize_group() calls cxlr_notify_ext=
ent()
which acquires the device lock:

    guard(device)(&cxlr->cxlr_dax->dev);

This establishes an (add_ctx.lock -> device_lock) ordering. If a DC event
arrives while a region is being probed, could these paths deadlock?

[Severity: High]
Could appending to mds->add_ctx.pending_extents here disrupt in-flight
multi-part runtime Add Capacity events?

Runtime DC Add Capacity events with the 'More' flag set accumulate partial
extents in mds->add_ctx.pending_extents across multiple interrupts, with the
lock released in between.

If __cxl_process_extent_list() is called concurrently during a region probe,
it unconditionally appends to this list. Later, it clears the list:

    out:
        clear_pending_extents(mds);

If there was an in-flight runtime event, would its accumulated extents be
processed as existing=3Dtrue (meaning no response sent) and then destroyed,
leaving the device stalled waiting for a response?

> +
> +	total_read =3D 0;
> +	current_index =3D 0;
> +	total_expected =3D 0;
> +	max_extent_count =3D (cxl_mbox->payload_size - sizeof(*extents)) /
> +			    sizeof(struct cxl_extent);
> +	do {
> +		u32 nr_returned, current_total, current_gen_num;
> +		struct cxl_mbox_get_extent_in get_extent;
> +
> +		get_extent =3D (struct cxl_mbox_get_extent_in) {
> +			.extent_cnt =3D cpu_to_le32(max_extent_count),
> +			.start_extent_index =3D cpu_to_le32(current_index),
> +		};
> +
> +		mbox_cmd =3D (struct cxl_mbox_cmd) {
> +			.opcode =3D CXL_MBOX_OP_GET_DC_EXTENT_LIST,
> +			.payload_in =3D &get_extent,
> +			.size_in =3D sizeof(get_extent),
> +			.size_out =3D cxl_mbox->payload_size,
> +			.payload_out =3D extents,
> +			.min_out =3D 1,
> +		};
> +
> +		rc =3D cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> +		if (rc < 0)
> +			goto out;
> +
> +		/* Save initial data */
> +		if (first) {
> +			total_expected =3D le32_to_cpu(extents->total_extent_count);
> +			initial_gen_num =3D le32_to_cpu(extents->generation_num);
> +			first =3D false;
> +		}
> +
> +		nr_returned =3D le32_to_cpu(extents->returned_extent_count);

[Severity: High]
Could a malformed device response cause an out-of-bounds read here?

Because min_out is hardcoded to 1, truncated mailbox responses are accepted.
The code then extracts nr_returned:

    nr_returned =3D le32_to_cpu(extents->returned_extent_count);

and iterates over it:

    for (int i =3D 0; i < nr_returned ; i++) {
        struct cxl_extent *extent =3D &extents->extent[i];

Since nr_returned is not validated against max_extent_count or the actual
payload size returned by the hardware, could a large nr_returned value cause
the loop to read past the end of the kvmalloc buffer into unrelated kernel
heap memory?

> [ ... ]
> +	} while (total_expected > total_read);
> +
> +	if (!list_empty(&mds->add_ctx.pending_extents)) {
> +		/*
> +		 * Reached only on the success path (every error does goto out),
> +		 * so rc is 0 here.  These extents are already accepted on the
> +		 * device (recovered from a prior boot).  Pass existing=3Dtrue so
> +		 * they are not re-reported in an Add-DC-Response (the device
> +		 * would reject a DPA already added by a prior response), and so
> +		 * a failed online releases them rather than silently dropping
> +		 * them.
> +		 */
> +		rc =3D cxl_add_pending(mds, true);
> +	}
> +out:
> +	clear_pending_extents(mds);

[Severity: Medium]
Does mixing goto statements with scope-based cleanup violate the cleanup
subsystem guidelines?

This function declares resources using scope-based cleanup:

    struct cxl_mbox_get_extent_out *extents __free(kvfree) =3D ...
    guard(mutex)(&mds->add_ctx.lock);

But it also uses explicit goto out statements that jump to a manual cleanup
label:

    out:
        clear_pending_extents(mds);

The cleanup subsystem documentation expects that usage of "goto" and cleanup
helpers is never mixed in the same function to avoid confusing ownership
semantics. Should this be refactored?

> +
> +	return rc;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D27
