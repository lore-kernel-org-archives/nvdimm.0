Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26631460E
	for <nvdimm@lists.linux.dev>; Thu, 17 Feb 2022 20:27:10 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id c4so624720pfl.7
        for <nvdimm@lists.linux.dev>; Thu, 17 Feb 2022 12:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YlSG++D5GfAHgHmjCfrZ6D8LvYD5B7GrBUMzoffTqAU=;
        b=0nnNSqJcsLP1yRJd17NtCLezgX+a+VIHCjJ20hnNd2JMFcDtSMvlN0CG3hTnitJpkJ
         mjLos2PgtPfsEcRauZ0aOjlsH/2T4HEItSaK5hQLJ0pYMeiYHQESwlKIRpJ5waVMDe5Z
         9rpZx971pGiBljR2Lp2Kt6GdtyXIn5Hj4X8n/nT0EIHqr7QSgGVmYJ1YSxlaQu7gSMfn
         oxp27a52vIcy7rEX0Nz38CXd1wqqwuYYQc72P4G8MdOfeLGoXzx9byXk86sMyHOUuZTt
         PZ9hvu3g29Z8lox1XB01OnlOAfNbPPIpkUxm5LBE+l0v4WBVKY6/6RAsXKaaxhydwvTM
         WY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YlSG++D5GfAHgHmjCfrZ6D8LvYD5B7GrBUMzoffTqAU=;
        b=6oDHoMMY1wVN255fKlmCvJkKpBP34CqjZXh80D5+GjADOs9QIpTfrl5RR3izVzAY16
         fOWrfeDP2McakArZOnJRB6l2A+oJ7b9KjNUwARordkFNsrA2x9e5NDRzp5ApDqJfGLcV
         MtS/qAn9Kcus6pxIyOP7t0pbRjefBN0SYWYJkMMHKibi1vsxHQSu8S/h3ekK87jbFfz7
         7NoWk5XLrA5i+VMbb9ZysjtccwqpkLay8o4eqIJlCzkzwflmW3W0HpxJaTC/D6SGwufZ
         t/WOx9FcSJKKZ2VycHrjvfiUv8E608J9s1tKL4Khy5lmLuiGA/d76xvEY5iN0OlymAug
         BwoQ==
X-Gm-Message-State: AOAM533n2Z7i2MtpKR779GoONFMcquJ5l6VfWEUCfVGRHSS4CZDo3c+p
	8uf6P5ojn5yLJ03LX+1if78+DPgLYO+AbwgBwZItew==
X-Google-Smtp-Source: ABdhPJx+YcfS9D3lwIGA9Or9eXz4j+NNFWaYU15u8B4dembYmHz2ef6AeGrexxMajMjW5O5p6yWNlE7EexQ1nAFHaWQ=
X-Received: by 2002:a63:f011:0:b0:36c:2da3:32bc with SMTP id
 k17-20020a63f011000000b0036c2da332bcmr3689054pgh.40.1645129629655; Thu, 17
 Feb 2022 12:27:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220217171057.685705-1-ben.widawsky@intel.com>
 <20220217171931.740926-1-ben.widawsky@intel.com> <CAPcyv4i83TxCN_-Y3a5CuM2ng9bCAyLm53=wcHWutASd434gkg@mail.gmail.com>
 <20220217185811.qjct4dlnupgah7lh@intel.com>
In-Reply-To: <20220217185811.qjct4dlnupgah7lh@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 Feb 2022 12:26:58 -0800
Message-ID: <CAPcyv4in9Pby8X8ydCLH8SOhr3pjYM7UCAbTOHzuMkKmax8M=Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/15] cxl/region: Add region creation ABI
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 17, 2022 at 10:58 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-02-17 09:58:04, Dan Williams wrote:
> > On Thu, Feb 17, 2022 at 9:19 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > Regions are created as a child of the decoder that encompasses an
> > > address space with constraints. Regions have a number of attributes that
> > > must be configured before the region can be activated.
> > >
> > > The ABI is not meant to be secure, but is meant to avoid accidental
> > > races. As a result, a buggy process may create a region by name that was
> > > allocated by a different process. However, multiple processes which are
> > > trying not to race with each other shouldn't need special
> > > synchronization to do so.
> > >
> > > // Allocate a new region name
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
> > >
> > > // Create a new region by name
> > > while
> > > region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)
> > > ! echo $region > /sys/bus/cxl/devices/decoder0.0/create_region
> > > do true; done
> > >
> > > // Region now exists in sysfs
> > > stat -t /sys/bus/cxl/devices/decoder0.0/$region
> > >
> > > // Delete the region, and name
> > > echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region
> > >
> > > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
[..]
> > > +static void unregister_region(void *_cxlr)
> > > +{
> > > +       struct cxl_region *cxlr = _cxlr;
> > > +
> > > +       if (!test_and_set_bit(REGION_DEAD, &cxlr->flags))
> > > +               device_unregister(&cxlr->dev);
> >
> > I thought REGION_DEAD was needed to prevent double
> > devm_release_action(), not double unregister?
> >
>
> I believe that's correct, repeating what you said on our internal list:
>
> On 22-02-14 14:11:41, Dan Williams wrote:
>   True, you do need to solve the race between multiple writers racing to
>   do the unregistration, but that could be done with something like:
>
>   if (!test_and_set_bit(REGION_DEAD, &cxlr->flags))
>       device_unregister(&cxlr->dev);
>
> So I was just trying to implement what you said. Remainder of the discussion
> below...

That was in the context of moving the unregistration to a workqueue
and taking the device lock to validate whether the device has already
been unbound. In this case keeping the devm_release_action() inline in
the sysfs attribute the flag needs to protect against racing
devm_release_action(). I am not saying that a workqueue is now needed,
just clarifying the context of that suggestion.

[..]
> > > +
> > > +       return cxlr;
> > > +
> > > +err_out:
> > > +       put_device(dev);
> > > +       kfree(cxlr);
> >
> > This is a double-free of cxlr;
> >
>
> Because of release()? How does release get called if the region device wasn't
> added? Or is there something else?

->release() is always called at final put_device() regardless of
whether the device was registered with device_add() or not. I.e. see
all the other dev_set_name() error handling in the core that just does
put_device().
