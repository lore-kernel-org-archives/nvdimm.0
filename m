Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8822F80
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 23:23:25 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso1543580pjo.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 16:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJppDtDekYuL4cldpvhWyZyRjcblITCSsPeqIjft4RM=;
        b=yr6kw4zf3gIwms/Q88NRoMz75sAKL02QThM0wQN+UqNWENuFrKmN+BaWXb7ywu+cYJ
         fU3LyjFZwemn2aKXNQl2EhOw1XmpolDFwb/6zlB8ROPTufuWXtwoD0Uxaut87feMA1q2
         jqgz7QMHLSk1uGXvOkPQ03plMlEQntwl/QOf7opT3eOBuODi/Iji1fjDl0nGXCjm9/gJ
         XZODtSaFfxiDXJB9BdfFmnGZk9BxuwqtZ54ym5WAC/vzHSxuCIXkw0Yk+YzRB8QQkhzL
         LuArIRpDS18WAYJWDMr8TDCFmRWjxSN2zfBSw6d28X6uRedeXFM2OgYDReK89s1M2P+w
         G+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJppDtDekYuL4cldpvhWyZyRjcblITCSsPeqIjft4RM=;
        b=bWU+8WHJMwwStyN7wZ33Kkc153QINA0u6H8XNtBR4fBT4cm/HU6Rvqos+tvr+l7Ibi
         +q3MVFOohrgyALY0+VsfTD5Gg2T7HurBScdW/grqfQD2ZGfLyGnqtufct6ql9F8MtjO+
         GkKkf+lFoEianBCEpmfkJ5Qawsx9Xf61rngAagw448NgCbViISeB7X81h9j4DkqXhvFP
         fWEdiWeT1OunZ29eMUI4e0UG7xXexJ2WDQjLACgWsfcUo/jVvEogEGphZjWzJu9W3S20
         YQFw3OLOtLgMJ1bv4c/XKo6dsq1IbfiE+gTKzJmg2HibUSyyQGhX9bP/dNIWMxUjPTKj
         Wgpg==
X-Gm-Message-State: AOAM533h6F5Y3G7f4Jc3OVAPYe7u8S4JF08HxzQlCy/bnugcx/yG83nn
	XIlgDkpj3aBspMZ2m9dSTut5pHB5SMjd4jWPoSNqPA==
X-Google-Smtp-Source: ABdhPJwLO7kXi5PzPgZkkGTm9QpggNSyfhWzfbITFv6b2qe0ZlE5ljlM6M13ncXAS3Z4qLENhnEhhA+Yvdr6t8zRaqU=
X-Received: by 2002:a65:5544:: with SMTP id t4mr25771932pgr.240.1627428205422;
 Tue, 27 Jul 2021 16:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
 <YPjW7tu1NU0iRaH9@casper.infradead.org> <5642c8c3-cf13-33dc-c617-9d1becfba1b1@oracle.com>
In-Reply-To: <5642c8c3-cf13-33dc-c617-9d1becfba1b1@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jul 2021 16:23:14 -0700
Message-ID: <CAPcyv4ho7idBPU8F4qE8XWhRttkdfzQRATaTAw2C3AfY+Z2BdQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 22, 2021 at 3:54 AM Joao Martins <joao.m.martins@oracle.com> wrote:
[..]
> > The folio work really touches the page
> > cache for now, and this seems mostly to touch the devmap paths.
> >
> /me nods -- it really is about devmap infra for usage in device-dax for persistent memory.
>
> Perhaps I should do s/pagemaps/devmap/ throughout the series to avoid confusion.

I also like "devmap" as a more accurate name. It matches the PFN_DEV
and PFN_MAP flags that decorate DAX capable pfn_t instances. It also
happens to match a recommendation I gave to Ira for his support for
supervisor protection keys with devmap pfns.
