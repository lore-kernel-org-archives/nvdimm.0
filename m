Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2FA41A4F8
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 06:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791613729; cv=pass; b=OSEXDNw4X6Pw0coSon40T+TGKJsnqDuFESBh7hP5owfiSHRMch3N0C2E/mwMpSe+xK8d8eKyt3OlStUGc8ZLoi86es6BoIxuxG9oudJpNJQtbbB+C5v4hQaxm/hsUrzdd6QETPRaFHHhf0Pw0BAESnaiOy3d0aZRKdOedTds8OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791613729; c=relaxed/simple;
	bh=TVZtiMrwIJrKKjnD9I3HLVYJjK51LW2y9AKV94uNdoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fBzLxR/JQilK1nON89xERguPD4dQHKPYoiKfSWf3iHoZUcLF2sIDp88hjP5HisL+otR6gdaF/kESiloapK0YWHbi/0QrNDuadaVSgREHj4HAY6f6r7eXTwfx6GIWgi+K9WuX5VrrOQOeiKqa6vtgHHyS2KWmr5BvFzD1QExeODI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=igmi3Lgm; arc=pass smtp.client-ip=74.125.224.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igmi3Lgm"
Received: by mail-yx2-f10.google.com with SMTP id 00721157ae682-88b9012eaa4so883297b3.0
        for <nvdimm@lists.linux.dev>; Fri, 09 Oct 2026 23:28:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791613716; cv=none;
        d=google.com; s=arc-20260327;
        b=VSi398Sqc0GiW3nmRzS8MI9OJb/J0dR3gbQrV5h2Eqvyi1yaPc7t5N6fPqJJmAmSzX
         DDcGL9gJSXUU6tM/eA8OiLLt4bPmREn/afWajRuqTU6xxuOBNUGO0dWEmPFSsHOvPYUd
         MS4b0upR4RA/H55KHqITkozmGGSgSYmx9qmS1tYtEab4UspSWcCW6GYVfw492mQ64mEd
         bmh5c6KpFKy4p+lkzSX6IqHR3yOhvf6mACfk3v+cbz0z/8rhJFttCkBXjbAihMO/uvHR
         LykmyO7QISVeKgkUupJDLuL3Z/6Az4eZKPZbR3QJn2Cq+qXXvCM7ag9Jdhs5EtWeWu2A
         0Y7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DwjOp8d2EARQ4rsUqkbDKMHg5qE5GmsnR+L4gVDcC2w=;
        fh=m74ElSqHazzSng+Mltoi5J3j8qED2+GBqGz/HsIcJkA=;
        b=RPdEevvz48AYHEorACs8IIVJlVhB582v7ydyhDJu6ZllE8q5GGpJg0MeYdiZlV05dl
         vlHTv1evCFK3fEFpbmcayzRb7Bs+i3Ua/1bbXt8IRdFx76PVngYGP/b8mrP7IC/JOOWA
         L/seCrRSCZaeTMKbgwDbSkBJS+UiHGgUIYrG4UJa2IRTcDWcJHKLrc5tm+UMEHDNl9fR
         jBc9QwTThCr1hgl7cv8RNS+KRQsW5bUeolNpdl8wwz+gswnXF0KGAXl5fK13hjB0l29J
         kBi+DWFKY8QQI0TCinwtxzIbLcexNNC5W5gQAyD21dD4E5BXE4EBJZ5xVz5iT+BPorHV
         Yb8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791613716; x=1792218516; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DwjOp8d2EARQ4rsUqkbDKMHg5qE5GmsnR+L4gVDcC2w=;
        b=igmi3LgmMB2l/mJ5CmK9GwKqG1hfyKu5QG9ziHmCisfTM+jbQnprLq+CTmlRdPzs3y
         Ria75okgXCXTUs4s/Kv/xY+qD2JNSdH7ePupm19uMZ+Ral+8FI9DRV3rdip7I6C2m94i
         Yg7n9hPO8sV4Hga75BuV2VDQxTPnUiMAswAHj6NCbM/BOuRUnoTDp3CVtt0jBf/qed/r
         hpg9tnIcPConenLW97TZFVkVGV7B+iIu8RTWOGzlJKT4sCarCJFTvR47N28C42wPSiZK
         lp3QfguCpak6PCIgMzsmToBgpOL4GOz3zCMY0q3Ai0w4w/347oJgiD5T5KI58bB+DaYI
         OTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791613716; x=1792218516;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DwjOp8d2EARQ4rsUqkbDKMHg5qE5GmsnR+L4gVDcC2w=;
        b=lEo50Z1X/dp48AEpTxggBjip3M69CVX7taJ6b4jIagGCZof/XqJrC+/qfqr9U71cYw
         5CekvvmFv58DHKd3fnR4wZY6Q8Yu9Rbt0PEYzIOrG3p8p8yN8q+gVWyvZVvdUn2XiFix
         UGOb0Eaoxxljiid0KYCN5lcueM+h9hbNJHDGMfYqZW4ioS8YTRp4m+8mqRqFbZ1gflo7
         ZkrowerIPkYjxNxTG3SGeHGsJSIiTzLs1nJP9edJ36+U90C6QXiUV0Ezuy95jG/byVz8
         yN8PHIoV8TJARmxXMiWiSMk3xbVmTsmjW6bV2GwySlJJYsLK+GFr4bwdQm9FSZbayFSl
         ICYg==
