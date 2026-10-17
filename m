Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA4F2741B6
	for <nvdimm@lists.linux.dev>; Sat, 17 Oct 2026 15:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252054; cv=pass; b=JcIu/M/mQV0xR6vkOtxvZ4eZ9a8GqscQ6x87qRSO9WByf3QcDTcqrBfLa7QpZgNoBZOTGnVqlzwi96/rGGLmGtZViVho31NgyljDvMbjmxJQiDrZsIlsIDM6QFe3yDgIjs9vHLEtVih3M+fyqYkL5ExAU9fdB/scssYDfRVhnF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252054; c=relaxed/simple;
	bh=FkQ9BGkZHIzSl4f7BgvwtqJKV8JaoQHfTjDdIqgPD7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kpSB7B504BZzl5Or8vj4o/mJJrriyjjAt3cOLqmNVErBDrYKWFgxzi/qxIT6sb2FLRsIHUJzQky5eIeh2sOsCcHmjNAvs8k+DGTdS3BS8BWSIzEcKMfjKH3Y8BebxiAfKMB8Uvea7z95/7j+yfiGMq1tzBmW3k4sg7bx3ZtQ2rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xs9/QiRJ; arc=pass smtp.client-ip=74.125.224.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xs9/QiRJ"
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-679b519c952so463867d50.0
        for <nvdimm@lists.linux.dev>; Sat, 17 Oct 2026 08:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792252052; cv=none;
        d=google.com; s=arc-20260327;
        b=NtiXVl9oN/WGO+4NZyt+CdIXT35bZ0GF6yOTPPgjIe6LYuQKdL7Nedaz1/R/v5Jr7H
         ziP5Be4FkiZq7hnbowOOoykJvu8lgyyVwqyAfIqoeN4FrSqdLysMHc/9dhqHeN2GR+R2
         yqBmJv5bu/4Mcrz4AIlRag/Pbr0UZjx05deDywcMjeujkyq6F54kI97YT8x3U1ql5xXG
         1tk37swjbR1ZK4gOm2s/ycVY09S4Wwwd9JajwoYCIMa5F91+cZfePOJMKOXnWDcMbcss
         sfbif4ykkONS0eINs2TXSlF2Jif27pLc488IgLvqThC8Xx49nmBog8ypQRm/zdfpQbvo
         9DuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nNQifjQfUVeridTllt8o7j6cyBjsZB7T3T0FO5TofVs=;
        fh=IuYKpnmqOzg4sYa6UvzMnXHGhbs824nW/d3eWFJPaD4=;
        b=KWlJCt15e5xyAGXHHPUY9TKAEXXCaaSsmnAR3xRaDY5nY1edc8BTfhdqrNs6RNXztC
         WcDCxI2gvOd9UZJV5ziPHf6iZapF8GFF4B2XsShwHhhVb4XHKEJ6pxBRGB7KNepWiE5a
         eaNdtLcqXBXXqo2byNU5nqH/GLZKVegdDRdsz4lDsUjuzlf+Vw/fnCT7Glc8PHRgMM68
         fFiUxNHwEgYidTMK3lvACh/D3mcyqzb9mBqblU2+8SjNIPn1lNLlS1p/oAzRo1knV103
         Az/AIcRG1IIVCOKcZl05mB+JmM5D6GCOxHiD3JfICeOFLFsj4e8m5gVH2SJbrcwhKMby
         VNWw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792252052; x=1792856852; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nNQifjQfUVeridTllt8o7j6cyBjsZB7T3T0FO5TofVs=;
        b=Xs9/QiRJsJUGDavH5HN//59YIBfN6I2dWWEND4B2xAnEow0K3cXhaY5sivyGJAxVHb
         9LYrHgAMMtiRPWhTgZima3vDjjLCO62nSJM+bwmHdROeBmQNbfD7AOvYJuvQIWpPfqj5
         nTTcsQAMbXeRTTyLABoV5/75/VXXvmWQfgkT47d+isu1/d57720C01joKDDJpY7uUaDu
         6rdQJbWZT3TqsX3wRfync/GI4+I4Bzj1GvjBqGVqUBMhDIxSzXtEafsjZmqrESdiyI6c
         8p3mg8jgZliiOHlLyqd5ZAjuE9xPvAKE6suyjLgZ7W9qM+kVzEdjG5lP+BOm49FGb1Dy
         77Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792252052; x=1792856852;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nNQifjQfUVeridTllt8o7j6cyBjsZB7T3T0FO5TofVs=;
        b=Ru/SaIysZRq4fZb+DQA4SXY2BInRWf1qHvRmUddOhA4iYlCT/mkKu8Nu6LOFeDZanP
         WKCvsDiVK4aZhjaW+5XZQtcDlo6o3/pVxtvjj2hOzATaDDeUYUqSsPvINcD2A6zoTpNT
         4BERtNNlOcmDmdPjKMKOob/Ed6BUqOj/h2VA6Avl1qe3n6cYTM7CW2Mh26xcFfp/hbOX
         zevQvLot61KsThEI8io8rf7lcpUM+i+iP7YNavjWUEDtSeNaZQbZrXlT1ojezljv5f9j
         rZUlfuT8jtVFvscEw4lO5lNBtJdjpa4UnJdsM55XxrkCPZR7aZwtcJ4sxaAJl7Peyunt
         1oPw==
X-Gm-Message-State: AFq9FYJmR36iDOfEJ2JYfXYnq7mCfP8sd5tZMbIwKc7XpeGynG9wjX4d
	2j6e8Scc8VhksYDAViJH9GVp81lV95SxrRyLbPY9oNSfRc6PiIar1hq2ojBUMwWYboKOFma00X3
	NX54cY6ys9aRr9Rr+++YGJjgZS2QJEYR7dm/uCmfwO4Pgcco=
