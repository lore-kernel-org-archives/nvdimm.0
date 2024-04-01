Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A291A56B62
	for <nvdimm@lists.linux.dev>; Mon,  1 Apr 2024 23:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712012794; cv=none; b=Jws+wq8EdVRjpTAmKYs0AWrqi4OwD4/Lrsm5/rO4tEzz9u7FZfDE51P/FmZucQNegfIFLk1/2uwQKNm0QvSOfjhLYuIdgK/ETM1KbRleT1cc/thfyq5DPE+7ei3EpvM9BvYqnhmcYK0OYkisP0pyR76bBA9KPOAmozxWJKU+QDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712012794; c=relaxed/simple;
	bh=TbpC8M+7RPwppbkhzTamYJOLZlUu6MTKc06W4CbpxE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dNvnXaK8AwBJ+DXT8L5QBHkR0ARMqVmGAr5blcB5dUpkl2fQI8IVS/qJ5hn/TMbXL7fHR8sZ59CKiXxD9zoePGBqdLCTgb5pGEbpe1QnimdyCDi/b3OSrGvbzW6aDHWgweDwEYbC1MpfrBSxwmeHsmRec68jAauYX4T1Zi2AXho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=PZCv0DFu; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="PZCv0DFu"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-dc74435c428so4335302276.2
        for <nvdimm@lists.linux.dev>; Mon, 01 Apr 2024 16:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712012791; x=1712617591; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8nGCphDC2lDqE/CSbphHfkuC3TvEewjmAtLy2kdkps=;
        b=PZCv0DFupz6tc+rKIm5Xx4Hq3SIobpP51h6ciiwk4JsKK4Es3DIfaPWxy21WFSPC3z
         8kceKTfkbP5psHFMJo8r/Eo79xAn4OlHfrctKgOYC5pVcJTGAnBvuPdUdCgsbAjhjPeF
         wFpK9fB9osOYmL8/fOxjzvScJXGJn4GkfXmC3mgA3W5UZTN20BrQQlAJc8YpKBvqdL3/
         IHXlCbnQY3miyEoi0BH95Y3fCyDluk1GCSSJDfOzL49/zRFdlDuXPLTL316trm0J5tnq
         G4uQjM4WASVhBpUsBhYA9Stu0+FCs83sK1RActRoH/Ut8qsDUP90ujCIzEHC7DhQUIq0
         Ztqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712012791; x=1712617591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8nGCphDC2lDqE/CSbphHfkuC3TvEewjmAtLy2kdkps=;
        b=VuPXWE/dU42pT6zOOQPvCem0isQav+YCDXBvKTZKQiawj+/9A6xleK8b95hWfzz0tX
         FtPzUOxLRk+pAeXfDjcKSiQQfTuvHKizTjsoM27Hqp1a20+Ob5AtaY6xxA7I78E7ZQ++
         sYnpQegZlP9IYw96h8TuUrnerI4KdEFNqCZOxRtEXaI3Y4YX+1OdT0CI/mpnGCmSMJXu
         UZfIbGuDiBxI58/Oqth+NpIdTevfX19jDPQUMoCRHcgpZvAqnt1EVS0hYni+P1wSoiF8
         GxEqQYdScBOebV5xLjHYu6RCcyGwiJdDdrAZNsWysuxJhgV1KGZyjvS/P0ygQknwS99l
         13tA==
X-Forwarded-Encrypted: i=1; AJvYcCXzlZbgz5mHLEu248Av6BAFo+smX6KUri44ZN0NdM5AgCmJsxe0HxKz2xVVuG9bI7crKsF01NoanujMZmA4PpKNYP1O3wM8
X-Gm-Message-State: AOJu0YxoLg8uDP4JpUB/QHJLxre1YfU/RKbek8wqHz0v/Kdb0C7WdXFO
	DT2r3kbCGz59/uQsWIlELje/47QY4YtrPe7Lao+lbjd8H5BJ3xqHaW5PHEBrym28hclHgHUWI9L
	zuc3a52Kun1HpoQg7Z6OVKvBmmThL3G8twmza0Q==
X-Google-Smtp-Source: AGHT+IHzFkHkXRaCjC8Uy5FTEb4BrGRIOAJ4uvIAnoieQDU096hzOpi7JP+GKKrquqv5tMmb8A6yVyiIs7YwfEUYlA0=
X-Received: by 2002:a25:bb51:0:b0:dcf:30d9:1d7b with SMTP id
 b17-20020a25bb51000000b00dcf30d91d7bmr9194408ybk.45.1712012791583; Mon, 01
 Apr 2024 16:06:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240329053353.309557-2-horenchuang@bytedance.com>
 <20240331190857.132490-1-sj@kernel.org> <CAKPbEqo3_zHF98SRoAz4L-CCGpEm8wN1P2RgPLa_q63e1qeGxQ@mail.gmail.com>
In-Reply-To: <CAKPbEqo3_zHF98SRoAz4L-CCGpEm8wN1P2RgPLa_q63e1qeGxQ@mail.gmail.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Mon, 1 Apr 2024 16:06:21 -0700
Message-ID: <CAKPbEqpsE8aqH0t6iKmuLkhjFX2CfRK70K5U0eC1VvAyk8ofKg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v9 1/2] memory tier: dax/kmem: introduce an
 abstract layer for finding, allocating, and putting memory types
