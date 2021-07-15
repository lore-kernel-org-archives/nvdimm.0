Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901A72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 00:19:28 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id s18so4239513pgq.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 17:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xptbCn3ZR6g3HHgjV/Xny4YP8XtafdWsr2mlA0mT64U=;
        b=pZ57OUfv/A3XPbSrq8TjPCfFK38KeIBp1cKqaCSFN7yDgtXstzslwp1/cg/MWnHAEN
         rvjpTla6Pmpq+QRIYprdqlOiFG+xlEpnftL5MubgNlUfRXI/50E22pRThISLKzQGRm91
         T426iHag7KVqecSn8VNEwbN+5H/YssX5MBL3Lf4IOMmgmarVnbvUs5tDpeDxOvutdR/2
         4FtpgUIAtm8XwgdS+VjlbErD6HSB3EBM1TxTVba/7RdwqO/s60/OwiwcJ3DT1FrJLgo/
         p5gBF+iuRXGZFPtm6NkAULS/PPMWaoMovxzzinqrf0SdnpMx+VQdMsRihIB7dDSamVvh
         7b6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xptbCn3ZR6g3HHgjV/Xny4YP8XtafdWsr2mlA0mT64U=;
        b=rnzt4dmoHfjgiPinehWVdOQd+TLzC2/OQ475mVJOX7TVkzu+WkhjfIc9cTBHV+Vg7R
         +23GTI+U6gAJt08omPu25uPjDJGCIGA6aW3pH7oTjoo2YxUAYGj9/rqKWlXSRllzuPMN
         k3652blgBN8HhHmEqYIUs22Ar2XI2X2Sk+jaIazN5L9CSIQ1/okbWxclBNptJZuU2FJ6
         HTl7af1lJZQ6r0WNxd0xRW4AL7E54EbbKSxNHHFXAkIwURCFkjIR4NUjgLCDzmsgJgEq
         FEAxSg8P+NwkSK49IzGx4DmgHZFmsNbA9nnspXo5Lsdodxk/YwB2QFNsvd9/tYpn62n0
         OM+A==
X-Gm-Message-State: AOAM531aG9j0uuzFtck4BY7INEIZHs7Hlj42x+YoMVhCg0sONmQZWmpK
	iLkAQG2KLjgbYfx0IyZXTsewBBCLMHdWCjGt71l8dw==
X-Google-Smtp-Source: ABdhPJzr3Gu4NfSezOIp9S9hnR9ZfNwv/i1ULAds8y94a5pFZ/UrtXrOB6tXMxlT/ruiiWH0tAJd3Csnh7XSYP4bKvU=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr620397pfv.71.1626308367997; Wed, 14 Jul
 2021 17:19:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-3-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-3-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jul 2021 17:19:17 -0700
Message-ID: <CAPcyv4iZGLzzv7o7JK3iTu6rudX2d0-OqV-ueDhx6w9fminnAw@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] mm/page_alloc: split prep_compound_page into
 head and tail subparts
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Split the utility function prep_compound_page() into head and tail
> counterparts, and use them accordingly.
>
> This is in preparation for sharing the storage for / deduplicating
> compound page metadata.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
