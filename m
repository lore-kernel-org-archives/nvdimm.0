Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6329A1E4BE
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764381050; cv=none; b=Wx5hE7IB0Oy8Nb9fcSot2inIEHebNoaY5PT2XZJFuU6HcWGH9Gh04XBizZDfXkocS7HRD7wi6K3ATLiWJDTs1dalE8PETJk7snrW4rDoVpC2WLBmOYT+gdH9VZIGtUNQpO3cjEDtMbaeDdgPMJwnrGgTOQfok1fwrnEGEcFIwW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764381050; c=relaxed/simple;
	bh=NaSVgYTQZj//T0kXBeK5L/YqRjV2JfM4MD+L1BQ61uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCRgZ2xJGIbbJrXucF6cOWQKZ//kAkKB0b7TdRDDhWOcYI8dwhHiPu+O23LD4/b7jFPVJx84wF4seefeL8UBhomV9VbObmepxEkAqt6GHOHFYdxsgRz2BBdBZ0108Fvo2GY8EOyI2G4TZwAczVfwnnYI4KkBX7EtoRzW9IcUzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bMJjDDjJ; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMJjDDjJ"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso21932771cf.1
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 17:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764381046; x=1764985846; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=bMJjDDjJ5rnwUmxelqZQIsONtcAwIKG6APHeeO61XbtDsG6TlKBNvwaHuBvhz7/EqS
         B3Q8qr9FSt+OU44Sl7oZmtxEjAvXhA4KkPvlOFmLYu0O8eRxeCZHLwFvTEsHXEnK2UQu
         PLSwoF3RDnlLNrP2J8z09ogBbL+ol9rvfGhCXgTynX9T3PTpejT4LAuOKVnh4XWDkGLg
         Srt88epe3I7kaf+o/pKTLpKmqZDEssMKGSGiWM+75OJXRxGKDjyeWAYD06TIkNOIKSLQ
         nC1F1uDxClmM2Q0srn2dyDH57a8MdBOtgpJYZzhyW/AmPkmoaJxOZnxuIIkeiBPIWbQ2
         Q+oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764381046; x=1764985846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=R4zWcvnvNXIlAHymnS/2Q8bSGv8V7tPveNdWbzPmTqnH04EWzPzlJaLK/T3JHn0tju
         4/zXY67Aa+5RvOj2sJedZ7fMn4pwYXToUFTnul+UrMx733oLZ5mQ9SO8ftD/bJOZiAlX
         VFPriGBlt8mzNsdUy2ai1mZmqZiq8tTMOfsOQR+OT4XaxKDNmeu0O2XAIk8EuJE8a/RW
         lJB5voBNFUgUjWPm7h6aHDn36qAg8WC1LILbeQnZMGxadXcSZy9ekp1NL1HeJg0LXY6N
         tgOg4dCQL2pbn2cMG2KgsllEZvdZvrPJRk6xiz9Jvrrm/2lz9QXud0zhk486ySAGE8YA
         SU/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwtopkuukv0BcvypJORa90HbH9QEzdbymbsdkJByUpomIw2c+B6ARRZE5gEUPl0iGxhqq4ZUE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsVPPb5v2SGSLWyIAXufQUOM+d1Y7lIaG8fkcPJ+ZCOEdro4jK
	viISRK+xzrj1lKYEWH2mhP/l3Zo5PKH7knITB0dxqrAoHUghyx6rPnzy3jyF3EP8H/+sOzKEZK3
	qRJiURzlTsIm/zSpWMXMb/4suJAgUmuw=
X-Gm-Gg: ASbGncszE86rqBRq4lRvOAQgzsSyRH2uPNo22WJ0GnysdqEaxfj2gMtHNaf/BHsCqBa
	x2cMb5TJ0ILOtMvIMkRFCso5z1fjMNt46WvIJUm3BHRqnoKEW8IRGSuJ6wQP++3yDO61U5kHgYM
	uTue8M5GqHF1QRnoG2yR9xjmb6q21dQxJEfU1ZzbK5pK/3Y/3/SzI+mB7fjGD4L51XP+J+gSCfb
	btr8kzlNt9lZSvoVSMq5Sm5nqu6l+5WpvQzbDcakZlLppUP8nLfXyGF7PRxclFk7VHygCL1ys4O
	tOKh
X-Google-Smtp-Source: AGHT+IE+Tw+9Y5Bub3lN6sC4Pj0OtdTK9knmaYL6GikYTYtgwTjW4uUHcZO2kGFVdLFpIVKdsMHQoOJ3Bk1wdK27dic=
X-Received: by 2002:a05:622a:1909:b0:4ee:2942:c4fb with SMTP id
 d75a77b69052e-4ee5882d9d4mr417978631cf.31.1764381046350; Fri, 28 Nov 2025
 17:50:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-5-zhangshida@kylinos.cn> <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
In-Reply-To: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:50:10 +0800
X-Gm-Features: AWmQ_bmFiM-2nj0DOVO633rnw-D1LMnVAvls5FZ2mk8-RJDyk4i3to2si2g7WjI
Message-ID: <CANubcdW7FxbtSRzePgO4wQwUFBpgbSYdL-GR87vUXKq7tAPsJg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
28=E6=97=A5=E5=91=A8=E4=BA=94 20:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Now that all potential callers of bio_chain_endio have been
> > eliminated, completely prohibit any future calls to this function.
> >
> > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index aa43435c15f..2473a2c0d2f 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *b=
io)
> >         return parent;
> >  }
> >
> > +/**
> > + * This function should only be used as a flag and must never be calle=
d.
> > + * If execution reaches here, it indicates a serious programming error=
.
> > + */
> >  static void bio_chain_endio(struct bio *bio)
> >  {
> > +       BUG_ON(1);
>
> The below call is dead code and should be removed. With that, nothing
> remains of the first patch in this queue ("block: fix incorrect logic
> in bio_chain_endio") and that patch can be dropped.

Yeah, that makes it much clearer. I will do that.

Thanks,
Shida

>
> >         bio_endio(bio);
> >  }
> >
> > --
> > 2.34.1
> >
>
> Thanks,
> Andreas
>
