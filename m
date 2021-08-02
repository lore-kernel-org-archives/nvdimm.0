Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD182168
	for <nvdimm@lists.linux.dev>; Mon,  2 Aug 2021 14:06:32 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id q2so19709646plr.11
        for <nvdimm@lists.linux.dev>; Mon, 02 Aug 2021 07:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S30D7JnOgPGqBVRgaO8L0r6DfESVg4Q0tFc852vuoQg=;
        b=o7zchrRzGSGJvS1YaJA1zPgb9ncAEmQmS7wdtDRLvzTCTV0KV5fs6bh0F0NjLGNQdA
         hAsch3Th8KrrnTB3oABOyV9xGiM0mqxvjwcQkfhvu6p+CzBkBfEJS62qGuplsCP//3yg
         Y/7Pd6ryCB0f1VkCo8aXIsC1y4zhgDxhhN+SRDfojcY9OlwszZt73S0OMdSAGrrt/lEF
         DAL3uoym+fNdBMYLmsgLkKHhyp31BFULI/YtTh4pTa9xWKYuYTipXMvvP+ON9z6AxU2Y
         Ley1Tyza1FWHdyq3dJxbBTwJofGKtCqvbKWZgl3yHMFRcxOB/Pt8dJtPdR+vN52DMLVv
         44lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S30D7JnOgPGqBVRgaO8L0r6DfESVg4Q0tFc852vuoQg=;
        b=dYiZvifEMlH2A3mAAKpmEH+sazP5dTW4lT9eNVETEwTxyJqWM5pDlliefuBgYoURwR
         2B5vYFFbPcvmy54fJQo0bRBR289Gah6cfDGIKHsWwxY+juhINP+R3Z6dRNhPaKX6UmAb
         S7cVivtIHDusVjxYOmxQ8gAXg6ibOJLChbITxso3M2yMUsUxFJUhDkfoMPACrzpxeS+0
         p2+YWAXfSHNOkbwajBea9DJlv9NJgGQzRVyTPmx/rgBNu1MEfPQnRYrK9j7zeVu+5WAG
         FFWuF4OrKGbh2A9P4S3a2Zy8RgJDj1P2ZQviCspCu/JdpVv2ha9f2uaJE4Ac2YkflfZm
         oU5Q==
X-Gm-Message-State: AOAM532grVFIr5lEkjIJruxJvfsF0gd+FPuU7JTmflx6cNxgsj64D0Nl
	BogPfUNDA8MyIwLDuE7iW5g5S8qrHy1JUHURKIqtWg==
X-Google-Smtp-Source: ABdhPJyVKOnhVt0Wdh9gR5klKUeMY8LJl9xOy+rXAR1aL3gh/RyX3d+gIGycEUJ0HTA94nfjLHThyGCadYvcoTFdMUM=
X-Received: by 2002:a65:6248:: with SMTP id q8mr1176705pgv.279.1627913192152;
 Mon, 02 Aug 2021 07:06:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
 <YPjW7tu1NU0iRaH9@casper.infradead.org> <5642c8c3-cf13-33dc-c617-9d1becfba1b1@oracle.com>
 <CAPcyv4ho7idBPU8F4qE8XWhRttkdfzQRATaTAw2C3AfY+Z2BdQ@mail.gmail.com> <fbb77d0f-f1e9-3ef9-fd12-b412b845b7fc@oracle.com>
In-Reply-To: <fbb77d0f-f1e9-3ef9-fd12-b412b845b7fc@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 2 Aug 2021 07:06:21 -0700
Message-ID: <CAPcyv4gXrNnTQfHXGy-psWRq59UdrfqJ_1xDvxb2Db_rQGGxug@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 2, 2021 at 3:41 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
>
>
> On 7/28/21 12:23 AM, Dan Williams wrote:
> > On Thu, Jul 22, 2021 at 3:54 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> > [..]
> >>> The folio work really touches the page
> >>> cache for now, and this seems mostly to touch the devmap paths.
> >>>
> >> /me nods -- it really is about devmap infra for usage in device-dax for persistent memory.
> >>
> >> Perhaps I should do s/pagemaps/devmap/ throughout the series to avoid confusion.
> >
> > I also like "devmap" as a more accurate name. It matches the PFN_DEV
> > and PFN_MAP flags that decorate DAX capable pfn_t instances. It also
> > happens to match a recommendation I gave to Ira for his support for
> > supervisor protection keys with devmap pfns.
> >
> /me nods
>
> Additionally, I think I'll be reordering the patches for more clear/easier
> bisection i.e. first introducing compound pages for devmap, fixing associated
> issues wrt to the slow pinning and then introduce vmemmap deduplication for
> devmap.
>
> It should look like below after the reordering from first patch to last.
> Let me know if you disagree.
>
> memory-failure: fetch compound_head after pgmap_pfn_valid()
> mm/page_alloc: split prep_compound_page into head and tail subparts
> mm/page_alloc: refactor memmap_init_zone_device() page init
> mm/memremap: add ZONE_DEVICE support for compound pages
> device-dax: use ALIGN() for determining pgoff
> device-dax: compound devmap support
> mm/gup: grab head page refcount once for group of subpages
> mm/sparse-vmemmap: add a pgmap argument to section activation
> mm/sparse-vmemmap: refactor core of vmemmap_populate_basepages() to helper
> mm/hugetlb_vmemmap: move comment block to Documentation/vm
> mm/sparse-vmemmap: populate compound devmaps
> mm/page_alloc: reuse tail struct pages for compound devmaps
> mm/sparse-vmemmap: improve memory savings for compound pud geometry

LGTM.
