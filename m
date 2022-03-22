Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3FA31
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:48:55 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id h126so32467099ybc.1
        for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 01:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QUKbEll3B3MyYDyon4P+rDcqkN3F18MECGrGkqKUuno=;
        b=rm2us6OKRLqK7uRSyjF58yCfkJFOuUQJ9OiT0aRPlGY+hdgxdLxevBebqmkYxi7Kvp
         dYYnA0yznikOIfcp94kmvCoHwd3eBaIBjlxJ5Ao8gBTwrcNcKI6+UrEemVYlvx+6/UVx
         xQVQLCPAuf2wJfSSvaL+r0brkUh5rLAurDIX9UxgFBAzX35pIb/O7NdcUgsovcWiJygc
         +F4Hmk9ymVELB1ruVF0OKDyHW3I9h6mok5rpFm1I/Rmx2oeIeTvKOXwH/USeLye/E6CX
         mVxSVtQpis0R05ccolu21RU+dA8oYht1hQDmNtryYzocmi033mHBJGcf8CtqqD9ukgUX
         BV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QUKbEll3B3MyYDyon4P+rDcqkN3F18MECGrGkqKUuno=;
        b=50KMHL4RAOkj0dvm3Yk0+//tQ4wOowZb7nSw5k6FZhuKgKsyj/pkRcy9HDV3IIhFcL
         K4vXVjCzpZpcxaZ84A+r2pVPykR0Zqxiu8K0biurLUfG1FBnpoTI5gX9+VXhL9yQVeTV
         eG2WTREICTZiGGquzPfvwDnMrGfxApvj/VGOEiRv3Sv/+vFOTNECx4J5/26GbUYBESEE
         IWc6L7hPvXaDxVJie4jg3evEsCAyQ/1Av791I9SdhTJFbHY/EZWbPxgQOyOjfSQILNpr
         cZRl4bxfbr/vtxPTeSq4++zJvxdP/Lh25i6RFOhL6RB3fvyJOTikSugZnWSyRZ/cNG+0
         Ohdg==
X-Gm-Message-State: AOAM530rZBX+2TxlCuBPpwad2Jr0AyEsuo1PQ2KE/50SSR+bKFPaDDEA
	/7oFCyzCATadmXPpYxZPQCVnik9ACna+ubrHGTvCpg==
X-Google-Smtp-Source: ABdhPJwub/NwJPB45j1iuLmm89NuZIw9wFdhV28CEQ33EGCiwtZ2hoVGFhhKU2aj/mWUCkmcesq4ImawnosiJZEkcZo=
X-Received: by 2002:a25:8390:0:b0:629:2839:9269 with SMTP id
 t16-20020a258390000000b0062928399269mr25658972ybk.246.1647938934543; Tue, 22
 Mar 2022 01:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <20220318074529.5261-6-songmuchun@bytedance.com> <YjmK0aaCu/FI/t7T@infradead.org>
In-Reply-To: <YjmK0aaCu/FI/t7T@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 22 Mar 2022 16:46:59 +0800
Message-ID: <CAMZfGtVBqVwHpoaotp+HF8+Sh-U3onKBBbQY69UT9SrGGOKVtQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] dax: fix missing writeprotect the pte entry
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, 
	Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 4:37 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> > +static void dax_entry_mkclean(struct address_space *mapping, unsigned long pfn,
> > +                           unsigned long npfn, pgoff_t start)
> >  {
> >       struct vm_area_struct *vma;
> > +     pgoff_t end = start + npfn - 1;
> >
> >       i_mmap_lock_read(mapping);
> > +     vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
> > +             pfn_mkclean_range(pfn, npfn, start, vma);
> >               cond_resched();
> >       }
> >       i_mmap_unlock_read(mapping);
>
>
> Is there any point in even keeping this helper vs just open coding it
> in the only caller below?

Good point. I'll fold dax_entry_mkclean() into the caller.

>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.
