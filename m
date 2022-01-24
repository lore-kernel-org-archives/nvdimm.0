Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31B173
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 08:51:43 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id g81so48874391ybg.10
        for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bELfTHEk6E+Ur1KnM4vcunvX6YMOTiYgaY+wBXhSmNY=;
        b=xuzHORiZtxL4ALsbPI12Enqz7+Y7z0qaEw1VTD5rZOAhs136D3XcklFmacDAPP1Wix
         b1LezGAI1F3NQTCI3w2mzRPC+MN6bdvFBSfGz1dtd48u5S8myG1WDGav+YscfQrYNIyT
         bW4EIysGkBOF3+/+evUyYiHTyjBobHidSnKY3XRHsRzfufOk2nJE7LOgO/bNLOnPqckC
         K2NOq5CLsd2a53530xwZVi/LbOfFyuiMm7xB/ASE2pT2LN7016uNyqlOtbNmhXhU6GUt
         ztNByXTKi0m1souZOOtIvo7KOv/wq5MzYC8eEGDxp0xOL5QolSsngo80rWPP/ZmLnKM1
         fFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bELfTHEk6E+Ur1KnM4vcunvX6YMOTiYgaY+wBXhSmNY=;
        b=uxY3voZrGUxhE4aiREt2gM+ewXjNpihqJ+6fK4PGkO6IbfDVKxS/fTYVDEW8zL6B33
         USEsgSgb69grQhMA0z9i8ODVeIctdYKtlaRfoM2TLJQ85xG97eD/qzu78Mcpoy5eTLlj
         3+VvxaktgJd2ZYqIQ+bSTo5G+Zp8P6sxRFhNWW0YNjrT7O+VqJJi9vv32pSlN9YXdm0G
         W6f5rFPe2b55DbSWuWwt90fy/LGsZIP1YhwNRua5NJuLQgIjkhvga1eyJwx1Hx+zNO9J
         oDeGaUIcoAdUNQKtcRi4+GmqN58559LjFWsE7cVDFvbvPf1NISCDeudEcgmCZhcy9tBc
         13VQ==
X-Gm-Message-State: AOAM530AFp1Ld9VhY1/m23fjYvDaJ52JFqUuAZL7lbf33z5ggWNyxkqS
	6bu2Va/7cpOvYYprw/qPt67/QKJvrwITLFMYfzr8CA==
X-Google-Smtp-Source: ABdhPJw1vSctPW8saHhj1FGspU/fxdcO6t1LvGwNO4aTt6W6d1v0JCyqb15ZQrKh1+6SniqvhSjPXoVXuqbGSbR4L3Y=
X-Received: by 2002:a25:d107:: with SMTP id i7mr20792477ybg.495.1643014302301;
 Mon, 24 Jan 2022 00:51:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220121075515.79311-1-songmuchun@bytedance.com> <Ye5WfvUdJBhZ3lME@infradead.org>
In-Reply-To: <Ye5WfvUdJBhZ3lME@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Mon, 24 Jan 2022 16:51:06 +0800
Message-ID: <CAMZfGtUab0PS7tO0ni4Z7eSKWc0UAVQO=prc-iKNj0S67qaRtw@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: rmap: fix cache flush on THP pages
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	Yang Shi <shy828301@gmail.com>, rcampbell@nvidia.com, Hugh Dickins <hughd@google.com>, 
	Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, zwisler@kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, nvdimm@lists.linux.dev, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 24, 2022 at 3:34 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jan 21, 2022 at 03:55:11PM +0800, Muchun Song wrote:
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index b0fd9dc19eba..65670cb805d6 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -974,7 +974,7 @@ static bool page_mkclean_one(struct page *page, struct vm_area_struct *vma,
> >                       if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
> >                               continue;
> >
> > -                     flush_cache_page(vma, address, page_to_pfn(page));
> > +                     flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
>
> Do we need a flush_cache_folio here given that we must be dealing with
> what effectively is a folio here?

I think it is a future improvement. I suspect it will be easy if
someone wants to backport this patch. If we do not want
someone to do this, I think it is better to introduce
flush_cache_folio in this patch. What do you think?

>
> Also please avoid the overly long line.
>

OK.

Thanks.
