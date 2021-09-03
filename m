Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D95A3FC1
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 16:26:20 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id c5so2708440plz.2
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 09:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytf2qKVJOpirHXnllSyl2KiVJt19ctCjez+4mJGSx9s=;
        b=kL9n1JmHNXqN0KPlHxbzGIfIiNAaXefiFpcKRMYbj6WOBcj7KTJz+PfN1B6IvpXAe6
         3Sj/fu9Gu3GpUwfeADQr6OgGurOu4WLF96bB8uIeEf6PXeQ0fjrS/F/MYZpwfQf5ZQSP
         paU14qxyqEPkrwUy0AXUQIdGdeKyYgL5ltchV06OVdMWBAt138WtpV285cymOAZ5gsnL
         yNEsWr+vt3iwsztoeSMy3bmc2s9s+Oke10JcTzvniQ3wXTG5wGPtse9HQAxb3jQfdJPg
         b5QryTmTFmyx2OVtm7OVMe1Ttrk954elWIb3tSo3IVzo+jTtEYfFZLwq1Oh9AqAPR/Jt
         i6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytf2qKVJOpirHXnllSyl2KiVJt19ctCjez+4mJGSx9s=;
        b=WHJ1cNAZzhEoKnRZfHbbmG9hvMr0rWrKKWrFUZsCVNfjlkpXjMcKP8F0Kcfvuq2yfA
         +Q1L4Ke3xPbk0+Xcd9KDBqTGpFDUl5dW597PFBKRF/WdLEjxOnstvirCGw2zz6rSM8om
         xu9xoJAKnTPViS1xsxuBTPJ//VcDLe73djh1px+6FWneYzDJ1v5dsiU4tUVeFHrFmeIT
         RB0VJ8BLvVZY385upVHrMvTUWwHS9y8BeVZPIUdnUIEfBsn5ALG5oGMeCRtAwk/5Uk2O
         ldYYAXOP9KCRAH3oTvoH6wUgRgusvNIPdSe1MfbsXbksqi5ytLbPWxyDdAIfnrd6K5yt
         r8CA==
X-Gm-Message-State: AOAM532xDalnDHuyvhoRrDYNvStEx1p44o/yeYR9FAdJc14j0OJM0xgR
	HUiWBaSwCFuBDxOCcaDO1Isiz8gOFbXk6BcNR2Bd0g==
X-Google-Smtp-Source: ABdhPJwcfmgPyxvuME3fy4RYFElLi4CQbOW6oPEBzF5AEdc8iRVVi41MV4dOTGEB+CxKbx7jqO6jfo3nDDTk5VAectA=
X-Received: by 2002:a17:90a:f695:: with SMTP id cl21mr1597569pjb.220.1630686380459;
 Fri, 03 Sep 2021 09:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982127644.1124374.2704629829686138331.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210903143345.00006c60@Huawei.com>
In-Reply-To: <20210903143345.00006c60@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 09:26:09 -0700
Message-ID: <CAPcyv4iaff7_YH1OG-yn4vnDbh-QF1DgLdGr8E4LT1bBBvX-yQ@mail.gmail.com>
Subject: Re: [PATCH v3 28/28] cxl/core: Split decoder setup into alloc + add
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 3, 2021 at 6:34 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:07:56 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The kbuild robot reports:
> >
> >     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
> >     limit (1024) in function 'devm_cxl_add_decoder'
> >
> > It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> > all the different decoder types. Fix the stack usage by splitting the
> > creation into alloc and add steps. This also allows for context
> > specific construction before adding.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Trivial comment inline - otherwise looks like a nice improvement.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

>
> > ---
> >  drivers/cxl/acpi.c     |   74 ++++++++++++++++++++---------
> >  drivers/cxl/core/bus.c |  124 +++++++++++++++---------------------------------
> >  drivers/cxl/cxl.h      |   15 ++----
> >  3 files changed, 95 insertions(+), 118 deletions(-)
> >
>
> > @@ -268,6 +275,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >       struct cxl_port *port;
> >       struct cxl_dport *dport;
> >       struct cxl_decoder *cxld;
> > +     int single_port_map[1], rc;
> >       struct cxl_walk_context ctx;
> >       struct acpi_pci_root *pci_root;
> >       struct cxl_port *root_port = arg;
> > @@ -301,22 +309,42 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> >               return -ENODEV;
> >       if (ctx.error)
> >               return ctx.error;
> > +     if (ctx.count > 1)
> > +             return 0;
> >
> >       /* TODO: Scan CHBCR for HDM Decoder resources */
> >
> >       /*
> > -      * In the single-port host-bridge case there are no HDM decoders
> > -      * in the CHBCR and a 1:1 passthrough decode is implied.
> > +      * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> > +      * Structure) single ported host-bridges need not publish a decoder
> > +      * capability when a passthrough decode can be assumed, i.e. all
> > +      * transactions that the uport sees are claimed and passed to the single
> > +      * dport. Default the range a 0-base 0-length until the first CXL region
> > +      * is activated.
> >        */
>
> Is comment in right place or should it be up with the ctx.count > 1

This comment is specifically about the implicit decoder, right beneath
the comment, that is registered in the ctx.count == 1 case. Perhaps
you were reacting to the spec reference which is generic, but later
sentences make it clear this comment is about an exception noted in
that spec reference?
