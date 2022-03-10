Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFE15395
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 00:01:55 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id z4so3267428pgh.12
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 16:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PUB8geEpJ+XtoTHFW5CyzSR89RxzbZocHBgXZDsT0q4=;
        b=otdsgu05707Lk9KMy9Xl5aGoGpb6RqPU5UPULqEDsN/2l0x6ZW4fwG3smZmmXYgccr
         uSOZID4KxBtbRYlE+5DzLmbTAZ+0UWldA4oJxDpKPrEnop8Fo9ENjzluPuJpHAt/f0Ph
         JWHz1tJmUUKYOA51azuWN3u/HBuHP6xKdAEKkTinas859+sluZ5V6iIwToVN0w545JZ0
         3MztadxrOxyAdk25++05k8H4fZKxTQ71SQh5zMwp9yN8iMhkMaVGQTUzYKS4c55c7s98
         4/Uv6gYvdgNlFaNfigcT3+pjUGlyDppfCnmg8Tgo1wa+NEPrmpAzqwTGnItaDus8dWJS
         vbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PUB8geEpJ+XtoTHFW5CyzSR89RxzbZocHBgXZDsT0q4=;
        b=velFJLjincPDdsIamcOhHuCPu4OxbJAIE/atU/PKkUH0H+c55Y2dDfcenyuFd3oozN
         9a4LU65XFVDsMTqxMu1aKH4iOuyJ6ntlhCLsj5ZUVYZbkmpFWw9u3k30ZSRsDSbXve9G
         sNu6iNCAJnPqoVPWugEM2RE5xwKyawrOxzOEbkobwKgZhtWIXkoO4sW06CgYiecdw46d
         hAwUqwmjYCBR+AK0relQaKZdZbr8ogdlopSL9rdVfhbR3bKQ/Am/R0Mf0OKxafJDBLV7
         Io0gCQPqLvxy+E1oDKkkzrRvCjPCi8nqVSzFwIcmwalxlzgrsAW2T1/WGLt8bzUIHKra
         ER8g==
X-Gm-Message-State: AOAM531LSeGSXpFLtvqTFRmWwJQO4kR9pZpgDaCNzPHumLRuQ3xke3xM
	uUeVK9D5clqX3EuEN8mInQjV4omV7fPFUs9rPYbZIg==
X-Google-Smtp-Source: ABdhPJxMwIgsbbMlOTDNiL7M3O6I5DfVtqlrxkmc58HdiEKBYmj4+VrHYnD7h5nPhaUJdRIDGvR7mrBpMKdCiPBYlTI=
X-Received: by 2002:a05:6a02:283:b0:342:703e:1434 with SMTP id
 bk3-20020a056a02028300b00342703e1434mr1821136pgb.74.1646870515046; Wed, 09
 Mar 2022 16:01:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com> <20220302082718.32268-2-songmuchun@bytedance.com>
In-Reply-To: <20220302082718.32268-2-songmuchun@bytedance.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 16:01:44 -0800
Message-ID: <CAPcyv4j0cMaknAcMSHJ0U0QP4E2btir2b+1g=Rw+o2CHVQrH=A@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] mm: rmap: fix cache flush on THP pages
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

On Wed, Mar 2, 2022 at 12:29 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> However, it does not cover the full pages in a THP except a head page.
> Replace it with flush_cache_range() to fix this issue. At least, no
> problems were found due to this. Maybe because the architectures that
> have virtual indexed caches is less.
>
> Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
