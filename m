Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB470
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 02:48:05 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so3034034pjo.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 19:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLYnBhNAj/XYO/bo2YBoHKajEtf9fKNsRXOzJF9AhAY=;
        b=WacdKpDj/uTksZo6/l6FDHFWO104E7OO2DgdbtlDcJCotc2VpJn0V6oiyUYEPdPbsQ
         ssVnr/8JKm8cIKZcniDPaxqhlFzeZFAf3DvwQGD/B1iPdcQ3V/Fpehd6v6v+SXAPJpyk
         iOvMEkx3YaxCr63is2uK9eJ3CCOBEH2cqrC/O7iDRN9K9Sw6OuE6K6CPyzF3PM3V9fL0
         llII3rzUe9qs8gH8c/cQYk4ZZuzDjm1rrXvWSdoIrJjhh+qSlajYgTI+u6zVDvRSRyzt
         hn4jYPeAvnkM7uGQy537gNMVXl9EVQCk26OWvOPizkE9GVOx2c3GXOsZIBAaTKlx4XoX
         EExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLYnBhNAj/XYO/bo2YBoHKajEtf9fKNsRXOzJF9AhAY=;
        b=TC1dxD6BSA/CUNSxXh22M3JtRGJX/imhJ9AsFpHAX8OrYrHIlS8k2GZihJoduIs8qh
         PuIVqf8ZNyXcCmp/uT+Iq36/zgFDna4Dq+yeA/ul1aiaDhy1g0pYrSGKLxJhjO3cjaMg
         f8KOirpdXbHRNeslUP6YNscGWuI9F4Wx5Ncq6T5QSJynef8iBOmNmdRNc7Kw6DZkgQE9
         uXYsT3eKQCSs99EMik7nq4y96mHHBgjQubBAk52caV0yXVi/LR5MSl2LzEU0YI8zN8DK
         AJJ4Qe5ZueBEOJVN49VnUnZH+ufqCcgyFGR7cZuV2x8/wgwbJp9btfi+NPjEiyObXgsC
         XoYw==
X-Gm-Message-State: AOAM532S74mhSsb5Fyi5Ap0hCPoQGvwEXuB4SbeP0rfXv23Amrn+6qZh
	qmZB0oe8Ig8kyO6COH8YFmdNZ55aS591+5Yadef57g==
X-Google-Smtp-Source: ABdhPJwnYKsB/f8VcSXozl4jCzBcmpmRoGBlFdzIHhfg7bLHH9uUQUn0ixm4YyAIqR4ymVuzLh5W7ViAwd54SDp7dgo=
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr1296324pjp.229.1626317284798;
 Wed, 14 Jul 2021 19:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-8-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-8-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 15 Jul 2021 10:47:28 +0800
Message-ID: <CAMZfGtVrv=Eh3PGkgYm+mV_E-mO9_0rVW0LSJsZh0e9Kr9hBFg@mail.gmail.com>
Subject: Re: [External] [PATCH v3 07/14] mm/hugetlb_vmemmap: move comment
 block to Documentation/vm
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
> In preparation for device-dax for using hugetlbfs compound page tail
> deduplication technique, move the comment block explanation into a
> common place in Documentation/vm.
>
> Cc: Muchun Song <songmuchun@bytedance.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

LGTM.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
