Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1D57A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 00:40:36 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id kx6-20020a17090b228600b001bf859159bfso6828873pjb.1
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 16:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RzBwZmXuL2mtDGId2fRGQ9cdH48yHESLY1EUls+Y0mA=;
        b=3fblK4Lx9eyAfaGQJ50OJygXLr3+yngV/09AYMG9DMOQXco1UvGBl0AA0tGjTcpBuL
         qHt6ZCzQlf8sISB0V93pZihkUafr9czsnHqjVeIJB64e7Odk4gEDbBLGV7HMcnb4CNqe
         2ZNlLK9eCP8cYoVJIeqOzgqErWYFpZzaGGpTl6YSYDkjL3SmiSahCh+xtHEDjO0njdJK
         1yi1kqR3uM1lGNvzVBUU6G3FKCEUFo9CWrmmN/lwTOnG6fRdAzpVscQ6LsXIDFtDZ9nk
         89nyYEbe1yTf8OUZXOg10LSsxznBJiSXMT/KFTyNyCSDq5UlCiSA4eUHry3XcY/oaIw4
         Fcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzBwZmXuL2mtDGId2fRGQ9cdH48yHESLY1EUls+Y0mA=;
        b=hRBGpSdnJiF6rElIK7tMffzFVLoHqZ7KRpz8xBWVKlTaw7Z8M8zpjc+AJei1PEPpup
         qUYsM3DFtaU9GgA5byLkDkYuOTr3BojtWQBub+D9OjM+Oqa0z5mmnkU7W7g+UijGmKRW
         +K8OGcxi810TfoTZbWdh6DM1M9+T+r1Nynt76sTUFjZepzWaqTSdBgWLcOKFCnk9WgOo
         EXBye6B6UhFO2Fh+PL+LBRRqsNMpU/rLJ9iaBSf6CSi5pBpknWXzA0PLnmYrzPIpacyQ
         eDHsS90h7SjAYJH3vEKR18dvt2iib6hD6jWE2/AuxP6uf6whgtLrRa1+3ay43v8NDN73
         8OEA==
X-Gm-Message-State: AOAM531ADcPA9ttF3dF6lEFRjWIORJw+pA3LV3jJEGq49QuXmGmzDCVO
	M9CFWbxixeYoS9VB8K2cny1FvwDpM2D7ercy8lKn9w==
X-Google-Smtp-Source: ABdhPJwFz17SQgb4pCOtnBdy5++/qwKC6LSIgtrRreuv2Nn2kEZn09A8yZqo+ZyLEO0m2rhpRcsK1XX++GWIEmAQt2U=
X-Received: by 2002:a17:90a:990c:b0:1bc:3c9f:2abe with SMTP id
 b12-20020a17090a990c00b001bc3c9f2abemr2235610pjp.220.1646872836330; Wed, 09
 Mar 2022 16:40:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com>
 <20220302082718.32268-4-songmuchun@bytedance.com> <CAPcyv4iv4LXLbmj=O0ugzo7yju1ePbEWWrs5VQ3t3VgAgOLYyw@mail.gmail.com>
In-Reply-To: <CAPcyv4iv4LXLbmj=O0ugzo7yju1ePbEWWrs5VQ3t3VgAgOLYyw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 16:40:25 -0800
Message-ID: <CAPcyv4hSg8tZdKSxZtk_iqm=8h-iVyWA_Qj+aqL5aEddnsXEDg@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
To: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, xiyuyang19@fudan.edu.cn, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	duanxiongchun@bytedance.com, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 9, 2022 at 4:26 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Mar 2, 2022 at 12:29 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > The page_mkclean_one() is supposed to be used with the pfn that has a
> > associated struct page, but not all the pfns (e.g. DAX) have a struct
> > page. Introduce a new function pfn_mkclean_range() to cleans the PTEs
> > (including PMDs) mapped with range of pfns which has no struct page
> > associated with them. This helper will be used by DAX device in the
> > next patch to make pfns clean.
>
> This seems unfortunate given the desire to kill off
> CONFIG_FS_DAX_LIMITED which is the only way to get DAX without 'struct
> page'.
>
> I would special case these helpers behind CONFIG_FS_DAX_LIMITED such
> that they can be deleted when that support is finally removed.

...unless this support is to be used for other PFN_MAP scenarios where
a 'struct page' is not available? If so then the "(e.g. DAX)" should
be clarified to those other cases.
