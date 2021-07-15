Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A7070
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 02:52:23 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id 21so3776841pfp.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMC/7BJES1xsl6whxIikhxzC8Rq8hRd9OZiivLLNk5o=;
        b=wVWv2guCZsRL63EFpcEV44cSTV9blEjTw/yo7hgyxR635O9UVREcpt+T3FzX4Lluqs
         9G7kDyCSSVj6iBRtHARWGMcpRXOO67gArpetvAoVUDNAwCc0X7fXV/FYFNk4h2qV6m8h
         Rl77vuZNfyFgqZ8+NucSgYQRhhsvVOOEHMixZRwsdM2gXDbNSHflX4NZ/evElDfxPTNw
         fQ/F/dwxnC+KU78EI5foaEWwwjSVMVXQhY2wGXsHoRBXVzLDNF6D6ta0tA9L7rmp9Y7V
         Mv2ayi8gIdpa3QNo3O+RZQMXpnyoYp5hXOYtXJ2V1VmTDMLNEl9V6AigG8qFVNbmsenW
         WOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMC/7BJES1xsl6whxIikhxzC8Rq8hRd9OZiivLLNk5o=;
        b=UW+D92kNXAiG9CsyLZS7xyKV5suu6cZC38/aFjKx+wx+pbJfWT4bvJlTbm/C1llA2C
         K8ENy/3PUl+dd+n8s7Gdlxx9ywPvuljF0+UePjMNWWNgS8txX6yuGaJq7h+UyLU3eZL8
         7TKbir+AN4g7MJHabeFQRBjfMhAN1ah8MlDbS0umz8AeawP8rrczLxynxWSS3S58iC41
         ZxZVH6fRQiL21PRuHCDgG1VZeFBc7v2ULQ7NwaAs2EU+u4mSPm7Z0yPX0q6HCGvHhOm2
         hfEelqJ1f8DdsUJjrdyEhdOA8KG7gGRIi6tO5BXU7LLlemHldWwmqzq4po8ROiLoQ6Mo
         2gaw==
X-Gm-Message-State: AOAM533Px4n2EwyHPTS1I7Dhfc/KYLAC+Chu3Vozni+VPphs+HeanbJh
	9gvKJ6QVgiloAnuaj27ln26pX6DTDBJnNVcYQD5/Tw==
X-Google-Smtp-Source: ABdhPJyCEpo9gLI9Iqz6IRgl/n5sGdxftzB8/eWvGjFyB3LPYbqUeTR0VczLI0dVPoOPiyANWeNQTYTcnqJBBlaPbr4=
X-Received: by 2002:a63:5963:: with SMTP id j35mr1588664pgm.341.1626317543330;
 Wed, 14 Jul 2021 19:52:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-2-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-2-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 15 Jul 2021 10:51:47 +0800
Message-ID: <CAMZfGtWhx71w0b4FM_t2LCK-q1+ePv6YQtQat+9FozLPnN4x3Q@mail.gmail.com>
Subject: Re: [External] [PATCH v3 01/14] memory-failure: fetch compound_head
 after pgmap_pfn_valid()
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Naoya Horiguchi <naoya.horiguchi@nec.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 15, 2021 at 3:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> memory_failure_dev_pagemap() at the moment assumes base pages (e.g.
> dax_lock_page()).  For pagemap with compound pages fetch the
> compound_head in case a tail page memory failure is being handled.
>
> Currently this is a nop, but in the advent of compound pages in
> dev_pagemap it allows memory_failure_dev_pagemap() to keep working.
>
> Reported-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
