Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD4173
	for <nvdimm@lists.linux.dev>; Fri, 21 Jan 2022 18:06:05 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id me13so2241992ejb.12
        for <nvdimm@lists.linux.dev>; Fri, 21 Jan 2022 10:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HB00Dk4BxVgWeQmFduo2LILaD1FFGYAEdZ3PebPBEBw=;
        b=btFmWrH/V9v5abyka+eab1Rs3zrpPn0nci4AUiouqLNDpjw/NkYUFUhvw773WCVIAk
         xVmqjmn/xkl65jW4CpvfWhM1dxlKUEOH+mZCaCYyhd3lampu7yFeaohMhgJxOLABmYK2
         0sgxwzihFGSQPijTrND8NtNoGE8QvLZsgDbb2u0jCFaiMSvU8eaXk992+0Fs/m8gK2i+
         dW9hP3ZqPsSXfA2BbKSsAN3XxXk1xRi2PsGpzdmTfbm/tAAg4TFXNNL6U3UECgd/ag2J
         5N6t40/gB1LtQRaV0K3wOggY/uAWuhlL/2gu3bKqYOK3tbn4edp4axjVfBashkqM4zQI
         xYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HB00Dk4BxVgWeQmFduo2LILaD1FFGYAEdZ3PebPBEBw=;
        b=b+HHNzuIibD4zX/3mfCfvknbb4uCG6371D7/63UwA0Mm/akYKTFnXzPeoPfUyy5q4n
         i5qiNNlOcf5DAE4g/kbH9kg5LWcajjgKHx3McwXTT/9F7CT2tAfC3FcmrPDCP5s/4pCr
         RdIaybOK2d21e+YLrlQzpXpnxddDHfcGR0Fkaq5fKqp8jFPxNsqTfd/GC6MN1r7C9GxI
         //bzgdBcl2J7gfw3QkdZAZ+XOTuSj9DRu4Tq69NoF3YEFIJScXySssOgfEbHg6pb5Xvv
         nca34l5L/exXLIpAcqpRbgGoh6ttrIu5fb9TZwKF4GJiTdcQAABQ+QQqZNasjil5A/GJ
         LZ7g==
X-Gm-Message-State: AOAM530GSDd1sBXiUNq1fVFl/ix6x6rtgB2e6+4V1+CMV3hXr6eEqikA
	MNk3hC3SWabbX8ho7ThefUyDhxpI0x5Y/wZf0MM=
X-Google-Smtp-Source: ABdhPJx/A/eFYcqDd4G5OcIvASWaZyYXtR3rIaew10BEAtQbSwm0/TspzVHpdvckLjatHTglZw4oLp9D9/+CH3DiukM=
X-Received: by 2002:a17:907:94c9:: with SMTP id dn9mr4119453ejc.270.1642788363547;
 Fri, 21 Jan 2022 10:06:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220121075515.79311-1-songmuchun@bytedance.com>
In-Reply-To: <20220121075515.79311-1-songmuchun@bytedance.com>
From: Yang Shi <shy828301@gmail.com>
Date: Fri, 21 Jan 2022 10:05:51 -0800
Message-ID: <CAHbLzkqzu+20TJc8RGDDCyDaFmG+Q7xjkVgpJF5-uPqubMN2HA@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: rmap: fix cache flush on THP pages
To: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, Hugh Dickins <hughd@google.com>, xiyuyang19@fudan.edu.cn, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, zwisler@kernel.org, 
	Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, nvdimm@lists.linux.dev, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 20, 2022 at 11:56 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> However, it does not cover the full pages in a THP except a head page.
> Replace it with flush_cache_range() to fix this issue. At least, no
> problems were found due to this. Maybe because the architectures that
> have virtual indexed caches is less.

Yeah, actually flush_cache_page()/flush_cache_range() are no-op for
the most architectures which have THP supported, i.e. x86, aarch64,
powerpc, etc.

And currently just tmpfs and read-only files support PMD-mapped THP,
but both don't have to do writeback. And it seems DAX doesn't have
writeback either, which uses __set_page_dirty_no_writeback() for
set_page_dirty. So this code should never be called IIUC.

But anyway your fix looks correct to me. Reviewed-by: Yang Shi
<shy828301@gmail.com>

>
> Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b0fd9dc19eba..65670cb805d6 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -974,7 +974,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
>                         if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
>                                 continue;
>
> -                       flush_cache_page(vma, address, page_to_pfn(page));
> +                       flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
>                         entry = pmdp_invalidate(vma, address, pmd);
>                         entry = pmd_wrprotect(entry);
>                         entry = pmd_mkclean(entry);
> --
> 2.11.0
>
