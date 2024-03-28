Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B6942A88
	for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711612466; cv=none; b=X6Kw5z8BA4loycL3bLUztWejNWu6BPK2/FtcAh56OCoCaXS59hvHV9qMSEF9fy2x5UgdIg8UhUZ0VqIYmqLNBbvp8xwMylHPiQvwLtWsPGaeIWU2u0D+p03rfQ6YO4Ew69/9jqjQcA6d+Rhe4sMISNMhwtySdshYMdRsGgL9zns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711612466; c=relaxed/simple;
	bh=30bAraAl/KuCq2L2WJtfoMDiNEUxCBxMkCbL1xWURV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ir9K6NBRruWB24TikVwVVL1nTYj8/0fUFgJk4QvluZAmc/VustjmB0s2FsQ7VRZ9asqODEWa1+lF7Xxv41gr2vupI7JyBjQ/LsDiyi8tfrCa0Ya83Mn9yaF26zkDe9FyiAaSkG3fQk6PzQRwSuIpJAUNnxUUxwSUc9UTlFl1GHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Z8QWSsD8; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Z8QWSsD8"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-ddaad2aeab1so602463276.3
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 00:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1711612463; x=1712217263; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbC5cWd3WAP709PDHIqZn6WUv4KT91ju291e26yekHU=;
        b=Z8QWSsD8WHMHBGfRHiniOZJ5pCwpojmYQJGon1G5zt1c1ePzaTmWuB5daFx2A64MBf
         dCC9bSFfbgVnJG2+1jJzSE/CMPjiWe4ul0Q+/jad9vtJ374Of2dzlsHyvtXgWQuVOWw1
         C1jhHa0q5td8RHyJX90nmlgxA9IFg8UaAHg+mPXU2vGxPU+iQdoM0rIIipowhmWculuw
         4NM+mtwczJzbi4TLwufL85ZEbctgPv52SBSbVrScXGItD3Mfhbg1ZOX0hnYpmV9pyvX0
         0zyB/EDKhMvz5CtQxQux3ZmcRDHCQnsBXMCI/ZAbOjBtiytoTEwxWJ/96gGyfe8h9H2f
         IqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711612463; x=1712217263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QbC5cWd3WAP709PDHIqZn6WUv4KT91ju291e26yekHU=;
        b=K9BlqWcc+8T+fmTrVThecMo4y82gFpTqY9TDjB1ytrAS9FJT9HtyQDC7Pkw8urH7aE
         O6Oy4HIiVYKxpZkAFK0LYnKu7CFb1OPgGwfW93AcxIUa6c2dVp0a3O89r3vN8f6ON8Ss
         JLlwn3TxZJurbNvElfwxIr7NGVWfZTZYDesfooxGg8lo0HUZEc3eu226q/oGSelW/5G6
         HtFFHqZDhh3fzwk1U51RPkpse0IZ6cPwxlCODH5Dwc/53Q8FW86KChaixjYzxlSXaJqx
         ywEIIOm2WxB1HLtoIXM8X4oUiuKVu6Gtdf+IsegRvxfOUO9WWgCeBCHxMa3a36WKAlJV
         fUMw==
X-Forwarded-Encrypted: i=1; AJvYcCVYcnbk80RdGQk0xstItllfAG8fnq5hxBY4wzub23bsMbDJ+AvnAv/rlQZ6hALFdYyczSkukugQj154GJ2SsSSHaUPmpCA0
X-Gm-Message-State: AOJu0YyUbuniLbafk1fKYwf/Au6OpJlWgh/YpXc5izXwgyINnyAV0SHM
	Rmdrxt57ZdWJF5vkN+juA6gKsyGBHnk6wbezTYn78+eAItOf7f6bfaejCF84MoIKACol0cpapX6
	RptWZmXRN1NF5CE7paG9m+/wcsyD6Odq4irCLOiJzGsdIZPugP/k=
X-Google-Smtp-Source: AGHT+IEdkLQhpRPn4k1IyjPDs5Vv2uuU8cYVmBxxxsVzJXO5QupQAGy5BtVXsboyybOzZeHVOtwZZhZHHoOjBTG7fIw=
X-Received: by 2002:a25:ab26:0:b0:dc6:a223:bb3b with SMTP id
 u35-20020a25ab26000000b00dc6a223bb3bmr2099954ybi.46.1711612463662; Thu, 28
 Mar 2024 00:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327072729.3381685-1-horenchuang@bytedance.com>
 <20240327072729.3381685-3-horenchuang@bytedance.com> <87v857kujp.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87v857kujp.fsf@yhuang6-desk2.ccr.corp.intel.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Thu, 28 Mar 2024 00:54:13 -0700
Message-ID: <CAKPbEqrhBLQ67ciUTukGTB0eC3G_JHcTEMfbiw_PtnGBSv=ksw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v6 2/2] memory tier: create CPUless memory
 tiers after obtaining HMAT info
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>, aneesh.kumar@linux.ibm.com, mhocko@suse.com, 
	tj@kernel.org, john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org, 
	Hao Xiang <hao.xiang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 6:37=E2=80=AFPM Huang, Ying <ying.huang@intel.com> =
wrote:
>
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> writes:
>
> [snip]
>
> > @@ -655,6 +672,34 @@ void mt_put_memory_types(struct list_head *memory_=
types)
> >  }
> >  EXPORT_SYMBOL_GPL(mt_put_memory_types);
> >
> > +/*
> > + * This is invoked via `late_initcall()` to initialize memory tiers fo=
r
> > + * CPU-less memory nodes after driver initialization, which is
> > + * expected to provide `adistance` algorithms.
> > + */
> > +static int __init memory_tier_late_init(void)
> > +{
> > +     int nid;
> > +
> > +     mutex_lock(&memory_tier_lock);
> > +     for_each_node_state(nid, N_MEMORY)
> > +             if (!node_state(nid, N_CPU) &&
> > +                     node_memory_types[nid].memtype =3D=3D NULL)
>
> Think about this again.  It seems that it is better to check
> "node_memory_types[nid].memtype =3D=3D NULL" only here.  Because for all
> node with N_CPU in memory_tier_init(), "node_memory_types[nid].memtype"
> will be !NULL.  And it's possible (in theory) that some nodes becomes
> "node_state(nid, N_CPU) =3D=3D true" between memory_tier_init() and
> memory_tier_late_init().
>
> Otherwise, Looks good to me.  Feel free to add
>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
>
> in the future version.
>

Thank you Huang, Ying for your endorsement and
the feedback you've been giving!

> > +                     /*
> > +                      * Some device drivers may have initialized memor=
y tiers
> > +                      * between `memory_tier_init()` and `memory_tier_=
late_init()`,
> > +                      * potentially bringing online memory nodes and
> > +                      * configuring memory tiers. Exclude them here.
> > +                      */
> > +                     set_node_memory_tier(nid);
> > +
> > +     establish_demotion_targets();
> > +     mutex_unlock(&memory_tier_lock);
> > +
> > +     return 0;
> > +}
> > +late_initcall(memory_tier_late_init);
> > +
>
> [snip]
>
> --
> Best Regards,
> Huang, Ying



--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
