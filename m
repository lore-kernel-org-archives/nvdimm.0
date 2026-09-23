Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97479392814
	for <nvdimm@lists.linux.dev>; Wed, 23 Sep 2026 06:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143269; cv=pass; b=ugEvg1MV7E0ypAzmSTvafrvs64ClesZYgcFm3bu7nxZfdpiS4T4NhBi+ScVPApo3dI7D/qKbbLcThv0z9qT778cNEZ2Kwx2B73nPUrxPFfKwaTCcg95hTS093G0q9I1g0Q0gWmpl44mzYrgcLsa0gbvZm+9NFV22sS0pnt+PU9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143269; c=relaxed/simple;
	bh=HgLSZl8XxyK20T4gh3lI0f3nK0YB9PmdSCSKHAKyLFM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IboCTkH/u/vtuImIxX/mo6evk+sffY4azm0/0pDRpXdowXhccCcy30M0fqdzsIj19c7A1ZtbPNVc4q9dtgLcBprBUpDlB+1Z2JnL3VzJXoBGSTxlWZjDsjQurayOewQoCn5K/MkiUl8tET9OYWAE+ia1wVXJEwEjh2rS5qJuebs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=jUsZaQRn; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="jUsZaQRn"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672ce86b21aso614350d50.3
        for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 23:01:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790143266; cv=none;
        d=google.com; s=arc-20260327;
        b=MAce9EgzkZCiwL7enD99anjFIXPD3wTnAbVnKxRadtbVF48ZnzIlxVLvurZfB1n4Bw
         Fte7S4tUeNtRuSo2NQShxfhT3Ebw5hHOvR8UhTJjA61q0cuHt4G2e3FpBlbkZ+VgLd+1
         qgJX7IWgNGTOxLHnxo/FOs8PBEsE1LSlazUelCvnhUIsfOH8wweu2Tvxcc25hzhaiSik
         G2D9nn8U1wqvK9Kcqgj1x1RQSI1K9SLMdmBpIJbcjF1Iq3ZUOshnj0zRFxl/gjDgu7ps
         Eq/BydXVaDjV8xu72ZSQ3ZtQc3tgBvjypP7ZMBwAub+ytPfvR3sUm1iNfsX4ooLvR7e/
         uCow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BI7bwcNjzQv13pRkfjbMflvweeVEe6lYqf3+ijkmu54=;
        fh=lTWAoYoQFHeGgpb2H2kO9SzFyttqo+nhTcUOJUQ5K14=;
        b=GHvfeiQ0nvPzHmRDbcHnDf9avTEdKB6K4egVp07mLhQ822TFPFzHTMAlCLJEXD7iMq
         5eeDHYeGqHayBnh9/amxSKKPBGBCADDh/8gD+A9zr2Q8mM+woqQSTWnLNivaRmhALz0H
         Et0GH0XwXsh5oROtOhQHHaJAZK4F39b3XRdOLBzc2GOXYUxc3cpzZPlMwwFTN88e40Vo
         o1SvFXdjePJGGB5ZqSyirzp4U3yaLFr/SJCqZ6WQYywN95+msYBYnmeQ9H/V6bbW56N2
         xlKQcatI2WoyurtE2Hij4GCXrRM7wbZqCm4E1LGkegBD95ON2q8iIhiXgD6Szg6jx/wY
         rk8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790143266; x=1790748066; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BI7bwcNjzQv13pRkfjbMflvweeVEe6lYqf3+ijkmu54=;
        b=jUsZaQRnGtLu97Sq1odJ+i2Cs/8cbQWrGwOldKN+Si5FH+ptN89aSKiF/cbSUbvV77
         jlruprcgMhwxUBWGeixof15JVWUDxf4+9I57RajU/JU7vGpgeoQgra3MDzV/VJmc7nWC
         vMPdraH2Dv3crwfBh3gwzOCuEChYfm285tmMThy7lr38GiIvkA4yV+Xf/dB42lKhQRR2
         sq+Tzp4PY6KsZG98Fq/fnDqgeQwWhPLP055gfgAQKaeuHX2igTtOqGo5pCgtu0kSg1CJ
         Gd0JTtVQbw5h0jcp8/bND8cWEM0jCrS5UWNNNW9/u48OG3m6xi7ogsBOUrsLrZOL3Z3V
         ZjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790143266; x=1790748066;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BI7bwcNjzQv13pRkfjbMflvweeVEe6lYqf3+ijkmu54=;
        b=pn8QWZ0QRbmvspPWA0o9UaXoVUO7RcP1IDYHa/9L2idpQqcu/yQSAO2ncJcBC4S1fn
         aaHvrYnWY0ayOrcDVlzFNLs6BFAiEfKBK+mcXq1c1Ai0LBgS7i/ggG1UFLQZq2ASR5yt
         pbgd0CVVRvjeQb/LP+83vNuUU9WHe1Y0inFWomzaDRd0Q9hJ2GnM5ykneeTfJObuadGf
         GxSNckwX1L16lycqMGDrwblGYNZ3QAn7UqDq4tNUvbojoQOvduHKu6dQ3DmgfVqnjy3F
         VuecB6tJa/vexmuYerPMiaOcDbmDW491HSMK1aaYHlnNXbKmfQWbdORGVRTx9R1ecWtg
         dp3Q==
