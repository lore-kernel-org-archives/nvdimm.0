Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C644F217
	for <nvdimm@lists.linux.dev>; Mon,  1 Apr 2024 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711996056; cv=none; b=JZVz1eRNCElpK3rY6jItHPfvu6oLc9Zeegae8sQuAe8P+hc9xeVW9rGZgphPaQjJlayxBe23CJ9Hce5SRTnj+mIyUegeE0gR1PwimJHuR8AkAR7PU8/WXXopiE8lQh0JmelmW/LofB98hvueXmxE8HbjijjN7zJmzU+MR5rnvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711996056; c=relaxed/simple;
	bh=k4SXXcm2mz8yX6Tn9J6bfnKNwZT38ARoeA60Km6CYJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvSzLj9LhayuJIsGJ9hKjRPJd3bflOZS7shY4265VZlTE5826pRK+oK5J31LbPnH9QbmI9OWbLJEozUcfhDhrFL1HxLbcJf1xGAm5EuBxhRr1X9NC/HiZBAqnOmrR6oXPVAjk3dSKMsBephC6svy4sbY4FXGp5dVeUorZ1N3aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=X8XoKiI3; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="X8XoKiI3"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-dc6d9a8815fso4093746276.3
        for <nvdimm@lists.linux.dev>; Mon, 01 Apr 2024 11:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711996053; x=1712600853; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncAfdDQGFs7+0XI6NTF6RR9ikr8USButMq6raz2KWU4=;
        b=X8XoKiI3GnYABr4TLbIM5yhnwDM+E2zk843no6Ph2xwIL6mcyhxD2m4/R0Q1apds5b
         N4dtztV1Ffv2tcNyVZPvSybYexg5fJg6pUaaPx/CxT0Sc5e//OroPHDdVQ5oCpD90Zaf
         54fF7xqEBy7HnYdVxSJStfW8tXx0zWE1WMaGCaZx+Z9PNCB92kFBNyofj+v+OuRw63Dt
         P32pdvbqE4nL6d/bt2/N4S1BRBjZW3JgvYG2JBU3ueiRzVpZMIFNm909Y6xvO/g7HQPX
         eBJSZLey2gEN6KPKaqExjUGcd+6iT9mw6rFaIq3H2kmFqxKiR4GxqmXmVgA6LdEgEnR4
         p0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711996053; x=1712600853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncAfdDQGFs7+0XI6NTF6RR9ikr8USButMq6raz2KWU4=;
        b=wVxhkM9jyEbGVojS4Ku3ZjW1b6W8IoxUANgNMiALlEXF5bjwSviXeikHIqaoP4GrT/
         4tSYWoUajQRWf3mzDrqcY2wx0cXX8oEaWW+8oZWhh29a8uGV8kA1aQ8xgztvieiPVKTN
         eweW649IRkfiFgG/ox+EMDPUXI28ephCW6PPKVEWcVfING09/7BHtrXh96t7wcwaOres
         GxfQAZsDtEC7aEh/46A6S4v0JdaAObamGdrbuA8LruDTl3JdZe8IsGAyU367TmJftgig
         7FFrM8IFlCGnF4KzH+bcEEJCtuXe5dAx/GI9BgjK6gN+/vg+P4JS0mTZZwJyw5lktIeU
         +V1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDQLpha9VzOgc1Cwbc6H+Apt9f/21wRkgulvuPtn+00m9sNoCGChcwA8Jgoc8cRFxyuT+VWm35u/1SbzcPFS2z2RFB+Uhm
X-Gm-Message-State: AOJu0Yxb9bP+WQ/KkNSmzPLxcXny2TyDYsAGGnxp2mOAc1a2ud26pZun
	7wzv08pcBUWSmdyv1iMh9SysW9lxBWPpcJIm79LFZ/ic4MEgpZCSGpa8AoH+/pxJsgbpH+rYbkO
	G2BFi3zObkuahcnBwYLd+lmksf46N9XdS1l2WMA==
X-Google-Smtp-Source: AGHT+IEI9Qa2iIPgyqtzSTMMD59mn8yy6m6BsMg+kP0/hWrb91+VDm9zCf5PfWZzhMKbAlclVs3f+DNixIvCjL6iyp0=
X-Received: by 2002:a25:ff12:0:b0:dc6:d7b6:cce9 with SMTP id
 c18-20020a25ff12000000b00dc6d7b6cce9mr7881129ybe.57.1711996053583; Mon, 01
 Apr 2024 11:27:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240329053353.309557-2-horenchuang@bytedance.com> <20240331190857.132490-1-sj@kernel.org>