To: SeongJae Park <sj@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Gregory Price <gourry.memverge@gmail.com>, 
	aneesh.kumar@linux.ibm.com, mhocko@suse.com, tj@kernel.org, 
	john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SeongJae,

On Mon, Apr 1, 2024 at 11:27=E2=80=AFAM Ho-Ren (Jack) Chuang
<horenchuang@bytedance.com> wrote:
>
> Hi SeongJae,
>
> On Sun, Mar 31, 2024 at 12:09=E2=80=AFPM SeongJae Park <sj@kernel.org> wr=
ote:
> >
> > Hi Ho-Ren,
> >
> > On Fri, 29 Mar 2024 05:33:52 +0000 "Ho-Ren (Jack) Chuang" <horenchuang@=
bytedance.com> wrote:
> >
> > > Since different memory devices require finding, allocating, and putti=
ng
> > > memory types, these common steps are abstracted in this patch,
> > > enhancing the scalability and conciseness of the code.
> > >
> > > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> > > ---
> > >  drivers/dax/kmem.c           | 20 ++------------------
> > >  include/linux/memory-tiers.h | 13 +++++++++++++
> > >  mm/memory-tiers.c            | 32 ++++++++++++++++++++++++++++++++
> > >  3 files changed, 47 insertions(+), 18 deletions(-)
> > >
> > [...]
> > > diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tier=
s.h
> > > index 69e781900082..a44c03c2ba3a 100644
> > > --- a/include/linux/memory-tiers.h
> > > +++ b/include/linux/memory-tiers.h
> > > @@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adist);
> > >  int mt_set_default_dram_perf(int nid, struct access_coordinate *perf=
,
> > >                            const char *source);
> > >  int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)=
;
> > > +struct memory_dev_type *mt_find_alloc_memory_type(int adist,
> > > +                                                     struct list_hea=
d *memory_types);
> > > +void mt_put_memory_types(struct list_head *memory_types);
> > >  #ifdef CONFIG_MIGRATION
> > >  int next_demotion_node(int node);
> > >  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)=
;
> > > @@ -136,5 +139,15 @@ static inline int mt_perf_to_adistance(struct ac=
cess_coordinate *perf, int *adis
> > >  {
> > >       return -EIO;
> > >  }
> > > +
> > > +struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct =
list_head *memory_types)
> > > +{
> > > +     return NULL;
> > > +}
> > > +
> > > +void mt_put_memory_types(struct list_head *memory_types)
> > > +{
> > > +
> > > +}
> >
> > I found latest mm-unstable tree is failing kunit as below, and 'git bis=
ect'
> > says it happens from this patch.
> >
> >     $ ./tools/testing/kunit/kunit.py run --build_dir ../kunit.out/
> >     [11:56:40] Configuring KUnit Kernel ...
> >     [11:56:40] Building KUnit Kernel ...
> >     Populating config with:
> >     $ make ARCH=3Dum O=3D../kunit.out/ olddefconfig
> >     Building with:
> >     $ make ARCH=3Dum O=3D../kunit.out/ --jobs=3D36
> >     ERROR:root:In file included from .../mm/memory.c:71:
> >     .../include/linux/memory-tiers.h:143:25: warning: no previous proto=
type for =E2=80=98mt_find_alloc_memory_type=E2=80=99 [-Wmissing-prototypes]
> >       143 | struct memory_dev_type *mt_find_alloc_memory_type(int adist=
, struct list_head *memory_types)
> >           |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >     .../include/linux/memory-tiers.h:148:6: warning: no previous protot=
ype for =E2=80=98mt_put_memory_types=E2=80=99 [-Wmissing-prototypes]
> >       148 | void mt_put_memory_types(struct list_head *memory_types)
> >           |      ^~~~~~~~~~~~~~~~~~~
> >     [...]
> >
> > Maybe we should set these as 'static inline', like below?  I confirmed =
this
> > fixes the kunit error.  May I ask your opinion?
> >
>
> Thanks for catching this. I'm trying to figure out this problem. Will get=
 back.
>

These kunit compilation errors can be solved by adding `static inline`
to the two complaining functions, the same solution you mentioned
earlier.

I've also tested on my end and I will send out a V10 soon. Thank you again!

> >
> > diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.=
h
> > index a44c03c2ba3a..ee6e53144156 100644
> > --- a/include/linux/memory-tiers.h
> > +++ b/include/linux/memory-tiers.h
> > @@ -140,12 +140,12 @@ static inline int mt_perf_to_adistance(struct acc=
ess_coordinate *perf, int *adis
> >         return -EIO;
> >  }
> >
> > -struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct li=
st_head *memory_types)
> > +static inline struct memory_dev_type *mt_find_alloc_memory_type(int ad=
ist, struct list_head *memory_types)
> >  {
> >         return NULL;
> >  }
> >
> > -void mt_put_memory_types(struct list_head *memory_types)
> > +static inline void mt_put_memory_types(struct list_head *memory_types)
> >  {
> >
> >  }
> >
> >
> > Thanks,
> > SJ
>
>
>
> --
> Best regards,
> Ho-Ren (Jack) Chuang
> =E8=8E=8A=E8=B3=80=E4=BB=BB



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
