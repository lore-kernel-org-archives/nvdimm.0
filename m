Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CDB173
	for <nvdimm@lists.linux.dev>; Sat, 12 Jun 2021 00:17:06 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id c12so5749802pfl.3
        for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 17:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=82VEF0jU1aJg9IivNM3m8n8dgHxa1D7N8oMOze7zYHk=;
        b=f50m71z8fzdIGfE7Y1k4CF+fILypd/f+RSCP+5hsPzlV2yOkbMSY1Exh8cX28+6nPv
         y1v0NCmCAh5Jav98nPF4m/swPoYLRACuydpXqKNnJU34gmhBj8AA70sYv0+wn0N3BBSy
         /Cjda73UeW/5QwZoypoj4TDloXzEYjVYcFQilHT2AuW3I9Sgd6xngdQbBRO2WJkc7NdI
         PYtc31+vH4vS5c2rtuQEV7Ugz2InitN+YsxbdQrZ6WTMZLkiFw0OVaCmFSRbdwKNCDli
         299HZ+aqoHoiuoDXHT2lGGh+QsYi1BjnPa5lFWv5QCfULYiOdCfTOLh/DCE7lXRcPaCi
         KmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=82VEF0jU1aJg9IivNM3m8n8dgHxa1D7N8oMOze7zYHk=;
        b=agZIeBfNx/NLv4ewGXMcVHU/UHkb7YvV9ioshI2eUSg7jAO4Gg2k/2aQNBa3H4viE4
         p173TYhRiJYDfgnBlA2C07KHo96mGW49wkC9ZMYbVjNokhCWCdfnCBn1vO/G2svKdHzv
         3lP3dc/mTFwjQqDnCFckkSVKNC/jCW/WqFWFDV2beYMz0vHtMfrLbs8Fcy2V1kRzSEfp
         Z95Mxz2fzcevzMKpEFcoebZpHQ823bXv7t2e9gg4qyrJvx7+PYBwBg33QvnDNEf58FvL
         F/dgDG+/lAqE/gbB1TyckXx5jp2WT0V/5P9+qZ5JKTECNwdJsdzMSnTf7gCGL67pyFGG
         Cr1w==
X-Gm-Message-State: AOAM531sx23AtQCBCbxUwrAhWeynTgvA1cMsmwxFhmK+e2hFyAbnLTQZ
	CNNeupFbHkhl5y0GiDq+zrQMRVC0e1RtOAloHwSdWQ==
X-Google-Smtp-Source: ABdhPJyOAEteNdyg6O8Dbz88K+bj8bLFU6PbLJJ0CFXNCtRPQWcQl42nzP4m6yawNlLjvphveb+OHCg5pp83hphY18s=
X-Received: by 2002:a62:8647:0:b029:2c4:b8d6:843 with SMTP id
 x68-20020a6286470000b02902c4b8d60843mr4616917pfd.71.1623457026192; Fri, 11
 Jun 2021 17:17:06 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336397948.2462439.5230237265829121099.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210611124703.000033af@Huawei.com>
In-Reply-To: <20210611124703.000033af@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jun 2021 17:16:55 -0700
Message-ID: <CAPcyv4gjA-AmYkUphLBmmnM1GFWcJ4WJHNobyw833DVp3XPwqw@mail.gmail.com>
Subject: Re: [PATCH 4/5] libnvdimm: Drop unused device power management support
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 11, 2021 at 4:47 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Thu, 10 Jun 2021 15:26:19 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > LIBNVDIMM device objects register sysfs power attributes despite nothing
> > requiring that support. Clean up sysfs remove the power/ attribute
> > group. This requires a device_create() and a device_register() usage to
> > be converted to the device_initialize() + device_add() pattern.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Trivial comment below. Looks good.
>
> > ---
> >  drivers/nvdimm/bus.c |   45 +++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> > index a11821df83b5..e6aa87043a95 100644
> > --- a/drivers/nvdimm/bus.c
> > +++ b/drivers/nvdimm/bus.c
> > @@ -363,8 +363,13 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
> >       nvdimm_bus->dev.groups = nd_desc->attr_groups;
> >       nvdimm_bus->dev.bus = &nvdimm_bus_type;
> >       nvdimm_bus->dev.of_node = nd_desc->of_node;
> > -     dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
> > -     rc = device_register(&nvdimm_bus->dev);
> > +     device_initialize(&nvdimm_bus->dev);
> > +     device_set_pm_not_required(&nvdimm_bus->dev);
> > +     rc = dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
> > +     if (rc)
> > +             goto err;
>
> Maybe mention in patch description that you also now handle errors in
> dev_set_name()?

Yeah, that's a philosophy change from when this code was first written.
