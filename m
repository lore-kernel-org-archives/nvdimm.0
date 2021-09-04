Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA733FC0
	for <nvdimm@lists.linux.dev>; Sat,  4 Sep 2021 00:27:23 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id d5so624170pjx.2
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 17:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNqDHc4DeYDGoAd0mq4iZzi3XtF93Dyr7S8yiUymZy4=;
        b=S9eQD39d/wC1WmPQTiYTbBoL18qPM6NxOwn9akdNmjyqoOL6wDDsiNbPpEbYg8tmIV
         Hs7+NJHyqFKV5BvwiLYhTVemIhQsCJ9AtKkNmvhhexcHmkWi8r0K7unkHnzou2Q6mrXX
         4EhNUdjSJKL3FbKNEP4bEBIkup7X/fJsC6AqCSEPuUnIG8YGSCle9vzqV5LYpP0jogIM
         Eufsn7kwVZT+Ijc6OljG3ChcR8IQC4DiwkztNBuiXosT+wNJXFYZzPur/WH8RVdI1sfM
         XjERGtEqU2xMPVMREr+pBAFZsx2StTznZXnMwe7VlmVevv9emGEq7XfinN6dDQGFGFHL
         cmjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNqDHc4DeYDGoAd0mq4iZzi3XtF93Dyr7S8yiUymZy4=;
        b=KVCo9nsuw+mJ8UoBrySSrvS3PIg32SG/dRsMYbogs17RCP8pKgkkJ0OdLcH/Be+1JQ
         SR6nwZ/3T8L1ZnyutQ2GDVyjY5u5Dh4xHunNx8i2Lefl5JAcDCkSbwYApsAEY0jLgbKO
         YTf6agmz29zkhEE6cRLID9CnIm7+5PUe3OOrq/NMKGYCiGXiOV33xWJxIKE3/kCcLnSa
         afM3c6W2TFEyttmQ84fy13y1q/crkWX3pL+N898oQ68tYYW3eNDmXICCjCP4dx7lgPbK
         e78dfTzNCvj0fGeoBon/mE5KGBLj8loSlZ/dShqRd6gPw+JjNtIwP0EZ577qro0jDDgu
         0YJw==
X-Gm-Message-State: AOAM532+J7k/yZ/rRjycWZRXQExFTGrKb8af6W5vYHDYbri2LBCvDbpF
	qFJtLCJSlYe679XfXk9sV0WFRB52g97GlPOO8A/dkA==
X-Google-Smtp-Source: ABdhPJy8buIuPi3rlRkUgeB5khkdH2y3gtKF5o9jtPNmZurcJvD0pWMBuZ6mox8x/mfA2SdT0Lx89rlJA0PLhOnKD6I=
X-Received: by 2002:a17:902:7611:b029:12b:e55e:6ee8 with SMTP id
 k17-20020a1709027611b029012be55e6ee8mr1218794pll.4.1630715243053; Fri, 03 Sep
 2021 17:27:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982127644.1124374.2704629829686138331.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210903143345.00006c60@Huawei.com> <CAPcyv4iaff7_YH1OG-yn4vnDbh-QF1DgLdGr8E4LT1bBBvX-yQ@mail.gmail.com>
 <20210903190133.000003e2@Huawei.com>
In-Reply-To: <20210903190133.000003e2@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 17:27:12 -0700
Message-ID: <CAPcyv4hTHq6BRek_5bMn0jbz2bQ=8Kd6EaBjsc6s2=snY5ws5g@mail.gmail.com>
Subject: Re: [PATCH v3 28/28] cxl/core: Split decoder setup into alloc + add
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 3, 2021 at 11:01 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Fri, 3 Sep 2021 09:26:09 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Fri, Sep 3, 2021 at 6:34 AM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Tue, 24 Aug 2021 09:07:56 -0700
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > The kbuild robot reports:
> > > >
> > > >     drivers/cxl/core/bus.c:516:1: warning: stack frame size (1032) exceeds
> > > >     limit (1024) in function 'devm_cxl_add_decoder'
> > > >
> > > > It is also the case the devm_cxl_add_decoder() is unwieldy to use for
> > > > all the different decoder types. Fix the stack usage by splitting the
> > > > creation into alloc and add steps. This also allows for context
> > > > specific construction before adding.
> > > >
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >
> > > Trivial comment inline - otherwise looks like a nice improvement.
> > >
> > > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> >
> > >
> > > > ---
> > > >  drivers/cxl/acpi.c     |   74 ++++++++++++++++++++---------
> > > >  drivers/cxl/core/bus.c |  124 +++++++++++++++---------------------------------
> > > >  drivers/cxl/cxl.h      |   15 ++----
> > > >  3 files changed, 95 insertions(+), 118 deletions(-)
> > > >
> > >
> > > > @@ -268,6 +275,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > > >       struct cxl_port *port;
> > > >       struct cxl_dport *dport;
> > > >       struct cxl_decoder *cxld;
> > > > +     int single_port_map[1], rc;
> > > >       struct cxl_walk_context ctx;
> > > >       struct acpi_pci_root *pci_root;
> > > >       struct cxl_port *root_port = arg;
> > > > @@ -301,22 +309,42 @@ static int add_host_bridge_uport(struct device *match, void *arg)
> > > >               return -ENODEV;
> > > >       if (ctx.error)
> > > >               return ctx.error;
> > > > +     if (ctx.count > 1)
> > > > +             return 0;
> > > >
> > > >       /* TODO: Scan CHBCR for HDM Decoder resources */
> > > >
> > > >       /*
> > > > -      * In the single-port host-bridge case there are no HDM decoders
> > > > -      * in the CHBCR and a 1:1 passthrough decode is implied.
> > > > +      * Per the CXL specification (8.2.5.12 CXL HDM Decoder Capability
> > > > +      * Structure) single ported host-bridges need not publish a decoder
> > > > +      * capability when a passthrough decode can be assumed, i.e. all
> > > > +      * transactions that the uport sees are claimed and passed to the single
> > > > +      * dport. Default the range a 0-base 0-length until the first CXL region
> > > > +      * is activated.
> > > >        */
> > >
> > > Is comment in right place or should it be up with the ctx.count > 1
> >
> > This comment is specifically about the implicit decoder, right beneath
> > the comment, that is registered in the ctx.count == 1 case. Perhaps
> > you were reacting to the spec reference which is generic, but later
> > sentences make it clear this comment is about an exception noted in
> > that spec reference?
>
> More that the conditional is above that leads to us getting here.
> Probably thrown off by Diff having added the new block that follows this
> after the removed block rather than before it.
>
> I'm fine with how you have it here.
>

Thanks, although I am going to leave your reviewed-by off for now
because I am going to fold this with this fixup patch that arrived
later which makes some significant changes:

https://lore.kernel.org/r/163002073312.1700305.17017280228713298614.stgit@dwillia2-desk3.amr.corp.intel.com
