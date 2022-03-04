Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C647C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 03:09:58 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id f5so14212775ybg.9
        for <nvdimm@lists.linux.dev>; Thu, 03 Mar 2022 19:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6q+ly/u39xYyKacUqKnY0+oHLRpmW1dHHfAGkiJCu1Y=;
        b=u3huWPeiz+Oe7K8PoY56nQ1fGZIlx5pbI1hIo7DmXRqmm88lM/h9wHq5wPisneW+3a
         i0lkATj0Tl5U90bQYe/pVgB9s3qNBIbZ5Idd8JZycguC0ViPbTVWGAkt4uXfvY9xdTHU
         GewXmlMYyrX+Jn38s7VSvnoEE0CU8K1ZcpP7EQDdaTlD2P6rIcAMF2MeCHJQobwlqX5s
         jIj6tX9ZiYJfiq68xVLTy/F5Wy0d3KKdnDgOiHcoih7x9LRQu18KasD4umDe5Mr5SWuc
         hIEKFs4kHra0W1WxYTsB3lG77rF080+GqLkMKeIXC/7C14sC4/Qe+oXSb5tqMofwU/Bd
         xukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6q+ly/u39xYyKacUqKnY0+oHLRpmW1dHHfAGkiJCu1Y=;
        b=Oe8zLYxtvguqKqxgULehgliroBQwOiTa86vYDd5svfyMe9ZR86dfzFgPDylWrhPHt3
         s6ne4WdxR/0Y+vTlBjLxVI/rgt6AVv6xlIS2oTU3eCFnL+e1bO6nE11ua4VECTqryUQg
         1MuNga8RIeY1huN58vd0xrmNJ2TP90fNiiFVudgjpvM1MiyVTyHZArp5ZrfTt/jnrZeb
         jq0sZcl4AqA01GLLimAbRpQmDWxTD0rWghTViW+R1YE7XID2bItu2R5hlIzDiamckepC
         bGu7sAQFLzPhIWZ8mdzPQLCEze6tmN23AN1CwPUH6u1jnS/v02fE/wh0MkPzsw324nAX
         YxIg==
X-Gm-Message-State: AOAM533NUwahP5W9R1zeAB3cmUx5YQT5l6Go9pPUTL8rcTXLMh4bqT1T
	6c+8nrezX9kqFN1i/6umyDAtGQVs8KQlIe0/xcuNSA==
X-Google-Smtp-Source: ABdhPJwn1/iKslLrd8kE67UZS3lsvCoC1aQ/in9KlZnkDOoOUsMSdpG+WvlGFvaQ1Sn1SoK7DfyY1+ZgFIwe/+lG8Bg=
X-Received: by 2002:a25:3d87:0:b0:61e:170c:aa9 with SMTP id
 k129-20020a253d87000000b0061e170c0aa9mr35759918yba.89.1646363397800; Thu, 03
 Mar 2022 19:09:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220303213252.28593-1-joao.m.martins@oracle.com> <20220303213252.28593-5-joao.m.martins@oracle.com>
In-Reply-To: <20220303213252.28593-5-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 4 Mar 2022 11:09:10 +0800
Message-ID: <CAMZfGtWmRfSzN+U-jxVXu6x3nRxHB2Wxse5y5835ezGzSqAQpA@mail.gmail.com>
Subject: Re: [PATCH v7 4/5] mm/sparse-vmemmap: improve memory savings for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 5:33 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
> means that pages are mapped at a given huge page alignment and utilize
> uses compound pages as opposed to order-0 pages.
>
> Take advantage of the fact that most tail pages look the same (except
> the first two) to minimize struct page overhead. Allocate a separate
> page for the vmemmap area which contains the head page and separate for
> the next 64 pages. The rest of the subsections then reuse this tail
> vmemmap page to initialize the rest of the tail pages.
>
> Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
> when initializing compound devmap with big enough @vmemmap_shift (e.g.
> 1G PUD) it may cross multiple sections. The vmemmap code needs to
> consult @pgmap so that multiple sections that all map the same tail
> data can refer back to the first copy of that data for a given
> gigantic page.
>
> On compound devmaps with 2M align, this mechanism lets 6 pages be
> saved out of the 8 necessary PFNs necessary to set the subsection's
> 512 struct pages being mapped. On a 1G compound devmap it saves
> 4094 pages.
>
> Altmap isn't supported yet, given various restrictions in altmap pfn
> allocator, thus fallback to the already in use vmemmap_populate().  It
> is worth noting that altmap for devmap mappings was there to relieve the
> pressure of inordinate amounts of memmap space to map terabytes of pmem.
> With compound pages the motivation for altmaps for pmem gets reduced.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
