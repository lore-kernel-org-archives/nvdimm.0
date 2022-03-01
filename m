Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3433217E4
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 03:15:34 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id g6so24563292ybe.12
        for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 19:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T0AjxvjFrHR6fu2oGFLcKZSFRRlXKq1Dcqtae0GYicM=;
        b=zI7OFwma/V9whbuWLP6/dekw2Ef4XO1BHT/odjfXiqqBSBN3wNRSaGlW2e5S3DMHh7
         6nafsyPBh4XZpyLf2y8+bx1wiOP4m/XVyOhznsE0nDLtBWURJEZWY5eN+FSlXebfO/aq
         MwUsslVUGDBvCplLbj0DodURsvuHlZKfRKRtG0HI9/Ohu/g8Fmg0lYEl7PCIAzTcnaWE
         Up6KvQB5PLEdim8+dqyWUZVrTMjwU+YF2tRj6Iur3Wzj7yuugcJee25X7gymnZVLr5Q2
         EiswuU88iHSTSH58Nu6p49kDjlzAq1dGIhw6LjEOdmlf7xGuc1AM4V3PFzyIodKR2Uzv
         nGpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T0AjxvjFrHR6fu2oGFLcKZSFRRlXKq1Dcqtae0GYicM=;
        b=TPe20PNEe6YQ67ZQR9h1tE5nyKfO21r7myz2okTGKZR7L/cD/24x6/hr1+r0jeOwrD
         ZNPSq60tzQppcK1h1J71QEEfMYzDToIsHUCY8weSoKL0qRINF4wY7FjSPFH8+uzYvJYx
         0KnyqqWkWBCo+vQrED6cc0L0lk6hEXK4x8l17u2E0/vtZmBm8GgozBSJdPLIQZiqKXUY
         SGWC46uA8XTgc2ocWLhRNQcPxW3IsTpDwzMH4pnllvs1bSXPfIw4aFsIeVVgjd+sZWgF
         33IUwiigbfD8PzUoNGamf5yI5FaViVzFD3TczGSJMQxbrN9D3uhLWOBd2K5OsFIBVn9O
         mSsw==
X-Gm-Message-State: AOAM531ZHCtgyt3k+gIHW6zYb+dNK6xTOnoAF1dIP3oYC8F1g0VN/KMl
	2i/I5Df0CIo3Fmnf4QXHML13ulbNdPvU51DNrWAUTQ==
X-Google-Smtp-Source: ABdhPJyLlgGIyou+wAfEaWXmEmFOpM1Brk7yD9bDbyrwHm7wvg19Gmdb28Sqk2YKeULEgdNtRu+P34JXz4ZnYeV1Fww=
X-Received: by 2002:a25:3d87:0:b0:61e:170c:aa9 with SMTP id
 k129-20020a253d87000000b0061e170c0aa9mr21333575yba.89.1646104533214; Mon, 28
 Feb 2022 19:15:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220228063536.24911-1-songmuchun@bytedance.com>
 <20220228063536.24911-5-songmuchun@bytedance.com> <20220228132606.7a9c2bc2d38c70604da98275@linux-foundation.org>
In-Reply-To: <20220228132606.7a9c2bc2d38c70604da98275@linux-foundation.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 1 Mar 2022 11:14:53 +0800
Message-ID: <CAMZfGtWrHCdE9PfUK2MGHfujBU=o1Dxv=ztdFwhXpjcTPCxnPw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm: pvmw: add support for walking devmap pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alistair Popple <apopple@nvidia.com>, Yang Shi <shy828301@gmail.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, zwisler@kernel.org, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	nvdimm@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, 
	Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 1, 2022 at 5:26 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 28 Feb 2022 14:35:34 +0800 Muchun Song <songmuchun@bytedance.com> wrote:
>
> > The devmap pages can not use page_vma_mapped_walk() to check if a huge
> > devmap page is mapped into a vma.  Add support for walking huge devmap
> > pages so that DAX can use it in the next patch.
> >
>
> x86_64 allnoconfig:
>
> In file included from <command-line>:
> In function 'check_pmd',
>     inlined from 'page_vma_mapped_walk' at mm/page_vma_mapped.c:219:10:
> ././include/linux/compiler_types.h:347:45: error: call to '__compiletime_assert_232' declared with attribute error: BUILD_BUG failed
>   347 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |                                             ^
> ././include/linux/compiler_types.h:328:25: note: in definition of macro '__compiletime_assert'
>   328 |                         prefix ## suffix();                             \
>       |                         ^~~~~~
> ././include/linux/compiler_types.h:347:9: note: in expansion of macro '_compiletime_assert'
>   347 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:59:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
>       |                     ^~~~~~~~~~~~~~~~
> ./include/linux/huge_mm.h:307:28: note: in expansion of macro 'BUILD_BUG'
>   307 | #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
>       |                            ^~~~~~~~~
> ./include/linux/huge_mm.h:104:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
>   104 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
>       |                          ^~~~~~~~~~~~~~~
> ./include/linux/huge_mm.h:105:26: note: in expansion of macro 'HPAGE_PMD_ORDER'
>   105 | #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
>       |                          ^~~~~~~~~~~~~~~
> mm/page_vma_mapped.c:113:20: note: in expansion of macro 'HPAGE_PMD_NR'
>   113 |         if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
>       |                    ^~~~~~~~~~~~
> make[1]: *** [scripts/Makefile.build:288: mm/page_vma_mapped.o] Error 1
> make: *** [Makefile:1971: mm] Error 2
>
>
> because check_pmd() uses HPAGE_PMD_NR and
>
> #else /* CONFIG_TRANSPARENT_HUGEPAGE */
> #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
>
> I don't immediately see why this patch triggers it...

Maybe the reason is as follows.

The first check_pmd() is wrapped inside `if (pmd_trans_huge(pmde))`
block, since pmd_trans_huge() just returns 0, check_pmd() will be
optimized out.  There is a `if (!thp_migration_supported()) return;` block
before the second check_pmd(), however, thp_migration_supported()
returns 0 on riscv. So the second check_pmd() can be optimized out as
well.  I think I should replace `pmd_leaf` with `pmd_trans_huge() ||
pmd_devmap()`
to fix it.

Thanks.
