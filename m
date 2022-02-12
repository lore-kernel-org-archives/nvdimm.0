Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46097D
	for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 11:11:50 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id 124so4059602ybn.11
        for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 03:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xrTak1VFmwYfWi/5C91pgPU3GcQuoEOjal0LN32/VtE=;
        b=CRBUDFDPb5R16DSAWpwZf/x5195N0j/8r4hfLE0UbeTlIlNE3JMq8vFj1Q0xmCztG4
         //BPPIY5FfbLE5Eu0N9UygveVJF8xWRZk7QxsM0kgu27NVucgdp9qSa9ZPuMkNhpgRaH
         q2T626YECEwJgtidwqOSiRLVOBFTT6KIAaLqEMkFy83d8ETDdgwc6p9FxhcTuM+ux7JR
         4N1n71TM2ra90WWyzsUKko7/RLvyFLJ5ZFh3UH9IlTc5MS5obNGOWXeWp+mvnNmRIK5y
         AlDE3jIpjcr07RN0LwEZN7KwU/5QW8+vMNgkC7mrDpkWZgmOf9Qlzo3mHR+rY/PAy/8O
         XW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xrTak1VFmwYfWi/5C91pgPU3GcQuoEOjal0LN32/VtE=;
        b=L35NacdDuX5SVig99z/SAbToBY7/KBnG/E5CS/3sSFxAlmXnbdwLZaWepjTkEtjgVb
         rEkD3f19EkSDA+q3ThROis4um8NsIRi86N+p3NKHRCQY/ZQLdOeh2knbuK0V/QAqQXZG
         C0NvVyNjQhBPhdoIK4HscgF2fBZCcxmj1DOfA/l88vR4ThcI3sp5eFy76MbeHfbNUL8h
         Xb7GkhOi4sQ6p2Qhw/FXztvkCHG+xNku5R8uZ+AwkLO+bb7n0tEHYRZ42caf/0DOTzDo
         jxt0M+FvwU+a+1H/UK7VSyGAkkKRdg3t3HeBq6507VO2RfRmQOkg5SVRV0XkH7EVRa4L
         aL8A==
X-Gm-Message-State: AOAM532piqcdqXgoyDpCxrb60OjFV+dJaLmciGX7iTHZhCdp5U+JRSpu
	Oc9zSo2d4Mh3OzgZMdhe+PRwzs/3phzU/CwWPMn3fA==
X-Google-Smtp-Source: ABdhPJyzi0DB9toSCVpkfD/oWJTS16ZkfcTvJtuyuZj4HY/NlpJ3rJtNI3SnPC60K5CR6cLB+J1EoQsHVS4+JnYv398=
X-Received: by 2002:a25:1e82:: with SMTP id e124mr2221807ybe.485.1644664309419;
 Sat, 12 Feb 2022 03:11:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-6-joao.m.martins@oracle.com> <CAMZfGtXRPn3MPDpDEyFJJ98E3xTB65Q8_C+P92_XKsL-q8ah=w@mail.gmail.com>
 <cfd0690f-bbc5-0fba-e085-1385041c470d@oracle.com>
In-Reply-To: <cfd0690f-bbc5-0fba-e085-1385041c470d@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 12 Feb 2022 19:11:13 +0800
Message-ID: <CAMZfGtUSH9cKWmQpsD2BzvVMAjQJCpyO_p7sFchEVx6ywxDEyw@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 8:48 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 2/11/22 05:07, Muchun Song wrote:
> > On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index cface1d38093..c10df2fd0ec2 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -6666,6 +6666,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >>         }
> >>  }
> >>
> >> +/*
> >> + * With compound page geometry and when struct pages are stored in ram most
> >> + * tail pages are reused. Consequently, the amount of unique struct pages to
> >> + * initialize is a lot smaller that the total amount of struct pages being
> >> + * mapped. This is a paired / mild layering violation with explicit knowledge
> >> + * of how the sparse_vmemmap internals handle compound pages in the lack
> >> + * of an altmap. See vmemmap_populate_compound_pages().
> >> + */
> >> +static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
> >> +                                             unsigned long nr_pages)
> >> +{
> >> +       return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
> >> +}
> >> +
> >
> > This means only the first 2 pages will be modified, the reset 6 or 4094 pages
> > do not.  In the HugeTLB case, those tail pages are mapped with read-only
> > to catch invalid usage on tail pages (e.g. write operations). Quick question:
> > should we also do similar things on DAX?
> >
> What's sort of in the way of marking deduplicated pages as read-only is one
> particular CONFIG_DEBUG_VM feature, particularly page_init_poison(). HugeTLB
> gets its memory from the page allocator of already has pre-populated (at boot)
> system RAM sections and needs those to be 'given back' before they can be
> hotunplugged. So I guess it never goes through page_init_poison(). Although
> device-dax, the sections are populated and dedicated to device-dax when
> hotplugged, and then on hotunplug when the last user devdax user drops the page
> reference.
>
> So page_init_poison() is called on those two occasions. It actually writes to
> whole sections of memmap, not just one page. So either I gate read-only page
> protection when CONFIG_DEBUG_VM=n (which feels very wrong), or I detect inside
> page_init_poison() that the caller is trying to init compound devmap backed
> struct pages that were already watermarked (i.e. essentially when pfn offset
> between passed page and head page is bigger than 128).

Got it. I haven't realized page_init_poison() will poison the struct pages.
I agree with you that mapping with read-only is wrong.

Thanks.
