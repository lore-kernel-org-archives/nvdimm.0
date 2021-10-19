Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961B22C81
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 04:26:35 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id i76so14357356pfe.13
        for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 21:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wQMmH7lLgMo4ZZ0vQVnCc8CBbLizGVkHHz0zd95llQ=;
        b=MvcoIlOvUTiFcAUmnCqYZwte1hVj5v3reXfdaO1Xfgi+un8viqI1QdL/tjcnUOM2XV
         ZDo6ZEF5uCA5i1x6BjYrmi8DEeVp0SLum8nLrPIINKKzqV8ai15f6RHoYSjmrt9on8tY
         b1zog1rf8V7VARIX1OUeQgbrBlrtoFJowPERLC9TxoRg00t/8QRSkkZp0IGcg0hjKqef
         o6FmdFk/ULkmqQ9gclPMnBUPdzA0mRGc7Qqfj+PBbLzidGVvRjhteqQdvQG6CtCpKe9B
         rDyKmu+kL+wI399BOIeHj9q8lWi7OK8tQ3qRLf5t0jgfdSjls2N/yDGQB+MeodiBF9gj
         N4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wQMmH7lLgMo4ZZ0vQVnCc8CBbLizGVkHHz0zd95llQ=;
        b=cRqsae76jy6NiaMNxFMozReMklg5iT+/wM7bGqrZhm9CXg2gTUojaG0JDggUsyu8Ti
         iYFOlnqsnxktys8OsmYvx1dKH0F8dm7GWwBldi/1utdgKb2272+Kv6dSSQmToIXXM7IB
         XVgbEMGzSi9fKEVr8xqdZ8mNW3OBS4SMc1qyS/NxjmcQHB2RgA5wx5FTQB2RctwHOGj9
         BFgHT91rcHHAFSh2V7OFBTKlIURkei7lM2fL0UnUnki+vGaLNSzaVNMsSqZF1houPTIU
         7gr/BXbtke2ghortBQPULVDW4IoNhVXDLCZE9MDZCr2kIhRQkT0/4MJpPuSxP80/UDxM
         MltA==
X-Gm-Message-State: AOAM5336VeZUexGV1+KGh65UZfTjVyTz0gdyBn5gIKgB+6APtVdBDqyY
	vNbzJYgZf3agrbCuL+01koRHL2+ydxzgr1z5+zRMPw==
X-Google-Smtp-Source: ABdhPJysFF00F8r4afBRUev7hG6iUFPxIcv8rxMlcC4A43npPr6ylw8S9GhiZVVlsaTUSvMNVzOXMjJMTgBVsNuI07c=
X-Received: by 2002:a63:8743:: with SMTP id i64mr9249749pge.377.1634617594915;
 Mon, 18 Oct 2021 21:26:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad> <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
 <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com> <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad> <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com> <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
 <20211018233045.GQ2744544@nvidia.com>
In-Reply-To: <20211018233045.GQ2744544@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Oct 2021 21:26:24 -0700
Message-ID: <CAPcyv4i=Rsv3nNTH9LTc2BwCoMyDU639vdd9kVEzZXvuSY+dWA@mail.gmail.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-s390 <linux-s390@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Alex Sierra <alex.sierra@amd.com>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, 
	Linux MM <linux-mm@kvack.org>, Ralph Campbell <rcampbell@nvidia.com>, 
	Alistair Popple <apopple@nvidia.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 18, 2021 at 4:31 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Fri, Oct 15, 2021 at 01:22:41AM +0100, Joao Martins wrote:
>
> > dev_pagemap_mapping_shift() does a lookup to figure out
> > which order is the page table entry represents. is_zone_device_page()
> > is already used to gate usage of dev_pagemap_mapping_shift(). I think
> > this might be an artifact of the same issue as 3) in which PMDs/PUDs
> > are represented with base pages and hence you can't do what the rest
> > of the world does with:
>
> This code is looks broken as written.
>
> vma_address() relies on certain properties that I maybe DAX (maybe
> even only FSDAX?) sets on its ZONE_DEVICE pages, and
> dev_pagemap_mapping_shift() does not handle the -EFAULT return. It
> will crash if a memory failure hits any other kind of ZONE_DEVICE
> area.

That case is gated with a TODO in memory_failure_dev_pagemap(). I
never got any response to queries about what to do about memory
failure vs HMM.

>
> I'm not sure the comment is correct anyhow:
>
>                 /*
>                  * Unmap the largest mapping to avoid breaking up
>                  * device-dax mappings which are constant size. The
>                  * actual size of the mapping being torn down is
>                  * communicated in siginfo, see kill_proc()
>                  */
>                 unmap_mapping_range(page->mapping, start, size, 0);
>
> Beacuse for non PageAnon unmap_mapping_range() does either
> zap_huge_pud(), __split_huge_pmd(), or zap_huge_pmd().
>
> Despite it's name __split_huge_pmd() does not actually split, it will
> call __split_huge_pmd_locked:
>
>         } else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
>                 goto out;
>         __split_huge_pmd_locked(vma, pmd, range.start, freeze);
>
> Which does
>         if (!vma_is_anonymous(vma)) {
>                 old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
>
> Which is a zap, not split.
>
> So I wonder if there is a reason to use anything other than 4k here
> for DAX?
>
> >       tk->size_shift = page_shift(compound_head(p));
> >
> > ... as page_shift() would just return PAGE_SHIFT (as compound_order() is 0).
>
> And what would be so wrong with memory failure doing this as a 4k
> page?

device-dax does not support misaligned mappings. It makes hard
guarantees for applications that can not afford the page table
allocation overhead of sub-1GB mappings.
