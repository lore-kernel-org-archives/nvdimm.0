Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAA338936;
	Sun, 12 Jul 2026 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871544; cv=none; b=lIEhlqF1oR/zFX53SpIJQjv/V1FmWE5nmCJLnYE8n2VtIwkY3Ec7pmncSYn4WS+Fi80pRjLglcMZE53eoDXskui85SNUbfTzgviKmNRdejrSgyrHmU5Z1hEsTZ/Wm2uWY45L/Tk32apjEjcKAWN/VuYzBIQfWKaAttjd7Xc9juU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871544; c=relaxed/simple;
	bh=whrKSmbAuyo68zzKi/h/PLcVvfwVPtIHyUj1JlWtb9I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Co+FWU/lSOvOBwawbi6zWUoVI1tij3aoEJJtziCzYNYG3OSQEn5QxCZmzEnjlpNVYsPNXGg+lI41qYrIZtH42BYAk37HDojCg4d+4P6T1FFgcg1ZLQUop/p0YckBg6qXKux9owHGw0YqIlLZCKS15Ld7BWKTHCQElSpbFrOgZAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBXmGkfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBXmGkfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623051F000E9;
	Sun, 12 Jul 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783871542;
	bh=AM1WGCLEgJNmhSGRbx5MRs1fFF/iCnx+mEzqLj5Ocxc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jBXmGkfM8fe/mrbB+BB2Hh+4chVoEveltDY/l9lIjON0DhDiSMjZ5rG9G38pDXWj7
	 kixxiMXK+XCFgSRSV9bSGGmTAp6Fg9S8l7z9fApmLd/1WCFssOEJ0dXoh+R3weJaGn
	 9iHUAMXoq+IfHwmey0Hl57WIitxY9OQfpdA0jKPiAZaL3KnhF93/FoeaWVpEMQKJ/w
	 y/Qlp114F0N9RarF6jyNeElOlWyM7GbCUT92DXmEVv0B7azrMlNDizRTHTMuEVbUWB
	 h8wVnTM0Kj+clHfzfCd1WYNkxoA6evct2F9BJ5c+wv2/MqZdWIv89n4+tLHrwlioON
	 65H17Cmg3bPkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 01/10] mm/memory: add memory_block_aligned_range()
 helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260712154505.3564379-2-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
 <20260712154505.3564379-2-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 12 Jul 2026 15:52:21 +0000
Message-Id: <20260712155222.623051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Integer overflow in `memory_block_aligned_range` when `range->en=
d =3D=3D U64_MAX` incorrectly truncates valid memory ranges.
--

--- Patch [1]: [PATCH v7 01/10] mm/memory: add memory_block_aligned_range()=
 helper ---
commit 1d936debbb2e5198011a220a96cf6a3dc9882748
Author: Gregory Price <gourry@gourry.net>

mm/memory: add memory_block_aligned_range() helper

This commit introduces memory_block_aligned_range() in <linux/memory.h> to
align ranges to memory block boundaries for memory hotplug operations. It a=
lso
updates the dax/kmem driver to use this new generic helper.

> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 463dc02f6cff0..1783299073e47 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
[ ... ]
> @@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_=
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
> +	aligned.end =3D ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
> +	/* No whole block fits (e.g. range below the first boundary): empty. */
> +	if (aligned.end <=3D aligned.start)
> +		aligned.start =3D aligned.end;

[Severity: Medium]
Does this overflow if range->end is U64_MAX?

If range->end is U64_MAX, range->end + 1 will wrap around to 0. This makes
ALIGN_DOWN(0, ...) return 0.

Since aligned.end is now 0, the condition aligned.end <=3D aligned.start
evaluates to true. This would incorrectly report a valid range spanning to
the end of the 64-bit address space as an empty range.

Is there a way to handle the U64_MAX upper bound safely to avoid truncating
the range?

> +	else
> +		aligned.end -=3D 1;
> +
> +	return aligned;
> +}
> +
>  struct memory_notify {
>  	unsigned long start_pfn;
>  	unsigned long nr_pages;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260712154505.3564=
379-1-gourry@gourry.net?part=3D1
