Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3CE29CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 19:32:58 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id d5-20020a17090ab305b02901675357c371so12274408pjr.1
        for <nvdimm@lists.linux.dev>; Mon, 07 Jun 2021 12:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6FIDTCFEtrXgKbHDhwTWqzryApfXRNgdkxabvY4188=;
        b=IjissTbP2H5cet6FCXTNl30Wp/VnCNmo3Y5bDLrdmPw1OIa9KCe4dop9+z/NgHVKNP
         a32GJSPU3fxmjbnqn1NuINGqgPuTab6SCPQC9DeMX8HkhnsV5peb1jkl6uuCPo+pJw0Y
         kXf18RhlkE2MuxSUw1Rz/wilF/sWAe/0oN84WRr0IKOXTQwi445Y6212a3rLHISFG79b
         aZGcxn8JblTw+/ScVEUtiJwvg5bcWsDuILE+CjtpZmuuJsupYPj1DoCMPnw73IeOPn85
         rB1OvMnlwtA1PvF4EW+PyIseEWwr/W3UFAKOqQMik1X8h/QxFnuPcEksSRx2HnmXidTk
         9DLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6FIDTCFEtrXgKbHDhwTWqzryApfXRNgdkxabvY4188=;
        b=Lhq0KpHYYC51lxpSYP6hMHSpGQURNUKtyg564LqzIQG6Uo+nvA1ESuwsV+rjHeMukI
         9geU0DuJFlRJ+T4kkGsowC6xyFcwcjrHYI4q8TySwYSK80goiE0u9W9xyMFUncIQ33Ke
         VRQMykgbjCRAUvdUuzgW+rLgyd/3ziHcOjRK6YyOO+i0xE3SD830N1VKyIfMvBqGPmmY
         bRpCS2XiwtwFRvaCOlAU7C/+N1wBV6EZqpgZh6YCL4JXL/ThyZ8y2FEdl9Z6zKyNaNtV
         FOoGbuavc8Ru5eyrbYF6ED2HdzxPCdh6FFEudW+8fdMFSzv4KQaXRkGV0C5gzpdAKft5
         AD8g==
X-Gm-Message-State: AOAM533jhGnW/F6ET70lPi+SYRfdKWMgocReUqLmZQx5vfoGx+T/RIjQ
	/Q8RcK5gBkcsGatzCCU3xbEyZjDPdenzT5bCKPmntQ==
X-Google-Smtp-Source: ABdhPJxLdqGwcZ+2kEFzaars2FEGU1U2AgrynhV6aFbI97/DYi0LMFPol174B5blpjQDiF+1RfKj+i5Pqb+ntWQzbFk=
X-Received: by 2002:a17:90a:414a:: with SMTP id m10mr686202pjg.149.1623094378041;
 Mon, 07 Jun 2021 12:32:58 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-10-joao.m.martins@oracle.com> <CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com>
 <840290bd-55cc-e77a-b13d-05c6fd361865@oracle.com>
In-Reply-To: <840290bd-55cc-e77a-b13d-05c6fd361865@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jun 2021 12:32:47 -0700
Message-ID: <CAPcyv4hJtqVGoA3ppCMfVQ4ZnWUa7jKtp=Huxu9mcSk4huq_7Q@mail.gmail.com>
Subject: Re: [PATCH v1 09/11] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 7, 2021 at 6:49 AM Joao Martins <joao.m.martins@oracle.com> wrote:
[..]
> > Given all of the above I'm wondering if there should be a new
> > "compound specific" flavor of this routine rather than trying to
> > cleverly inter mingle the old path with the new. This is easier
> > because you have already done the work in previous patches to break
> > this into helpers. So just have memmap_init_zone_device() do it the
> > "old" way and memmap_init_compound() handle all the tail page init +
> > optimizations.
> >
> I can separate it out, should be easier to follow.
>
> Albeit just a note, I think memmap_init_compound() should be the new normal as metadata
> more accurately represents what goes on the page tables. That's regardless of
> vmemmap-based gains, and hence why my train of thought was to not separate it.
>
> After this series, all devmap pages where @geometry matches @align will have compound
> pages be used instead. And we enable that in device-dax as first user (in the next patch).
> altmap or not so far just differentiates on the uniqueness of struct pages as the former
> doesn't reuse base pages that only contain tail pages and consequently makes us initialize
> all tail struct pages.

I think combining the cases into a common central routine makes the
code that much harder to maintain. A small duplication cost is worth
it in my opinion to help readability / maintainability.
