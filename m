Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DEF6AD0
	for <nvdimm@lists.linux.dev>; Mon, 14 Mar 2022 20:50:27 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id n18so11884939plg.5
        for <nvdimm@lists.linux.dev>; Mon, 14 Mar 2022 13:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2sXHURm0NoY8IkGl4zp8hYr0GiRSSumlHJx+8DBDR8=;
        b=VhtWPU5hfae5y3UUUMJ53v9z+E9cDVJIzdnbdhqMLcZjn/y1tL1g4Ip4yO+C4Fok2K
         bkA2PkP51EJHCCddXQKObdt27Fru7/62k24TcydvfkiIVLHPqli3aLjUtpSqhf6fdvm8
         1tdvjT2lcpLsz9HkJYzRiUDg0oCZ5KAIkOCZllpiAF6fb+esenRjlDpqT7+FW9d7AchY
         mGVomHGFT+saFC/IwCLVOpGVGM13KdQCU94o195Z/wWPW30GzVIhaRLhaD0BjuDsiejE
         24QuSkzXgDPKVuG/LFy/ynbPOQDZfiRQ0Ri1H2+DhkMdX+72GpsZkfJDWYWMHLKiSbnT
         /mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2sXHURm0NoY8IkGl4zp8hYr0GiRSSumlHJx+8DBDR8=;
        b=ALrHcW9fEHnxnjfGOxCE2zAQ6gzNUH+MwNJ8aaPInykIP6fsINwRPnGaCFDhp/+Em+
         WIBqrcjY5C0f7enBk4FdTFil8y61OxwsOA548SbWLQssAIWr1dnTdWhJ8h0rZc3fFcBL
         Br8J8uuWzmz5NsA/WkXOjR5P/7i4E26ziHEwx/ymJvI1uk2kTy0//WfG/2GO8Cs4ya17
         eZGkRkUGnaSZ6JweefG+LOMn9yn0PcUXxTIOfO+eCYnE6VeYq8FbdLEKTguwX4Q/SV+r
         De0TldAOV2TR72c62ePPG2yxyL5RhJQwSldviGHhl0tMrtnVBziBTMKzezOZHBsW10ab
         XkSg==
X-Gm-Message-State: AOAM531SLdAITlVXs4zmCpSGfcloY4V02VXYoiqxSZyf54DikET2uNrl
	6TuWa00O+S1ZKD8GnYv40aeB6/aLfKxA2JqhVH6RIQ==
X-Google-Smtp-Source: ABdhPJyzK/9bpWo87K7yVfuQDVxjAiaa0iHolmeQz5FZjuIEWLouKzJgJxd/xUTCLfio9rCn6T0zucx/Bsw9kuMKEmc=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr25125235pll.132.1647291026682; Mon, 14
 Mar 2022 13:50:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com>
 <20220302082718.32268-6-songmuchun@bytedance.com> <CAPcyv4hsMWe1AreVVhGJD-St3FGtGBMeA-BX7XbA_kVX97tw4Q@mail.gmail.com>
 <CAMZfGtUmhcryboPdRC7ZhWVuV3TX0rLcKUxhvamAGbHUoATaow@mail.gmail.com>
In-Reply-To: <CAMZfGtUmhcryboPdRC7ZhWVuV3TX0rLcKUxhvamAGbHUoATaow@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Mar 2022 13:50:16 -0700
Message-ID: <CAPcyv4gdP+FSsQW2+W3+NKNGnM3fAfF3d=ZxuCDc+r_AnRBCUg@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] dax: fix missing writeprotect the pte entry
To: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	Xiongchun duan <duanxiongchun@bytedance.com>, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 11, 2022 at 1:06 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Thu, Mar 10, 2022 at 8:59 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Wed, Mar 2, 2022 at 12:30 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > >
> > > Currently dax_mapping_entry_mkclean() fails to clean and write protect
> > > the pte entry within a DAX PMD entry during an *sync operation. This
> > > can result in data loss in the following sequence:
> > >
> > >   1) process A mmap write to DAX PMD, dirtying PMD radix tree entry and
> > >      making the pmd entry dirty and writeable.
> > >   2) process B mmap with the @offset (e.g. 4K) and @length (e.g. 4K)
> > >      write to the same file, dirtying PMD radix tree entry (already
> > >      done in 1)) and making the pte entry dirty and writeable.
> > >   3) fsync, flushing out PMD data and cleaning the radix tree entry. We
> > >      currently fail to mark the pte entry as clean and write protected
> > >      since the vma of process B is not covered in dax_entry_mkclean().
> > >   4) process B writes to the pte. These don't cause any page faults since
> > >      the pte entry is dirty and writeable. The radix tree entry remains
> > >      clean.
> > >   5) fsync, which fails to flush the dirty PMD data because the radix tree
> > >      entry was clean.
> > >   6) crash - dirty data that should have been fsync'd as part of 5) could
> > >      still have been in the processor cache, and is lost.
> >
> > Excellent description.
> >
> > >
> > > Just to use pfn_mkclean_range() to clean the pfns to fix this issue.
> >
> > So the original motivation for CONFIG_FS_DAX_LIMITED was for archs
> > that do not have spare PTE bits to indicate pmd_devmap(). So this fix
> > can only work in the CONFIG_FS_DAX_LIMITED=n case and in that case it
> > seems you can use the current page_mkclean_one(), right?
>
> I don't know the history of CONFIG_FS_DAX_LIMITED.
> page_mkclean_one() need a struct page associated with
> the pfn,  do the struct pages exist when CONFIG_FS_DAX_LIMITED
> and ! FS_DAX_PMD?

CONFIG_FS_DAX_LIMITED was created to preserve some DAX use for S390
which does not have CONFIG_ARCH_HAS_PTE_DEVMAP. Without PTE_DEVMAP
then get_user_pages() for DAX mappings fails.

To your question, no, there are no pages at all in the
CONFIG_FS_DAX_LIMITED=y case. So page_mkclean_one() could only be
deployed for PMD mappings, but I think it is reasonable to just
disable PMD mappings for the CONFIG_FS_DAX_LIMITED=y case.

Going forward the hope is to remove the ARCH_HAS_PTE_DEVMAP
requirement for DAX, and use PTE_SPECIAL for the S390 case. However,
that still wants to have 'struct page' availability as an across the
board requirement.

> If yes, I think you are right. But I don't
> see this guarantee. I am not familiar with DAX code, so what am
> I missing here?

Perhaps I missed a 'struct page' dependency? I thought the bug you are
fixing only triggers in the presence of PMDs. The
CONFIG_FS_DAX_LIMITED=y case can still use the current "page-less"
mkclean path for PTEs.
