Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194D03FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 14:53:34 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id n12so955907plk.10
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 07:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ylhUTqwJhOuYYwdsmYmo/6iY3LnpW0+y5HqqgED6H8=;
        b=0GqAkBH/nv5mE+SUkUmCtp/Pwe2XyfpfayIPW7xPf4zMALUn+8UVuRqkiU5/doWAyu
         mYltVepwNSNg4jFsmuXbs0v3dQ1BDTt6vaL7/GAiuFiI684L6L+K76lJrONqA9PoUKTZ
         H98GgJ6wpuG4u+VZ+rOGiYpjGy1dIZJbTCiBtcEvQHTBiWGIH4qRplx+5wPBu5PCjIFk
         9OBXbOiNJetFqwHBcvKNPfUwCLj33yaz6uqLopvKR0Re5pPWAQCKgtr4FqCkD/DrGF6i
         S0FWWP6ujBqaO/ixSi1B8Qtm/cvJ9ZpyK5HCj5KknKJqHaLQMCj6+7AskxNfi8waSbKY
         AdXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ylhUTqwJhOuYYwdsmYmo/6iY3LnpW0+y5HqqgED6H8=;
        b=g1v9fb6hvypMg/8ukkSPoP48EbNrYEV0thM13AzpCl+5hPA/GbaPgmaMr/8gPHn1pa
         X9ATH8+1czbl7M7IegzC3wvqi2ytmE9UTcLsmB6fsYOPizStcrjv6QgpyjUXiQruLknK
         yMyvfyxPqFOQdZNgTp1diejUM+n/isbtw9wwTm1kzb3rfcn490lGZmA08byBb7vqbwiY
         D0Ue3qqXfpMcQARUlPwQAOIDYhML/fObnDtln9qGqmzUpkPa0Q8wGqp6XFYfAPhZe3wq
         gS9/vIdICEQbLg8V5lTitCHlsMPVEi/gVBDBFsCW/6KkSrdp6AUu3DYcBjwx/ZIFRT8a
         xFgg==
X-Gm-Message-State: AOAM530N+5GrVbV18MIZIl6lEf5T8kNSuMxX0QIg4lBJjJrZtNZNk4NG
	MzlrHshJa7JrJKc97NXEOsSfAJ4n5VQ3rSW/35os5g==
X-Google-Smtp-Source: ABdhPJxB5qoItv8tPXXCue0hhdumr9yxeciPby/nl24so9ftRlXdHk/l9EUDaI5+k43oB4FfA4dj+mopqnyG/DhwRe8=
X-Received: by 2002:a17:902:9b95:b0:130:6a7b:4570 with SMTP id
 y21-20020a1709029b9500b001306a7b4570mr21771893plp.27.1629816813538; Tue, 24
 Aug 2021 07:53:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad> <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
In-Reply-To: <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Aug 2021 07:53:22 -0700
Message-ID: <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 24, 2021 at 7:10 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
>
>
> On 8/23/21 9:21 PM, Dan Williams wrote:
> > On Mon, Aug 23, 2021 at 12:47 PM Gerald Schaefer
> > <gerald.schaefer@linux.ibm.com> wrote:
> >>
> >> On Mon, 23 Aug 2021 16:05:46 +0200
> >> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
> >>
> >>> On Fri, 20 Aug 2021 07:43:40 +0200
> >>> Christoph Hellwig <hch@lst.de> wrote:
> >>>
> >>>> Hi all,
> >>>>
> >>>> looking at the recent ZONE_DEVICE related changes we still have a
> >>>> horrible maze of different code paths.  I already suggested to
> >>>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> >>
> >> Oh, we do have PTE_SPECIAL, actually that took away the last free bit
> >> in the pte. So, if there is a chance that ZONE_DEVICE would depend
> >> on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
> >> and get rid of that CONFIG_FS_DAX_LIMITED.
> >
> > So PTE_DEVMAP is primarily there to coordinate the
> > get_user_pages_fast() path, and even there it's usage can be
> > eliminated in favor of PTE_SPECIAL. I started that effort [1], but
> > need to rebase on new notify_failure infrastructure coming from Ruan
> > [2]. So I think you are not in the critical path until I can get the
> > PTE_DEVMAP requirement out of your way.
> >
>
> Isn't the implicit case that PTE_SPECIAL means that you
> aren't supposed to get a struct page back? The gup path bails out on
> pte_special() case. And in the fact in this thread that you quote:
>
> > [1]: https://lore.kernel.org/r/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com
>
> (...) we were speaking about[1.1] using that same special bit to block
> longterm gup for fs-dax (while allowing it device-dax which does support it).
>
> [1.1] https://lore.kernel.org/nvdimm/a8c41028-c7f5-9b93-4721-b8ddcf2427da@oracle.com/
>
> Or maybe that's what you mean for this particular case of FS_DAX_LIMITED. Most _special*()
> cases in mm match _devmap*() as far I've experimented in the past with PMD/PUD and dax
> (prior to [1.1]).
>
> I am just wondering would you differentiate the case where you have metadata for the
> !FS_DAX_LIMITED case in {gup,gup_fast} path in light of removing PTE_DEVMAP. I would have
> thought of checking that a pgmap exists for the pfn (without grabbing a ref to it).

So I should clarify, I'm not proposing removing PTE_DEVMAP, I'm
proposing relaxing its need for architectures that can not afford the
PTE bit. Those architectures would miss out on get_user_pages_fast()
for devmap pages. Then, once PTE_SPECIAL kicks get_user_pages() to the
slow path, get_dev_pagemap() is used to detect devmap pages.
