Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32E7F
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 00:06:17 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id r12so3375920pla.1
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 16:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQJaIhmi/QzFmALiltJXNjf6ckrS2EgY1Uh0aPn7MYs=;
        b=gHn6uRZhcwc/1/iluj+hvVI/tjLthpe0Akd+MQKuvfdxMcu9PCDly6aCrg472eEh3m
         TjX0NOdopbKbRdKaTnbzERgZdM/mueEx2YG8+M+5257GEhp393PupeQgUlkt7oFEvDNE
         3oK0YaD8xaVKZQHhdXj8we5uTjgvoB98hHYuntfbhhJEs/08fC7MpT6rEISUbYY/ic66
         WSvO3h2xy30LL3YTP0oNjR8eybS0lFiAfsfYGA4HOD3rEng97uK2wZ6VlssMAfKNTXSz
         EKoRjaRuHELjmnQMxekNcgSoQf+ZMttBSndyI4apgf7t9m0BmZJQgb+1OpttRu0tnJ2D
         9JGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQJaIhmi/QzFmALiltJXNjf6ckrS2EgY1Uh0aPn7MYs=;
        b=19F+zD3NLx40usSi4M1dmX24+vwrjpE/Wm9wyz7JI26M9WaasoxFqal/oS21bqzYpg
         DfSf8Wr/TkaItPVtK9kzyjLPlpQE/oPPMABRhBk+zStqPIAv67LzflKieuC/ROVZ6lkb
         Xn5GaTNd4RA/0NY06C7HnH/kFVNeommMfI0zJa3TYn6lXxbjD4r6bjKR3pv/tTSdDeEP
         Gjvb54y1fNi5NqYdLS8AAXoOtJ5jPAL1O+QNkQsOAB+WbId1HQynugOb5Gd8sbTuwF4R
         09J9v1VIwsAOoO2d1k4mDN01p6kPrLVRsqS6Mf1xwLghq7pLXeouYcrI+rV//FX7to1w
         hKxg==
X-Gm-Message-State: AOAM531gI7wlVwUg+xwbr/C8YSJtuusRmG2wob1sg4bTZOrKA43Ec4U+
	ZbYCJWvir+EI2Ub+T1U918k0kDG5YD97OX7u+xfJdA==
X-Google-Smtp-Source: ABdhPJwb9kJQ7QI7FmWPhygsP7CpEdP0qVgYwpDcpFWyZG/Qf8Jpi7IliqWagwPdOiBZnW2yD9cno3XpwTf/bXrgthc=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr2305234pll.132.1646870776595; Wed, 09
 Mar 2022 16:06:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com> <20220302082718.32268-3-songmuchun@bytedance.com>
In-Reply-To: <20220302082718.32268-3-songmuchun@bytedance.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 16:06:05 -0800
Message-ID: <CAPcyv4j7rn8OzWKydcCJNXdrhXm6h6Vq5n7uLzP5BSMJ_qSZgg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] dax: fix cache flush on PMD-mapped pages
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
> Replace it with flush_cache_range() to fix this issue.

This needs to clarify that this is just a documentation issue with the
respect to properly documenting the expected usage of cache flushing
before modifying the pmd. However, in practice this is not a problem
due to the fact that DAX is not available on architectures with
virtually indexed caches per:

d92576f1167c dax: does not work correctly with virtual aliasing caches

Otherwise, you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
