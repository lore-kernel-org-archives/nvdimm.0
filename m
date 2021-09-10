Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2272FB3
	for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 18:46:40 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d18so1714023pll.11
        for <nvdimm@lists.linux.dev>; Fri, 10 Sep 2021 11:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QTU/OxOBQzMOY5lZxzMBSA+uw9+bBSKTTEEGkzUKB7I=;
        b=RbEh/nY0rMcpIs7qtyeZ/5T9pbKKpW8p1zOGDopbk3ZVPtEieInLYLoqT3pIORBNou
         SiOs1CcHn3rWTMWz73artTkQ3xhJ/Rt14fmpQ+a6EvqZGRmSisKbRAg/lh2RjkdILtLR
         qQekpm8GWDqfHkjMvkRzrF8Wd/4YQZAqLedONrlLBq6iTxxnicyUIqQ/VAuu3YE7xaX0
         TippGXr3JCy633tD9eDXMuT78fVpzRehIL7bVy09qbz/LrHb44mpVhMyYbBCN2924arE
         A1H6q9EG3YuQoNqlu3TLT9qGLNg9/YumzTBEs1QYhu+VhmGbdB+w80Ki1Im73JIGVVyj
         p8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QTU/OxOBQzMOY5lZxzMBSA+uw9+bBSKTTEEGkzUKB7I=;
        b=ko9m5fv5iJWaRtDb0QS1SzmkgNNFTWTaBe6CVrhuMXI9O+H0OBFIx92rboq++ego41
         07DEdfkCqgBhwaZMhEEYJJan/tVf5nb6iIEduGA1nDE7rie8Ugfh/DKFf91iKlaRQ/0m
         coqBEeSj4z61jK/13EdJBD0uF7J2GRnLKOi0jh7qTSjbx/8TNODiQdQ9DdYWu69UGkYy
         +x+C4I9J4Wl28pMHKSUbHBkqOOTIiipi/TPmulDMKQcQsvugs/UMORIcLTCwQlP/5Kia
         1rk9z2AODChQZ8bvdVN0WS5pr1yH1lDyRIYy5sjJ2vWEKElr3eq9uegqR73npOFvxVRC
         sxpA==
X-Gm-Message-State: AOAM531jGv+e+m5W+Iv8OrbDkiIhYCemwi4U5li8n45R52jQBt5MqEVG
	AtmE4nXZzt9R6VRLOkUqMzubJY+SHf0baApwEzRbGw==
X-Google-Smtp-Source: ABdhPJwB9TgWypz0/g7xsRwNkNwbdD2iH8E0KoZmkzh9ZR9X1/J898p/QAYSaO0x2g/OWBH0jw3DVrwKEb4bPzRVry8=
X-Received: by 2002:a17:90b:513:: with SMTP id r19mr10753479pjz.93.1631299599819;
 Fri, 10 Sep 2021 11:46:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116438489.2460985.12407123882806203553.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210910105313.00006408@Huawei.com>
