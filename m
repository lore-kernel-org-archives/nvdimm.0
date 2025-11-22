Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2301B4244
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 07:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763795357; cv=none; b=fgPiqmlZI2X6BjKvASKpCNYLTzfZm/2cQHS1+Vv9rTJOnDJhVfgK0Arqa7pQCumqZtWkxpSJYrMN/myEV9Wy44nccuZ66nmXq7flCZg2Ig0F+ioEESWveDJh3H3RF332Q1uDSwQ/F131KbNCoK5Q8+8G2+C2duLo2PTbRhLJULU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763795357; c=relaxed/simple;
	bh=7Yd8nloP8m0dR422jBlUsUdryD11f8cV04WwFlwTHDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bMBvU/kShAA8Az6VGuIiCPWaFrq84EHPx7nu5m2kdYy8mqbWCVsFKfEo8J9rFGNSGL4kSI3L2jTdMip7jUwe53i3xaFVGi6JNJK5j3fRe+BZeyA2uziiqkL2np9PPrTzDImK0b2BdmI8PZmbB1LHzfvC075Cdau6OYmCptYyu4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TSf8jY5D; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TSf8jY5D"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4edb7c8232aso35181721cf.3
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 23:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763795355; x=1764400155; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TOU5zUa9ExH2UPIf77XppaYiXONJBt1V6maHsn7ikzg=;
        b=TSf8jY5Di0/B1Hq9yM7U6hBqdfHqu9eSc3Wx2kETFttPG/18St7hp5ZN+a8cnuIiXC
         338OEfH+ISgTsOirotUK8SwKO88U/MjfHpi4wdRTn1R/U4R847Asc59V8HkKkdYQpkjY
         QyefmNvTDMBkw5h+ibsgFvmeYOpfhkhTfEEVMs4mnyqCdMwPF7E9w+ZyrVbZ8kV2aunQ
         bs4nGac/cd7c9s+naafdpbvIk2idcDXwI5YhOolATA1ynCEnvmXR7MsKhmE084nw1GmG
         jBmK3DK94Gd38fii3P390fdKku18m7+JXyStRPT71MsHwHV9eAJ/752vZJMPtNYe6QaT
         BqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763795355; x=1764400155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TOU5zUa9ExH2UPIf77XppaYiXONJBt1V6maHsn7ikzg=;
        b=XdSIGRoCJvxQVfUXe7AoqZ5Jbjt5zxrMItHmQ55jKf0vRw9uce3XIHSeZelrwqbn3v
         f0YDxl7550f0tM1N1/Mqy1RpRzStj5b/P1xy1a5ZVh2/KaCt2nRsCbnaYnQqfpwTY6RA
         DuEdtgQnGQtPW8ll5/WpWh6bSq9dAUjotVvZUWVCiWmIZKS56k52qGkd5ShilxaeMoJN
         off2b1NhgKfLoXUKW44VOikTzJNcCdyQl8oaRKqyUwVPHC7cBC9XF1LMEfTHgrc2BpDm
         eqFfMNlBMVCv50R7RVzVbDUQeJd3R/3NwQ/wNMLNOxWYakgZgZMLcCZzxYUYQqiJyv8o
         AQWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJ5DcG156fiYybW+M0cma5licun4jDk6w8/8NINvUsUbDPJzLzgdxn2Fidk5QqYtvpcdOlW7E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCACdCFcmtnvOy2pwjL1advkrNyPMkht3obXKUZK6fCBG5SxN7
	j3zAFZlya2cK5fB9MXukdGykyLwCO0DKcpogExcncqzrZn2aEbLpeaoaL8ImIideI/J5MogI/F7
	31sE4nSQNAqEqjkI5LOcochEgJPH58ZA=
X-Gm-Gg: ASbGncsK+gACMFyjYnMmO60LdgcsB5tayh2PaWgSH6B1GBylwKChiRHowQYVOPzljrs
	0IhnUtOX0T2vqSdUJ8yHiL5JB/crcIy8iOWNxinLiqBXlY04/4JyDq1cgFPYnpzNi/qpMbSCV4A
	WmkVw/4MnKNbizk06hZFmJZAyVtuq5BuNRSHLItGr2+fVaqEjATNAS4P0jM0wHL43K4IbYL8MKf
	92bbnsTQcp6IDmzwn8+XzZA2jd3ZhbjWpImdIqgEgoCjrka5C3C7YKC4s+FVBHE7z1W0g0=
X-Google-Smtp-Source: AGHT+IH732VY2HEOL1GTjGnjiDpMpgHpw4qhxelOjeL0bgVDWuC8OicLazoWJuAvAFEObeAlgbjBNJsbaZaVBgshjVg=
X-Received: by 2002:a05:622a:1207:b0:4ee:1563:2829 with SMTP id
 d75a77b69052e-4ee58b04a99mr71664381cf.72.1763795354707; Fri, 21 Nov 2025
 23:09:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <72fb4c90-0a75-43df-8f5a-154d9e050c09@wdc.com>
In-Reply-To: <72fb4c90-0a75-43df-8f5a-154d9e050c09@wdc.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:08:38 +0800
X-Gm-Features: AWmQ_bkaHk0wh-SvlSCw46Rlr82grFve_Y0_m2bfS2qbhv3bWWgwLzC0W1VLkPA
Message-ID: <CANubcdVx3MkWwncj1S0cS4FN+Stt8FpHD89dCFeStsd2QE=2sg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "zhangshida@kylinos.cn" <zhangshida@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Johannes Thumshirn <Johannes.Thumshirn@wdc.com> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8821=E6=97=A5=E5=91=A8=E4=BA=94 17:35=E5=86=99=E9=81=93=EF=BC=9A
>
> On 11/21/25 9:19 AM, zhangshida wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
>
>
> Regardless of the code change, this needs documentation what you are
> doing and why it is correct
>

Okay, will do that if I can get the chance to make a v2 version.

Thanks,
Shida

> > ---
> >   block/bio.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index b3a79285c27..55c2c1a0020 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bi=
o)
> >
> >   static void bio_chain_endio(struct bio *bio)
> >   {
> > -     bio_endio(__bio_chain_endio(bio));
> > +     bio_endio(bio);
> >   }
> >
> >   /**
>
>
