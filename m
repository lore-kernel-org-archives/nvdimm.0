Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC5D2264AB;
	Fri, 16 Oct 2026 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156959; cv=none; b=jsEDKPpBYOCdcuSGJBtWkMqvTVhIaQEtQbnXa1q3Fdk+X2uSX8ptnAB/5XFP134bhDz5V8ZU/bfT16qRwT6HdctIjgbsFwzHq8tEYQ/6aj0WladnJfSBEoCglrhW4HxQV35tOuZNnfQ385goETtSfF1bdPi59AetP/8GwHsGiQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156959; c=relaxed/simple;
	bh=n57jUUESL8rbpvAwZfbAG2oYwVwQ4pxz5uklQTRgj4s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ebLootPRXmYbwvlvW5XYyNM7VoupJJOwKnyzZvHSaTL0c9M0h53zBQ/pp+Ad+HvfR7jl2xIk9b8ybFEC+N6FxyAZD2KvA8QwG9UCV7zE9XC9LTl9X3NNfG6WP8Kkyw9qGNLIXcRqVFz4lkUyq1N+Il2FZBE1gciMgJJz8qTvDyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCoqQ1N7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCoqQ1N7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260D91F000C4;
	Fri, 16 Oct 2026 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792156958;
	bh=vS/NsIBEq72uHRm4BOGenztWrETTm66l5nHrtUTnqDM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bCoqQ1N750MGBDv1kjNG62WX6gYty3hg+jP+VT++JKC8BnwIYHM3SbsSo0khlOFcZ
	 cO6CSJAqZatdUm+IAZTqWodqgknMzjQIlugmePDJT2shtBlBK+VS5SCuVayeezAM0X
	 tdq1e6XxS3Fm6QwlYJSAJYOHQ8z8J6CFj3YGjT904Jxl/AxdcvY5aFEU4Qxw4sVq9D
	 WhJWNJzl3G1dyIfVLpcH1DhIHjqJX5A14dM7JfJ4nezp5YIhDX7qIR+gDQOaNjiu2q
	 HRZcxn8bTnooEjW2vuxny+1oCrs+xvNI+RKUJqLHzAgpSiLQ3CFMHnQKxVM3MqHDif
	 RojYvrJtiIAbg==
Message-ID: <sashiko-outbox-174381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: warn on unaligned compound zone device ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20261016131334.3419393-1-songmuchun@bytedance.com>
References: <20261016131334.3419393-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 13:22:37 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: out-of-bounds struct page write due to unhandled unaligned ran=
ge
--

commit b8dd4e5f7a50b091c065c7673c2a6a148529465a
Author: Muchun Song <muchun.song@linux.dev>

mm: warn on unaligned compound zone device ranges

A compound page of order N must start at a PFN aligned to 2^N pages.
Therefore, a range used to initialize compound pages must start on a
compound-page boundary and contain an integral number of compound pages.

Link: https://lore.kernel.org/r/20261016053944.2579541-1-songmuchun@bytedan=
ce.com
Link: https://lore.kernel.org/r/20261016054914.2601510-1-songmuchun@bytedan=
ce.com

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 4c17a892924d2..01ced0553ce9b 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone *zon=
e,
>  	if (!nr_pages)
>  		return;
> =20
> +	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
> +

[Severity: High]
This warning detects the unaligned range, but does this still allow an
out-of-bounds write if execution continues?

If nr_pages is not a multiple of pfns_per_compound, the main initialization
loop in memmap_init_zone_device() advances by pfns_per_compound chunks:

	for (; pfn < end_pfn; pfn +=3D pfns_per_compound) {
		...
		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
				     compound_nr_pages(pfn, pgmap));
	}

And memmap_init_compound() will then write exactly pfns_per_compound entries
(since compound_nr_pages() returns pfns_per_compound), ignoring the actual
end of the zone-device range:

	for (pfn =3D head_pfn + 2; pfn < end_pfn; pfn++)
		zone_device_page_init_from_template(pfn_to_page(pfn), ...);

Could this overrun the allocated range and corrupt adjacent struct pages?

Additionally, since VM_WARN_ON is compiled out without CONFIG_DEBUG_VM,
could this result in silent memory corruption on production kernels?

Should we abort the initialization when an unaligned range is detected?

>  	/*
>  	 * Seed the reusable head-page template from the first real struct
>  	 * page. The normal page-init and refcount helpers must operate on

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016131334.3419=
393-1-songmuchun@bytedance.com?part=3D1