X-Gm-Message-State: AFq9FYLinCzmIsJiiwpcnLVzCuoVsRezqFTxbirpWFOktyKIxVd2YUIo
	WZ91QBB0BGD3+D0Rml7q4N8mleLC+HpRADgdvc/L9tC38eZvkVR/IJ7igOC9JnPnivXDjZAYE4T
	d+4Gr8HjwlgwUw4ap87na9W+TkjXikE5hive6p9ehAIAZvS4=
X-Gm-Gg: AYBFou3A+uKnbG1g+kxv6bTSQRZk13SWbU6yDisggHViMr0uPzG25AbTDJfE+ni4BGK
	bZWr6AaTOwRdQZd41EcHBa3nvaBO1F6gwD1qhQUKHcS563OEodNFY94rdde2EuH37CYCVwMrSYJ
	0L3V6br88UC0IzGJ2lI/hY+7iOrbE+7uXpB5fQTvL9OJf+y+JUjdU/sddmItP3LDYI1+Nwc/XBn
	m1c4HSLwdniE6LxHDEmiCd5BH3gJIzAdCBjz6Qb9T3i9J/oya9BVmrAyhlhqiOxtT5Dtv1F+1/Y
	5mqNkZsCtGWE2YK2JU3pqMPrsep6J47X4O+D3md5qUVqIKZim4q3hHM=
X-Received: by 2002:a05:690e:458a:10b0:672:f620:3552 with SMTP id
 956f58d0204a3-67936298daemr1027115d50.98.1791613716226; Fri, 09 Oct 2026
 23:28:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261010021010.19575-1-jianyungao89@gmail.com> <sashiko-outbox-166211@kernel.org>
In-Reply-To: <sashiko-outbox-166211@kernel.org>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sat, 10 Oct 2026 14:28:24 +0800
X-Gm-Features: AclHuK9B38RfzpVynqHn6-1KOLXXUajPRzRGr-IbjmyS0zOcCV7zJ1AXl01LH8I
Message-ID: <CAHP3+4DveBJxaWK7cGgjHvOUio55zrj7drgh5Eqq+0Pe+pG17g@mail.gmail.com>
Subject: Re: [PATCH] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
To: sashiko-reviews@lists.linux.dev
Cc: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the review! You are correct that dax_range_compare_iter() pas=
ses
ALIGN(pos1 + len, PAGE_SIZE) as the size argument to dax_iomap_direct_acces=
s(),
which is an absolute file offset rather than a length. This is indeed
a bug that I will fix
in a follow-up patch.

However, this is a pre-existing issue unrelated to the bug this patch
addresses.
The purpose of this patch is to fix the error path in
dax_dedupe_file_range_compare(),
where return ret can leak a positive value from iomap_iter() and cause
vfs_dedupe_file_range_compare() to misinterpret an error as success.
Changing return ret
to return status ensures the actual error from
dax_range_compare_iter() is correctly propagated,
regardless of what that error happens to be.

On Sat, Oct 10, 2026 at 10:24=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] dax: dax_range_compare_iter() passes absolute offset instead of =
size
> --
>
> commit a30afa39f06e5d921895421d92a26f1823e65cbd
> Author: Jianyun Gao <jianyungao89@gmail.com>
>
> dax: fix wrong error code returned from dax_dedupe_file_range_compare()
>
> This commit modifies dax_dedupe_file_range_compare() to return the actual
> error status from dax_range_compare_iter() rather than leaking a positive
> return value. This prevents vfs_dedupe_file_range() from misinterpreting
> an error as a success.
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
> Does returning status here expose a bug in dax_range_compare_iter()
> where it passes an absolute file offset as a relative size?
>
> Looking at dax_range_compare_iter():
>
> fs/dax.c:dax_range_compare_iter() {
>     ...
>     ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAGE_SI=
ZE),
>                                   &saddr, NULL);
>     ...
>     ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAGE_SI=
ZE),
>                                   &daddr, NULL);
>     ...
> }
>
> The third argument to dax_iomap_direct_access() is a size, but it is
> passed ALIGN(pos1 + len, PAGE_SIZE) and ALIGN(pos2 + len, PAGE_SIZE),
> which are absolute file offsets rounded up to the page size.
>
> For large file offsets, this requests a massive access size. The underlyi=
ng
> dax_direct_access() call computes nr_pages =3D PHYS_PFN(size), translatin=
g
> the absolute offset into a huge page count.
>
> This will overflow a 32-bit unsigned int for offsets >=3D 2TB. Additional=
ly,
> driver-level bad block scans like __pmem_direct_access() will iterate ove=
r
> this massively inflated range.
>
> If any hardware poison exists anywhere in the remainder of the device,
> it can spuriously return -EHWPOISON. By propagating this error status to
> userspace, will this cause deduplication to spuriously fail?
>
> >               src_iter.status =3D dst_iter.status =3D status;
> >       }
> >       return ret;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010021010.19=
575-1-jianyungao89@gmail.com?part=3D1
