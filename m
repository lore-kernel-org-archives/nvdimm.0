Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AF9388876
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 02:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791599055; cv=none; b=bkjrvfXbb7D3jYp3rPQk3X5vOhKIoxffTRcnf5Lilds4yGqmPtd3J3miXSgLqnKSC1waB0s4+mC0hVMl/hvH1vELNtgYHDzEt061oGwcRuckEMufC4b4mmZaWJ0uLTCXsP+/wR/D7zHkClgra0YHHQuemGVW7D4fNtdimZCnO2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791599055; c=relaxed/simple;
	bh=P9l6dNY6XnpCDGBLUqXroeoyvf1IEbHnIqYP5FzVSPk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OJhK/s/qR6l/D2FDx+GJgOrGUbc2+hRamQ/D5uHDfo0OCRgLs5ZpYfrVWXxy2lR3sERmK6Ics2Vf1nW5tlli0359ov40JmswVW3SssquWJxnCKw/ot9MrZ9d3iTPVB1Yw1rL+jmk6UL0rF05b4ln9aCs/8MCHKJ3bvobFJsAsFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ8R+LCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ8R+LCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB0A1F000FF;
	Sat, 10 Oct 2026 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791599054;
	bh=mvjRzoGiNsVe+Ut8ZCS1kmaXSPNY38TqQhTL+rVYChs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EZ8R+LCuX9F6lZzPB6araFKKJknd5Z0WaVmv7/9GG7j2aAfd9JN+qqVkSfL78ctsZ
	 i9fj/1ZbusVqfUoPtvKUOyxqKrYgcXe5udDZ3HncAjltG8FEuOW4CS4DYEKL1asJhT
	 0HslTjbR46X4ltxEsAYZgYaqkuwa37P5YMmm0Mb5WeR1oPxGnDIKv5XTnMaOGYi/EA
	 lPKf3JQsX8EuiOZ/9bny02WY6VdK2j++I8xdw4fZdqFHKWvqOt6zpgnqApHPlvNVNK
	 b+5usPa6tc+8/Dggdoi264SVgbXLzIsNVlFm9JHFPaQgwRYtWRrKbxCSocdjzJ6lZ5
	 WBuUw76S7ZH4A==
Message-ID: <sashiko-outbox-166211@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Reply-To: sashiko-reviews@lists.linux.dev
To: jianyungao89@gmail.com
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261010021010.19575-1-jianyungao89@gmail.com>
References: <20261010021010.19575-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 02:24:13 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] dax: dax_range_compare_iter() passes absolute offset instead of si=
ze
--

commit a30afa39f06e5d921895421d92a26f1823e65cbd
Author: Jianyun Gao <jianyungao89@gmail.com>

dax: fix wrong error code returned from dax_dedupe_file_range_compare()

This commit modifies dax_dedupe_file_range_compare() to return the actual
error status from dax_range_compare_iter() rather than leaking a positive
return value. This prevents vfs_dedupe_file_range() from misinterpreting
an error as a success.

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
Does returning status here expose a bug in dax_range_compare_iter()
where it passes an absolute file offset as a relative size?

Looking at dax_range_compare_iter():

fs/dax.c:dax_range_compare_iter() {
    ...
    ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SIZE=
),
                                  &saddr, NULL);
    ...
    ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SIZE=
),
                                  &daddr, NULL);
    ...
}

The third argument to dax_iomap_direct_access() is a size, but it is
passed ALIGN(pos1 + len, PAGE_SIZE) and ALIGN(pos2 + len, PAGE_SIZE),
which are absolute file offsets rounded up to the page size.

For large file offsets, this requests a massive access size. The underlying
dax_direct_access() call computes nr_pages =3D PHYS_PFN(size), translating
the absolute offset into a huge page count.

This will overflow a 32-bit unsigned int for offsets >=3D 2TB. Additionally,
driver-level bad block scans like __pmem_direct_access() will iterate over
this massively inflated range.

If any hardware poison exists anywhere in the remainder of the device,
it can spuriously return -EHWPOISON. By propagating this error status to
userspace, will this cause deduplication to spuriously fail?

>  		src_iter.status =3D dst_iter.status =3D status;
>  	}
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010021010.1957=
5-1-jianyungao89@gmail.com?part=3D1
