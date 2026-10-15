Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D103CB8E9
	for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075986; cv=none; b=SVtqe9HgXqTC4Ml+XZ9w8y5yWh80ZEssRSUP061mfC6zjutZph2jSydZX4ZAr3KPQOYbZ2gao1jjrBGGu7A7rxHMvFfNk1KMseToO82uYfKCEItCo/ElSWZK69ozlzGpLxC2nWQx++2xFAaK2dPIGKvrFYqvd6yNc8kQ+ruhJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075986; c=relaxed/simple;
	bh=+y5oqsfBENvs7sW9Am8tScxjKqjlgi/PpVXdGuDeIqI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=IAn1O2OfW9VEI+XvY/QlRPjOyFSciiXbuG2mClWzUWYOniwIwqBd0+Xvzjeus8JpvkpFcGE1Lsxsqd13CqV2qdCGEcnavDXseE79YqVy1zYGdeYcQB5hTHZiCeo1inpcnoQPAfHnj9M7oO1A3lpQMwxE1Y0g4J6NzOz6xlO9fxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzy3K0Ui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzy3K0Ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E151F000C5;
	Thu, 15 Oct 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075985;
	bh=HWZK0V23t9iCaT+SKTwfGa0hheoXemXSvI3AUtbQ04E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mzy3K0UiKytTwKWH6HLYfDvHETzNMTCinYRTS5eJiaIqS4MB6JE2s554wpFfbhDBh
	 6tf/u7dEUo0N+oo3mRxkFvdPBJtg/s3knw44hI39X6o5/ZO8F+akmj8Kl3xg1LeQXt
	 8fawe242F8u37QvjtSAwQOFDTYHeddux7Y68fFklKkjKGZA7+QkQ2+r27dKuBhKNkT
	 Yuw6tiDfeQ3a644uQ6rDnTl2Q/IAJ3Xcf2R0oFo0InVkUrC89T37fgTJNQVOAfQxrP
	 PJdSxuJ83Cz9IQhZ0AturrDoJLlP8k0cA1+4OAQsj1yAW0PyZSd5+4aTPBPPw+nKVl
	 uUQ5O6gzZyoTQ==
Message-ID: <sashiko-outbox-173003@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Reply-To: sashiko-reviews@lists.linux.dev
To: jianyungao89@gmail.com
Cc: =?utf-8?b?b3BlbiBsaXN0OkZJTEVTWVNURU0gRElSRUNUIEFDQ0VTUyAoREFYKQ==?= <nvdimm@lists.linux.dev>
In-Reply-To: <20261015143426.17620-1-jianyungao89@gmail.com>
References: <20261015143426.17620-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 14:53:04 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fsdax: incorrect size parameter in dax_range_compare_iter causes m=
assive direct access requests
--

commit 65ff21563702a9036c338f4961a061d5c576d038
Author: Jianyun Gao <jianyungao89@gmail.com>

dax: fix wrong error code returned from dax_dedupe_file_range_compare()

This commit fixes a bug in dax_dedupe_file_range_compare() where a positive
return value was incorrectly propagated on failure. It now correctly returns
the negative error code from dax_range_compare_iter().

Link: https://lore.kernel.org/lkml/20261012144925.6728-1-jianyungao89@gmail=
.com/

> diff --git a/fs/dax.c b/fs/dax.c
> index 08adeaed2baf1..97b6212bfa898 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -2254,7 +2254,7 @@ int dax_dedupe_file_range_compare(struct inode *src=
, loff_t srcoff,
>  		status =3D dax_range_compare_iter(&src_iter, &dst_iter,
>  				min(src_iter.len, dst_iter.len), same);
>  		if (status < 0)
> -			return ret;
> +			return status;

[Severity: High]
By correctly propagating the error code here, does this patch now expose a
bug in dax_range_compare_iter() that will break dedupe for large offsets?

Looking at dax_range_compare_iter() in fs/dax.c, it appears to pass an
absolute end offset instead of a length as the size parameter to
dax_iomap_direct_access():

static int dax_range_compare_iter(...)
{
	...
	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
				      &saddr, NULL);
	...
}

When dax_iomap_direct_access() receives this size parameter, it converts it
via PHYS_PFN() and interprets the massive absolute offset as a relative
length:

fs/dax.c:dax_iomap_direct_access() {
	...
	length =3D dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
				   DAX_ACCESS, kaddr, pfnp);
	...
}

This requests an out-of-bounds mapping length from the underlying block
driver (up to pos1 + len instead of just len), which typically fails with
-EINVAL or -EIO for offsets that exceed device bounds.

Since this patch changes the behavior from a silent pseudo-success to an
explicit failure, will standard deduplication at non-zero offsets now
consistently fail when dax_range_compare_iter() erroneously asks for an
enormous number of pages?

>  		src_iter.status =3D dst_iter.status =3D status;
>  	}
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015143426.1762=
0-1-jianyungao89@gmail.com?part=3D1
