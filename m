Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D38013AD22
	for <nvdimm@lists.linux.dev>; Thu,  4 Apr 2024 21:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712264706; cv=none; b=qwEOq8Wv665++GDZAsSyxP4gi1wehCa/xpMukROla5hu3bqo7S75gOzvGMBUKZkJ+H+5xzZJDznNwUKuD5vOwlFRAF1H5txFu4Hfs2NLBN8hMKj2giMggLPxTQ3PKQWITaBzQaimNlN5pT/zJ6xZgZK9rfNm0nuicyLwGIOBtco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712264706; c=relaxed/simple;
	bh=V1bvfCjUMNTcwsT2lBKJF4J897CJP70t3WLaAcvFFS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMeQuW36/2DXKNVBOp/ki4+HzhXUr2cmp4z6GV0vlNerJWVnZo0Yte9PcCgPE2o3neQOQslhSSOhtiMzWYuHJE9+XL4sNf1JocE7F/fEKPQ2y3G6frTfQPlIIsYzbFYT3lW1VCagiuFwyaMzZcUNvOJkATHndYnP4QthC4Sa+IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=e61oW4lo; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="e61oW4lo"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-614b02f8ed6so22803867b3.0
        for <nvdimm@lists.linux.dev>; Thu, 04 Apr 2024 14:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712264703; x=1712869503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BEwoI7vaLN7STH+6B1HZ1H40SSE9uFhmcRIVexkA4A=;
        b=e61oW4lo8oBuAovU4nNgzeB1WUMWWVEGTVuqarrMno60CiTaIll0hje/vtPuOorqYa
         CWyZup4GF4Xcryt8NcsF4KwmYTVcPnMwk56nWkVPMDXYlBxzUvN37g31L1b9WVoQWBd5
         d/x3sS+56QIUSRCpbEY6CtZKY2fT89wsGdrwmu6xg0UIgGHhzsP/Po/NBQX1RG3saRPp
         389ahEz7taT8zaOpwXQbodDFVa7vSyvQqw818oRBBEKTEfbXDUht9wM+z/xUwJoWpAA2
         OKTfO9NOC2DJDVFvAeR+raPe6fESAxeiXi/Rwz1BUx8FcIdph6TfsZ/deIzllAHYHaga
         92Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712264703; x=1712869503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3BEwoI7vaLN7STH+6B1HZ1H40SSE9uFhmcRIVexkA4A=;
        b=PXhKgT4Ua1u3Cb/OppROaxMeRdFLZ9jFi1ajMYUMYfDZjgJ5fiWitnGpn24Go+Bk9I
         Sbf3WHHRzWL/Eobjt7T++kFXwWIJvRHTgAEGnrluvvuFkuKqrvvxPkaWymXibwyMMiru
         GaX/PahI2PDESvSHq7PlIUfUuV2rmGIRSUZcjrVt1aQ+9isPtSO+uSFGt5NM8E+m8/3I
         WNgHGsY4bWm/+5rtFlsjpc7L4iE6+oN9viUya/q7iOZs8JR4QXeHabEVbPgonf/8Fs38
         qGbSCtvWlg+nISmeM+SeDMJr7FcRMjKuvuFvxfSItI1dib5+a3uUspK+nYl2HXzCVINn
         9+Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWe9wtqdNY6jpAf/r0lDfDERB/rzFU6DV/brM4iT0BGyuuaWcwAA/Mg7c+PM153xFBLt333+3ddhAMhXKy3qouf0Mt2mYKD
X-Gm-Message-State: AOJu0YzZYa2Z16w9GsZsq47CQ6qS55DtQFTa1E1sspu5fuQ9k229MiFR
	U4aJ150XnTYYPrMiQuk+Z+vt2XreOrBTX2KjyQX8W8m4pvratJk14du8wPPcchRCMIGWecNKsrX
	OsKit1Oatq/Tl7bjNKT4Ff5EtP02Hyjyn7Nh1sA==
