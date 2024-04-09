Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAA1156C6D
	for <nvdimm@lists.linux.dev>; Tue,  9 Apr 2024 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712704205; cv=none; b=iB9MsVWrpea4DFLHU6FtqPxaT0wEuGwWxIeIwADlEjuwSo/IuMpzt0Ib0gG1cI16a2BjsG8ZtNS/BEVRQH7dcg2KPtMCn+K6MLBjW2QbD3/rENP6+dfT7HL05rl13yvPwK0G0R/Z3yvwIvt6QXzWPcaOawvFE7Xs5XD6fR2IKNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712704205; c=relaxed/simple;
	bh=MnSBREf1/ZfgMhsdgHA0pvIo22AgghcA4rYn6itMmko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GwCf5cB996+Ukts8i0haPDQJFr0xOAdGu0v+JW7LAanii2vHQtAowzd+0uEWrKMbFyttQN1boPAfYURJmhaEGMW3+/zMfL3DtNVYtX3GM+UzsGsdWOFxrtNtzdCwTgzgRZr2BWYVY1E+RHx3CyX+ncTxSFqmkPNH9fBsbfxuhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=l1StCB93; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="l1StCB93"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-dc6cbe1ac75so4666671276.1
        for <nvdimm@lists.linux.dev>; Tue, 09 Apr 2024 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712704203; x=1713309003; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBQMpIqEurG8MF/tPT1PXk9SqhO/wjdruY1OsEdLqVc=;
        b=l1StCB93oauBMwpXLbFAFJDn8Jn4IJan+FMbwIQsrDWi1UJ1oBjWWjo3tz/TYP3ftu
         ZS2baPAk3XewV/dw9QY1dTCAmbcnwg4kYznBckFF+SUibb8vp8l3IkFkQ5XcfuvidC4R
         9afO9693dctPKvXUcrrqimX+pHKb29lqGftUYkBKwqtrjc4yNc22GzXoK0jG0iKR4yjR
         8uJ++iU7H2t3IpmC1ZvaxPIdyIm9qWon0gpYyp0XovsyRN6kWFu0Dx5XCTepEWmiAkji
         USXdKkIzp3rV6PlgrjblIMVrL4ZzVP80awaKn5B9yNQ1SOhB+HfHol07dyWZQ2k0lL5x
         I1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712704203; x=1713309003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CBQMpIqEurG8MF/tPT1PXk9SqhO/wjdruY1OsEdLqVc=;
        b=hE4i5swgcPGHdXlIi5C8xXJZEZkq+bR+43+3HCzuzWbWw+koNrzsa4id3Y6jGto5G+
         FEpcQAGDUe2IPtOWjp10OToxlHPeBy3Gj6YVZu7Kd/r2NrYz4OuyVSgCNOajhA49yqMH
         6hKaGnkH5nXGQ97uZ4tp7Gdq01V2+4h2RZl+bie70SYhTs2AMLrI3/PPFT3VP8jE3B0e
         W4U1gdjUrTZ1WsrmGCP2oimVhInINtxLeVKQlhV7bnfkMBo7evVGpK8jUtMUp+uBK7hz
         ywOsp7AlCsMxqqLhCsn12n40eq/Je/aBOfntamJBZl9JMazAXO7IVfpl/xpu06MX4xff
         GMUw==
X-Forwarded-Encrypted: i=1; AJvYcCWK6tDasYnoyLC8zuEMv0pDUDm23SxOnuFIO65MlT+J9o3cJjlvV9DhDNM8S5fbXiy4qRXZAY6F/gt3OJpQ8Aad/VgBfn5r
X-Gm-Message-State: AOJu0YyIewtOjnpsyohAW/c6s1UPEYfW0yL2KfGzU7xmh2lAqGyNplA2
	JictiomMbb/TaxE89zSFqK+yr+aILjLTobt7AuVAK3phdMcwIm3PmnOHkn50LWFE1NpYpnNF151
	jdgRMKyioO7jFwS/wQT5FG9HMtYEVtgeok9MYjQ==
X-Google-Smtp-Source: AGHT+IGKj70giI0uSMILbO3VPM9mbHT4HM6rigAIadI6TUaytzdkRQBEfqv4b6oKHX4IAAJuxwSf30E0yhjaCwWCgiY=
X-Received: by 2002:a25:f306:0:b0:de0:cd0f:e9ac with SMTP id
 c6-20020a25f306000000b00de0cd0fe9acmr2372195ybs.31.1712704202827; Tue, 09 Apr
 2024 16:10:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
 <20240405000707.2670063-2-horenchuang@bytedance.com> <20240405145624.00000b31@Huawei.com>
 <CAKPbEqrTvY4bsRjc=wBWpGtJM5_ZfH50-EX4Zq2O_ram9_0WbQ@mail.gmail.com> <20240409145018.e2d240f9a742cc15ff7bc11e@linux-foundation.org>
In-Reply-To: <20240409145018.e2d240f9a742cc15ff7bc11e@linux-foundation.org>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Tue, 9 Apr 2024 16:09:52 -0700
Message-ID: <CAKPbEqqWLrD-bJiyE9Yc0CYLh_8_uMtf+9nD_eenXh3S=Ro=pQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v11 1/2] memory tier: dax/kmem: introduce
 an abstract layer for finding, allocating, and putting memory types
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Gregory Price <gourry.memverge@gmail.com>, aneesh.kumar@linux.ibm.com, mhocko@suse.com, 
	tj@kernel.org, john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 2:50=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue, 9 Apr 2024 12:00:06 -0700 "Ho-Ren (Jack) Chuang" <horenchuang@byt=
edance.com> wrote:
>
> > Hi Jonathan,
> >
> > On Fri, Apr 5, 2024 at 6:56=E2=80=AFAM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Fri,  5 Apr 2024 00:07:05 +0000
> > > "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
> > >
> > > > Since different memory devices require finding, allocating, and put=
ting
> > > > memory types, these common steps are abstracted in this patch,
> > > > enhancing the scalability and conciseness of the code.
> > > >
> > > > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > > > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> > > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawie.com>
> > >
> > Thank you for reviewing and for adding your "Reviewed-by"!
> > I was wondering if I need to send a v12 and manually add
> > this to the commit description, or if this is sufficient.
>
> I had added Jonathan's r-b to the mm.git copy of this patch.

Got it~ Thank you Andrew!

--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
