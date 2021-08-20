Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952F72
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 16:54:17 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id k24so9759182pgh.8
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 09:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/jv/65/o/pr3Arrh3DCsUW+kuq3VQXikqXf2iTWhR0=;
        b=wmKOKlHKACOKqcXgGfzOyuS+T8nTPa0UTHRKzXqyEB7n1oMhL9ybIy4re4kL145HF1
         bMtrau52pfw/I1Kc5cdxzuDtd0Et/jJkS5US+hv/mTQyQM7TcCklar0bSyyEBZaFQivs
         wSYZ7huQEIGoNty7O9v1HlhEnIt+psE5sGUDc9it5+LPZ7q/ulbelZHxwf3w1Cir636k
         IGP2ByU9d0ypCXvfCnbVJxTWgVNrKwxvWAw8s1imwihI5Uzzw1LN35likbg8w9wlGZNJ
         vEpJZYYjxE1je5/O/8C/dWmlALP8frPW0a+yHWctwSdYLH99P7ISs6wJ2ZSV9hwtj/V7
         R6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/jv/65/o/pr3Arrh3DCsUW+kuq3VQXikqXf2iTWhR0=;
        b=Kr3mDmACnNOa8XZh5hQ9VE0FiItzp3GVTPCld0rf8uvRDUHi8/v35FdKgt715avYTj
         NOqajycbULaheXYncizlTW4YSE6LEYn1Ubu2xUtYPy3iXu443iszoq1BJsmdMLNRAQ6D
         TfHM+ZRxmoDeRrcvjqbnzAdkK7szVw88UOg4jkWVnv21mmmuL3uZi75X0l9ReF0kQmC/
         MNSs2PFxCkgYCtq3ZVM7LfGpg8cL+xJyRV6EeyBPy9JuBKU+/n6DoM4gPZWZHry9+8bt
         VUbmJY8i16WDljhqViQr3xWKdV2VmkzdHUX9NRJVCqrPr7BScZ6i5JOrOfbq12OeQQyx
         GHYQ==
X-Gm-Message-State: AOAM5304f1m15CyHQ58QAlB9yg1Oa5x/GL6BCziIPyXC3hljqstFM1lK
	ILhRkNH5kyAbxy5S9GODCvoI/ofxxcj+FPIMX8cU7Q==
X-Google-Smtp-Source: ABdhPJxOaSnUuSDnQi5DeVTlIJ2tZRX4+NfWecFNtpOa2DU5Lh7Ot8DcjqxkMAwkp+e/mA/IvF4DoFjucZJd3KA/Wvo=
X-Received: by 2002:a65:6642:: with SMTP id z2mr7510515pgv.240.1629478457626;
 Fri, 20 Aug 2021 09:54:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
 <20210730100158.3117319-4-ruansy.fnst@fujitsu.com> <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
In-Reply-To: <a5580cf5-9fcc-252d-5835-f199469516b0@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:54:06 -0700
Message-ID: <CAPcyv4hQvR+KND8F1zGoX=jBJQ6bXhLtmEAPVb=O7rDwzHniiQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 3/9] mm: factor helpers for memory_failure_dev_pagemap
To: Jane Chu <jane.chu@oracle.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 5, 2021 at 6:01 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > -     /*
> > -      * Prevent the inode from being freed while we are interrogating
> > -      * the address_space, typically this would be handled by
> > -      * lock_page(), but dax pages do not use the page lock. This
> > -      * also prevents changes to the mapping of this pfn until
> > -      * poison signaling is complete.
> > -      */
> > -     cookie = dax_lock_page(page);
> > -     if (!cookie)
> > -             goto out;
> > -
> >       if (hwpoison_filter(page)) {
> >               rc = 0;
> > -             goto unlock;
> > +             goto out;
> >       }
>
> why isn't dax_lock_page() needed for hwpoison_filter() check?

Good catch. hwpoison_filter() is indeed consulting page->mapping->host
which needs to be synchronized against inode lifetime.
