Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6D93BBFBD
	for <nvdimm@lists.linux.dev>; Sun, 11 Oct 2026 06:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791700572; cv=pass; b=NtsmsxH14BctLaDbbqLGr43r2C+HR66xKcg3eKPOAq6FZJ5mdkXE5tmqD5SQ5/U74hTVJJ2AmXSTlXbuKDG2zMs1pccV0UwaUOse7X5jRvEkLed09v5o5JiKyhwBirRUPsx7pgXQooozV8RiriygY/deyoO/Sk99NbD/ZWBG3+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791700572; c=relaxed/simple;
	bh=7hD88bWiAam8+NXWjV2nyhl9mwoC6BjQ1vQ4o2Q4L98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aXalsYi7K8R6XKqAeNoi2camfMAeXov2mc8Ogu6HlFIB11xtYdJYtzt5dLFBCRnmTNaI2Xlj6VRvUHE6lr+vYd2ipX/frX0hn1qrlvyhjUQs1CvGda5ggsiB3WeNei6NxGtw0DgXKd3+aURYhovh10GtT53d4XLACSPHYdwz8lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ap1tM+DT; arc=pass smtp.client-ip=74.125.224.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ap1tM+DT"
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-672d92bbfd3so504906d50.1
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 23:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791700570; cv=none;
        d=google.com; s=arc-20260327;
        b=q5Q2FqeHac48vhQAcomIM9z4zzb24X6o0aWXz7HpaUYYBy+iKdYS2s5lSKpD/41LIy
         2g6GJj4SCbhb9dygZkuUYQyPpjdQjwgziu1O2UaqH3pR21eTzt5MckoaMaRf+medUWrn
         lWbStPg6/ltLSo22YPEV0Ht7KagO3/sFFodPe87slgMBjTyEXIB6Ry82/W+NxmnjKgSK
         9nPtbMiy6gyDrpwjCBqtu4uor6Zw5tQkmxMMDkQgd3yh1ZRYbXQiTpn4LHw4geZ+IX89
         8e/tjxd6+bPswALNn1/IabzMjR+EXh96bziGQ8JIJuK3cFce0yoWodcBDAl32Piw2MaR
         98KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=atEifmmOXWuQlnCZ1ScxDD9fnEVZxipao95maoAjOXM=;
        fh=m74ElSqHazzSng+Mltoi5J3j8qED2+GBqGz/HsIcJkA=;
        b=c0K/xxEisuIt1rI6H8NpYr9i9OoayGEhIJjfC57OXyiaX2AwBD0CwbGp0CFDRReMxH
         BveG7iptuWo9/g0oVpnjM5dqxBDdE8wTHwHKboPXFqpqFUINW60//jeba6jC//bpD9aG
         pCviof25TOj1OmyN4ctpxkw7YhyeIDgZG5FOR25ddhrgzB8zxkUB6nbiKjlqghRTT8Co
         KLsRQFgN1zZmg5PUxdkDwBnErQQ1ydfahm6ArZBBMRyk2FvhCYHkId2hcIiO6MtQHHi2
         a4qd5IQwOmfTFk8M3L/+oMULWizL9Y8MAyci4JwTQ7IDxjNqWOW/IhVLSjm486HvvIhb
         DSoQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791700570; x=1792305370; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=atEifmmOXWuQlnCZ1ScxDD9fnEVZxipao95maoAjOXM=;
        b=Ap1tM+DTpOc++iTRhS1MOCs5F225CXG7viRQ5m8nLQ8A2bCPae+h9dWdM6uBx9R6tR
         J0FUXMZ61qdtf78kmy0iSFs7KqPXtTtA5XgWlQtAcP8tAyCfG8B+e04RRzwgIa4owOEM
         xirYdVBKncoLdkMitlpd9FyYjtHKkXk8/jlGxQdzV9E5eaXJZD7av12UU4w35Bnlzd9f
         TyRy7uydKlitJkiwrWklxZrLslXIs9o0c/cLyC+P/7H/urlccffxAhJbaM73hCIvKIPj
         ziv11LPp8WkQ5qHHUGo1D3773LmlnND0VRsbK+LgFSOipULTgPhqLRjHSeUH4cmYj6wf
         0Jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791700570; x=1792305370;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=atEifmmOXWuQlnCZ1ScxDD9fnEVZxipao95maoAjOXM=;
        b=Berl+Z4haF5y37+royA90x/0xQbV74dHolx9UD12UIzgD0O0E4WZyBuD6CB0tXdt3p
         lkvReiFUvKW3b5EklaW/W5tKrjHz9NrEO0GPvYRsmT2lzUAXCl9vWaCIyQMHPIY3MVSw
         Y1NdpO2OqLR7RVbLYP32eBOcQ2d0yJzAj5FmL6XgKoOlqZ6gtCxguOsBpp8fWhPSsHub
         3wjHsXEToQWq3ujrj1O/h1sjaTDFvqya4kc3EZKrBFuyI8EiPNLRFv9ht4xo91BnTKTB
         YRD3m9XGXGAKtQaPlU0PHQWT9MC4yTAP+x/QovB/MHI6rZMyn34S/vzPn03y1jYK4EMx
         JoMQ==
