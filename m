Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5692E8DEB
	for <nvdimm@lists.linux.dev>; Sat, 17 Oct 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252337; cv=pass; b=gfuqsr9FO4Yd8VnTdvJ85go1BGqrDmsFw6mg/uv723Qcm1FOvIs6TJIfmZc0FIO/a7sRcZ3Ulh/HbGkHs7zbSkF7Tv8bHA9jHZpJI+fjI/pqT2erSE+ymv8Mz4AjNjGvHD6KClXzR1XeqenThM9zORK7WG9sRd4d2c/y9+2dDFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252337; c=relaxed/simple;
	bh=bnjkPkEAdPmINg1RA9oDgANNlvYD2LriHvYJDibwokM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RaFYr9G++kPGgJDdNDXUbHjYplSpsWu5kiESJI2LxtAlFYJKFV746TZrWCsWiJm9S7vKD8pnCp3T9twaEAEVkomv5OOZmBJFJecmbJoeZf46fbSUZiIy9wOL3pVUQUyPpwnR1Kq/3AI29h2l5d9aPKyMM2ZJsUHMS9gkZE96bu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv8Ypb8/; arc=pass smtp.client-ip=74.125.224.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv8Ypb8/"
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-677bd24a602so433974d50.1
        for <nvdimm@lists.linux.dev>; Sat, 17 Oct 2026 08:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792252335; cv=none;
        d=google.com; s=arc-20260327;
        b=VaSBeXdHfbVp1OptKQPDxEZN/lKS/XFe3EazuuH2hEuYlofagZN8fZdNK13izLF1kK
         KP3mauAofKwSZUGRqTvsS064ga022vKqOlIEC1KvVaaL8o/Zz3V/RlsaMQhtMeT+qf5N
         acKrLG/juwasdAiP9yjlVft5Y9AbMhMV4EFFW8eA45KQavZa23hniwMx6vdQUjVEMegA
         tzBcXb71BMdxMWI0nkpdW1KlLpHy1a0p5kLrlbZOVd44VAVGNToWH5y4fwNxkQXAzDV/
         RDQlra/DLoNLrE92DuS7TmHARaYejEd1XOus81mOugSgwgGDeaNB+23eNMVSgnx0Dccz
         5ejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OLXPXIfPNuS9IvRUvmHmUY/S7grY8emZfJl3BOr7iEQ=;
        fh=gw2O28A9tVcJ19nt0DkcTQvfsxhSa8TQitDz8RDAmxs=;
        b=VZFEXzTg1TdIw2as/RdaGTLKU3ErfBITQQWJ4VJCqDUf44tIRllzzgJtPy/eLuTdQC
         9AhVkrnnF2AXTGxAdoX7TbxEF3XqrovTRi/whALCDGJWHF4CXtsUu2wHmyh9EzkapE51
         W07R40zrJ+NxveV/PGdVz8WUtomyNxhxch45KJ82N13YJr4nntobNPN3Lnh1oy10Kuh9
         K+WDm6pFkLdKjFMu0bbfbIkIjizfZqqz24AjmdSrnghqZRHEcJA3aWXc98YrvE+2tt+H
         zYhwmCH/Ec8M1ZHwWDrj5ZUhtSiuy11+A9JKksta/ofjmglaGRyKIHE4741BL4myXBbA
         qX1A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792252335; x=1792857135; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OLXPXIfPNuS9IvRUvmHmUY/S7grY8emZfJl3BOr7iEQ=;
        b=Dv8Ypb8/NjT15B7MIYO3o2K05YFV8MB5djpDVGuX64+mO9S0MZj7pK0A1uJxP8f7/O
         93ElG2KZJPMHvhEAlky+scJBP6L6rfgOyFxl7Y5JJ8FYGtZL9Ccg2jg8J8gqxpyZXAe7
         tq/cuuaaACd4Nt2oWzDY7HjdAQVX0ghZUp/rz+cAW1N4sNG7KjQxeDM/ZXGuXk8L0Ggi
         jaRe00gy9H5AjaDjnveAJH3otZhQxLMJvNpRa2h5q9+d7QsCakgn3GuZgIjDqzxrEFh+
         deBYeBE/wm/wVMSceG5Jz2u4IJMqj0uQ539gXQkJNq3EYn9k6JSuuV4ZtKEg54wR37hB
         x/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792252335; x=1792857135;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OLXPXIfPNuS9IvRUvmHmUY/S7grY8emZfJl3BOr7iEQ=;
        b=M2FDv3fViS2zX2zv/H8Ger6LQ2XPh1dreeO70fTaXyKohTl8VPxbmcbHx4IIBlLt7l
         2D8t/kLGk95z4t0e870eiDk5MwNa4oxp/JPKDYksrVL7BGfcwj48c9SODqx2VtK8w/uq
         8H/cPm4f6dJ9qieIpg0Yu02PVdt7jpgzA5Yc6eprZ8gSIqRouShMTcwXIWxj4ugS4o9Q
         TJ4WxXJZ86ybGdDtmk/XxngKoTBLTaClSlZkHE4kYGFQFaX2UF5p1zAPMERkZ82R21N9
         MyKmRPUS57Ax8k6SR8Vje1wMq7hoOobqFAOr/dyLU2Bu+xejffRHr1DliTiyetCJghso
         KvmA==
