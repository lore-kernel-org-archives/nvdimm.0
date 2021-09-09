Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460E73FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 18:50:13 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id k24so2728597pgh.8
        for <nvdimm@lists.linux.dev>; Thu, 09 Sep 2021 11:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2+KUFUok6SA2jcR9Vhb080u3BolVjtOcgcauFbFl0Q=;
        b=zlnbe4R4Aaz0PEElFoIcunGsJQH/qILZd5fa1zy1Jc6lz3m1W3gYiYUpOZxI4fhUgD
         lBWp1XysCW6KBsoUXv2Hh6u4K771xjd5+yvUSRt+VlwdylQmjg7YUf+y2d+GF1n0khgR
         F0e1NXdV0NeOisPm+5yICNMnL1kDvUvWJr97UVtxrbkqrvtwGv1w36ktvbKm8BBebJw0
         oXrEkTB+zSum4ySYd6XrsPC8LOBuvooSItcjlCXX1fFQ2MUngoI42OKM4QwZfH0fKmHm
         ALxB+TeJ9KpoWbUX3PJcgv3xj5/toqJrl7fW8CM8MK6qMJmNX+dKQ15JgUpUXoQk/W1r
         Gg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2+KUFUok6SA2jcR9Vhb080u3BolVjtOcgcauFbFl0Q=;
        b=i7qeMgVS+VCVZ+1Bd9Ia2DPlp3Mso/JYLMhZ5vbO4GlF4451nkzyseNY4SJu8wCsvn
         4vLtmUUY2oQn/NB0yidWjuE0PUV8dUoluNTL6QHMYeW4irii9uTzaRRjSfOayq8Ny+rD
         QCqW1riioAQrBnd1nZsTQDpss9ROKgq6ivMhyVnntsCVO/kyyGZzSmtG3uF+Or4wO+YC
         84/+53A+LQlupZR/VhGUcNFI2HXOXlo9+whl2JLxyDTc8MsrAH7mtio7di87sMx1pAgO
         Ivy5764WlK5EwwcRoNiW/4DKp2eneLGoy/vY4N7jwpWqyZxfpkkneRb9RRkgothNDLwE
         g2Sw==
X-Gm-Message-State: AOAM531JVaojQTVHMCsbEkqyfP2e6K4rnGdmgagaaV/J3GEsKtR7XU+9
	kOpHuwaekIZA5q0UoDRCjWD8i+NBPRz7bV8VZhedfw==
X-Google-Smtp-Source: ABdhPJyRdOmtPd0s2xFWVDE0piNkTvJbP57DLCVwte6ikcKvurNHKJMruC52a1h0Sg4Su8mt3wDLlIhQjK3qXce1sao=
X-Received: by 2002:a63:3545:: with SMTP id c66mr3863167pga.377.1631213412732;
 Thu, 09 Sep 2021 11:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116435233.2460985.16197340449713287180.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210909164125.ttvptq6eiiirvnnp@intel.com>
In-Reply-To: <20210909164125.ttvptq6eiiirvnnp@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Sep 2021 11:50:01 -0700
Message-ID: <CAPcyv4hH7=cbnpz9dcKFEByqZkVxJVXpuks4g_63VguisDdPPw@mail.gmail.com>
Subject: Re: [PATCH v4 11/21] cxl/mbox: Move mailbox and other non-PCI
 specific infrastructure to the core
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 9, 2021 at 9:41 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 21-09-08 22:12:32, Dan Williams wrote:
> > Now that the internals of mailbox operations are abstracted from the PCI
> > specifics a bulk of infrastructure can move to the core.
> >
> > The CXL_PMEM driver intends to proxy LIBNVDIMM UAPI and driver requests
> > to the equivalent functionality provided by the CXL hardware mailbox
> > interface. In support of that intent move the mailbox implementation to
> > a shared location for the CXL_PCI driver native IOCTL path and CXL_PMEM
> > nvdimm command proxy path to share.
> >
> > A unit test framework seeks to implement a unit test backend transport
> > for mailbox commands to communicate mocked up payloads. It can reuse all
> > of the mailbox infrastructure minus the PCI specifics, so that also gets
> > moved to the core.
> >
> > Finally with the mailbox infrastructure and ioctl handling being
> > transport generic there is no longer any need to pass file
> > file_operations to devm_cxl_add_memdev(). That allows all the ioctl
> > boilerplate to move into the core for unit test reuse.
> >
> > No functional change intended, just code movement.
>
> At some point, I think some of the comments and kernel docs need updating since
> the target is no longer exclusively memory devices. Perhaps you do this in later
> patches....

I would wait to rework comments when/if it becomes clear that a
non-memory-device driver wants to reuse the mailbox core. I do not see
any indications that the comments are currently broken, do you?

[..]
> > diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> > index 036a3c8106b4..c85b7fbad02d 100644
> > --- a/drivers/cxl/core/core.h
> > +++ b/drivers/cxl/core/core.h
> > @@ -14,7 +14,15 @@ static inline void unregister_cxl_dev(void *dev)
> >       device_unregister(dev);
> >  }
> >
> > +struct cxl_send_command;
> > +struct cxl_mem_query_commands;
> > +int cxl_query_cmd(struct cxl_memdev *cxlmd,
> > +               struct cxl_mem_query_commands __user *q);
> > +int cxl_send_cmd(struct cxl_memdev *cxlmd, struct cxl_send_command __user *s);
> > +
> >  int cxl_memdev_init(void);
> >  void cxl_memdev_exit(void);
> > +void cxl_mbox_init(void);
> > +void cxl_mbox_exit(void);
>
> cxl_mbox_fini()?

The idiomatic kernel module shutdown function is suffixed _exit().

[..]