X-Gm-Message-State: AFq9FYIyHghhRB+KHqi5uaSC6trHCFtk8+AuSVEELwnMjjye6EQ/Ievn
	zKqfppN2ytpVNEI7EIhHwhEZMWx/piW7673XMk19LN7OhryI4NDGNsSassdxswYr1yfz6r2DXjJ
	+CjsJfkC+as64ygkSwx+aTW9F3b24Sqs=
X-Gm-Gg: AYBFou2qsPadfPe1LnscaXn/poyc2TZHww8Iz5zSlUOqeeLbwBnwCujhO9JgZzmqH7e
	QR1fTNjefQ/lwM62FN1hX7UrbOcvhGOwUH1G2iI5GxgRQ/x30bGQmUH8plCe2ktu/wYq3BUJwln
	2yQQgLrSSbGDjCxZ2dgY+iX/SQBEbo+CottNLS8DOfqIm40MXg+cXC81KFZR0jqKQXePwsl4+VR
	U7fmZUvuHhVEnyzfXClb2kbNvb1lPJTjQC3Bg/KA7Tl79OI/trkfXr1d0+g/h2aIehHcELeFwpf
	GynxYBLJ91M6Gjsxk/L+OwaQgb8m1+V7/V2oDdFirzx89Ib476N7msA=
X-Received: by 2002:a53:ed4f:0:b0:674:2095:58cf with SMTP id
 956f58d0204a3-679362f029dmr1632902d50.109.1791700569625; Sat, 10 Oct 2026
 23:36:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261010071453.6028-1-jianyungao89@gmail.com> <sashiko-outbox-166309@kernel.org>
In-Reply-To: <sashiko-outbox-166309@kernel.org>
From: Jianyun Gao <jianyungao89@gmail.com>
Date: Sun, 11 Oct 2026 14:35:57 +0800
X-Gm-Features: AclHuK9RoUADDw1tz0eQK1gtI1KrPPfDOq8OoVJJE_g9_50GffvdcXsqG9DlN_k
Message-ID: <CAHP3+4Cu5=LaMy0ONkTmuJej7kq7v6b5NEzUG-Gb7em90nyBJw@mail.gmail.com>
Subject: Re: [PATCH] dax: fix wrong size passed to dax_iomap_direct_access()
 in dax_range_compare_iter()
To: sashiko-reviews@lists.linux.dev
Cc: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for the review!

Regarding the first issue (memcmp ignores page-in-page offset), you
are correct. This will be fixed in the v2 version of this patch, which
adds offset_in_page(pos1)/offset_in_page(pos2) to the saddr/daddr
arguments in the memcmp() call.

Regarding the second issue (bypassed length check when pfnp is NULL),
this is a pre-existing behavior of dax_iomap_direct_access() shared by
all callers that pass a NULL pfnp (e.g., dax_iomap_copy_around(),
dax_unshare_iter()). In the dedupe path, the access range is
guaranteed to be within the iomap mapping via len =3D min(len,
min(smap->length, dmap->length)), and filesystem iomap mappings do not
cross device boundaries. This is outside the scope of this patch and
would be better addressed as a separate fix to
dax_iomap_direct_access() itself.

