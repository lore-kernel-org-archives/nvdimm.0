Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583713FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 18:44:32 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id a5so12802050plh.5
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 11:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TRwKLaX2ItZjRYOoEKi+1XP9VAqyCcYQq14j2HLT3M4=;
        b=Nt5lJeDTRnM5nhh1exQoriKKVHV0fw3JoBry3YUfH2IPdUqnfeVVCcEIubvo7cNUHt
         Ud/9Rkn3V8OaTeCGqnJXJkwL/UlcXdqzipSpDtfQAZ0IGHn5eVLEKGNKxR2/6G0kVdkW
         pKZ6EychT3fqFUyDrlDFM6fIvPaoTqlJMg1fySAnwJiI9kTkeCVuKBWs7Ky8erT/FHmZ
         1jyrgG3rSJsP6wn6hV2yMRRjmk8zuJEAwwfBbQ7gJEsDFK0TSv1Xo1fY+1n4kf5fPTvH
         AMpNrEOVwNwOaykgB2QbYsyXpzBnNVvNGVU8V2sjZKXb9TmBmhd4jlDz5h/wBzsJTg1H
         Sj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TRwKLaX2ItZjRYOoEKi+1XP9VAqyCcYQq14j2HLT3M4=;
        b=o0UxBsUIO+OCUuo6qLJYivTL440gs/RNUyJkuVuPHbiQue8NyvHwJZKqsClqjKjDu9
         ghRc/6/ecqcjrHibsAJQ0qyyvGEFre4o4/Qp6R6bNgTtcVWBTpLJndyjn5VqZyQV0LSA
         UhZjhFo5VgMsW60YFxRPzAb6nn8H2Y9l21dqP/nEBfBHgxv0nUa1cGzuWsaD1LOUORco
         0q+hYLOTrTAd3cy2g7mzbOIDlzbrZ0/X3TFj7O/p7Sxs54BirQQCKvCG1z71DF4Nt+NA
         jJduDBDj0M7yV5ZXb7FHAJ/eWWDhmsReStorzBWkqnbdeVFGObJHHylKWq+7vPCAvUfo
         Ls4Q==
X-Gm-Message-State: AOAM533DrAByBE3mMDGVoE5K329+uoNx9kN5sFXKxMo+EE5FmFqa4VcK
	Sf97HpoLr79QNRQx7lBVWIpp7AxePmpreBAthwz4Jg==
X-Google-Smtp-Source: ABdhPJyLDYHIjD3vSuo6W54SrBE/AuPM79/vosejgrg+ZP5KvkuVpcOQH7P/R/4CZ0uUKYVH7a2u+FhYpAqAHV87+Ic=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr5684717pjb.149.1629830671695;
 Tue, 24 Aug 2021 11:44:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad> <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com> <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
In-Reply-To: <20210824202449.19d524b5@thinkpad>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Aug 2021 11:44:20 -0700
Message-ID: <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, Christoph Hellwig <hch@lst.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 24, 2021 at 11:25 AM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> On Tue, 24 Aug 2021 07:53:22 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Tue, Aug 24, 2021 at 7:10 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> > >
> > >
> > >
> > > On 8/23/21 9:21 PM, Dan Williams wrote:
> > > > On Mon, Aug 23, 2021 at 12:47 PM Gerald Schaefer
> > > > <gerald.schaefer@linux.ibm.com> wrote:
> > > >>
> > > >> On Mon, 23 Aug 2021 16:05:46 +0200
> > > >> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
> > > >>
> > > >>> On Fri, 20 Aug 2021 07:43:40 +0200
> > > >>> Christoph Hellwig <hch@lst.de> wrote:
> > > >>>
> > > >>>> Hi all,
> > > >>>>
> > > >>>> looking at the recent ZONE_DEVICE related changes we still have a
> > > >>>> horrible maze of different code paths.  I already suggested to
> > > >>>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> > > >>
> > > >> Oh, we do have PTE_SPECIAL, actually that took away the last free bit
> > > >> in the pte. So, if there is a chance that ZONE_DEVICE would depend
> > > >> on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
> > > >> and get rid of that CONFIG_FS_DAX_LIMITED.
> > > >
> > > > So PTE_DEVMAP is primarily there to coordinate the
> > > > get_user_pages_fast() path, and even there it's usage can be
> > > > eliminated in favor of PTE_SPECIAL. I started that effort [1], but
> > > > need to rebase on new notify_failure infrastructure coming from Ruan
> > > > [2]. So I think you are not in the critical path until I can get the
> > > > PTE_DEVMAP requirement out of your way.
> > > >
> > >
> > > Isn't the implicit case that PTE_SPECIAL means that you
> > > aren't supposed to get a struct page back? The gup path bails out on
> > > pte_special() case. And in the fact in this thread that you quote:
> > >
> > > > [1]: https://lore.kernel.org/r/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com
> > >
> > > (...) we were speaking about[1.1] using that same special bit to block
> > > longterm gup for fs-dax (while allowing it device-dax which does support it).
> > >
> > > [1.1] https://lore.kernel.org/nvdimm/a8c41028-c7f5-9b93-4721-b8ddcf2427da@oracle.com/
> > >
> > > Or maybe that's what you mean for this particular case of FS_DAX_LIMITED. Most _special*()
> > > cases in mm match _devmap*() as far I've experimented in the past with PMD/PUD and dax
> > > (prior to [1.1]).
> > >
> > > I am just wondering would you differentiate the case where you have metadata for the
> > > !FS_DAX_LIMITED case in {gup,gup_fast} path in light of removing PTE_DEVMAP. I would have
> > > thought of checking that a pgmap exists for the pfn (without grabbing a ref to it).
> >
> > So I should clarify, I'm not proposing removing PTE_DEVMAP, I'm
> > proposing relaxing its need for architectures that can not afford the
> > PTE bit. Those architectures would miss out on get_user_pages_fast()
> > for devmap pages. Then, once PTE_SPECIAL kicks get_user_pages() to the
> > slow path, get_dev_pagemap() is used to detect devmap pages.
>
> Thanks, I was also a bit confused, but I think I got it now. Does that mean
> that you also plan to relax the pte_devmap(pte) check in follow_page_pte(),
> before calling get_dev_pagemap() in the slow path? So that it could also be
> called for pte_special(), maybe with additional vma_is_dax() check. And then
> rely on get_dev_pagemap() finding the pages for those "very special" PTEs that
> actually would have struct pages (at least for s390 DCSS with DAX)?

Yes, that's along the lines of what I'm thinking. I.e don't expect
pte_devmap() to be there in the slow path, and use the vma to check
for DAX.