In-Reply-To: <20210910105313.00006408@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Sep 2021 11:46:29 -0700
Message-ID: <CAPcyv4izawiBPyDNe-yeijy9nF+Ehdu5vrSffPT_pWbQvG8xFA@mail.gmail.com>
Subject: Re: [PATCH v4 17/21] tools/testing/cxl: Introduce a mocked-up CXL
 port hierarchy
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 10, 2021 at 2:53 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 8 Sep 2021 22:13:04 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Create an environment for CXL plumbing unit tests. Especially when it
> > comes to an algorithm for HDM Decoder (Host-managed Device Memory
> > Decoder) programming, the availability of an in-kernel-tree emulation
> > environment for CXL configuration complexity and corner cases speeds
> > development and deters regressions.
> >
> > The approach taken mirrors what was done for tools/testing/nvdimm/. I.e.
> > an external module, cxl_test.ko built out of the tools/testing/cxl/
> > directory, provides mock implementations of kernel APIs and kernel
> > objects to simulate a real world device hierarchy.
> >
> > One feedback for the tools/testing/nvdimm/ proposal was "why not do this
> > in QEMU?". In fact, the CXL development community has developed a QEMU
> > model for CXL [1]. However, there are a few blocking issues that keep
> > QEMU from being a tight fit for topology + provisioning unit tests:
> >
> > 1/ The QEMU community has yet to show interest in merging any of this
> >    support that has had patches on the list since November 2020. So,
> >    testing CXL to date involves building custom QEMU with out-of-tree
> >    patches.
> >
> > 2/ CXL mechanisms like cross-host-bridge interleave do not have a clear
> >    path to be emulated by QEMU without major infrastructure work. This
> >    is easier to achieve with the alloc_mock_res() approach taken in this
> >    patch to shortcut-define emulated system physical address ranges with
> >    interleave behavior.
> >
> > The QEMU enabling has been critical to get the driver off the ground,
> > and may still move forward, but it does not address the ongoing needs of
> > a regression testing environment and test driven development.
> >
> > This patch adds an ACPI CXL Platform definition with emulated CXL
> > multi-ported host-bridges. A follow on patch adds emulated memory
> > expander devices.
> >
> > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> > Link: https://lore.kernel.org/r/20210202005948.241655-1-ben.widawsky@intel.com [1]
> > Link: https://lore.kernel.org/r/162982125348.1124374.17808192318402734926.stgit@dwillia2-desk3.amr.corp.intel.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> A trivial comment below, but I'm fine with leave that one change in here
> as it is only a very small amount of noise.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
>
>
> > ---
> >  drivers/cxl/acpi.c               |   40 ++-
> >  drivers/cxl/cxl.h                |   16 +
> >  tools/testing/cxl/Kbuild         |   36 +++
> >  tools/testing/cxl/config_check.c |   13 +
> >  tools/testing/cxl/mock_acpi.c    |  109 ++++++++
> >  tools/testing/cxl/test/Kbuild    |    6
> >  tools/testing/cxl/test/cxl.c     |  509 ++++++++++++++++++++++++++++++++++++++
> >  tools/testing/cxl/test/mock.c    |  171 +++++++++++++
> >  tools/testing/cxl/test/mock.h    |   27 ++
> >  9 files changed, 911 insertions(+), 16 deletions(-)
> >  create mode 100644 tools/testing/cxl/Kbuild
> >  create mode 100644 tools/testing/cxl/config_check.c
> >  create mode 100644 tools/testing/cxl/mock_acpi.c
> >  create mode 100644 tools/testing/cxl/test/Kbuild
> >  create mode 100644 tools/testing/cxl/test/cxl.c
> >  create mode 100644 tools/testing/cxl/test/mock.c
> >  create mode 100644 tools/testing/cxl/test/mock.h
> >
> > diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> > index 54e9d4d2cf5f..d31a97218593 100644
> > --- a/drivers/cxl/acpi.c
> > +++ b/drivers/cxl/acpi.c
> > @@ -182,15 +182,7 @@ static resource_size_t get_chbcr(struct acpi_cedt_chbs *chbs)
> >       return IS_ERR(chbs) ? CXL_RESOURCE_NONE : chbs->base;
> >  }
> >
> > -struct cxl_walk_context {
> > -     struct device *dev;
> > -     struct pci_bus *root;
> > -     struct cxl_port *port;
> > -     int error;
> > -     int count;
> > -};
> > -
> > -static int match_add_root_ports(struct pci_dev *pdev, void *data)
> > +__mock int match_add_root_ports(struct pci_dev *pdev, void *data)
> >  {
> >       struct cxl_walk_context *ctx = data;
> >       struct pci_bus *root_bus = ctx->root;
> > @@ -239,15 +231,18 @@ static struct cxl_dport *find_dport_by_dev(struct cxl_port *port, struct device
> >       return NULL;
> >  }
> >
> > -static struct acpi_device *to_cxl_host_bridge(struct device *dev)
> > +__mock struct acpi_device *to_cxl_host_bridge(struct device *host,
> > +                                           struct device *dev)
> >  {
> >       struct acpi_device *adev = to_acpi_device(dev);
> >
> >       if (!acpi_pci_find_root(adev->handle))
> >               return NULL;
> >
> > -     if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
> > +     if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0) {
> > +             dev_dbg(host, "found host bridge %s\n", dev_name(&adev->dev));
>
> I didn't call it out in the previous review, but technically unrelated to the
> rest of the patch even if useful.

I'll delete it. It was added during development to debug the mocking
code, but it should have moved to a separate patch, or been dropped.
