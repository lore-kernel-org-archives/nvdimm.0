Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3227C84E
	for <nvdimm@lists.linux.dev>; Sat, 22 Nov 2025 07:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763794970; cv=none; b=H4t8ApAh8a3p5C5Xo6YVaj2/+ETtFVtBBKQ0nTefJRtDCQ17DudFYJgyjw1WLrGZsXpOLX3VXe0EFuNB4QmDrork0mKG66NEm2lNRYobR1VCBGnhIfAnNPNG5IoMXyflEr62Mra6M98m7jzcXPXQ0mMK3MsmELM1i5cqMdKfHhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763794970; c=relaxed/simple;
	bh=3qML6mAdP3XOHu6CRgEfvtbrG4LVKi3a96yUcu5LMO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pCLX62FbjC0yoV7M74PZ4xsKvWfACnoVfWtWCsrSMvwUqilKuN8PgvcsA1Zb1SwTceZYlKOMWKbWK/+fm8mj0SZ/k1e5y/K/4yhbOo/0RGXvXGEM/dzrKoO/KhrcFmSvqW5yxQyvO1wk2gVH+3TRc6Cp+OvOaAGFkSw19y1HPzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NFNGP3cE; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFNGP3cE"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b2ed01b95dso276257985a.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Nov 2025 23:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763794967; x=1764399767; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLckKOB/6XWKdTlMPCvOWJYhseDg7RVjB2FyFDWqsDI=;
        b=NFNGP3cEcVI4DzLS8NwKrlYEZXToc2D655GsOaN0h/xdx3GhMFMY6HxuOMewSZteBX
         3q4kK2ozIT2dDMgGY6DgcZU4IH/Z9mc9Ojpt110/BGVvIruSFX/UjNt2N7IKwc8IQwSO
         UJhSWqjuQfnHfNAFaIzmtKHXGZvBnxdUPkFWyOsXcg37FwRRQzz5cSUAhVb7s4mWAmRZ
         e+SePYfBxAY0+2Npkz41TWtvs35beVKSqj9m5CfvxcZH5ShcV0UBNWSH0B+2hX9BCruh
         6b/07c085YvLMnAqigV3uqmcNT04sUvNIJMX4MDTacTj4tU3w67f0Z+iOjj2qoFtSwjl
         oLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763794967; x=1764399767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WLckKOB/6XWKdTlMPCvOWJYhseDg7RVjB2FyFDWqsDI=;
        b=u/w3AxhDhBHX/axgM6O3t21F1dQ1O6oR+8tFe6L+V6xsAEXCya63nEsATCMTEz2Nux
         Jxi/p0ExGRTt5CY8jn9qMw8L/Dnd14oI40dJ8rn2hZSkxOmcaIK2dujw10bqnpWl8KTE
         O5u9UgGKVNNwtF1v8ERZZA50YNYmxMDDwAzmrwwUvJpdcvLuOuVvp+8NsMjI7YBT5+AH
         UW6vLGQcZCDckSGB5tjka9a9vkNryxjXRjF8RzDm6x1lQvapwpbMSOowWMSDhYFaFq79
         8pBEyivp9cf7DJdptjN21bHMfjTLGCKi4KCksD3mAQ8JOpOsqYbpTvE9HdhWOXVrG+tS
         hgXA==
X-Forwarded-Encrypted: i=1; AJvYcCVC0A4srkSYLi0oLTrTmtTsfNweXNRCkFzv+SHYaF1ckr/M/oTWAE4x/VhImmxiDXf+KRKnNjo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3oY/Qenm06JWxJ8L4dKUIR1vu6VXQE4VmGMHFH8bcjcN5bxkn
	FVyQICpsyDVkoDL5sYtX98RFxVBT/sul077DF0K+2kTN7aD/sCTiQ7WVd3v/AZ2XgZWM0UeEPtV
	2vfafD9WstN+VJ+Btr0lefm/CoJqR7KYk33Th
X-Gm-Gg: ASbGnct26RUChWrXfrM3/6vGGLnyZMTnFVjtkn9yTH2aylJ2PVFYKFmvCSdWXws/Nov
	IjEbDZx4kfulxyZsjvuFwb1TLYtD6tywaAFCjXUSpXtNgyDbhrdVzMo0mrk9b51vyTl9JVJJkCb
	z4qQ37D8uRWvfhOOjIdQJFDa/3DnPL16ExeUFfPE1eFcp0cgyTQ0Nu8yRIusU0oK6w9Vim/DnaY
	HveKXJelfGoP6q/DZs0/pTyTp6scP46EFFDJH1iVU/0aGOscYNLCE6te+Hd4MCC854stYQ=
X-Google-Smtp-Source: AGHT+IEjcPOv6aPW6JO4Bb1jDowgVciSWSsWd+FNjyx3VBhgbx3Pj6ddYbo0M3Mtuw+ANHFx2AKfX0TCp1WB72JEhOk=
X-Received: by 2002:a05:620a:7106:b0:8b2:e5da:d316 with SMTP id
 af79cd13be357-8b33d48b7d4mr603659585a.87.1763794967475; Fri, 21 Nov 2025
 23:02:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-3-zhangshida@kylinos.cn> <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
In-Reply-To: <CAHc6FU7eL6Xuoc5dYjm9pYLr=akDH6ETow_yNPR0JpLGcz8QWw@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 22 Nov 2025 15:02:11 +0800
X-Gm-Features: AWmQ_bnR6g2ivQ9YSC5w0bIwME61y28InS6FucoZ4PBrcXjaLHV0KwJ_bufirnM
Message-ID: <CANubcdXx8Lp1JsqG3ctAE2V6jpuvJL93UH+7yHaAFtdMjHdijw@mail.gmail.com>
Subject: Re: [PATCH 2/9] block: export bio_chain_and_submit
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
22=E6=97=A5=E5=91=A8=E5=85=AD 01:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 21, 2025 at 9:27=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index 55c2c1a0020..a6912aa8d69 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -363,6 +363,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, =
struct bio *new)
> >         }
> >         return new;
> >  }
> > +EXPORT_SYMBOL_GPL(bio_chain_and_submit);
> >
> >  struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
> >                 unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> > --
> > 2.34.1
>
> Can this and the following patches please go in a separate patch
> queue? It's got nothing to do with the bug.
>

Should we necessarily separate it that way?
Currently, I am including all cleanups with the fix because it provides a r=
eason
to CC all related communities. That way, developers who are monitoring them
can help identify similar problems if someone asksfor help in the
future, provided
that is the correct analysis and fix.

Thanks,
Shida

> Thanks,
> Andreas
>
