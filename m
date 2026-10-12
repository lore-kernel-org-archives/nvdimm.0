Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35743494835
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817721; cv=none; b=BfIOZWs9FvyulOMkZVmclNvZEPZUNpbp+8TJJNS7+HRa13pzXg1EsgmVcFP9Fr5YGhVohlm1CwPS1MjFZlFP8JPu9BgmjMzi6f0c1UOsRPy6BDs/bxMyEDqBgm8/lLPkIlnhPllMvF9jx+/L2F6Jg4Wp8j8De6mSe8mDV77THwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817721; c=relaxed/simple;
	bh=GZ4/N7BpuAqWtlibc9utNn5U8/mRBLuZ5mPqbpe80sE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bQLuvPPi6Lji6PzokwBbKlDIfo21MTgAKrLrDPp4ef4AbnlRL5gwCP+qfviejfnZ/syepGCdhis/a518mZKp2cPK5jDkODSoq1CyYJUnvqaJJDab5w2ck2W0C5cbb/zvyRHU44rgc4Z0fLsD5BC8bvX/7ZOJBb5lYCcdemLWzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkm0suwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkm0suwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3061F0089C;
	Mon, 12 Oct 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817720;
	bh=99VQ5XdFKKFbg556oICFeoGOoXJXkG3e4IoUptp718U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jkm0suwPd3FhgU06F1vy7Jj36Xgns2XFWDz0nQMfxbQYCS85xRAKlK+1O5mByHL2K
	 KEllZQiKOvfIQiuSJmIFOwZRbH2WsM9tTFtk+zX1/W6/fB0fWLM+dMo3hNxsDsXpdx
	 YKy6ZUc58wkGZYs9nRS0MiBrPq731jLHEeNdl5KLuWI2BFwbi26YEY/y5mBjsZGuQ0
	 Sp6XqdW3hctVnqKlVZLIFxG6x+D36leoK8VuYVq4cVXiYYt4fpi+IwTAUwAUxh3B2T
	 G1XLd4R0+8mdmPuW1GYDvbcoYw4w3VlT1wy7lxoaZgKVcjvn1q3oO5ScCNttst+BKO
	 0CdN7xry1tOyQ==
Message-ID: <sashiko-outbox-168318@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Reply-To: sashiko-reviews@lists.linux.dev
To: jianyungao89@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261012144925.6728-1-jianyungao89@gmail.com>
References: <20261012144925.6728-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 15:08:39 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fs/dax: out-of-bounds length and size calculations in dax_range_co=
mpare_iter()
--

commit 01ad9c7e5da5c800a76808134a31ff80911b589c
Author: Jianyun Gao <jianyungao89@gmail.com>

dax: fix wrong error code returned from dax_dedupe_file_range_compare()

When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
dax_dedupe_file_range_compare() incorrectly returns ret which holds the
positive return value from iomap_iter() indicating more iterations remain.
This positive value leaks to the caller, where vfs_dedupe_file_range()
interprets it as success, causing userspace to incorrectly believe
deduplication completed.

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
Does propagating this error code expose latent out-of-bounds calculations in
dax_range_compare_iter()?

Inside dax_range_compare_iter(), the length is incorrectly clamped using the
total extent length rather than the remaining mapped length:

fs/dax.c:dax_range_compare_iter() {
	...
	len =3D min(len, min(smap->length, dmap->length));
	...
}

If the file offset is inside the extent and the requested length is large, =
len
will exceed the valid remaining mapped length. This directly triggers a
WARN_ON_ONCE(count > iomap_length(iter)) in iomap_iter_advance() and aborts
with -EIO.

Additionally, when calling dax_iomap_direct_access(), the size calculation
uses the absolute file offset instead of a page offset:

fs/dax.c:dax_range_compare_iter() {
	...
	ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE),
				      &saddr, NULL);
	...
}

Since pos1 is an absolute file offset, for large file offsets this massive
size exceeds the physical device bounds, causing dax_iomap_direct_access()
to fail with -EINVAL.

Now that the error code is correctly propagated, will these calculations
actively cause dedupe operations to fail?

>  		src_iter.status =3D dst_iter.status =3D status;
>  	}
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012144925.6728=
-1-jianyungao89@gmail.com?part=3D1
