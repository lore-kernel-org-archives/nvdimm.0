Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62473ED6
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 03:03:17 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2d625082ae2so11019227b3.1
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 19:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LBjw731gOZAZX11izjBDJpMfyEuV5GyF58y13CmjgQI=;
        b=WCSX7/V63Tb5YJ/PxU+KniB8C1Khw0+KR+ynZIbN1J62sE3rn9lOMkIK1u21L5m/Wu
         7IGQyDtJmH0r9tZfIjBsJvXZVpGv9cThH1BPWzrdG/fRzT5CxWhUQUfSxfIJ+36FWv/T
         +fbdnl8jfw6XCmqU2C1Az2GRLN/9bwb8wqp6JCopXfQvVWRK+yBbVN5yhL/lw5D9NlU2
         67UMFEVxKWVXXCBFmVXk3IGYMajUoqN85/eCbgQsMp9rD1PyjZ/7cD1w7VZtYXqup3mg
         SQFgHY041XA52HrXwHG3kfkM9VfoorWaT3r/9b9J9KXy1m9GFCBZ3kMh7WuhGH4qmzHb
         sNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LBjw731gOZAZX11izjBDJpMfyEuV5GyF58y13CmjgQI=;
        b=kD0YLzXrak0aXYpQkSWNlhRtdgJWq0gF50ex5saC+Pyvpaz7JvqPAn+wkCzBNnKT6h
         ZVsBJSZhoOJf+/U7tOTXNc8buLg8WgF4+x7mqF4dnN31DC+rA2dQZ2/c38SDEVQRrLkl
         sLguop713CQI04a9pesDJt+67yfY/ZbQX8RjMRAY4rXCJK92Oq19uP666U69t/74NDAS
         7UUJe8SnEztWu734/+pIbVT0JeLBbHTosjyA/yIHre8cWfSECXt3SYvbSrlhPlIYkuT9
         mgTvHCLgPoXnSD7HzRFqKWXOUUmWn4YKWMco5sH2acv4ohSuVWdvlMalnQ7yOxHKg7Sb
         fxjw==
X-Gm-Message-State: AOAM5329DFq6lEbmEQdxWd93NLocIOAkpcx5aeXtvknZBJ/6XR0UujNe
	04YLYe7UfPhTPLL2NWtC2AWOtq9H7G6De118bMib8Q==
X-Google-Smtp-Source: ABdhPJz2AQ9wlEoioUOpPwIgSwQcN0ZkHflGDqUQfNbL2z/finOeSUCgBTkwVIhrEnBxK44ehL9YfcYLmYISvGb+fx8=
X-Received: by 2002:a0d:e609:0:b0:2d6:b8b0:8608 with SMTP id
 p9-20020a0de609000000b002d6b8b08608mr551938ywe.31.1645671796086; Wed, 23 Feb
 2022 19:03:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com> <20220223194807.12070-2-joao.m.martins@oracle.com>
In-Reply-To: <20220223194807.12070-2-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 11:02:38 +0800
Message-ID: <CAMZfGtXejFZhfs8hUB9MM-oozPhG-TO1PK4p8Z9o4QzmGtWp5Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm/sparse-vmemmap: add a pgmap argument to section activation
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
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

Missed my Reviewed-by from previous version.

Thanks.
