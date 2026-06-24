Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2716F3DB332;
	Wed, 24 Jun 2026 15:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313714; cv=none; b=Cyn3AAwtCegUM0whc5WZ55gwVXkwdutiDchgYJ+yU8hJfTRR3XI2CkalOk7rgK7LZ8ow+YJp0ezi4nmCLlYi6pzVdPlU/jJO15/4fTcJAXhzQv2kxZotC3GGxcCwjH4+AjKm4jhyzORvm3Pn6ZieZIIxFnxD07hpmtNT5o2D3mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313714; c=relaxed/simple;
	bh=emGGf4QTkQS7nVeXMTrukNn51b3SE9d2sIVCALvxxp0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o/DbtGqZIpvKmKVkddpRTAMdc/xL61Ok1Hmjg1zDPhggxruSuuOnToV9y416t1pJWf3mM6KoN4+bRnIOiPS78UfhfruvUkIU2ablY5tuRytAnaLy9ziYPWHdieywTGF0Cxla3IIaYv6SP6kHLMXVfVbHMigzj7IITbjQIapJjPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVadAMav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVadAMav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE15F1F000E9;
	Wed, 24 Jun 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313712;
	bh=vSzx+C4yhPV80wdSya0nsc4cxaMvWNegCrxAgtF7yNQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LVadAMavq4dT1DawEgx6zhX4QMJqXHERSEd0lKYyzgjpEnm2p9MAhapXM9jB4DrTg
	 6JHCZxZ1fzLEwWu2iST6QG84tq3DS30kyr3fwAKKLpkz20+dU8Y01rpsGVEzzjhJEk
	 9tg+CV7AWiBiQDgR6gVMhHMbHK41FnlEt7gHeSJtOircZojZV5rfM2Ws0M5sKl8hjW
	 zLDfHsUbeZI217kErdGOTY3dBcrRDDm3qWYSozpGi8iJFwtWOhf15y7f6h04SQxmLu
	 /MWwK5FMpH4h+Rn3XFf3T+FA4VsG8dGkK/eEcYGcjvDpQrLtJoWQKixQYR0+oCLTu+
	 ipwesJ4UsmyxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/9] mm/memory: add memory_block_aligned_range()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624145744.3532049-2-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-2-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:08:31 +0000
Message-Id: <20260624150832.AE15F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but elevating the ma=
th into a generic helper codifies a vulnerability: boundary calculations in=
 `memory_block_aligned_range()` can mathematically underflow or overflow, b=
ypassing the recommended validity check and producing massive invalid range=
s.
--

commit 6ed2cd40240e54e5a9638798bd15e535e425a3da
Author: Gregory Price <gourry@gourry.net>

mm/memory: add memory_block_aligned_range() helper

Memory hotplug operations require ranges aligned to memory block
boundaries. This is a generic operation for hotplug. Add
memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries. Update dax/kmem to use this helper.

> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index a18e2b968e4da..592171ec10f49 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
[ ... ]
> @@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int =
i, struct range *r)
>  	struct dev_dax_range *dax_range =3D &dev_dax->ranges[i];
>  	struct range *range =3D &dax_range->range;
> =20
> -	/* memory-block align the hotplug range */
> -	r->start =3D ALIGN(range->start, memory_block_size_bytes());
> -	r->end =3D ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
> +	*r =3D memory_block_aligned_range(range);
>  	if (r->start >=3D r->end) {
>  		r->start =3D range->start;
>  		r->end =3D range->end;

[ ... ]

> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 463dc02f6cff0..9f5ef0309f773 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
[ ... ]
> @@ -100,6 +101,27 @@ int arch_get_memory_phys_device(unsigned long start_=
pfn);
>  unsigned long memory_block_size_bytes(void);
>  int set_memory_block_size_order(unsigned int order);
> =20
> +/**
> + * memory_block_aligned_range - align a physical address range to memory=
 blocks
> + * @range: the input range to align
> + *
> + * Aligns the start address up and the end address down to memory block
> + * boundaries. This is required for memory hotplug operations which must
> + * operate on memory-block aligned ranges.
> + *
> + * Returns the aligned range. Callers should check that the returned
> + * range is valid (aligned.start < aligned.end) before using it.
> + */
> +static inline struct range memory_block_aligned_range(const struct range=
 *range)
> +{
> +	struct range aligned;
> +
> +	aligned.start =3D ALIGN(range->start, memory_block_size_bytes());
> +	aligned.end =3D ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) -=
 1;

[Severity: High]
This isn't a bug introduced by this patch, but elevating the math into a
generic helper codifies an issue. Could this boundary calculation underflow
and produce massive invalid ranges?

If a caller provides an unaligned physical address range that falls entirely
before the first memory block boundary, for example when
range->end + 1 < memory_block_size_bytes(), the ALIGN_DOWN calculation
evaluates to 0.

Subtracting 1 then causes aligned.end to underflow to U64_MAX.

While it is physically unlikely for a DAX device to be located below 128MB,
an edge case near physical address 0 triggers this underflow.

When this happens, the invalid range check in dax_kmem_range() is bypassed:

drivers/dax/kmem.c:dax_kmem_range() {
    ...
    *r =3D memory_block_aligned_range(range);
    if (r->start >=3D r->end) {
    ...
}

Because r->end evaluates to U64_MAX and aligned.start aligns up to 128MB
(if range->start > 0), the check 128MB >=3D U64_MAX is false. This incorrec=
tly
signals the empty range as valid and aligned.

In contrast, an empty range in a higher memory block correctly fails this
check.

If this underflowed range is then passed to hotplug APIs like
__add_memory_driver_managed(), could it cause an immediate OOM and kernel
crash as the system attempts to allocate tracking structures for millions of
memory blocks?

> +
> +	return aligned;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D1
