Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418EF31F98E;
	Thu, 25 Jun 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411655; cv=none; b=Iy7N/GIeKkHL0Y2CA4Zef7/asgnLCD58he9Z2eSGTqNb9COrHzQu70VjOV9L030xwTzRU2EIoNSyMnZQmIo8rY/3iRnCUH+W5iPogFPgAU6oVZvklwXzMnntpf7jRWvdRnt5Jum63l3nm4/v5QiMNotFx7VDieRcF23jDZsxDFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411655; c=relaxed/simple;
	bh=86JPG3ye2RD/9r+qkIVEYVzqipkTnMDxw1D/0qVHrHc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ko0x6z1lenz8MCO5vI7JGM3uWk9b4jbvZR5/NscZdorifAIb+fZwzHvLRZlqCHIa2ZhdtPsyxNUKiDRZzhWiA4/ZbOINuMVqvNy8nzKHwfEmhP/866FDI1GSEnhnJYipIUp6PzLpuObbEeVcqu1QWMadSivbcI6TmDfBQ5RIQ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULVSt+Vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULVSt+Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E301F000E9;
	Thu, 25 Jun 2026 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411652;
	bh=W5HKQ6V5lHzB+BCAVeKKCbJS4YWGIEs3PaOFAv/UFT8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ULVSt+VmeYrnLXsqVmXWH5qiN5s1uneTE3xVRwRQ9g/mqUhVPw7o6OBdm3FrVE/ah
	 ZT5KcZDIOthN9BBhEzbQXoE4hR15XBrKe7EYUsvXrR3UXVAecW3HVps/8dFahVKRIR
	 OGZWDtD7VkF6efxXagd8W/NN3JXsW9IeRCRNtihCcHP1Ln5JskKt4T9r9mQ4bV2GY/
	 UFt5K/+48jQ/Jg+cFVCzmKx92qdNqlh6ThdQ6kWm3zLlpujkVQspiLBveZs6ut1BtN
	 lAjesW7PgIYfKjSzL0fyonZ3X/kPymgioiAOwIrhpr8d7Ke/DoOzkJfy/CjS1xvUKu
	 euxV6imMYaytw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 16/31] cxl/extent: Validate DC extent partition
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-17-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-17-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:20:51 +0000
Message-Id: <20260625182052.07E301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Entirely duplicate tag groups are rejected and dropped instead of =
replying success to the device.
- [High] Concurrent access to `group->nr_extents` without locks causes a me=
mory leak and pins the DAX region device indefinitely.
--

commit b3bfb6df5d2f0f0f9e2b022064279f74742afa2e
Author: Ira Weiny <iweiny@kernel.org>

cxl/extent: Validate DC extent partition
   =20
Extend cxl_validate_extent() =E2=80=94 the per-extent check of the add pipe=
line
to check partition membership. Resolves an extent's DPA to its containing
DC partition. Sharability is a property of the partition (part->shareable),
taken from its CDAT DSMAS entry.

> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> index 6e67e787d14de..2e770c5279c23 100644
> --- a/drivers/cxl/core/extent.c
> +++ b/drivers/cxl/core/extent.c

[ ... ]

> @@ -101,6 +159,27 @@ static int cxl_validate_extent(struct cxl_memdev_sta=
te *mds,
>  		.end =3D start_dpa + le64_to_cpu(extent->length) - 1,
>  	};
>  	struct range ed_range;
> +	uuid_t uuid;
> +
> +	import_uuid(&uuid, extent->uuid);
> +
> +	part =3D cxl_extent_dc_partition(mds, extent, &ext_range);
> +	if (!part)
> +		return -ENXIO;
> +
> +	if (part->shareable) {
> +		if (uuid_is_null(&uuid)) {
> +			dev_err_ratelimited(dev,
> +				"DC extent DPA %pra: sharable-partition extent has null tag (firmwar=
e bug)\n",
> +				&ext_range);
> +			return -ENXIO;
> +		}
> +	} else if (le16_to_cpu(extent->shared_extn_seq)) {
> +		dev_err_ratelimited(dev,
> +			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=
=3D%u (firmware bug)\n",
> +			&ext_range, &uuid, le16_to_cpu(extent->shared_extn_seq));
> +		return -ENXIO;
> +	}
> =20
>  	cxlr =3D cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
>  	if (!cxlr || !cxlr->cxlr_dax)

[Severity: High]
This is a pre-existing issue, but I noticed a potential race condition in
drivers/cxl/core/extent.c:dc_extent_release() that might lead to a leak:

	group->nr_extents--;
	if (!group->nr_extents)
		free_tag_group(group);

Could concurrent access to group->nr_extents without locks cause a lost
decrement?

When userspace closes sysfs files for multiple extents of the same tag group
concurrently, their kobject refcounts can drop to 0 simultaneously, causing
dc_extent_release() to run on multiple CPUs in parallel.

If group->nr_extents never reaches 0, does this permanently pin the DAX
region device (since the reference isn't dropped) and leak the
cxl_dc_tag_group structure?

[Severity: High]
This isn't a bug introduced by this patch, but I have a question about how
duplicate tag groups are handled between drivers/cxl/core/extent.c and
drivers/cxl/core/mbox.c.

In drivers/cxl/core/extent.c:cxl_add_extent(), duplicate extents return 0
without allocating or assigning mds->add_ctx.group:

	case CXL_EXT_DUPLICATE:
		/*
		 * Idempotent accept simplifies the dax-side scan for existing
		 * extents on region creation; reply success without duplicating.
		 */
		dev_warn_ratelimited(&cxled->cxld.dev,
				     "Extent %pra exists; accept again\n",
				     &ext_range);
		return 0;

If all extents in a group are duplicates, cxl_realize_group() in
drivers/cxl/core/mbox.c finishes its loop with group_cnt > 0 but
mds->add_ctx.group remains NULL. It then returns -ENXIO:

	tag_group =3D mds->add_ctx.group;
	mds->add_ctx.group =3D NULL;
	if (!tag_group)
		return -ENXIO;

Since this causes the caller cxl_add_pending() to treat the group as an err=
or
and drop the extents instead of adding them to the accepted list, does this
leave the device hanging without an ADD_DC_RESPONSE if it resends an
unacknowledged extent group?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D16
