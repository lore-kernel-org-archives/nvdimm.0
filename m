Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D392FFFAE
	for <nvdimm@lists.linux.dev>; Fri,  5 Dec 2025 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764924961; cv=none; b=s2I1x6zBH6c4I3U4naBYWmKFDcTEja3ARDtOBa8Ex7774nqZ1X9lgwGp8wS5KN5GQ+4horWyZoPQ5Op7klZGTduBOzssyiEhtxItzdqH42wjaoxXrORk3SnDzYExQgFhyqxTUBEVL8uIJLFAl3oROEpVrrfxzDka7ej9y5ptXm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764924961; c=relaxed/simple;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0zd7evN8OHgpt373ElY4XJgSZQ7CaW5PbllEcZiZz9bgLhYjuS9eaFgiLiLaztPJpilmklvt+nEvwqeyt71/hD7LBrRxZAPTfFoGoHQbp2j8nQ/HSrAQ0t5XRyKnJsvk12TIqk0llmxgC7g3DYYpZE2KnY3v5l4/b2iX+3fu6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=imTo4pO3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="imTo4pO3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764924953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	b=imTo4pO3zy/73+VWMX+SjPE08Js9OwifnSo+fHt2mVNaiXnZ7GLR/rIRPpDNAJVuyhF5F7
	cwTQtC31xFW+IRFmp8bWijDhXlPyV1tH1xLAY19Zkl7AT7pdqjP9ms7a/wPpdAr7ZIMWUT
	Q9WQCpfZu5wbgItd0zMWn0WwZWU7euw=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-kxGbsr-1OX6h8vP6TbDZvA-1; Fri, 05 Dec 2025 03:55:51 -0500
X-MC-Unique: kxGbsr-1OX6h8vP6TbDZvA-1
X-Mimecast-MFC-AGG-ID: kxGbsr-1OX6h8vP6TbDZvA_1764924951
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-64203afd866so3081121d50.0
        for <nvdimm@lists.linux.dev>; Fri, 05 Dec 2025 00:55:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764924951; x=1765529751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
        b=TZX7FnSf0zpamgIB4NfEbYmaj+BJtsMvopna6Lwnyoh6Y4EHFcP5ufSjorE44eWcuR
         kuqhgfFtdEgGTWEveS+KisigvdVwfHki5ldAN1ZZlzWFej4co7Hw4YhEhEi+Pd0N+ZHW
         BujRDlEp4HfmjB3WzmhpYuLakAaVC91GrnRxMTaOC8YcQSehJKfNth/I8+LHbLyyVUV8
         KYC8JdgBBFcc0fqwLbP82PIoh6s+CNvgbSqF8iKsY5P54cWjA9Zg8rsG4uxtpFDnDTGl
         rpxzvWIvDv2+q1pmshiaBgGKfQuUVZanz+TBfLrcMnfde4neK6a3UUKZgBgkXYba9fmL
         9Z1A==
X-Forwarded-Encrypted: i=1; AJvYcCVEzlmnun1EtH8z/4adgPiwXW+9y9itKXmXVxLJ/KrJ9aGlxy4k1wBP/D9iQ2E4c+BsZC5Ymi0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9Hkl6Kd6WSCHhhgStL5OtsFJtoh0iDxjSerZL4Fkla8G9Z3zZ
	9NjFmPXDwzSDcLDjrcHpd1MTatLA1t+bx7pYyhV02no0pwrqrAmFXDIDNLUvve69VLCGN9xMj2S
	ben8RAz9++WBMn6fOLaCOjsHxM6dL2uLnhFGaefFlwcW16/Leoc2xrd+wM03EjPcuzeNJ8uVTUM
	m+WCxlai5I4RlXgfLrkjt7VQbDfBTrDwoO
X-Gm-Gg: ASbGncsJlmc2nJZLDY0egb+9gJFuMs5UU7eribhpfEfN8oZuF+DqDru1R6Dxx38LuCz
	R74e/ggAuTnGEdqM1OA4J2W+p7Dz/fDFqCFe/sFMUwuM8m2wXEFe+wuK0BHvYIcQkjeRG4GOjSk
	O4ZDX8zxZkJRwOsKoYaO6r5tTwlM1bMZ3hyUaOe1s81H81ei3lYrn5cDkCCfup9JOC
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id 956f58d0204a3-6443d6e683bmr5035637d50.9.1764924951090;
        Fri, 05 Dec 2025 00:55:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH06t5ScTL3/41cXQ9/KNdNBUKke6bRZRDIIsDOJI/s90MmtU+OELXMsXOy8CKQ41Y5BIrK12B8cMtyqGUq3aU=
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id
 956f58d0204a3-6443d6e683bmr5035612d50.9.1764924950709; Fri, 05 Dec 2025
 00:55:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
 <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com> <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
In-Reply-To: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 5 Dec 2025 09:55:39 +0100
X-Gm-Features: AWmQ_bn5nYIfNoOVXdPvu9TIQvwvBK4TRvGDwrtrakvgOSxNJSsbjWkIZFSXMho
Message-ID: <CAHc6FU4G+5QnSgXoMN726DOTF9R-d88-CrfYMof0kME6P_o-7w@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j8rt9ebjJ0XvYbt_mba3CwVyq4RwbXN-QQtcPTYoZs4_1764924951
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 8:46=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail.co=
m> wrote:
> Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=
=884=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@r=
edhat.com> wrote:
> > > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@g=
mail.com> wrote:
> > > > This one should also be dropped because the 'prev' and 'new' are in
> > > > the wrong order.
> > >
> > > Ouch. Thanks for pointing this out.
> >
> > Linus has merged the fix for this bug now, so this patch can be
> > updated / re-added.
> >
>
> Thank you for the update. I'm not clear on what specifically has been
> merged or how to verify it.
> Could you please clarify which fix was merged,

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8a157e0a0aa5
"gfs2: Fix use of bio_chain"


> and if I should now resubmit the cleanup patches?
>
> Thanks,
> Shida
>
> > Thanks,
> > Andreas
> >
>

