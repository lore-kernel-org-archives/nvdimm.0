Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952BF302140;
	Thu, 25 Jun 2026 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412019; cv=none; b=WJ/jOXAnrDZKHwSwxuAl8inLvSsZJeg5bSH3U/VkXeHyqRAjqS+0dwxURR3De2WxOnmWb/myh2e0WS2injVGFT+INUg4eEL/e2f3MpHVTmpVy07vdm+0bWjPHsx3tdvukgo7HWHfn+whGQ2NQrZgP7hKrQwdCYKc2EqUYrC3bPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412019; c=relaxed/simple;
	bh=WgJoPHBC+9mvTmC2YYUctVUI5Mm9sYoAB7lB7XJacnw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jOtH4SUGZj4sPjLRWiKrB4Dqj3IyXWg1f3oPC/wMEu74daXpSsZw0lKxIaaBTTkytBD3WTVFxVaqStsgGMK+OEAf1voU1nURU/e+L7LJj8XBVkK2ZbKOMJinbUeE6566xHjayJfacmf2RsoVcG4ZPSoS6PPZbLUvsXxHde1QfBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCEUByhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCEUByhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CBC1F000E9;
	Thu, 25 Jun 2026 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412018;
	bh=UutrYfmwNmv0Et/dlUJAmd6pKLRM9f5vVGNh87fF+M8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fCEUByhJ8O2HaKS3aVpl+ge/+6c9dOfGYLTW9h3FMjj25YsFJnsmgXD/8kaaL2u5X
	 JaA2uH6mx/foDFhFyXwfkB5Jygbr1lMPK4LKtMBG5s3SjLWkoZQiZz+upJZeppXPv3
	 QWldTzb02if2cf+yKLzP8uJDBYEVaj3R6y5a5JfXOOSF7eW3JmOK1entS2uxO196xu
	 iQWJuJnOVpPM/ohqlUy+kXDg3kLCAgf6zycZQmfyFJQhNAcL8+fmokRU7xuO85eaoq
	 4hk2+68U79/eyIL7jLWXkiEMdo0zLhFRC498NcAEAkZmbqbwPYHm5hf6RNgD/k77b/
	 106TZQ5lXk0bg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 26/31] dax/bus: Tag-aware uuid claim and show on DC
 dax devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-27-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-27-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:26:57 +0000
Message-Id: <20260625182658.45CBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Retaining pointers to `dax_resource` in `dev_dax` ranges without h=
olding a driver-core reference on the underlying extent device risks a Use-=
After-Free.
- [High] The error rollback path in `uuid_claim_tagged()` leaks DAX mapping=
 devres actions, leading to Use-After-Free on device teardown.
- [High] The sequence validation in `uuid_claim_tagged()` fails to detect m=
issing trailing extents, silently carving a partial allocation.
- [Medium] Modifying device capacity via `uuid_store` bypasses the check fo=
r bound drivers, leading to driver state inconsistency.
- [Medium] The `align` attribute is silently made read-only on dynamic DAX =
regions, preventing userspace from configuring huge page alignments.
- [Medium] `uuid_claim_untagged()` may falsely fail with `-EINVAL` if the f=
irst discovered untagged extent is unaligned.
--

commit cde0cc72c8f92d08e5dfa29000813bc5b9c53109
Author: Anisa Su <anisa.su887@gmail.com>

dax/bus: Tag-aware uuid claim and show on DC dax devices

This patch introduces userspace claim semantics to resolve tagged groups
into DAX devices on DC DAX regions. It populates a seed device with zero
size, and allows capacity to be claimed by writing to the uuid sysfs
attribute, expanding the size or consuming an untagged resource.

> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index f086ad27d5077..d94c0853af105 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1100,6 +1101,9 @@ static int alloc_dev_dax_range(struct resource *par=
ent, struct dev_dax *dev_dax,
>  		},
>  		.dax_resource =3D dax_resource,
>  	};
> +	/* Pin the extent for this range; trim_dev_dax_range() drops it. */
> +	if (dax_resource)
> +		dax_resource->use_cnt++;

[Severity: High]
Does this code risk a use-after-free if the underlying extent device is
removed?

alloc_dev_dax_range() pins the extent by incrementing use_cnt, but it does
not appear to secure a reference to the underlying extent_dev via
get_device(). If the parent CXL device is hot-unplugged, the core driver
model will unregister and free the child extent devices and their
dax_resource data.

Later, when the dev_dax device is destroyed, trim_dev_dax_range() would
dereference the freed dax_resource to decrement use_cnt.

[ ... ]

