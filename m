Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C52F26
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 23:56:18 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id d5so18622577pjk.5
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 15:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CEfWmFa6h1pSisWUvUHFqdY1xxpJcSJ77JcYULSeoMg=;
        b=x9eEhKXjotb03EBl7uteomY26LqM/y4ciidoaVzvnI7NgTTn0X2msquA4LxcSW9Sui
         Ohj8JXxvyumrePoS9Oh1/gINTrj7ps6S5YWT4C7ZTbB/wJEpRa2gYNGY5AVzxplzFt/6
         B2TM/Yez1HtdKgI4VACGb+EcjHPzBEXD3x7OkujXZXjUG4C3X1kdUxzaCt4dWx6Izmvs
         LPsynTrrZEmF4LglOjpBc+wc0xiTPoe/+01+MJnUWzLl08LLy2y388dgsIg4oStQnVZk
         a84QYRTl82OxKtJ7FWYxNqfm4hCgm3YHzQwM5A42iCrSHzBtua6e+zt9OQgst/AFR8PJ
         xcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CEfWmFa6h1pSisWUvUHFqdY1xxpJcSJ77JcYULSeoMg=;
        b=xDKn4l+gyhdBtptZVwXxbzT1nMD58/ifSLdYHMqvQfwb73XPBDy9mOrLaRHgn0GOAB
         bZGrV5QNLOOLLyjvstYFUZpGaBlx9fyDoRENrSp0xjntjC/AwM+358espUPBvG3esm+1
         gD5gxWtGi5jgS5rm2le1fvLBqmORYWsVZOxKKXEbofyBs84HcDNoYnviXyJxC7jkB07+
         Y/tpp5MYqDvk5uGjF5PqwObmu1+/PWaZ2mvOC2deC/l8vDc8K0KWd1J+1GowMhMwo+BZ
         8aguu9orXTznNoCAnA1dRkBqfeG7GfRiIexfLqfF6xP/AxShxraftB9jTQ+S/XOpczag
         6uuQ==
X-Gm-Message-State: AOAM530i1mQoJRzujllGBymzWfF12zS3BEAvAcx4J8vRJf5XJMYVnty+
	ov5p5wDZ8fgRYpDCe4BiUVPhUzJPIOz3Wl6tZVFnGg==
X-Google-Smtp-Source: ABdhPJwVKeLD51uxXWe19JmZTmvBXefzk63Jw4s2H90HY14DG2NRaOY3gyf0F+eH0LhIpYHi0bdbBmN6hNo5jxnhFLM=
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr901277pjb.220.1643759777648;
 Tue, 01 Feb 2022 15:56:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298427373.3018233.9309741847039301834.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131182939.000001db@Huawei.com>
In-Reply-To: <20220131182939.000001db@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 15:56:10 -0800
Message-ID: <CAPcyv4ifmCh1bBiFztafOMyk0Y4V2ER-VRcAPE2ae2B+J73SEw@mail.gmail.com>
Subject: Re: [PATCH v3 29/40] cxl/pci: Implement wait for media active
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 10:30 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Sun, 23 Jan 2022 16:31:13 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > From: Ben Widawsky <ben.widawsky@intel.com>
> >
> > CXL 2.0 8.1.3.8.2 states:
> >
> >   Memory_Active: When set, indicates that the CXL Range 1 memory is
> >   fully initialized and available for software use. Must be set within
> >   Range 1. Memory_Active_Timeout of deassertion of reset to CXL device
> >   if CXL.mem HwInit Mode=1
> >
> > Unfortunately, Memory_Active can take quite a long time depending on
> > media size (up to 256s per 2.0 spec). Provide a callback for the
> > eventual establishment of CXL.mem operations via the 'cxl_mem' driver
> > the 'struct cxl_memdev'. The implementation waits for 60s by default for
> > now and can be overridden by the mbox_ready_time module parameter.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > [djbw: switch to sleeping wait]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Not being a memory device person, I'm not sure whether my query below
> is realistic but I worry a little that minimum sleep if not immediately
> ready of 1 second is a bit long.

Perhaps, but I think the chance of getting to this point is slim in
the common case where platform firmware has already done CXL memory
init.

> Perhaps that's something to optimize once there are a large number
> of implementations to assess if it is worth bothering or not.

Sounds good.

>
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > ---
>
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 5c43886dc2af..513cb0e2a70a 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -49,7 +49,7 @@
> >  static unsigned short mbox_ready_timeout = 60;
> >  module_param(mbox_ready_timeout, ushort, 0600);
> >  MODULE_PARM_DESC(mbox_ready_timeout,
> > -              "seconds to wait for mailbox ready status");
> > +              "seconds to wait for mailbox ready / memory active status");
> >
> >  static int cxl_pci_mbox_wait_for_doorbell(struct cxl_dev_state *cxlds)
> >  {
> > @@ -417,6 +417,51 @@ static int wait_for_valid(struct cxl_dev_state *cxlds)
> >       return -ETIMEDOUT;
> >  }
> >
> > +/*
> > + * Wait up to @mbox_ready_timeout for the device to report memory
> > + * active.
> > + */
> > +static int wait_for_media_ready(struct cxl_dev_state *cxlds)
> > +{
> > +     struct pci_dev *pdev = to_pci_dev(cxlds->dev);
> > +     int d = cxlds->cxl_dvsec;
> > +     bool active = false;
> > +     u64 md_status;
> > +     int rc, i;
> > +
> > +     rc = wait_for_valid(cxlds);
> > +     if (rc)
> > +             return rc;
> > +
> > +     for (i = mbox_ready_timeout; i; i--) {
> > +             u32 temp;
> > +             int rc;
> > +
> > +             rc = pci_read_config_dword(
> > +                     pdev, d + CXL_DVSEC_RANGE_SIZE_LOW(0), &temp);
> > +             if (rc)
> > +                     return rc;
> > +
> > +             active = FIELD_GET(CXL_DVSEC_MEM_ACTIVE, temp);
> > +             if (active)
> > +                     break;
> > +             msleep(1000);
> Whilst it can be a while, this seems a bit of an excessive step to me.
> If the thing is ready in 10msecs we stil end up waiting a second.
> Might be worth checking more often, or doing some sort of fall off
> in frequency of checking.

I dunno, when the minimum hardware precision in the spec is 1 second
it's not clear that the driver can do better than this in practice.
Let's see what real platforms do. Part of me also thinks that this is
an incentive for devices to get ready before the OS might penalize
them with a coarse wait.
