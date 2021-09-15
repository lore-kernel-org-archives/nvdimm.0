Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152313FC5
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 16:22:50 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id n4so1937390plh.9
        for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 09:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uo9eXS3r1ePjhHgKEVY7iDRGL6C2CVufWx2q0EBxp6c=;
        b=VbSQ6m+QZ2Ovtk44be3X7yH2ZcuXgRlB+8QKMGJHG/EN0obGcxP9LIOS9PpfBAjt5s
         SdgAt7cKxRsI40DCPobdI9zsLGClZhLcAGTSarAKUV3NQDMDUhcEMY4xw7/LU5yGUNxZ
         lv2KdmqEUqRmftpvW/6jXrZUy58U8iLvue7Foxpx7qe7UaSOxcAB3k/JLO9vOBt4uKl5
         ki+GbQMJADLKXRYjzsFUQrZ2gpF1bc+HYMEmyPpV0U+tRPUxi+toWEwSRCR90rSiM8Yc
         YLxyMlCRsOjX8KJhi+8L6utnlNCPt8OjbFduBG6YqMnH7BMFfFGm7UHuF0yfK+/qlCng
         Rlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uo9eXS3r1ePjhHgKEVY7iDRGL6C2CVufWx2q0EBxp6c=;
        b=NtBS6K30lp9u36Pv64zFzcPgW0/SzTzKUqpLfTBkbdo5/ifBYKN/DtNYojuCpmxYJc
         DVFSyW3gECOn2LJtWapaiFdR6RhHbar6c7HESPO/eVad/MiBj18rKvTX0mCiuNivr7jh
         39eYCmSOXgNVP37bjxaLLk6zIxiSsOtpJ89iMST9Y78QuTHWMpCpUUqDC8/fnsg+ZeMx
         mc/cMO0YNtpXMlNsRhpKNvIFw4tbj4GHLWBTamlBQjgJ2TGqpSWP9sqaEXhiGHwmCk+l
         VJ0DZeu1fcdgVWLT3RMl68sNIEbbIe5GH8sKuVgxwejmPAKMpTpfTwkjIV6xh367v0Ev
         rX+Q==
X-Gm-Message-State: AOAM533AqzjXcEaeJtJC1NBsth1z4nzBoBdchDQVQFTfGiC8asCAK2Gg
	4kXqj9S3idD8+ZsF+nKn9nUXxjOguJQg9cQ1FH6YQQ==
X-Google-Smtp-Source: ABdhPJxfUGSb+GUqBJtlSscG5n9JftXnWgXq3rUqcLOxL+UT8vNGrvZsFtC4IKySAWzvT+Gcd/iQJo9UqpPmNuL8cLA=
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr658569pjb.220.1631722970520;
 Wed, 15 Sep 2021 09:22:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210910124628.6261-1-justin.he@arm.com> <CAPcyv4ie_ZzEwrrKJEVrDP19UWAgSiW3GU9f99EqX0e6BPQDPA@mail.gmail.com>
 <AM6PR08MB4376FC35158104629C603197F7DA9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <CAPcyv4gyCHTcXUSLcsgnX8o0JUfpSNf8B=7zbfcZcvWFCUSCvw@mail.gmail.com> <AM6PR08MB4376877792291C237AE1AE30F7DB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
In-Reply-To: <AM6PR08MB4376877792291C237AE1AE30F7DB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Sep 2021 09:22:39 -0700
Message-ID: <CAPcyv4j6rusw7ixpjLsTK3NhJDD_poTp8dUKjQ45jn=vuqgncw@mail.gmail.com>
Subject: Re: [PATCH v2] device-dax: use fallback nid when numa node is invalid
To: Justin He <Justin.He@arm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Hildenbrand <david@redhat.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 11:51 PM Justin He <Justin.He@arm.com> wrote:
[..]
> > > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > > index fb775b967c52..d3a0cec635b1 100644
> > > --- a/drivers/acpi/nfit/core.c
> > > +++ b/drivers/acpi/nfit/core.c
> > > @@ -3005,15 +3005,8 @@ static int acpi_nfit_register_region(struct
> > > acpi_nfit_desc *acpi_desc,
> > >         ndr_desc->res = &res;
> > >         ndr_desc->provider_data = nfit_spa;
> > >         ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
> > > -       if (spa->flags & ACPI_NFIT_PROXIMITY_VALID) {
> > > -               ndr_desc->numa_node = acpi_map_pxm_to_online_node(
> > > -                                               spa->proximity_domain);
> > > -               ndr_desc->target_node = acpi_map_pxm_to_node(
> > > -                               spa->proximity_domain);
> > > -       } else {
> > > -               ndr_desc->numa_node = NUMA_NO_NODE;
> > > -               ndr_desc->target_node = NUMA_NO_NODE;
> > > -       }
> > > +       ndr_desc->numa_node = memory_add_physaddr_to_nid(spa->address);
> > > +       ndr_desc->target_node = phys_to_target_node(spa->address);
> > >
> > >         /*
> > >          * Persistence domain bits are hierarchical, if
> > > ===================================================
> > >
> > > Do you still suggest fixing like this?
> >
> > Are you saying that ACPI_NFIT_PROXIMITY_VALID is not set on your
> > platform, or that pxm_to_node() returns NUMA_NO_NODE?
> >
> Latter,  ACPI_NFIT_PROXIMITY_VALID is *set* in my case.
>
> > I would expect something like this:
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index a3ef6cce644c..95de7dc18ed8 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -3007,6 +3007,15 @@ static int acpi_nfit_register_region(struct
> > acpi_nfit_desc *acpi_desc,
> >                 ndr_desc->target_node = NUMA_NO_NODE;
> >         }
> >
> > +       /*
> > +        * Fallback to address based numa information if node lookup
> > +        * failed
> > +        */
> > +       if (ndr_desc->numa_node == NUMA_NO_NODE)
> > +               ndr_desc->numa_node = memory_add_physaddr_to_nid(spa-
> > >address);
> > +       if (ndr_desc->target_node == NUMA_NO_NODE)
> > +               phys_to_target_node(spa->address);
> > +
>
> Would it better to add a dev_info() here to report this node id changing?

Yes, given all the possibilities here, a dev_info() reporting the
final result of the node mapping is justifiable.