X-Google-Smtp-Source: AGHT+IG6KpWakGj8bl6wl0XaCmeiykXs6HQkS3DMCudH9AT087DNiiXeU48IwUZnyWYEgunzOmtd5Z4JvSn2JDWo2cM=
X-Received: by 2002:a25:bc50:0:b0:dcc:5b7e:ddfe with SMTP id
 d16-20020a25bc50000000b00dcc5b7eddfemr549930ybk.4.1712264702360; Thu, 04 Apr
 2024 14:05:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240402001739.2521623-1-horenchuang@bytedance.com>
 <20240402001739.2521623-3-horenchuang@bytedance.com> <20240403180425.00003be0@Huawei.com>
 <CAKPbEqoJZe+HWHhCvBTVSHXffGY2ign3Htp4pfbFb4YVJS_Q2A@mail.gmail.com> <20240404143733.00004594@Huawei.com>
In-Reply-To: <20240404143733.00004594@Huawei.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Thu, 4 Apr 2024 14:04:51 -0700
Message-ID: <CAKPbEqpp-mFv0bnOPtk0hFYVqA5y-e-T3QMWrS19g00Mob6D+g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v10 2/2] memory tier: create CPUless memory
 tiers after obtaining HMAT info
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Gregory Price <gourry.memverge@gmail.com>, 
	aneesh.kumar@linux.ibm.com, mhocko@suse.com, tj@kernel.org, 
	john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, "Ho-Ren (Jack) Chuang" <horenc@vt.edu>, 
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org, 
	Hao Xiang <hao.xiang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

Thank you! I will fix them and send a V11 soon.

On Thu, Apr 4, 2024 at 6:37=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> <snip>
>
> > > > @@ -858,7 +910,8 @@ static int __init memory_tier_init(void)
> > > >        * For now we can have 4 faster memory tiers with smaller adi=
stance
> > > >        * than default DRAM tier.
> > > >        */
> > > > -     default_dram_type =3D alloc_memory_type(MEMTIER_ADISTANCE_DRA=
M);
> > > > +     default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADIST=
ANCE_DRAM,
> > > > +                                                                  =
   &default_memory_types);
> > >
> > > Unusual indenting.  Align with just after (
> > >
> >
> > Aligning with "(" will exceed 100 columns. Would that be acceptable?
> I think we are talking cross purposes.
>
>         default_dram_type =3D mt_find_alloc_memory_type(MEMTIER_ADISTANCE=
_DRAM,
>                                                       &default_memory_typ=
es);
>
> Is what I was suggesting.
>

Oh, now I see. Thanks!

> >
> > > >       if (IS_ERR(default_dram_type))
> > > >               panic("%s() failed to allocate default DRAM tier\n", =
__func__);
> > > >
> > > > @@ -868,6 +921,14 @@ static int __init memory_tier_init(void)
> > > >        * types assigned.
> > > >        */
> > > >       for_each_node_state(node, N_MEMORY) {
> > > > +             if (!node_state(node, N_CPU))
> > > > +                     /*
> > > > +                      * Defer memory tier initialization on CPUles=
s numa nodes.
> > > > +                      * These will be initialized after firmware a=
nd devices are
> > >
> > > I think this wraps at just over 80 chars.  Seems silly to wrap so tig=
htly and not
> > > quite fit under 80. (this is about 83 chars.
> > >
> >
> > I can fix this.
> > I have a question. From my patch, this is <80 chars. However,
> > in an email, this is >80 chars. Does that mean we need to
> > count the number of chars in an email, not in a patch? Or if I
> > missed something? like vim configuration or?
>
> 3 tabs + 1 space + the text from * (58)
> =3D 24 + 1 + 58 =3D 83
>
> Advantage of using claws email for kernel stuff is it has a nice per char=
acter
> ruler at the top of the window.
>
> I wonder if you have a different tab indent size?  The kernel uses 8
> characters.  It might explain the few other odd indents if perhaps
> you have it at 4 in your editor?
>
> https://www.kernel.org/doc/html/v4.10/process/coding-style.html
>

Got it. I was using tab=3D4. I will change to 8. Thanks!

> Jonathan
>
> >
> > > > +                      * initialized.
> > > > +                      */
> > > > +                     continue;
> > > > +
> > > >               memtier =3D set_node_memory_tier(node);
> > > >               if (IS_ERR(memtier))
> > > >                       /*
> > >
> >
> >
>


--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
