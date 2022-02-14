Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11BDA35
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 19:14:20 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id 10so11309743plj.1
        for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 11:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LNIIAz3zQQaMmzK3Lz7n5biZPq3E2euYGu1gGCUEiUU=;
        b=e+9/aIcapobLzUjuzWwCgjtrECD4Nz67ZklJZLlhaJiox8qfEoUy+GU7FMZlc9tQKf
         70XobxmHxms3p+b3cX1vPLmpMzFtT4TUxGpxDFVgIsD1tIcgAidU7NyTOhAPOvtWOOOL
         trGD4b8Z6qqdEiHjjhgqr21N2vFoaCE3/fgG4Wh6mNqpZLb+OIGpnaXP37C5FH3V44Nc
         3SxQUaw7z7VJb3t8wRiidTg9AXs/QyF4FNIIvKuYzseQDibK2D4jwHdkgpSqWN1+UJ6C
         7PaeNPx+1C6E06lXbGybY0/do0xzLQHhRBwrNTxzgB3KagOb9AUR7u2K0azCw4YX3nvJ
         hDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LNIIAz3zQQaMmzK3Lz7n5biZPq3E2euYGu1gGCUEiUU=;
        b=b5Y2CQrqDhOUjO625i/NOb1TJndUC1RSqJI9YUZB27RmCtxtLWIw7LL9u4/Ebpjmvj
         YeECq8tNRhl5RlhVG7eO3ydGX45Rf7mVn+Q6TbY+2smuY1722G5EQ8vyhcgLLQ4FusUB
         pu2XBNWzN+xCM+HXyK9XyWqZcwghxz/1oFFfgUtFOO70RVkZ/36XgzUn0YtHI+lqTE7N
         dbGWSpLJX77BDt+39l+lVdpIGqY2los+YmIQl58avBZJ8DU7L5jOoNgaTy2F1f3aKwr2
         JuxvrC5jz8HqYCapWVeskCVoUFmi9QH8Nw/dkkg4U8BxAeTMTeotWFc/sdfQvt0cNT/A
         +AoA==
X-Gm-Message-State: AOAM5328DTHJ9zwhM/5pQKA/f/Gp5Ami7RpVQDzqUkLyS/yQ/trmElsh
	+/H79VdH6YdEJPF4Cng/VuEQ3fWHlkQt0yySKdMNfw==
X-Google-Smtp-Source: ABdhPJxVTF5h08NSNXTHrXWdDbPywfICYCIAA4dvceyfHnC11SOo3zAin7e+e2W6f7vCUWzlvI+mSWTgxqtkOna79vk=
X-Received: by 2002:a17:90a:e7cb:: with SMTP id kb11mr94342pjb.220.1644866060312;
 Mon, 14 Feb 2022 11:14:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298430609.3018233.3860765171749496117.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164386092069.765089.14895687988217608642.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220214174521.00003b84@Huawei.com>
In-Reply-To: <20220214174521.00003b84@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Feb 2022 11:14:13 -0800
Message-ID: <CAPcyv4g++ishMNkSLYAq3ss_qMXv-gabubVG_q2H9ed+C7KW-A@mail.gmail.com>
Subject: Re: [PATCH v4 35/40] cxl/core/port: Add endpoint decoders
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 14, 2022 at 9:47 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 02 Feb 2022 20:02:06 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > From: Ben Widawsky <ben.widawsky@intel.com>
> >
> > Recall that a CXL Port is any object that publishes a CXL HDM Decoder
> > Capability structure. That is Host Bridge and Switches that have been
> > enabled so far. Now, add decoder support to the 'endpoint' CXL Ports
> > registered by the cxl_mem driver. They mostly share the same enumeratio=
n
> > as Bridges and Switches, but witout a target list. The target of
> > endpoint decode is device-internal DPA space, not another downstream
> > port.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > [djbw: clarify changelog, hookup enumeration in the port driver]
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> ...
>
> > index f5e5b4ac8228..990b6670222e 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -346,6 +346,7 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct c=
xl_port *port,
> >  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
> >                                            unsigned int nr_targets);
> >  int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> > +struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
> >  int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
> >  int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cx=
ld);
> >  int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port =
*endpoint);
> > diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> > index 4d4e23b9adff..d420da5fc39c 100644
> > --- a/drivers/cxl/port.c
> > +++ b/drivers/cxl/port.c
> > @@ -40,16 +40,17 @@ static int cxl_port_probe(struct device *dev)
> >               struct cxl_memdev *cxlmd =3D to_cxl_memdev(port->uport);
> >
> >               get_device(&cxlmd->dev);
> > -             return devm_add_action_or_reset(dev, schedule_detach, cxl=
md);
> > +             rc =3D devm_add_action_or_reset(dev, schedule_detach, cxl=
md);
> > +             if (rc)
> > +                     return rc;
> > +     } else {
> > +             rc =3D devm_cxl_port_enumerate_dports(port);
> > +             if (rc < 0)
> > +                     return rc;
> > +             if (rc =3D=3D 1)
> > +                     return devm_cxl_add_passthrough_decoder(port);
>
> This is just a convenient place to ask a question rather that really bein=
g
> connected to this patch.
>
> 8.2.5.12 in CXL r2.0
>
> "A CXL Host Bridge is identified as an ACPI device with Host Interface ID=
 (HID) of
> =E2=80=9CACPI0016=E2=80=9D and is associated with one or more CXL Root po=
rts. Any CXL 2.0 Host
> Bridge that is associated with more than one CXL Root Port must contain o=
ne instance
> of this capability structure in the CHBCR. This capability structure reso=
lves the target
> CXL Root Ports for a given memory address."
>
> Suggests to me that there may be an HDM decoder in the one port case and =
it may need
> programming.
>
> Hitting this in QEMU but I suspect it'll occur in real systems as well.

It seems reasonable to wait for a real system like that to arrive. If
someone is cheap enough to build a one-port host bridge would they
spend the silicon gates on these unnecessary registers?
