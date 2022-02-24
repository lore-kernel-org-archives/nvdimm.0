Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943C7A
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 15:41:45 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso6042028pjj.2
        for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 07:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aglwyJuncdMb7TX3kliuiHLVhSIH5aYNnruwhD2Ltmc=;
        b=TROd7V022FpJERjl9bIAT1CByY618UmA0CCwtcpFre6Pzzsc3VcaJ1lo8VTGuKfzTG
         T8BQFm+jhcAyZ5K97lxfP+qAfDnmsR/p4sISJ60lKgw6UlQC4j8WFVGogvhODKFHvidh
         LQaLNxH2I8a7YK73eBimULBO49cy622Ag7Bt6VH0+50zsiZFeZB7PqI7B3bprdlKX/5D
         lh4zAvYyfK2jjSClqeoVeURwDqvKaB9jiRB3Lh7igMW8YMWZxGN182EfZynKe4SZX8he
         W510oDJzTJ7xTz8yfFOOt2+CI8sWq+8x8MNP0665vNGPH8kVwIz3B7iMkqEhpXw7O/X/
         63uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aglwyJuncdMb7TX3kliuiHLVhSIH5aYNnruwhD2Ltmc=;
        b=U3hAgQ+v+Koa2fwhqW7XYdqMYiS8tDAbgX3NIvdXqJDF5tq83pAVRsx394ZC+BLAEq
         LHJTw7BmGfrdwFVcDYWm+JGjVIP9Z3kMvFpa4+F890i2QuXaypmbWxMsCsRLJVTD6uXM
         zCSN3ZUX25rcJOAIIaZMM3d/y0osGvGGukRub8nDOVCIfasXB6LtFgdzkEw9ZGoaJAXe
         2VzM8HWi+LgIvT8S0vakoGBTP573u19hVbjsstMtx+ma9i16qdIBSQmRu1NjCcxMysuK
         Jk/Ux1yQh5mCfTgEV3HzjdkmWqjeyKlWcZHq1ZjRSJVO4EG22lRRhtJQgjGqxSAHw5UN
         /FAQ==
X-Gm-Message-State: AOAM533RtdkqSsWLiwOpaMF++fnPavkqWwbzp9OeoElxrkhunbeXqFJr
	UHO3kFB2GWC4lpYQfI40rGb35Bl8mpXwQEG+nb9yUQ==
X-Google-Smtp-Source: ABdhPJw0qCYj4wX044KlswblL6qaOV1khF2ln5o1BdyFM3xFURkaFxNC7iQzOv4gcEGB24YMZBQdmPh7RBoMgTlZe3I=
X-Received: by 2002:a17:90b:1b46:b0:1b8:f0eb:e424 with SMTP id
 nv6-20020a17090b1b4600b001b8f0ebe424mr15144712pjb.185.1645717305102; Thu, 24
 Feb 2022 07:41:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com> <20220223194807.12070-6-joao.m.martins@oracle.com>
In-Reply-To: <20220223194807.12070-6-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 23:41:09 +0800
Message-ID: <CAMZfGtVCXDeF=3=0n83Bx_20MHOqWsRoJAtZeE53WMr3FA+j7w@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Currently memmap_init_zone_device() ends up initializing 32768 pages
> when it only needs to initialize 128 given tail page reuse. That
> number is worse with 1GB compound pages, 262144 instead of 128. Update
> memmap_init_zone_device() to skip redundant initialization, detailed
> below.
>
> When a pgmap @vmemmap_shift is set, all pages are mapped at a given
> huge page alignment and use compound pages to describe them as opposed
> to a struct per 4K.
>
> With @vmemmap_shift > 0 and when struct pages are stored in ram
> (!altmap) most tail pages are reused. Consequently, the amount of
> unique struct pages is a lot smaller that the total amount of struct

s/that/than/g