On Sat, Oct 10, 2026 at 3:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] fsdax: dax_range_compare_iter() memcmp ignores page-in-page offs=
et
> - [High] fsdax: out-of-bounds access due to bypassed length check in dax_=
iomap_direct_access()
> --
>
> commit 05244bba82891c8d959214ace5da854f182c9e20
> Author: Jianyun Gao <jianyungao89@gmail.com>
>
> dax: fix wrong size passed to dax_iomap_direct_access() in dax_range_comp=
are_iter()
>
> dax_range_compare_iter() passes ALIGN(pos + len, PAGE_SIZE) as the size
> argument to dax_iomap_direct_access(), but this is an absolute file
> offset rather than a length. This causes the underlying
> dax_direct_access() to request a massively inflated nr_pages via
> PHYS_PFN(size), leading to unnecessarily large access ranges and
> potential spurious -EHWPOISON from driver badblock scans.
>
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 08adeaed2baf1..fb12d0c0dcd49 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -2190,6 +2190,7 @@ static int dax_range_compare_iter(struct iomap_it=
er *it_src,
> >       const struct iomap *dmap =3D &it_dest->iomap;
> >       loff_t pos1 =3D it_src->pos, pos2 =3D it_dest->pos;
> >       void *saddr, *daddr;
> > +     size_t size1, size2;
> >       int id, ret;
> >
> >       len =3D min(len, min(smap->length, dmap->length));
> > @@ -2205,13 +2206,13 @@ static int dax_range_compare_iter(struct iomap_=
iter *it_src,
> >       }
> >
> >       id =3D dax_read_lock();
> > -     ret =3D dax_iomap_direct_access(smap, pos1, ALIGN(pos1 + len, PAG=
E_SIZE),
> > -                                   &saddr, NULL);
> > +     size1 =3D ALIGN(len + (pos1 & ~PAGE_MASK), PAGE_SIZE);
> > +     ret =3D dax_iomap_direct_access(smap, pos1, size1, &saddr, NULL);
>
> [Severity: High]
> Does this code risk an out-of-bounds access in the subsequent memcmp() if=
 the
> underlying physical DAX memory mapped is shorter than requested?
>
> Looking at dax_iomap_direct_access(), it bypasses the length validation w=
hen
> the pfnp argument is NULL:
>
> fs/dax.c:dax_iomap_direct_access() {
>     ...
>         if (!pfnp)
>                 goto out_check_addr;
>         rc =3D -EINVAL;
>         if (PFN_PHYS(length) < size)
>                 goto out;
>     ...
> }
>
> If the iomap extent crosses a device mapper target boundary, such as on
> dm-linear, dm_dax_direct_access() truncates the mapping length and return=
s
> fewer pages than requested.
>
> Because dax_iomap_direct_access() is called here with a NULL pfnp, it ski=
ps
> the length check and returns success even for short mappings.
>
> Could this regression cause the subsequent memcmp() to read beyond the
> physically contiguous mapped memory?
>
> >       if (ret < 0)
> >               goto out_unlock;
> >
> > -     ret =3D dax_iomap_direct_access(dmap, pos2, ALIGN(pos2 + len, PAG=
E_SIZE),
> > -                                   &daddr, NULL);
> > +     size2 =3D ALIGN(len + (pos2 & ~PAGE_MASK), PAGE_SIZE);
> > +     ret =3D dax_iomap_direct_access(dmap, pos2, size2, &daddr, NULL);
> >       if (ret < 0)
> >               goto out_unlock;
> >
>
> [Severity: High]
> Is it possible that the memcmp() that follows compares the wrong file dat=
a
> because it ignores the page-in-page offset?
>
> The dax_iomap_direct_access() function translates a file offset to a kern=
el
> virtual address, but the returned pointers saddr and daddr are strictly
> page-aligned, ignoring any page-in-page offset (pos & ~PAGE_MASK).
>
> When filesystem block sizes are smaller than the architecture's page size=
,
> deduplication requests can be block-aligned but not page-aligned.
>
> If memcmp() is called directly on saddr and daddr without adding the
> pos1 & ~PAGE_MASK and pos2 & ~PAGE_MASK offsets:
>
> fs/dax.c:dax_range_compare_iter() {
>     ...
>         *same =3D !memcmp(saddr, daddr, len);
>     ...
> }
>
> Will this regression compare memory starting from the page boundary inste=
ad of
> the actual file offset? Could this lead to FIDEDUPERANGE incorrectly
> deduplicating non-identical blocks and causing data corruption?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010071453.60=
28-1-jianyungao89@gmail.com?part=3D1
