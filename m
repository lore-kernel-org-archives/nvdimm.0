Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA9D3FD3
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 04:44:21 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id f21so870010plb.4
        for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 21:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ke2SRIGg+XGVFQMj2Nt31WiTZWFxp5XafAaSq0r4/4=;
        b=IgddcRQ7nEVsnQHD4blpqVfJkt+DwRZsn1JfhZcfU2PVTGfTd0vg73tM/KT+8U8CQe
         4e69bwZ4MTnHmixKqECl7S9IKK7tTvMFMonN6yRO1YQYg+hWwpT4triYtph1/StYGx34
         3bofmcgWihb/3d3zyXxlicz/EYNzLwjDzqSrrO6LtGFPJ8hBS24ssqZsBwkjHjJvIFRw
         1LVMGNbMDi/vkbi8B0Njra7wFPNrPBo9GjErDIN+CFkpa5XmGBMjkjEsbGZYud0bxZPj
         whnHExG6NPVNyWtCjro3XhdA0frBCxVdE62aac/hH0dUtSGi67RZez0dr3ad+kmbhlap
         y0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ke2SRIGg+XGVFQMj2Nt31WiTZWFxp5XafAaSq0r4/4=;
        b=5gDhnAYEi7st9Es/jZ1byw/KgxEMVm3xTj9m4H+L63MQ6RTKu9isE162DMqYKqm35/
         fgxilP/eJH0B0ibTq1wZuXULqYK5b2maGv3Imgj0v8fvv01UuOUlIQVjq/nLtNUx9otM
         3oRFYhxGPXdpLAPHaEjPSRIDCwu6EcpI4FSzx9jVxQlUrwQqMh/GEBAiVkzACwPKB24L
         QDOCyl8tQtaq+qOd3TLeRr7218g+dLXgOHmwfi9kC8Ds7DVSKTPXbtWMJzd1zG2kbp0W
         behldlKa/1uxsthbIlhYITl6kPPdA+Li5FoLDoEsTY/IcPOulupveTuBhoJLsua1zqkk
         lqAQ==
X-Gm-Message-State: AOAM531INUdINJqCY2SlQjOGyU1MUSO8DWy8tScockLUpBf80ZzBpQRL
	+/sH9LAAolENEciYOb8wIstJWgwdxy4OY2nGzrDshA==
X-Google-Smtp-Source: ABdhPJzx4g82CIHm0nZUdlQbdJR7J9Aag191pgYrsfIq2kmSlUsJ+IEAjsXoy1QVMvB9zFyoHYJ5VLm80IwNQqJLsCc=
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr6263231pju.8.1631681061030;
 Tue, 14 Sep 2021 21:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210914233132.3680546-1-jane.chu@oracle.com>
In-Reply-To: <20210914233132.3680546-1-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 Sep 2021 21:44:10 -0700
Message-ID: <CAPcyv4h3KpOKgy_Cwi5fNBZmR=n1hB33mVzA3fqOY7c3G+GrMA@mail.gmail.com>
Subject: Re: [PATCH 0/3] dax: clear poison on the fly along pwrite
To: Jane Chu <jane.chu@oracle.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 4:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> If pwrite(2) encounters poison in a pmem range, it fails with EIO.
> This is unecessary if hardware is capable of clearing the poison.
>
> Though not all dax backend hardware has the capability of clearing
> poison on the fly, but dax backed by Intel DCPMEM has such capability,
> and it's desirable to, first, speed up repairing by means of it;
> second, maintain backend continuity instead of fragmenting it in
> search for clean blocks.
>
> Jane Chu (3):
>   dax: introduce dax_operation dax_clear_poison

The problem with new dax operations is that they need to be plumbed
not only through fsdax and pmem, but also through device-mapper.

In this case I think we're already covered by dax_zero_page_range().
That will ultimately trigger pmem_clear_poison() and it is routed
through device-mapper properly.

Can you clarify why the existing dax_zero_page_range() is not sufficient?

>   dax: introduce dax_clear_poison to dax pwrite operation
>   libnvdimm/pmem: Provide pmem_dax_clear_poison for dax operation
>
>  drivers/dax/super.c   | 13 +++++++++++++
>  drivers/nvdimm/pmem.c | 17 +++++++++++++++++
>  fs/dax.c              |  9 +++++++++
>  include/linux/dax.h   |  6 ++++++
>  4 files changed, 45 insertions(+)
>
> --
> 2.18.4
>
