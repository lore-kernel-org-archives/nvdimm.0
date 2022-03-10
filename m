Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DD7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:49:47 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id g1so10997078ybe.4
        for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 05:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YrHkxxw7wa90Lz7KvljazCkAUUcPibWKOq87Yk0/n0Y=;
        b=XGmoL/c7V6Yac4ZEaR34Gjm6a6GdVsGuTpFSzLBHc7yEcOzghG/dIhCfJ+IGa6DGll
         um2nX+BPpcofKOEbHuoL0ARr8fftC54cYzbFusMr6qktOlTX3nwet/pOE/oOrbEgTbIm
         srktgS+dbasgTIFOXTRuTk/81fHPS2YRD5Neg1yH/Cl5HvDHv3i0A72w/W3xYjyBQMzc
         EsCvzG6S6GbCocy2VVx00HQUHM2UZlwJ+TSmxKTBTpCMToZr7jfpd1ggOOExyE3B8Yrg
         WIa0Nno/JDdKOiGkQZstYOF7gMjwyDZY62fKy6S1uh2KkxNO/Jr9NuUMbgUc+oyiHHoM
         aWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YrHkxxw7wa90Lz7KvljazCkAUUcPibWKOq87Yk0/n0Y=;
        b=TjqyZ1rwVS1fdPNLsIMDvfRG3DOkDVX5Sm5sAoNv84XrpsxDbd3EG8MXgipTS82Emh
         5TTF5w19w+GZ9q/5Cea8dytv8eDVIOenp20wXAeD2BZ/O/0h48JFhA5EoTbj7OmK7PzZ
         9aZ1oW/lHDh5ydwAyilhcRDo9nsr5/LjECEPUhI6H42+HZKkw/c6XS+yHYjQ9gs3fCQv
         O2pLiNnVNnjM2pRk6hpf4j+P++t9b1mfqsjRt3uE0yhyrEyIO7lMdLTEzboBBKyoAlgG
         mFsu6h3H2AueRHZW7q13GnPfCZBUdl9/67bHajBQ3GVWu+Y3HsOG45ivU2LkkHcy8zf0
         Uefg==
X-Gm-Message-State: AOAM5329hNF1GKNx0y/2mQSbAMcb3a/ndrPtpUZebUKdatPrwuRKMhpi
	Nq0MgoZ+NVX5lqhDWcjL61ruHvBnKs1PQEm7m2b3GQ==
X-Google-Smtp-Source: ABdhPJxEyh0BnHyunA1YVnIuCNPWGZHleKd1WO6N3gi7S+63k2cJ+dICHYCAS3kauxgrvZDRc7AkiSHCwy8gPXQMxcI=
X-Received: by 2002:a25:8390:0:b0:629:2839:9269 with SMTP id
 t16-20020a258390000000b0062928399269mr3888598ybk.246.1646920186546; Thu, 10
 Mar 2022 05:49:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com>
 <20220302082718.32268-3-songmuchun@bytedance.com> <CAPcyv4j7rn8OzWKydcCJNXdrhXm6h6Vq5n7uLzP5BSMJ_qSZgg@mail.gmail.com>
In-Reply-To: <CAPcyv4j7rn8OzWKydcCJNXdrhXm6h6Vq5n7uLzP5BSMJ_qSZgg@mail.gmail.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 10 Mar 2022 21:48:01 +0800
Message-ID: <CAMZfGtUNRAb3qnx5-ZV1uPEx1aLNbkzjJw5JrUzX8tMbR9AGNg@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] dax: fix cache flush on PMD-mapped pages
To: Dan Williams <dan.j.williams@intel.com>
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

On Thu, Mar 10, 2022 at 8:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Mar 2, 2022 at 12:29 AM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> > However, it does not cover the full pages in a THP except a head page.
> > Replace it with flush_cache_range() to fix this issue.
>
> This needs to clarify that this is just a documentation issue with the
> respect to properly documenting the expected usage of cache flushing
> before modifying the pmd. However, in practice this is not a problem
> due to the fact that DAX is not available on architectures with
> virtually indexed caches per:

Right. I'll add this into the commit log.

>
> d92576f1167c dax: does not work correctly with virtual aliasing caches
>
> Otherwise, you can add:
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks.
