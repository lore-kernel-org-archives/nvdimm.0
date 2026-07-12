Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75492CA52;
	Sun, 12 Jul 2026 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871652; cv=none; b=NT5hqKbuK6VXaxn/2B8v7LhDWJ8Be4qeKds6ibWU1s0ifrmAyKxpfBfPOJ9/DSQj2pC9uE8vwGb9ifIvrFaV4d0HgPtHMY5BIh5u8NWwoMd8fyx5xNxaIt15BeL7n5uicl3FFk0pOLEhevhr7qqfhtpO4LuPt6zYwr/XOHHFpWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871652; c=relaxed/simple;
	bh=BlTatt9egHAQadwzVtYu0PSFfI6hzoL07CO0YeS5/nU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XXhQmfxGR0LjfNEN7Ai55nPT4hl/MH/xyslP3RH+QcBN9L9GNN2qKcxlJgwM3w4/Llp6NHZXxyYtX49gsJoVfvKcRSYQnkct1SMSN1TdtkMQDLNG4J4P5oIhDRSOU2qb4ElWXt5GYWEhYylN6fHkrYE4GoslcOmPaa/OVLvx2Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHkOnok2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHkOnok2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D391F000E9;
	Sun, 12 Jul 2026 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871651;
	bh=9n0+ig0ScLFSWCBS+wNeJlwOegb+Bib0PT8HEmiicn0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHkOnok2qjdb9ZOe6rP7ETJoVj/5K2SnpLGJSxWBA6LNFEWtJ26JWrOKwlPxWRbjs
	 eisNll8YA+f2Aeg3sA4vhgCVhMvAfud9mxeS4FwrUyiqvGBKS8fNGiNHX5sicwS4j2
	 GilNrMQMInw2Z30UbYSNZCSe8ieSoR0iXYOPqghDERs3O3Ts3gU3ioGzieCMn2XRlD
	 DZHP2qWiiipjYCY5RZMcISqSIbljlus6YoSASec1hX6QUAiImW1Aw4SHYl85V3YZ0F
	 b1Slty6OqTKJB/4KPjTOiCJnAlSP6h6Zg3asXDUX4SmzTj9dEvU1F88CYdjV7vvprE
	 qOqEtr4NZ1gng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 08/10] dax/kmem: extract hotplug/hotremove helper
 functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260712154505.3564379-9-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-9-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:54:10 +0000
Message-Id: <20260712155411.00D391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If a DAX device has multiple ranges and at least one is too small =
to be aligned, removing the device will unconditionally leak driver data an=
d memory group registrations.
--

--- Patch [8]: [PATCH v7 08/10] dax/kmem: extract hotplug/hotremove helper =
functions ---
commit 44ad562618b0448a09ed81ab105fa4c8551b6718
Author: Gregory Price <gourry@gourry.net>

dax/kmem: extract hotplug/hotremove helper functions

Refactor kmem _probe() _remove() by extracting init, cleanup, hotplug,
and hot-remove logic into separate helper functions. This splits the
hotplug and init phases to have resources available for hot-add, while
enabling future granular hotplug operation control.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 38ed5c4e9c83d..6174f7d3d05bd 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c

[ ... ]

> +static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
> +				 struct dax_kmem_data *data)
> +{
> +	struct device *dev =3D &dev_dax->dev;
> +	int i, success =3D 0;
> +
> +	for (i =3D 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +		int rc;
> +
> +		rc =3D dax_kmem_range(dev_dax, i, &range);
> +		if (rc)
> +			continue;
> +
> +		/* range was never added during probe, count as removed */
> +		if (!data->res[i]) {
> +			success++;
> +			continue;
> +		}
> +
> +		rc =3D remove_memory(range.start, range_len(&range));
> +		if (rc =3D=3D 0) {
> +			/* Release the resource for the successfully removed range */
> +			remove_resource(data->res[i]);
> +			kfree(data->res[i]);
> +			data->res[i] =3D NULL;
> +			success++;
> +			continue;
> +		}
> +		any_hotremove_failed =3D true;
> +		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
> +			i, range.start, range.end);
> +	}
> +
> +	return success;
> +}

[ ... ]

> @@ -208,7 +354,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  #ifdef CONFIG_MEMORY_HOTREMOVE
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> -	int i, success =3D 0;
> +	int success;
>  	int node =3D dev_dax->target_node;
>  	struct device *dev =3D &dev_dax->dev;
>  	struct dax_kmem_data *data =3D dev_get_drvdata(dev);
> @@ -219,48 +365,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev=
_dax)
>  	 * there is no way to hotremove this memory until reboot because device
>  	 * unbind will succeed even if we return failure.
>  	 */
> -	for (i =3D 0; i < dev_dax->nr_range; i++) {
> -		struct range range;
> -		int rc;
> -
> -		rc =3D dax_kmem_range(dev_dax, i, &range);
> -		if (rc)
> -			continue;
> -
> -		/* range was never added during probe */
> -		if (!data->res[i]) {
> -			success++;
> -			continue;
> -		}
> -
> -		rc =3D remove_memory(range.start, range_len(&range));
> -		if (rc =3D=3D 0) {
> -			remove_resource(data->res[i]);
> -			kfree(data->res[i]);
> -			data->res[i] =3D NULL;
> -			success++;
> -			continue;
> -		}
> -		any_hotremove_failed =3D true;
> -		dev_err(dev,
> -			"mapping%d: %#llx-%#llx cannot be hotremoved until the next reboot\n",
> -				i, range.start, range.end);
> +	success =3D dax_kmem_do_hotremove(dev_dax, data);
> +	if (success < dev_dax->nr_range) {
> +		dev_err(dev, "Hotplug regions stuck online until reboot\n");
> +		return;
>  	}

[Severity: High]
This is a pre-existing issue, but does this logic handle unaligned ranges
correctly during device unbind?

If a DAX device is created with a memory range smaller than the block
alignment, dax_kmem_range() returns an error (like -ENOSPC) during probe,
but the device can still probe successfully.

During removal, dax_kmem_do_hotremove() will also get an error from
dax_kmem_range() for that small range and skip incrementing the success
counter.

This causes success to evaluate as strictly less than dev_dax->nr_range,
resulting in an early return here.

Since device unbind can be triggered from userspace, does this early return
unconditionally leak the memory group registrations, device name string,
and driver data on every unbind for devices with unaligned ranges?

> =20
> -	if (success >=3D dev_dax->nr_range) {
> -		memory_group_unregister(data->mgid);
> -		kfree(data->res_name);
> -		kfree(data);
> -		dev_set_drvdata(dev, NULL);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D8