> @@ -1595,13 +1682,178 @@ static DEVICE_ATTR_RO(numa_node);
>  static ssize_t uuid_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
[ ... ]
> +static ssize_t uuid_claim_untagged(struct dax_region *dax_region,
> +				   struct dev_dax *dev_dax)
> +{
> +	struct dax_uuid_match match =3D {
> +		.dax_region =3D dax_region,
> +		.uuid =3D &uuid_null,
> +	};
> +	struct dax_resource *dax_resource;
> +	resource_size_t to_alloc;
> +	struct device *extent_dev;
> +	ssize_t alloc;
> +
> +	extent_dev =3D device_find_child(dax_region->dev, &match,
> +				       find_uuid_extent);
> +	if (!extent_dev)
> +		return -ENOENT;
> +
> +	dax_resource =3D dev_get_drvdata(extent_dev);
> +	to_alloc =3D resource_size(dax_resource->res);
> +	if (!alloc_is_aligned(dev_dax, to_alloc)) {
> +		put_device(extent_dev);
> +		return -EINVAL;
> +	}

[Severity: Medium]
Will this falsely fail if the very first untagged extent found happens to
be unaligned?

Since device_find_child() only returns the first matching extent, returning
-EINVAL here stops the claim entirely instead of iterating to check if
there is another untagged extent available that is properly aligned.

[ ... ]

> +static ssize_t uuid_claim_tagged(struct dax_region *dax_region,
> +				 struct dev_dax *dev_dax, const uuid_t *uuid)
> +{
[ ... ]
> +	/*
> +	 * Tagged groups carry a dense 0..n-1 @seq_num regardless of source =E2=
=80=94
> +	 * the device-stamped shared_extn_seq (already 0..n-1) for a sharable
> +	 * partition, or cxl-side arrival order for a non-sharable one (see
> +	 * &struct dax_resource).  A gap or out-of-range value here means an
> +	 * extent went missing on the cxl side (e.g. a per-extent failure in
> +	 * cxl_add_pending) or a cxl-side validation gap; in either case
> +	 * refuse the whole group rather than carve a partial allocation.
> +	 */
> +	for (i =3D 0; i < c.count; i++) {
> +		if (c.arr[i]->seq_num !=3D i) {
> +			dev_WARN_ONCE(dax_region->dev, 1,
> +				"tag %pUb seq invariant violated at slot %u (got %u)\n",
> +				uuid, i, c.arr[i]->seq_num);
> +			rc =3D -EINVAL;
> +			goto out;
> +		}
> +	}

[Severity: High]
Does this validation loop miss missing trailing extents?

The loop only checks up to c.count. If a group is expected to have 4
extents, but only the first 2 (seq_num 0 and 1) were collected, the loop
will successfully validate them.

This seems to violate the all-or-nothing allocation invariant mentioned in
the comment, silently carving a partial allocation and permanently orphaning
the remaining extents since a device cannot be appended to once claimed.

[ ... ]

> +rollback:
> +	/*
> +	 * Partial failure: trim every range we added in this attempt.
> +	 * trim_dev_dax_range pops the most-recently-appended range from
> +	 * dev_dax->ranges[] and decrements its dax_resource->use_cnt, so
> +	 * looping until we have undone @i additions restores both
> +	 * dev_dax->ranges[] and the matched dax_resources' use_cnt.
> +	 */
> +	while (i-- > 0)
> +		trim_dev_dax_range(dev_dax);
> +out:
> +	kfree(c.arr);
> +	return rc;
> +}

[Severity: High]
Does this error rollback leak devm mapping actions?

During a successful allocation, alloc_dev_dax_range() calls
devm_register_dax_mapping() which attaches an unregister_dax_mapping devres
action.

When trim_dev_dax_range() pops the ranges, it does not seem to call
devm_release_action() to clean up the attached actions. When the dev_dax
device is eventually destroyed, these leaked actions would execute and atte=
mpt
to unregister mappings using array indices that no longer exist, leading to
an out-of-bounds dereference on the freed dev_dax->ranges array.

>  static ssize_t uuid_store(struct device *dev, struct device_attribute *a=
ttr,
>  			  const char *buf, size_t len)
>  {
[ ... ]
> +	ACQUIRE(rwsem_write_kill, dev_rwsem)(&dax_dev_rwsem);
> +	if ((rc =3D ACQUIRE_ERR(rwsem_write_kill, &dev_rwsem)))
> +		return rc;
> +
> +	/* A claimed device already has capacity; do not overwrite its uuid. */
> +	if (dev_dax_size(dev_dax))
> +		return -EBUSY;

[Severity: Medium]
Should this also check if a driver is actively bound to the device?

If userspace binds a driver to this 0-sized device before writing to the
uuid attribute, this bypasses the check. Failing to check
if (dev_dax->dev.driver) allows the capacity to change while a driver is
already bound, which breaks the contract enforced in size_store().

[ ... ]

> @@ -1661,8 +1913,12 @@ static umode_t dev_dax_visible(struct kobject *kob=
j, struct attribute *a, int n)
>  		return 0;
>  	if (a =3D=3D &dev_attr_mapping.attr && is_dynamic(dax_region))
>  		return 0;
> -	if ((a =3D=3D &dev_attr_align.attr ||
> -	     a =3D=3D &dev_attr_size.attr) && is_static(dax_region))
> +	if (a =3D=3D &dev_attr_uuid.attr && !is_dynamic(dax_region))
> +		return 0444;
> +	if (a =3D=3D &dev_attr_align.attr &&
> +	    (is_static(dax_region) || is_dynamic(dax_region)))
> +		return 0444;

[Severity: Medium]
Does this unintentionally prevent configuring alignment for dynamic regions?

By forcing the align attribute to be read-only (0444) for dynamic regions,
userspace cannot configure huge page alignments (like 2MB or 1GB) for DC
DAX devices before they are claimed.

> +	if (a =3D=3D &dev_attr_size.attr && is_static(dax_region))
>  		return 0444;
>  	return a->mode;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D26
