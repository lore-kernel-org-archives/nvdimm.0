Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E6470
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 02:54:13 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id a127so3745669pfa.10
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C90l7UH/YbMRyELxbBHByt2xcdW8Ch3InZoolsX6UZo=;
        b=tZiKTFH0YsHg3h/aDt2SiBtLUkYsFlXO5g3gj2mAXaX2Je6Y0a7i805bqoPsZKZmVj
         XjvsA5vskZULMgND6WSPz2I3ucfEr8Zh1G1lFSoPab6CJjv+0ZDrdSggEj0GD9qjfjT4
         KZ97dHwETzNhEwbJZORnXbDgoEhQvi55go1o2ZGdkPy1peepsJY+4GBgaQK8bQ3cXwBv
         anG224BiSL3DG7FYGz/s87MRHFBn80aMR+Mmft10qtFMxUNmX0Q4fT3nS619dhEWSu2b
         n+y2wKRxMmIkmwrxuS4dxs/s4K3463XqnENG6TnxT1dKH0HuJUPUQLBjYOgO1ucBNLNo
         MnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C90l7UH/YbMRyELxbBHByt2xcdW8Ch3InZoolsX6UZo=;
        b=b9I2fwmtvx7bnvCwEpFcaS3/Eb9j5Jtit04t660L+cY5RITPuIzMwK/vrrWX2RooCZ
         ZjDr2gBV5j3Z8fLOHLND4GA9rjUpYubuyIdI7uTkFzJj3jp0Sx9TchEl3taEziO1/ueD
         4fcS4Zr5okb66umj7K+WBzQ+V8XWXxOdCAzhgYWXXge12BvVFFwZjLDUoddfFnXdkqM9
         spUPbZVkxD3NhGSDLysRZqsDOTkV47RUu2FIVNvxDGIuAtZC7+D4UMewKeB171OTGuZ1
         vZ88tdS+bAvU2mvRLXxltU/2y+xTZodpOnHx+0M6/iSnParEjJc8kj0KldcX2LyDtE5B
         eklQ==
X-Gm-Message-State: AOAM530/HnRttefad3tdbCKHPNjQX9pxy+4qHTN2qNMFOd6/+2zB6kns
	afXoGpFHohPbQGco8NGSTXp3tTXkomOKgpRG281OQQ==
X-Google-Smtp-Source: ABdhPJxHxk0QDwb10wnGqRmVq/VMVZ/VNOfw+9uOUQ7cTgD7H6IqGRmEEH9vEbdDhUQj72sGNuYENyeprDsy/ULlcjc=
X-Received: by 2002:a63:5963:: with SMTP id j35mr1598651pgm.341.1626317653069;
 Wed, 14 Jul 2021 19:54:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-3-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-3-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 15 Jul 2021 10:53:37 +0800
Message-ID: <CAMZfGtVhMbQ=QH__SbM4zf1KYBPSVsOcA-Cho2k832Qqmz+uMQ@mail.gmail.com>
Subject: Re: [External] [PATCH v3 02/14] mm/page_alloc: split
 prep_compound_page into head and tail subparts
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
> Split the utility function prep_compound_page() into head and tail
> counterparts, and use them accordingly.
>
> This is in preparation for sharing the storage for / deduplicating
> compound page metadata.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
