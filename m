Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D545B2C9C
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 08:04:33 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id v47so22525318ybi.4
        for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 00:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dxknHxb36rbifNWkNcv9VONDPog7tM6iEXnWvM32+Tc=;
        b=D0jLF5Daas/6Jk3NUsVPwZFaFyBP48m8kmx335qxOT/YqQsO8WQdrpXc8xUxn6Uk9/
         z6+uIxCoXUl8Vg8/gnBaaEHPHcSsKFrP9dSzq2gWNeov4MsgkOFlRLGzlCgiqCh3RLNP
         HMwkoMosu2SsdtbJWPCZ3b3JGg3DOEEZ6HcPsihB9czGLZpB9WgVMjcASQc76gtXzWM6
         ALwQkCbWrKgLHNuW4G8bdHgnwuxRBPbtQsZRsGAE6uH5YOUolyhxKB135UED5cIUvjxE
         KhGFKPN/10BLgtkRu4UZ1wojLARrEXaXZHj+cwXsBhhXKoxxNUUPlytF/VZ0EATnmH3U
         4oHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dxknHxb36rbifNWkNcv9VONDPog7tM6iEXnWvM32+Tc=;
        b=xpFUyZVKPjx3W2jcvJPaWRvNwg2060X7D4dG1G6KCWhmDeTMcgIzkDZGXiLp5UQDum
         9nRKinkd7QwqgGKSgkEHENLFcLY4eAsn7j18se7l5t6wrT07Te6hRgRUfZrZE5VnjVJB
         lbf8QjjmuL0HD6be4hCYAVuI4N1HAwLAPm7zcIohKun1eK69wBj3pNumyCwVipAtixrV
         gJkkb/ndfLO8QN+3SjCal93JED0S7iP4IRff2Pl6iBBWPHreW/htzJo0qV45gTd+DMEu
         33Z289RP+vFQR5hRfwIkLRUzGFG6DWfgQAHlWFBI34yqvGUt4Us2K242jvsBTkrW25o7
         7Q4w==
X-Gm-Message-State: AOAM530H0OXuEmDUSiZAItfhf1eYvs4FG5WCvMYagh4GaDQiC30xpVFW
	eO6wqSZAXaLKHHu4B9gWu87ZWKOCDzdgpZsILAQWYA==
X-Google-Smtp-Source: ABdhPJyU3xGRlVamweE+Q7TKE0AllylV5ToYb3DPWinhfyYERv+u5Gyj/PL3r2Zu6vl5zPtBqGiNHUNH9nwKPDGu1xQ=
X-Received: by 2002:a81:310:: with SMTP id 16mr517301ywd.35.1644566672815;
 Fri, 11 Feb 2022 00:04:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com> <20220210193345.23628-2-joao.m.martins@oracle.com>
In-Reply-To: <20220210193345.23628-2-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 11 Feb 2022 16:03:56 +0800
Message-ID: <CAMZfGtUwL-whhTeLydS9+H9weJ5sztAcrTi5ZK1ayNzSBMYtnQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> In support of using compound pages for devmap mappings, plumb the pgmap
> down to the vmemmap_populate implementation. Note that while altmap is
> retrievable from pgmap the memory hotplug code passes altmap without
> pgmap[*], so both need to be independently plumbed.
>
> So in addition to @altmap, pass @pgmap to sparse section populate
> functions namely:
>
>         sparse_add_section
>           section_activate
>             populate_section_memmap
>               __populate_section_memmap
>
> Passing @pgmap allows __populate_section_memmap() to both fetch the
> vmemmap_shift in which memmap metadata is created for and also to let
> sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
> whether to just reuse tail pages from past onlined sections.
>
> While at it, fix the kdoc for @altmap for sparse_add_section().
>
> [*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