X-Gm-Gg: AYBFou0AYCH2xbo3aUwSJjQ9FegJjLIOIHqBw1e/lSSBRyCyOc61KybD9rUGtrsm7Gx
	7TEGnNqY3zdq6BHk2I933wydw9oYjP4po6kWLPjrG00L+zpwP8y3+jXeQc5EKx8avMsLb5qN9wA
	xwadA9o59sld2NnMgTzxUiWw6o2ujFPSpN0Hi/E4VFd4eBN2g88T3syV2c5O7t1rxA+WY400mRp
	09EIjsPrxWaxcVJxmMc4G04rXPBOybhb02q9fd8sF5fsE90UBEAhaBYsjQqrIXh7f0mahEVHcpQ
	AGUM4SvizYlGW0eUrRAXvO8chk4GHeU887p82lj2UW7jje55ve+bzF5VCdylX4BHJfzYTZdy7Wq
	NCbuda4CtZ4wPnCoQGvQAUWLfBwtsXEXmTzU=
X-Received: by 2002:a05:690c:a686:b0:8b0:e238:271e with SMTP id
 00721157ae682-8b0f2245dddmr7527327b3.105.1792252051731; Sat, 17 Oct 2026
 08:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015143426.17620-1-jianyungao89@gmail.com> <sashiko-outbox-173003@kernel.org>
In-Reply-To: <sashiko-outbox-173003@kernel.org>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sat, 17 Oct 2026 23:47:20 +0800
X-Gm-Features: AclHuK-luv-4iS6ShmJC3j8p42V2H0JsHrQsaqIcsGdvjv-_S5wN9kY6_ueRbgk
Message-ID: <CAHP3+4CKXV6sUHg2yCKHADA5E53Jz=8y+SShvgp+g8G8Ujpiew@mail.gmail.com>
Subject: Re: [PATCH v3] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
To: sashiko-reviews@lists.linux.dev
Cc: "open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review. You are correct that dax_range_compare_iter()
has a bug where ALIGN(pos1 + len, PAGE_SIZE) passes an absolute file
offset instead of a relative length to dax_iomap_direct_access().
This causes dax_direct_access() to request a massively inflated
nr_pages via PHYS_PFN(size).

This is a real bug, but it is a separate pre-existing issue from the
error code propagation bug that this patch fixes. I have already
submitted a separate patch to fix it:

  "dax: fix dax_range_compare_iter() to use correct size and address offset=
"

That patch:
  1. Fixes the size by computing ALIGN(len + offset_in_page(pos),
     PAGE_SIZE), matching the pattern in dax_iomap_copy_around().
  2. Also fixes memcmp() by adding offset_in_page(pos1)/
     offset_in_page(pos2) to saddr/daddr, since the returned
     addresses are page-aligned starting addresses.

The two patches fix independent bugs and can be applied separately.

Thanks,
Jianyun

On Thu, Oct 15, 2026 at 10:53=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] fsdax: incorrect size parameter in dax_range_compare_iter causes=
 massive direct access requests
> --
>
> commit 65ff21563702a9036c338f4961a061d5c576d038
> Author: Jianyun Gao <jianyungao89@gmail.com>
>
> dax: fix wrong error code returned from dax_dedupe_file_range_compare()
>
> This commit fixes a bug in dax_dedupe_file_range_compare() where a positi=
ve
> return value was incorrectly propagated on failure. It now correctly retu=
rns
> the negative error code from dax_range_compare_iter().
>
> Link: https://lore.kernel.org/lkml/20261012144925.6728-1-jianyungao89@gma=
il.com/
>
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 08adeaed2baf1..97b6212bfa898 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -2254,7 +2254,7 @@ int dax_dedupe_file_range_compare(struct inode *s=
rc, loff_t srcoff,
> >               status =3D dax_range_compare_iter(&src_iter, &dst_iter,
> >                               min(src_iter.len, dst_iter.len), same);
> >               if (status < 0)
> > -                     return ret;
> > +                     return status;
>
> [Severity: High]
> By correctly propagating the error code here, does this patch now expose =
a
> bug in dax_range_compare_iter() that will break dedupe for large offsets?
>
> Looking at dax_range_compare_iter() in fs/dax.c, it appears to pass an
> absolute end offset instead of a length as the size parameter to
> dax_iomap_direct_access():
>
> static int dax_range_compare_iter(...)
> {
>         ...
>         ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAG=
E_SIZE),
>                                       &saddr, NULL);
>         ...
> }
>
> When dax_iomap_direct_access() receives this size parameter, it converts =
it
> via PHYS_PFN() and interprets the massive absolute offset as a relative
> length:
>
> fs/dax.c:dax_iomap_direct_access() {
>         ...
>         length =3D dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size=
),
>                                    DAX_ACCESS, kaddr, pfnp);
>         ...
> }
>
> This requests an out-of-bounds mapping length from the underlying block
> driver (up to pos1 + len instead of just len), which typically fails with
> -EINVAL or -EIO for offsets that exceed device bounds.
>
> Since this patch changes the behavior from a silent pseudo-success to an
> explicit failure, will standard deduplication at non-zero offsets now
> consistently fail when dax_range_compare_iter() erroneously asks for an
> enormous number of pages?
>
> >               src_iter.status =3D dst_iter.status =3D status;
> >       }
> >       return ret;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015143426.17=
620-1-jianyungao89@gmail.com?part=3D1
