Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99C92CA3
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 09:01:41 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id i62so2628047ybg.5
        for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 01:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qPuSl5NxTGIIFIMAw/dyMyil9mBbCPqU09NIe0oAokU=;
        b=6llndIHFqFppJ4Gj2xb3cyh+pp6mM711rLtlQwGBakuS3Q/v/2zuj98cryr+VeHrrL
         o2nf1CmZkHq3QGBrZz1wVwwc8efKujB3hPJQp8C18rdlsVNUx09LyjgmCG4xxoPWQIrH
         tXOo/ee/k5v9Ic/JAECmKiaQPChSJqOuzivhyfpTWcq6rXvOTLL8Q47QcHdVdH9eQdL6
         9P494f3fHakyK4GIkdVdr/un6XlnRhD8Slk1P+r1/j+V2wqnbtDvV8odCtEhc/ohlZU2
         d5OwhJx6507d5A3f02MdKERpXa4k6wccCLoHWkv1h56Sik5coVN96gQjQkpXch7rsJIB
         Z0vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qPuSl5NxTGIIFIMAw/dyMyil9mBbCPqU09NIe0oAokU=;
        b=DS9ZOrZ/YxNLDW0dB4bMyOZD7eiBu34Npvia2JYqamn0hEEmGbB5OaWpJWaDeH2eQU
         IQ/C/BQ8Do7WvRwzKBDj1XnL2DOm0R1fXFijlaCybN+z1aTUjSwdf0t0Uau+7l1kYnBV
         jWVfl+o9prAcQelG4bbzN8ks+ENkaj2Yd75cqPDS7mSrrGvzoHM4ACk6opHEOFfuwNkd
         rR+J37nywH6s+RhT79WYGRJMHgr/snJMEzSo98jRwoEXpQXNtZ8OD7SXyf3PKvjDzuhx
         9syz9gQwDi1jF9AK5AlumSxS4Odi8yhZzWPBhBEMl+AbBlvAZsntWqzSfq3XeX57Us3a
         k2VQ==
X-Gm-Message-State: AOAM531kuRM/TyFguqIsy3jQ3Ap8T2QGT0fzHWkertx36SjNHvqc/nsX
	bpaxq/wKMIXGq5NzWuMYhA092QmmzLgK7PPUZ4cb8w==
X-Google-Smtp-Source: ABdhPJxCB2+GYystUm4f6yE23AKfFLdR4LWU/ii96fyLJt0DuPLnpNq7DG11ShRdZIfMVzy8ewQT7cV3z2wTwLiVyRY=
X-Received: by 2002:a25:6d09:: with SMTP id i9mr20946206ybc.703.1643014899644;
 Mon, 24 Jan 2022 01:01:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220121075515.79311-1-songmuchun@bytedance.com>
 <20220121075515.79311-3-songmuchun@bytedance.com> <Ye5XEeMYt8c7/iMV@infradead.org>
In-Reply-To: <Ye5XEeMYt8c7/iMV@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Mon, 24 Jan 2022 17:01:03 +0800
Message-ID: <CAMZfGtWForYqmrZJFfOVw5pQPq8idQxwT9aFcUuCJMjdE6Tf3Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] mm: page_vma_mapped: support checking if a pfn is
 mapped into a vma
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

On Mon, Jan 24, 2022 at 3:36 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jan 21, 2022 at 03:55:13PM +0800, Muchun Song wrote:
> > +     if (pvmw->pte && ((pvmw->flags & PVMW_PFN_WALK) || !PageHuge(pvmw->page)))
>
> Please avoid the overly long line here and in a few other places.

OK.

>
> > +/*
> > + * Then at what user virtual address will none of the page be found in vma?
>
> Doesn't parse, what is this trying to say?

Well, I am also confused.

BTW, this is not introduced by me, it is introduced by:

  commit 37ffe9f4d7ff ("mm/thp: fix vma_address() if virtual address
below file offset")

If it is really confusing, I can replace this line with:

"Return the end user virtual address of a page within a vma"

Thanks.
