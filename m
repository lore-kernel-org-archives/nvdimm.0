Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AF31F1537;
	Thu, 25 Jun 2026 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412579; cv=none; b=XTsLog/4VqSKd/Odmfa7+MR+5vsQHAzTyn96XqGBw1TfjRmNpqQnKmaEe9QgHlxwXI8le1rLJdxyK8fMZpXpwFGD5CWD9bEhADDfopB5ewL+eAyZrnyyPR7roVRo49wPJTY1WSF6lUAiMfCZP4y7PjSrE137OG36URe6Q6Jo3eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412579; c=relaxed/simple;
	bh=xD4iyZTz/ORco4hqU91Mg7BlxFmcHuWOte2yNSTKN0M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mXs2zbKc56aXehqv/jeZ/qgF//pZlHWqbHYAfQupwzDvan4SGIhI+32BFueArgrNPc4FMqTHQVRgtR8dd0YmtqFhWSRbhhFweEW/yd5p6I/2YsF8mmG/NT0FWWhqqiJCQ6u/Y/MNb5JlZiubhSOEsfNY8z0+7OBTh2o88Hi6JgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fta/CYPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fta/CYPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6CF1F000E9;
	Thu, 25 Jun 2026 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412578;
	bh=HlcSyUQjzCvKlQqntO3dGQKqAgnSJHmGqA4mTMURINg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fta/CYPf2d9Lgje0zKZubzFpQe3N/bz4zrMhRjgxV5Vflv2/O83SnWa0NqrgJHD6K
	 TjOqcvfeq3tqeGBX+pvNko70J3wJ0kimzfJV5i/3FaYDtNdAjpjCBzgTQ2WYsA+Y3g
	 C311gKzVonvalkI/OX++OmIRLNIN+7j4EoiRZ+sgUwHoAH7z3IxVgZvJVfPTdJxIcG
	 HacOlqxflDMpPDWlbEgtxf2+Wu9XXvIQvYnOoLoFFBl5nbXIdQBXeuOFC/oi/B4kbq
	 kqidb9V7j+s3fY4HR0laKukeGGdZBr/pK3RTM6yVPOROLKCoCk6sQqubyaY4NmritL
	 k0Ii7/Gz/xVHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 22/31] cxl + dax: Release dax_resources on DCD
 Release Capacity events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-23-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-23-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:36:17 +0000
Message-Id: <20260625183618.3B6CF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Returning 0 when the DAX layer returns `-EBUSY` silently clears th=
e release event without notifying the device, causing a permanent capacity =
leak.

Pre-existing issues:
- [Critical] Unprotected `xa_for_each` iteration over `dc_extents` in `cxl_=
rm_extent` accesses unlocked and potentially freed `dc_extent` pointers, ca=
using a Use-After-Free.
--

commit a5dc5f1cb7a057f33cf2e7a95e0f09b9a990b420
Author: Ira Weiny <iweiny@kernel.org>

cxl + dax: Release dax_resources on DCD Release Capacity events

Implement the release path that mirrors the add path: when the device
asks for capacity back, the dax layer tears down the per-extent
resources for the whole tag group atomically via
dax_region_rm_resources().

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 59db1878b5e2d..7009ac6a51b46 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c

[Severity: Critical]
This isn't a bug introduced by this patch, but is it possible for the
xa_for_each() loop in cxl_rm_extent() to trigger a use-after-free?

Since cxl_rm_extent() and handle_add_event() hold cxl_rwsem.region
only for read, can two threads execute them concurrently for the same
region?

If thread A calls rm_tag_group() and unregisters devices:

drivers/cxl/core/extent.c:rm_tag_group() {
    xa_for_each(&group->dc_extents, index, dc_extent)
        devm_release_action(region_dev, dc_extent_unregister, dc_extent);
}

Which triggers a synchronous free via dc_extent_release():

drivers/cxl/core/extent.c:dc_extent_release() {
    kfree(dc_extent);
}

And concurrently, thread B executes the xa_for_each loop in cxl_rm_extent():

drivers/cxl/core/extent.c:cxl_rm_extent() {
    xa_for_each(&cxlr_dax->dc_extents, idx, dc_extent) {
        if (dc_extent->cxled !=3D cxled)

Since xa_for_each() takes and drops the RCU read lock internally during
lookup, could thread B yield the dc_extent pointer just as thread A frees i=
t,
causing the access to dc_extent->cxled to be a use-after-free?

[ ... ]

> @@ -627,6 +627,18 @@ int cxl_rm_extent(struct cxl_memdev_state *mds, stru=
ct cxl_extent *extent)
>  	if (rc)
>  		return rc;
> =20
> +	rc =3D cxlr_notify_extent(cxlr, DCD_RELEASE_CAPACITY, group);
> +	if (rc) {
> +		/*
> +		 * dax layer refused (-EBUSY) or failed (-ENOMEM, etc.).  Do
> +		 * not proceed to tear down the tag group =E2=80=94 leave its
> +		 * dax_resources alive so we do not free them out from under
> +		 * live dev_dax ranges.  The device will retry the release.
> +		 */
> +		return 0;
> +	}

[Severity: High]
Does returning 0 here when the DAX layer returns -EBUSY silently clear the
release event and cause a permanent capacity leak?

If cxlr_notify_extent() returns -EBUSY because capacity is actively mapped,
returning 0 signals success to cxl_handle_dcd_event_records().

This will cause cxl_mem_get_records_log() to issue a
CXL_MBOX_OP_CLEAR_EVENT_RECORD command, which clears the event from the dev=
ice
without ever sending the CXL_MBOX_OP_RELEASE_DC command.

The comment mentions the device will retry the release, but section
8.2.9.2.1.3 of the CXL 3.1 specification states the device 'MAY reissue an
event', not MUST.

If the device does not actively reissue the event, will the host permanently
lose track of the release request and leak the capacity?

> +
> +	/* Release the entire tag group */
>  	rm_tag_group(group);
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D22