X-Forwarded-Encrypted: i=1; AKwUvBwWlbaWvqcKkBns8pFCHLhu3rkEjPuNcQEv1IaMHoDdH9DoY8L9Rc5bW0vWU53RRTwq7Dc7HTU=@lists.linux.dev
X-Gm-Message-State: AFq9FYK8Rwb9l/hdWlVYL8KqfPFfstJ5JeuR5t9cvwGMGKBj/VNM0uF2
	v+zvPrr+zeGaciOi+TN3j/qbPBRqlbNJKR5vIEXHtDsviVFuxFT1NGFQU3lKqv/ZGaQfjbJlisb
	+mU8SagmvOm26x7/t0oeCtAHOqcEH3Dw=
X-Gm-Gg: AYBFou1sBenU3+iJYgo6wXnJb9ejVbLv0+DD6Ec/rVJQOiLr0+7aRQew77g9Spvb7lp
	omQNlliPSjGE8KN+wNiL9s5RT3zNEhro2U4M6NfPiCaXdCdy6c7kcsOHO+KDJM/8hYoa3eQVE3C
	C5CSs/VRNWggEbKuWY2pRYlcU/c9AdL8T/HYGHZeghaaXqUHVpDc6UPPL8e1iijPobO5dCbxAtf
	CYw/81zExqyMUFyn1UuWIxkJq6UgWmYFgPN3dJPfK5AuX7h3Ei07XzivCVfBMdRkXCEjvXLx0Kk
	szrXWkvwNqAQek07eiiIV4tGn3EG97ioEd6ONlOFQ0BalNEUiORsX6jgD5r2aU7VqFL1Pvpt33Q
	K2T+IJSMwbooDw/Iw9ivs/UrkuLEgqvKLdI8=
X-Received: by 2002:a53:bf0e:0:b0:677:afa4:a210 with SMTP id
 956f58d0204a3-679ca8c84e6mr690917d50.95.1792252334855; Sat, 17 Oct 2026
 08:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015143426.17620-1-jianyungao89@gmail.com> <atF8f0Jdb8OMcE9I@aschofie-mobl2.lan>
In-Reply-To: <atF8f0Jdb8OMcE9I@aschofie-mobl2.lan>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sat, 17 Oct 2026 23:52:03 +0800
X-Gm-Features: AclHuK9hDBQvGLcT3mNvFowJYZJuyWyo9WXLFqaeSLdb5QJcwrs-segceXyoX-g
Message-ID: <CAHP3+4CM=ZjuP+S10T9wxcBOBt3tXH0ObY42fcDUm2pGE1gr6Q@mail.gmail.com>
Subject: Re: [PATCH v3] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, 
	"open list:FILESYSTEM DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alison,

Thanks for the heads-up. The Sashiko complaint in v3 is about a
pre-existing bug in dax_range_compare_iter() =E2=80=94 the size parameter
passed to dax_iomap_direct_access() is an absolute file offset
(ALIGN(pos1 + len, PAGE_SIZE)) rather than a relative length.

This is indeed a real bug, but it is a separate issue from what
this patch fixes (wrong error code propagation). I have already
addressed it in a separate patch:

  "dax: fix dax_range_compare_iter() to use correct size and address offset=
"

That patch fixes both the size parameter and the memcmp() addresses
(missing offset_in_page()). The two patches fix independent bugs and
can be applied separately.

I've also replied to Sashiko.

Thanks,
Jianyun

On Fri, Oct 16, 2026 at 9:23=E2=80=AFAM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> On Thu, Oct 15, 2026 at 10:34:25PM +0800, jianyungao89@gmail.com wrote:
> > From: Jianyun Gao <jianyungao89@gmail.com>
> >
> > When dax_range_compare_iter() returns a negative error code (e.g. -EIO)=
,
> > dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds t=
he
> > positive return value from iomap_iter() indicating more iterations rema=
in.
> > This positive value leaks to the caller, where vfs_dedupe_file_range()
> > interprets it as success (bytes_deduped =3D len), causing userspace to
> > incorrectly believe deduplication completed.
> >
> > Return 'status' instead to propagate the actual error code.
>
> Hi Jianyun,
>
> I looked at merging this today but the Sashiko response stopped me.
>
> I do see you addressed Sashiko in v1, ignored Sashiko in v2.
> If this v3 Sashiko complaint is one you've already addressed, please
> reply saying so. Thanks!
>
> -- Alison
>
> >
> > Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> > Changes in v3:
> > - Fix the Fixes tag to point to the commit that actually introduced
> >   the bug (0e79e3736d54), not the one that renamed the variable
> > - Add Reviewed-by from Darrick J. Wong
> >
> > Link: https://lore.kernel.org/lkml/20261012144925.6728-1-jianyungao89@g=
mail.com/ # v2
> >  fs/dax.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 6ba50142eeb2..1f6a4fbb97bd 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -2261,7 +2261,7 @@ int dax_dedupe_file_range_compare(struct inode *s=
rc, loff_t srcoff,
> >               status =3D dax_range_compare_iter(&src_iter, &dst_iter,
> >                               min(src_iter.len, dst_iter.len), same);
> >               if (status < 0)
> > -                     return ret;
> > +                     return status;
> >               src_iter.status =3D dst_iter.status =3D status;
> >       }
> >       return ret;
> > --
> > 2.34.1
> >
> >
