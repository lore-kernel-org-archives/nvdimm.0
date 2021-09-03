Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149A3FC9
	for <nvdimm@lists.linux.dev>; Fri,  3 Sep 2021 22:43:37 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id i24so604327pfo.12
        for <nvdimm@lists.linux.dev>; Fri, 03 Sep 2021 15:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wbWGRLm3+Qymcryffw4cLW7WSeEnLBl2CtJGzTty/BI=;
        b=OU10NlIZe9NsYRtV3R03OQunb6dXGpKJQjFzf+7yQfA0svX7gwHTBto5Hnae7KTbUY
         5TbDOBfXMhtojd0wftBkZBMIL52YL6mopsAV5FdwEngeuXugWCFZHIpF6vMm1BgU6u1C
         31hmETztf96yiH6LCHr6sxSSmXLbZbsOIx5434hhC8V4LiSIg43aHwsr4fCBeWWMgC1h
         rjCVz8X4FDyTXMQ8JXFbMOhL1ElpdpqFDad5gyZDZnEVGpcdy4r3ikpRB0Al1t3oq1lO
         zlGWlhemToNf6z5jVBb1VAw6F7/1Kn1gU7iSJnBF9+mRlNvELmRoiohshV4f9GFbJam4
         M46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wbWGRLm3+Qymcryffw4cLW7WSeEnLBl2CtJGzTty/BI=;
        b=l6Io1n0fj13Dup9bOQickZ/Bpj759PaUYhwwjD2o0CB5R6976M/rhUB3kStDheywwf
         QLwEUmSeGuGZ+9Ugo9kzc9UupKOIXAwB+aP00L7B6QIWwoUobe88/OtJqnVb1VR21wXZ
         vSo7l9qLBqrNqHnfyY1CiI2XKT3qgLibmthgULqjabHCnSzW4GLVY0C2SKT92FTNwCRg
         Cqyueo4cqyNnGnuAKqUq3u7Kk5d6p6feY7OzMfnCocN3FTOAf1Wx5D5SvPiZCCRcfGJa
         symZ2/9fRQsF0UNcOWzByFTuhcamonRBJmDq3rbrBx2yfT3J+DzgsceZZBa24gahihO5
         v23w==
X-Gm-Message-State: AOAM5320MAh1eiPvwmcDHMOc5Rw2OQPS54nwi//fg3uv5OJarhx2YFHW
	uMwu49QNbfT5t+Szvo5iz7vWpsaKWjYVhc1k0ln2+A==
X-Google-Smtp-Source: ABdhPJyAqZaEQLRcDQ9WLVR7VCY1b/F7LJZdvXK5YmBvn4/4nE195ZeySHwDUiiMsX+gwkKdJsgFubSCmYQ+x21E5QA=
X-Received: by 2002:a62:1a90:0:b0:405:157c:4d94 with SMTP id
 a138-20020a621a90000000b00405157c4d94mr1081417pfa.78.1630709016573; Fri, 03
 Sep 2021 15:43:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982125942.1124374.13787583357587804107.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210903135938.00004b6e@Huawei.com>
In-Reply-To: <20210903135938.00004b6e@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Sep 2021 15:43:25 -0700
Message-ID: <CAPcyv4gKd6885ekJTbn_Au9khJSQhDpfdZp2OVcTBO=+=afKBA@mail.gmail.com>
Subject: Re: [PATCH v3 25/28] cxl/bus: Populate the target list at decoder create
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 3, 2021 at 5:59 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 24 Aug 2021 09:07:39 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > As found by cxl_test, the implementation populated the target_list for
> > the single dport exceptional case, it missed populating the target_list
> > for the typical multi-dport case.
>
> Description makes this sound like a fix, rather than what I think it is
> which is implementing a new feature...

It is finishing a feature where the unfinished state is broken. It
should never be the case that target_list_show() returns nothing.

[..]
> > diff --git a/drivers/cxl/core/bus.c b/drivers/cxl/core/bus.c
> > index 8073354ba232..9a755a37eadf 100644
> > --- a/drivers/cxl/core/bus.c
> > +++ b/drivers/cxl/core/bus.c
[..]
> > @@ -493,10 +494,19 @@ cxl_decoder_alloc(struct cxl_port *port, int nr_targets, resource_size_t base,
> >               .target_type = type,
> >       };
> >
> > -     /* handle implied target_list */
> > -     if (interleave_ways == 1)
> > -             cxld->target[0] =
> > -                     list_first_entry(&port->dports, struct cxl_dport, list);
> > +     device_lock(&port->dev);
> > +     for (i = 0; target_map && i < nr_targets; i++) {
>
> Perhaps move target map check much earlier rather than putting it
> int he loop condition?  I don't think the loop is modifying it...

The loop is not modifying target_map, but target_map is allowed to be
NULL. I was trying to avoid a non-error goto, but a better way to
solve that would be to make the loop a helper function taken under the
lock.
