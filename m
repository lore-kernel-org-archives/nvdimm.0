Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93152F24
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 14:54:26 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so6367563pjl.2
        for <nvdimm@lists.linux.dev>; Fri, 04 Feb 2022 06:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAzGX2KRF3xTv3jELkNUUo9hmDUDOEqLvI+SzwJPEUk=;
        b=griiqNV/EpySOJADrjSZGVBCvHIfo8JtMRKTCD2Fbi6SX+VDfMUHxtL9dC9G2u80mM
         cfSVMJ/7Wjk++keAgFDd0AMK/A1caKcmpJsp0Lc6hBdqT3Ie71O2+xBFdOA/Tc9HZ3Mm
         C/966ddr0venVBJBmbBQ/vmp/N7gGQJ/viatTp0yRqBOtonxP04xfJzih2KGEKRnB03c
         t14YFpij1YCMY52PNCpwTt2t834y8c+OTYFsz15F+T2DFc9PfXqhndtnwlAt7KqfNAYM
         CCHRwivmqE6eBq3v1/XxNV5wU2cjkLFbyb6V+iwSnbWOAncHtitZfzhhsK/4ualIFW8R
         CIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MAzGX2KRF3xTv3jELkNUUo9hmDUDOEqLvI+SzwJPEUk=;
        b=soTMCUk4y6zvM87emGb75peq0OvTd0+5XT/E6VA6QoFxhGdFWpkxy2KS82sEMlsikj
         PWLf6Y9AYOEPEMzE7eOQE/YNR22mUPU0tElh6uLt4KvupYG1cbIBmECib1dDQSjH2Xd8
         T+RooiTUhtByF0uRZvcc1TnzuERNDW6lHg2IyBtnITCf05rVRIpjidpcQRshTZ8mTzon
         v62hvPWKhrKaF3SyaI9UmVLYxmhoLbabLbN1+uobMtZr8UnhdA4WyDtnCMdNTrYQdkya
         9cmTrjbBVgSsqVyC+4nl8bEFs76Cb3/OCp56DwWMFNObOPP0HaRZ4NbCcs1kJFCySUsz
         /cLA==
X-Gm-Message-State: AOAM531i5U52MUg1jN4fHYW+XMF2rvAueXWKmmUWB9xSpE0W2GZ65q2C
	ksOpgUlwy680FyiijFrNzVWA3/ktWucoWYcWtb+WOQ==
X-Google-Smtp-Source: ABdhPJxqz8hHiR92IvNiFO0gzB7syV6xa+eUIXWjFCOucavErfp5yrYtVvMBzd1i5JI0hU5YBLO2w6ngWkbj0kD1iTk=
X-Received: by 2002:a17:902:d705:: with SMTP id w5mr3648499ply.34.1643986463432;
 Fri, 04 Feb 2022 06:54:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298429450.3018233.13269591903486669825.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164316691403.3437657.5374419213236572727.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220201124506.000031e2@Huawei.com> <CAPcyv4jBs4DXGUE0rtyhp2WG2pU45zBv1zGJuLjMfyAKGmfVyw@mail.gmail.com>
 <20220203095959.000078f1@Huawei.com>
In-Reply-To: <20220203095959.000078f1@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Feb 2022 06:54:12 -0800
Message-ID: <CAPcyv4gqOAMPSHdG2pzXCUFPu0Wd9XNJsF1_mtGkr8rFKK2SHg@mail.gmail.com>
Subject: Re: [PATCH v4 33/40] cxl/mem: Add the cxl_mem driver
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, 
	Ben Widawsky <ben.widawsky@intel.com>, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 3, 2022 at 2:00 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> Hi Dan,
>
> > > > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > > > index b71d40b68ccd..0bbe394f2f26 100644
> > > > --- a/drivers/cxl/cxl.h
> > > > +++ b/drivers/cxl/cxl.h
> > > > @@ -323,6 +323,8 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
> > > >  struct cxl_port *find_cxl_root(struct device *dev);
> > > >  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
> > > >  int cxl_bus_rescan(void);
> > > > +struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd);
> > >
> > > Should be in previous patch where the function is defined.
> >
> > Not really, because this patch is the first time it is used outside of
> > core/port.c. I would say convert the previous patch to make it static,
> > and move the export into this patch, but I'm also tempted to leave
> > well enough alone here unless there some additional reason to respin
> > patch 32.
>
> I hadn't read this when I sent reply to previous patch v4.  Up to you on
> whether you tidy up or not.  Though I'm fairly sure you'll get
> a missing static warning if you build previous patch without a header definition.
> Agreed adding static then removing it again would be an option, but
> meh, too much noise...  The one going the other way (defining a function
> before it exists) is probably more important to fix.

There's no warning about declaring a function that is never defined,
but that's egregious enough to go fixup.