X-Forwarded-Encrypted: i=1; AKwUvBzmtW3QjUTSuHk9EKBw5j2oC8NDZYejdj2F5WWKHO/1UIZm+r+G8iGRX6e/Be/kK2LOV81sc94=@lists.linux.dev
X-Gm-Message-State: AFuF++kBFjvjZVORv7dVKkNTuYVTfEnxZVWTJvUU8qwUWl5R+lLqiqdZ
	Zs75MtGlNq3HfoIh3fn762JYK8S/Ts4X/L0dYDJY8+OMlzq1rNG71wzC6Wk/SMLj7PMCgWmsudk
	5tKLo2pl9d0LhsdfIYoCBqHqX3PM/c7wd4xkwvA97oQ==
X-Gm-Gg: AYBFou1luL9MBoZv8w73qO84XtTXHqR7W/lUsjUY34JaHYzvCocSGGcLrtmaYVsPm2+
	BU7ZWGV7TGpHT8g3cDjz/CbheaLKk03LJPTctHvyon572xIqN79UAbIZ646XfvQE6dmqL4lipY9
	eGEP8JMLAdwSwp2GMkDTftj0KuRTdSgTcBeHd7BcaRNld43fLM5i0z0fU6uUi21ul5rUP/wvfsX
	gUekCF09KkHycQvBt/n++c2az4+m325Pczy8VcGEkjn04BC5HwngaNz571Hia53AWPgXbnkGtZd
	WOEv4+soPWPx0MufCNBDdsgkWpbGfp84jkudxgg4oWfEZW44Gkl9Hjc=
X-Received: by 2002:a53:ad50:0:b0:66f:c1bc:40a0 with SMTP id
 956f58d0204a3-672d58abf06mr470879d50.99.1790143266221; Tue, 22 Sep 2026
 23:01:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922082551.874901-1-songmuchun@bytedance.com>
 <20260922082551.874901-3-songmuchun@bytedance.com> <20260922083712.A89111F00893@smtp.kernel.org>
In-Reply-To: <20260922083712.A89111F00893@smtp.kernel.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Wed, 23 Sep 2026 14:00:29 +0800
X-Gm-Features: AcwNN1U14lhaEIPXhrx92Llhfbcm9mObr2diD8G4hu8c12kamR6vjUggv5v3RCQ
Message-ID: <CAMZfGtURkCQo4DCbdj+KcG0zbZHzECfY2c0aqnDeLWYt_uo9Eg@mail.gmail.com>
Subject: Re: Re: [PATCH v2 2/2] dax/bus: fix Device DAX range alignment validation
To: sashiko-reviews@lists.linux.dev
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 4:37=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] dax: TOCTOU race in size_store causes partial shrink failure
> --
>
> commit 519db297333e73581e0bbd5524e7d6959d7610a7
> Author: Muchun Song <muchun.song@linux.dev>
>
>     dax/bus: fix Device DAX range alignment validation
>
>     dev_dax->align describes the page size used by a Device DAX mapping.
>     Both the start and size of every range must therefore be aligned to i=
t;
>     otherwise the starting PFN cannot represent a naturally aligned page =
of
>     that size.
>
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index e40c25401cf06..277c3ce23b831 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> [ ... ]
> > @@ -923,6 +964,9 @@ static int adjust_dev_dax_range(struct dev_dax *dev=
_dax, struct resource *res, r
> >       if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shr=
ink\n"))
> >               return -EINVAL;
> >
> > +     if (!range_is_aligned(dev_dax, range->start, size))
> > +             return -EINVAL;
> > +
>
> [Severity: Medium]
> Does this new strict alignment check introduce a regression where partial
> shrink fails if the device alignment changes concurrently?

Thanks for pointing this out. The underlying TOCTOU race is not
introduced by this
patch. It was introduced by commit 6d82120f4156 (=E2=80=9Cdevice-dax: add a=
n =E2=80=98align=E2=80=99
attribute=E2=80=9D), which made dev_dax->align writable while leaving the
size-alignment check
outside the locking scope.

That is also the commit this patch is intended to fix, as indicated by
its Fixes: tag.
The stricter check added by this patch merely makes the existing race
visible as a
partial-shrink failure. I will therefore fold a fix into this patch by
moving the size-
alignment validation under dax_region_rwsem and dax_dev_rwsem, before any
ranges are modified.

>
> In the sysfs interface, size_store validates the size alignment before
> acquiring dax_region_rwsem. If a root user concurrently writes to align_s=
tore
> and changes the alignment requirement under lock, the shrink path proceed=
s
> with an outdated alignment assumption.
>
> During a shrink, dev_dax_shrink irreversibly deletes fully trailing range=
s by
> calling trim_dev_dax_range. When it reaches the final range to be partial=
ly
> shrunk, it calls adjust_dev_dax_range.
>
> If the concurrently updated alignment causes this new range_is_aligned ch=
eck
> to fail, it returns an error mid-operation after trailing ranges have alr=
eady
> been deleted.
>
> Since sysfs writes require root privileges, can this time-of-check to
> time-of-use race leave the local resource state corrupted, with the devic=
e
> configuration permanently broken due to missing ranges and an inconsisten=
t
> size?
>
> >       rc =3D adjust_resource(res, range->start, size);
> >       if (rc)
> >               return rc;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922082551.87=
4901-1-songmuchun@bytedance.com?part=3D2