In-Reply-To: <20240331190857.132490-1-sj@kernel.org>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Mon, 1 Apr 2024 11:27:23 -0700
Message-ID: <CAKPbEqo3_zHF98SRoAz4L-CCGpEm8wN1P2RgPLa_q63e1qeGxQ@mail.gmail.com>
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

On Sun, Mar 31, 2024 at 12:09=E2=80=AFPM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Hi Ho-Ren,
>
> On Fri, 29 Mar 2024 05:33:52 +0000 "Ho-Ren (Jack) Chuang" <horenchuang@by=
tedance.com> wrote:
>
> > Since different memory devices require finding, allocating, and putting
> > memory types, these common steps are abstracted in this patch,
> > enhancing the scalability and conciseness of the code.
> >
> > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> > ---
> >  drivers/dax/kmem.c           | 20 ++------------------
> >  include/linux/memory-tiers.h | 13 +++++++++++++
> >  mm/memory-tiers.c            | 32 ++++++++++++++++++++++++++++++++
> >  3 files changed, 47 insertions(+), 18 deletions(-)
> >
> [...]
> > diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.=
h
> > index 69e781900082..a44c03c2ba3a 100644
> > --- a/include/linux/memory-tiers.h
> > +++ b/include/linux/memory-tiers.h
> > @@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adist);
> >  int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
> >                            const char *source);
> >  int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
> > +struct memory_dev_type *mt_find_alloc_memory_type(int adist,
> > +                                                     struct list_head =
*memory_types);
> > +void mt_put_memory_types(struct list_head *memory_types);
> >  #ifdef CONFIG_MIGRATION
> >  int next_demotion_node(int node);
> >  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
> > @@ -136,5 +139,15 @@ static inline int mt_perf_to_adistance(struct acce=
ss_coordinate *perf, int *adis
> >  {
> >       return -EIO;
> >  }
> > +
> > +struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct li=
st_head *memory_types)
> > +{
> > +     return NULL;
> > +}
> > +
> > +void mt_put_memory_types(struct list_head *memory_types)
> > +{
> > +
> > +}
>
> I found latest mm-unstable tree is failing kunit as below, and 'git bisec=
t'
> says it happens from this patch.
>
>     $ ./tools/testing/kunit/kunit.py run --build_dir ../kunit.out/
>     [11:56:40] Configuring KUnit Kernel ...
>     [11:56:40] Building KUnit Kernel ...
>     Populating config with:
>     $ make ARCH=3Dum O=3D../kunit.out/ olddefconfig
>     Building with:
>     $ make ARCH=3Dum O=3D../kunit.out/ --jobs=3D36
>     ERROR:root:In file included from .../mm/memory.c:71:
>     .../include/linux/memory-tiers.h:143:25: warning: no previous prototy=
pe for =E2=80=98mt_find_alloc_memory_type=E2=80=99 [-Wmissing-prototypes]
>       143 | struct memory_dev_type *mt_find_alloc_memory_type(int adist, =
struct list_head *memory_types)
>           |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>     .../include/linux/memory-tiers.h:148:6: warning: no previous prototyp=
e for =E2=80=98mt_put_memory_types=E2=80=99 [-Wmissing-prototypes]
>       148 | void mt_put_memory_types(struct list_head *memory_types)
>           |      ^~~~~~~~~~~~~~~~~~~
>     [...]
>
> Maybe we should set these as 'static inline', like below?  I confirmed th=
is
> fixes the kunit error.  May I ask your opinion?
>

Thanks for catching this. I'm trying to figure out this problem. Will get b=
ack.

>
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index a44c03c2ba3a..ee6e53144156 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -140,12 +140,12 @@ static inline int mt_perf_to_adistance(struct acces=
s_coordinate *perf, int *adis
>         return -EIO;
>  }
>
> -struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list=
_head *memory_types)
> +static inline struct memory_dev_type *mt_find_alloc_memory_type(int adis=
t, struct list_head *memory_types)
>  {
>         return NULL;
>  }
>
> -void mt_put_memory_types(struct list_head *memory_types)
> +static inline void mt_put_memory_types(struct list_head *memory_types)
>  {
>
>  }
>
>
> Thanks,
> SJ



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
