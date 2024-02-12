Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C23D3F9FC
	for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707761421; cv=none; b=SHW5POmiZzigTrrAxWe70LuxZYJmaz/SzMcldZlSPyAyi7YML2Q8/Mc6uYTGfzazNbrDxivhxjK/n1C5NrgJLQMBRvsN9hgXQHYz3W7EZUS0RgLKKxQrVQvH3IbKIFZr/PIDaJW+cBGAep/mEnZIGd4ot2h6N3h/f1qlMsQVL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707761421; c=relaxed/simple;
	bh=tUH75BMR8RlaXQRraRAUrPJTcnun0Jtn3Z6gldXyKIk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XXbsJmNFeTWnGvbtuXvlLZHNGhYT1Re6GkRguzxrZ3TNbEgpqMr6d7eqsG38orrm1H/FYpUXBjuL/pS0R6vdL1+bBtIVRnc55H/jA+/hrXLK/DdzyjN5LKzICiYqw4vtTR4N6m1qXezzxRcJ9Pw5EChR/4cW5+qXvnlc5ONmgVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WEvvGvQs; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEvvGvQs"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5601eb97b29so6300981a12.0
        for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 10:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707761417; x=1708366217; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=twQ8ztHBF6EEP2CTDTo73x3N0hT2u1lGwcIeQMe0GDc=;
        b=WEvvGvQsfUxIFIyLikOcbZsGTwi4Ij/5P+2SSXiwVYAWbrQgYZypW5HZLfdFOFgVF5
         G6Lnobq7Nceio6b7dEYUS5bB3l3HLBWtBpYpKlL6OEHhZxJKQvTZVxR9DKitgrj/osuM
         Kh9RA2D0/GXJqreg4igry+KMzcS2i1p6B097pt1hjHNosczwGS2vjMC8v+S3mpKgI1an
         Lv0xWqnZ1s69dzXJI1fgy1ZQTj4hbuM5UYH/BA9XLkCL68WlIDE7Uffr1/7Hm2lTw+qi
         GDWydm+161/yuLYOJbhfhmoU4bKUO/fUu7m2rrdJgRC33Khdj8q98kMFP7MDF/PM5x9c
         ShYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707761417; x=1708366217;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twQ8ztHBF6EEP2CTDTo73x3N0hT2u1lGwcIeQMe0GDc=;
        b=T+vkJpCGoTl+bXqfRK93RDQCXBh8uofBzVciJxX+5Qwn3jmacIMTn+L9lsLlb6e6Gz
         nNEJnyGz1GYfB592HYW+yMKlF1vFD7qqDxyc66YnA2RLGyAwcHaLfPeM4RGhLp5TfyJd
         ClHNVRXcLm/XrzdH9F6KM56zjQiDdYYVOvzEopUyOQofWn7oIkK9aHTRD1D3+Jwgs+br
         XkIaIvUxj0tU0pXrpxm9DCv2CFf4pSL2nGRau/+zN5dp1jjTsjnXz8+Y3BfHPKt9YebY
         FJVXPgWSTrvJbGEseV2UNE5SiQAVWfnWcMjs1A9NmR0a5ktJvonuJztKHmATaW8wg1m2
         0P8Q==
X-Gm-Message-State: AOJu0YwR4JmPOanKnkUFSByJazfZsy7dzwFHTrPrdBMomyYoyFpTO8P3
	eBOMizTq3hNEo9mZPaotNwbm2nNZ8KyQtvlayso/XHCYj7rb7SaoS3SPHBBAXcyATRl/Jnrh9v/
	dTbiYWPySM4b84LsLCRBJZlLwD2A=
X-Google-Smtp-Source: AGHT+IGzPFtrEFZE5gZew2YC4BiLSfnEvxzixcQFyqt4+/KTobiKMHgK5KJ9XU477i5iaVK/PLYZQEx46zXPoFH8zHU=
X-Received: by 2002:a50:ec85:0:b0:560:ebdc:9eb with SMTP id
 e5-20020a50ec85000000b00560ebdc09ebmr194981edr.17.1707761417230; Mon, 12 Feb
 2024 10:10:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240212123716.795996-1-pbrobinson@gmail.com> <65ca4eca209b0_8387e294c3@iweiny-mobl.notmuch>
In-Reply-To: <65ca4eca209b0_8387e294c3@iweiny-mobl.notmuch>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Mon, 12 Feb 2024 18:10:06 +0000
Message-ID: <CALeDE9PCSBxX96_N_v9Fi=YSL8mWY31SjBveFNHgwSjhxgQaVQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix ACPI_NFIT in BLK_DEV_PMEM help
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Feb 2024 at 17:01, Ira Weiny <ira.weiny@intel.com> wrote:
>
> Peter Robinson wrote:
> > The ACPI_NFIT config option is described incorrectly as the
> > inverse NFIT_ACPI, which doesn't exist, so update the help
> > to the actual config option.
> >
> > Fixes: 18da2c9ee41a0 ("libnvdimm, pmem: move pmem to drivers/nvdimm/")
>
> I don't think this warrants a fixes tag as this commit has been around
> since 2015 and has not bothered anyone.  But the change is valid for the
> next merge window.

Well I added it because it does fix a legitimate problem, even if it's
only documentation, I don't mind if you strip it, it's always hard to
tell what maintainers want, because some explicitly want it added and
some don't.

> > Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> > ---
> >  drivers/nvdimm/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> > index 77b06d54cc62e..fde3e17c836c8 100644
> > --- a/drivers/nvdimm/Kconfig
> > +++ b/drivers/nvdimm/Kconfig
> > @@ -24,7 +24,7 @@ config BLK_DEV_PMEM
> >       select ND_PFN if NVDIMM_PFN
> >       help
> >         Memory ranges for PMEM are described by either an NFIT
> > -       (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
> > +       (NVDIMM Firmware Interface Table, see CONFIG_ACPI_NFIT), a
> >         non-standard OEM-specific E820 memory type (type-12, see
> >         CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
> >         'memmap=nn[KMG]!ss[KMG]' kernel command line (see
> > --
> > 2.43.0
> >
>
>
