Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE562C9C
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 07:55:09 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id e140so3248909ybh.9
        for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 23:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cFWl4N/6J5B3bDAo1+3Ti4QnX8z8+sO+me8z+ZLOUek=;
        b=qImMfzX75nIsucO3r+h4uLRvcljZb3e7cr/WNACPHJseT0wYpE9507AdRswD3BvGcR
         c36waKHvaxSDJJummhi4bJsR2ZLUt2d19KAIGpgKboZnYuF7ha5MRCfYuuoYNarP46uo
         BPS60oFB1TJ2GEuA/ji+qgOsZmXfkXVIvv/Gvs6Z/gl3AZzJMtClIm/Kbtym6xfkssji
         x202KzM8rI70bEVFKE9ibYuQeV44gloJmmEZzTLTQwjCdc/Y5a8ROxZc/DxHH7sGpxJp
         v2dj8ksVJyvEtVF57xwkgvWynBtLm9sLtOxOyRKx4lYob1PClOU2Pq8ckanFQXKMX4sw
         o3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cFWl4N/6J5B3bDAo1+3Ti4QnX8z8+sO+me8z+ZLOUek=;
        b=Zm6bcNjG1RzSFFNxg5R1QF35WciclQVButaxMJgAqloQMLo51RlmpXnbPYpOdXlv1A
         7wp8JdgpibL/yQbI5eWmeSWhJPg+FXYOS0zcBn8P0e/fuxEK/1c0oUOKN/sjLN15yY0F
         EMwHGCNGwgdfPRNdDu5npxwghfisNTLjnjxgIoVO66wX6Pr2ce45vw3kVmAalEOuqv+A
         Y85aJ78SEP7nOQoKm1jpBeD5RW3mUS9EPLS4QaYGgnKhkFfghzvjqmqZUOCfo29dsbrA
         aK/y4AlFhvbp2thVLTkQiomkh5rDf4ns4hasIG22/S8bwvL8IFBDoIjzjSTrocACLW1+
         70CQ==
X-Gm-Message-State: AOAM533YlhVVSOzhDtPZddOap/P1T2WBggTYHnzRfHxVl8iEDR6ebkGl
	HPm/yqJyoBe9hT47GDlAf0Ye+bJuZOMr/z1kxRBFRQ==
X-Google-Smtp-Source: ABdhPJz36OYGiW0l0r/oylHwfdCxsXvMNwCMmoqyD81+7Jri0bGHPdZ9d2xirwVPfwxyo/MAFmCVBhn5Pt50YkwkrZ0=
X-Received: by 2002:a81:4524:: with SMTP id s36mr478438ywa.331.1644566108982;
 Thu, 10 Feb 2022 23:55:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com> <20220210193345.23628-3-joao.m.martins@oracle.com>
In-Reply-To: <20220210193345.23628-3-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 11 Feb 2022 15:54:31 +0800
Message-ID: <CAMZfGtXM0S1L-AbMXVuCEjFLns4X-jG3mk2js-fFw0uk0RfBHg@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] mm/sparse-vmemmap: refactor core of
 vmemmap_populate_basepages() to helper
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> In preparation for describing a memmap with compound pages, move the
> actual pte population logic into a separate function
> vmemmap_populate_address() and have vmemmap_populate_basepages() walk
> through all base pages it needs to populate.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/sparse-vmemmap.c | 51 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 32 insertions(+), 19 deletions(-)
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index c506f77cff23..e7be2ef4454b 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -608,33 +608,46 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>         return pgd;
>  }
>
> -int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> -                                        int node, struct vmem_altmap *altmap)
> +static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> +                                             struct vmem_altmap *altmap)

How about making it return a "pte_t *" instead of int. If it returns NULL
meaning NOMEM. I'll explain the reason in the next patch.

Thanks.
