Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FA92CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 00:44:06 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so804575pjb.1
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ogo17UqARJL4p9/LnCmhjKJqbXuqhpyXuwxM70OGXlE=;
        b=c/376VNugm56bLwLAeXVu2BkqPu6SjdkyjMHwccQMq8pothhH4fO8WLySebdQcMD4H
         loG6kUDzEYGhQa82gRKpqVhOUHGnewKq/WNZn4MLGesAnoMvnvbQhu1Ccmfzorl7/cV7
         OEZ8a+Gyd+zal9oBz2vk+PJQ1ZFd02wAtzvnV1tAbXuSUFE0uiKuvI42UmDmm80R1WgK
         qZraj11WiDcWOoImxxnH99Y/W4JqELiqXkCQspluqqhexUHlEUIM4J7frzjmYmFoBaye
         9hOQk1hvkjH22urQF4Xy+PUpnHRRP/n5r+l7X+ZI4MhAcXNBPDWUZF2VpwBzSt0a41ob
         E1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ogo17UqARJL4p9/LnCmhjKJqbXuqhpyXuwxM70OGXlE=;
        b=4CP3u5lwUNnWV+9OsjKQDUzOr/RYMnTEmzbAtqrLhyotFv2UVRD6ghBNxBERLmyyQ9
         mbYgyKUt97IhlS64m5tJ2UMXK401831JbfORnuzmOTvP1V+n6r7U1GQpBJVKbz1rIx1+
         x+zcU3PvX3UMn7ZuvIvLiLiK3xv/sC/2Qj6+I3foJz4d7K6aLQlXyfg0fAtg7hQhkDT0
         CRCXBeiL2M238lG/Fo0al3ES4m3jLDcm76BrpVzHuOZDivexfoHxVIgzPuTpeSqmSC2n
         r9+uCe/BDaE956ou8WykBJyeefXM9CnBo7YltAy7Fl8jNh+hn/FoeWsqCsZdAXBbgA+P
         6oAg==
X-Gm-Message-State: AOAM5309YQ7pGMFyYZS9XX12i2OdijDMq5GQaKzyIH0nA21jrn0Pb8f1
	I7b1rWEOm9+Idgxn9c8raoosAqGepf9en655/JN/fA==
X-Google-Smtp-Source: ABdhPJwvfdKe0O3cEdLQmli0XryY4gO5HzlQNdngTCrUOV66YWmpQb/QY9/oJXGJogWtu0TkcS3vUNlsGbmDbUQ6wDg=
X-Received: by 2002:a17:902:d705:: with SMTP id w5mr22672490ply.34.1643676245916;
 Mon, 31 Jan 2022 16:44:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298422000.3018233.4106867312927858722.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131234740.bzg63pqyf2wl3din@intel.com>
In-Reply-To: <20220131234740.bzg63pqyf2wl3din@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 16:43:58 -0800
Message-ID: <CAPcyv4gAJO+eqep1Ba1TtHUccfCw2yEjaHSV8iDhHJ9H8oADUQ@mail.gmail.com>
Subject: Re: [PATCH v3 19/40] cxl/port: Up-level cxl_add_dport() locking
 requirements to the caller
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 31, 2022 at 3:47 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-01-23 16:30:20, Dan Williams wrote:
> > In preparation for moving dport enumeration into the core, require the
> > port device lock to be acquired by the caller.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/cxl/acpi.c            |    2 ++
> >  drivers/cxl/core/port.c       |    3 +--
> >  tools/testing/cxl/mock_acpi.c |    4 ++++
> >  3 files changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index ab2b76532272..e596dc375267 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -342,7 +342,9 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> >               return 0;
> >       }
> >
> > +     device_lock(&root_port->dev);
> >       rc = cxl_add_dport(root_port, match, uid, ctx.chbcr);
> > +     device_unlock(&root_port->dev);
> >       if (rc) {
> >               dev_err(host, "failed to add downstream port: %s\n",
> >                       dev_name(match));
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index ec9587e52423..c51a10154e29 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -516,7 +516,7 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
> >  {
> >       struct cxl_dport *dup;
> >
> > -     cxl_device_lock(&port->dev);
> > +     device_lock_assert(&port->dev);
> >       dup = find_dport(port, new->port_id);
> >       if (dup)
> >               dev_err(&port->dev,
> > @@ -525,7 +525,6 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
> >                       dev_name(dup->dport));
> >       else
> >               list_add_tail(&new->list, &port->dports);
> > -     cxl_device_unlock(&port->dev);
> >
> >       return dup ? -EEXIST : 0;
> >  }
> > diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> > index 4c8a493ace56..667c032ccccf 100644
> > --- a/tools/testing/cxl/mock_acpi.c
> > +++ b/tools/testing/cxl/mock_acpi.c
> > @@ -57,7 +57,9 @@ static int match_add_root_port(struct pci_dev *pdev, void *data)
> >
> >       /* TODO walk DVSEC to find component register base */
> >       port_num = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> > +     device_lock(&port->dev);
> >       rc = cxl_add_dport(port, &pdev->dev, port_num, CXL_RESOURCE_NONE);
> > +     device_unlock(&port->dev);
> >       if (rc) {
> >               dev_err(dev, "failed to add dport: %s (%d)\n",
> >                       dev_name(&pdev->dev), rc);
> > @@ -78,7 +80,9 @@ static int mock_add_root_port(struct platform_device *pdev, void *data)
> >       struct device *dev = ctx->dev;
> >       int rc;
> >
> > +     device_lock(&port->dev);
> >       rc = cxl_add_dport(port, &pdev->dev, pdev->id, CXL_RESOURCE_NONE);
> > +     device_unlock(&port->dev);
> >       if (rc) {
> >               dev_err(dev, "failed to add dport: %s (%d)\n",
> >                       dev_name(&pdev->dev), rc);
> >
>
> Since I really don't understand, perhaps an explanation as to why you aren't
> using cxl_device_lock would help? (Is it just to get around not having a
> cxl_device_lock_assert())?

Whoops, this gets fixed up later on in , but I rebased this patch and
didn't notice that I inadvertently dropped the lockdep stuff. Will
rebase this hiccup out of the history.
