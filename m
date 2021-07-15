Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D54170
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 09:20:16 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so3360598pjb.0
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 02:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6pAhtSqRq3EZDsI0szqPR/lESeA+rPyUtVd7J89gp40=;
        b=rLsmkhldrp4yl3Wj1JRXZbOHe3pAbHtpqrRAlluoOR/eDaY0YRxccgzCKFvyXLr20f
         ljivsy3JYKVoLfKg7n6+29ruUL/gIBr5Jwgbv3XtTLTOmb2XF30tGCIKOmtMCabjzA6R
         NyI2gAUkaEBgCSUbRMY5xZI7zlvQxJA2S0/z20/tJZIWYZGZzwxGsYEs36/hHpn+DS0k
         3O/1hZ0aKIFjPlLIUmOx+9rE7YgV7lAk+aQtNyJiqnxZNzDRnEKA4rDxOUAZVVh6ADzS
         mrsdr4dSSszl+wGv/SKWdCi+ZPHpxW2IwE+wht66O1Ab/GIC7d2gTSDzqDlBCzcz3S9F
         K/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6pAhtSqRq3EZDsI0szqPR/lESeA+rPyUtVd7J89gp40=;
        b=M2TR/P/Bz2EZA7ZOuA+rIcUsWwdMejnByAXTjZLKO34UwbmypFmharxFBM2ZePGrA9
         Aw2679hKqdnbK5HB4TzFAMmpAQ3cJ1gHvNUFfi/ly+nAbGVfIyeCCQRnyS4c3TJqry+V
         G7Cd65o2Zsr52ISPpkmBlhgsJolk1Atu7JQF0GKzMw2XfciLRYguhwZSTDu2FesbL5MU
         rwKWHjRoD2NSL8WzALfL0MNbuULVjSjgnl4hU4L3fHRPsFSsVpL3jU3RR0+5EhOUIGp4
         TKxXawXGyk5oH7TZElxyCf/ZW5sQX7JGIumsFEMbb5yypH+5MFvkNS9A6JI0w/CLqwkr
         iE3g==
X-Gm-Message-State: AOAM530qvBw2nvUj+/3IFm0eiWszNOxmJf17+ayzvjUrg+j4+xJBxUTs
	M5HmlDMzo4UJ6P/kRkIZihZnQVjvBTX4uXrEoM/LDw==
X-Google-Smtp-Source: ABdhPJyoq+CplDAt0++yDKPq5zlRJd7A1inSxCzrPDNc8oARKST5bwqgbLq2thZt2IBorCVGJoXBVKWrQHQ8DpqlmAo=
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr3270778pjp.229.1626340815734;
 Thu, 15 Jul 2021 02:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-2-joao.m.martins@oracle.com> <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
 <YO/YcBTzKTzzNUfK@infradead.org>
In-Reply-To: <YO/YcBTzKTzzNUfK@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 15 Jul 2021 17:19:39 +0800
Message-ID: <CAMZfGtWe1Wc_TZksDAdLmwsAZ2vv9CP0QBr4ABYt+KyqbTbNzw@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] memory-failure: fetch compound_head after pgmap_pfn_valid()
To: Christoph Hellwig <hch@infradead.org>
Cc: Joao Martins <joao.m.martins@oracle.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Naoya Horiguchi <naoya.horiguchi@nec.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 15, 2021 at 2:42 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> Can you please fix up your mailer to not mess with the subject?
> That makes the thread completely unreadable.

Sorry. I didn't realize it before. Thanks for your reminder.
