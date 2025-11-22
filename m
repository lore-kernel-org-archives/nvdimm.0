Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F022D9792
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 07:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763796352; cv=none; b=Z87J5DheiCJxhh+S6fx8dKdzKDYDjI1uCFS7u8pj8ItDvFrbZfsEViHQpRPAONsIezqZdnDQTLCfladDjv8bR4D55vOh2SCaKO08kyQ7+A/7aOmxUiibcxIe+LdiY2olv+AE7X0IdzC1y9vTIilIFONNMW9VL7K3cKglj9UX4jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763796352; c=relaxed/simple;
	bh=JIS6SCLgbf+oOuOkDo/dHaEAqLI3/Ie51gDdGsv7FCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PryYS2MbaY4bGFC02BtVsGyHIjz2yrutG2NPIbMYrWDodEig3ZhQdbHca8dISKxYTbiJsMi+uler13Le3v0imcnddHITrrpHREFU3FFMUV3/HoX9CBYGZCQTKP/2kadsNlklbMWL0joKmBwwr2CVoN6TNh8DM1hBDtSnDpM90cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f/rNJhq6; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/rNJhq6"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso36581021cf.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 23:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763796348; x=1764401148; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBwVylaCDYZawWaYOaVSH7r235GJ5pL280n6ediNWBA=;
        b=f/rNJhq6DjE9eeK0DuTrJpZJTX2Z8A+DOeDHy1U6J3oxmPzSwzRbSwwojvMqoQ0csr
         nb8m+xd4T3T8JZhZbKeDcsH6KMoHNQs3TEXZRypJPy/RQiqyVTQj8WXfGgyWNNmeipH+
         VzCKXTjg0L8mYZtRU+heIB+wMqx6Ik/sB7AF+StjAWm4as2mdwEdS5tXJ5lzxa2WXElV
         Zf+TWcCwdPVA7mDrCty54yzPFzaxbSgpgMW2CH/bACNBQuc/5lmOW//QX1SumK+HHTNk
         PWDyAqk+++nH1HwCq2mmZDJTAZinSOIFxUE4SX5VjxxxPmCOJ/w2ghTasySm5UYOLdAI
         BLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763796348; x=1764401148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eBwVylaCDYZawWaYOaVSH7r235GJ5pL280n6ediNWBA=;
        b=q6oUZEsqYM9luajMSYRdhGIBX9FqPvQP2UsSCVhLsGbXRndVQu0dGPjVIlazHw+pdN
         3vd1yMZxOEIvMomz5ZP/7vuLgzx7xig5OPrRv+1/12fLeL4CqH16JT96ZY708tFR4HoQ
         JVzXBXZPi+1GDYcnFDd7JjhMWKvGBP4+kPlau8YJgKqjWOo3Y9dr1QfOEGfa0sjdRTCY
         TJ2BZrIFaIIj+wOOg2iGGePh9RnWPGJ/eiWubqLU+jMtrjoTtS0xqSxMhvuOT9fhqpAj
         JYOkhVyar6mfz+SNwWG7T1slkJ8Nq5cQdbz7Vh6SwQFXi3G/4zwpC7WSwTk38sMG27z8
         MNDA==
X-Forwarded-Encrypted: i=1; AJvYcCVQaxIF+yTNjKaataN75a1xCLJlyRVMTZCt7NLKgmmm/g1TYqW5x2mK77SDHmwMy0etzq9Jr6M=@lists.linux.dev
X-Gm-Message-State: AOJu0YygDPre86a6eWxxyr06thYct4H/SUhyn+4LrRVAAeAaKn5WdeCk
	7eoKxu7mNgh87AJV/fhWYXVLXTjGeEMoIxFnqXoBZp3+ULp9TnP8LOF/9qHWkI7V+xLCF5HsFEQ
	3k3XADELrqhkqp28ZGpdcIjR5jsTZ/I4=
X-Gm-Gg: ASbGncsuyaMKIBczgz/ZTi+0wzi3vq0ZD20VTZD5M8qtAGH3ErvIPBLocBrVIaB+MOJ
	b3X62aqa5ZOGvIKf4hFe8PV3TnXfvvVCvuZ8mdfL3/TFZmThLOD2Up1Y3fWCJkGfhOcg0kkMHUT
	Drni1MYKA0syiRGn9fFvJlqfyIXEFt39MzFU2WAPLh7FkgWfB9yy5lrW5ajpBl9vb5d3E0TZ8I4
	lZ0Mz4wWwRJGc/GJPeQ74MS7BrmFoC0pg0wTVfXQJzrOTvy3vKIdND67OYmvy2ftKiBthI=
X-Google-Smtp-Source: AGHT+IE9V/QbSlM+tFjYlGuMiqhVjgd2vxC0t40Xg/Gl8NLqAZlhJSgGugagYhyt41bdzYZDASTkKfW3q1PwTWY5MjU=
X-Received: by 2002:ac8:580a:0:b0:4ed:b1fe:f885 with SMTP id
 d75a77b69052e-4ee58848f99mr81632341cf.19.1763796347971; Fri, 21 Nov 2025
 23:25:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
In-Reply-To: <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:25:11 +0800
X-Gm-Features: AWmQ_bm3jSl3t5CGtWT-qk2xFeLKlRyvhhYg4MhhBIRyX0iMMBB8sT9lfrjP88A
Message-ID: <CANubcdWaegO8k=_fkNFSvnp2bUYMmPehSFnenCCjVw2sz_1jqg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 00:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 11:38=E2=80=AFAM Christoph Hellwig <hch@infradead=
.org> wrote:
> > On Fri, Nov 21, 2025 at 04:17:40PM +0800, zhangshida wrote:
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  block/bio.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/block/bio.c b/block/bio.c
> > > index b3a79285c27..55c2c1a0020 100644
> > > --- a/block/bio.c
> > > +++ b/block/bio.c
> > > @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *=
bio)
> > >
> > >  static void bio_chain_endio(struct bio *bio)
> > >  {
> > > -     bio_endio(__bio_chain_endio(bio));
> > > +     bio_endio(bio);
> >
> > I don't see how this can work.  bio_chain_endio is called literally
> > as the result of calling bio_endio, so you recurse into that.
>
> Hmm, I don't actually see where: bio_endio() only calls
> __bio_chain_endio(), which is fine.
>
> Once bio_chain_endio() only calls bio_endio(), it can probably be
> removed in a follow-up patch.
>
> Also, loosely related, what I find slightly odd is this code in
> __bio_chain_endio():
>
>         if (bio->bi_status && !parent->bi_status)
>                 parent->bi_status =3D bio->bi_status;
>
> I don't think it really matters whether or not parent->bi_status is
> already set here?
>

From what I understand, it wants to pass the bi_status to the very last bio
because end_io is only called for that final one. This allows the
end_io function
to know the overall status of the entire I/O chain.

> Also, multiple completions can race setting bi_status, so shouldn't we
> at least have a WRITE_ONCE() here and in the other places that set
> bi_status?
>

Great, that means I could add two more patches to this series: one to
remove __bio_chain_endio() and another to use WRITE_ONCE()?

This gives me the feeling of becoming rich overnight, since I'm making so
many patch contributions this time! :)

Thanks,
shida

> Thanks,
> Andreas
>
