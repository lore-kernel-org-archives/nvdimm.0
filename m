Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A8972
	for <nvdimm@lists.linux.dev>; Tue,  7 Sep 2021 15:57:59 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id s11so10438804pgr.11
        for <nvdimm@lists.linux.dev>; Tue, 07 Sep 2021 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eeeG0Dps7JbDocH3TygyWjfVW5Um9ryVeIM7O18tPW4=;
        b=rYxGlvFdDtaTuEC/AsbxVNeQn8PI6ZF0b0c6mdZxyz0ZeUOQnrok5dpDKvT/FuoKVO
         DlDBPLSSDd/Poqj7+A2bQno41+PIaxZOAKPOTqKdj9kNsUHElJroePE0aQlyZBNWiAKN
         /mGyNLG4CwDK+rdWbRu81csRxJ7z0UXjfFJOWnSA4PW1oP6xNMdo40d4rNo9FEcMF+JQ
         68SH4fWO7cevIQH7LdRylEMWgvp76nmjWLd4um44rRvgcdZawJGzz5Dzi3/nJT957tjW
         CZL0jVBMKX8UzwV2etTjqOiPa8UsiulmMRKlL3lA/NJ2j+ijaJQeSgBPab1KJ2Rnkb08
         pwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eeeG0Dps7JbDocH3TygyWjfVW5Um9ryVeIM7O18tPW4=;
        b=tN8yuaMuYaLO61saQd5x0g63DH0oaark2tSmkAUebb9hf5avYnZIrSjkE9gnxSTZ1n
         otMR4L+qFQPv446wSPbqMMnjcw22tI9CKoY7/Yh/vUP8Slugedntks05fZObWlq0rKJg
         xYRoDeI7tmQAKL1a+JN7akPNtHAoiv36X8l6eQqZlYuRRzoGRZi3Bxh1X/wn2ynCv3DD
         hbcCOU6VaJpI+uSrm+liORJcvK7GluW9xeBKgAzIlAhxY2zuEJ/W5gXKi3d0f1uHAApL
         JZF63sRiITTzKka+T1mH6YYd5+8RGuHgoOhYumUp+TT8uF9LlDR/pXbA2Sf1MlDqEf0x
         RiOA==
X-Gm-Message-State: AOAM533zarnOoZYR+XQOCDjuJvarrvIogoniH9buj+XFkvQTBmeqnFmE
	mbjBWFjt3ebu2IeHJVXdfLs3DLXIoKEdf6zZ5CJpww==
X-Google-Smtp-Source: ABdhPJyDCFqNgmxJ6V1x16+sVXHv5g2F5t0sUOXByAqBz9/Xjty38j66cZYvY2klkiYABa3huUronGHvjKuzdN9X5tw=
X-Received: by 2002:aa7:9255:0:b0:415:ba53:e6f5 with SMTP id
 21-20020aa79255000000b00415ba53e6f5mr11473890pfp.78.1631030278548; Tue, 07
 Sep 2021 08:57:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162982125348.1124374.17808192318402734926.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210903135243.000064ac@Huawei.com> <CAPcyv4ik1e4rvys5x66iD1+-M4G_NdsEcs24m2y3MYzhpYsrOA@mail.gmail.com>
 <20210906093207.00006766@Huawei.com>
In-Reply-To: <20210906093207.00006766@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Sep 2021 08:57:47 -0700
Message-ID: <CAPcyv4ghCftjZOKXZ8vVUpEd2nNfDGS5yk+DWP+=9XYy3iWTdg@mail.gmail.com>
Subject: Re: [PATCH v3 24/28] tools/testing/cxl: Introduce a mocked-up CXL
 port hierarchy
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 6, 2021 at 1:32 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Fri, 3 Sep 2021 14:49:34 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > On Fri, Sep 3, 2021 at 5:53 AM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Tue, 24 Aug 2021 09:07:33 -0700
> > > Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > > Create an environment for CXL plumbing unit tests. Especially when it
> > > > comes to an algorithm for HDM Decoder (Host-managed Device Memory
> > > > Decoder) programming, the availability of an in-kernel-tree emulation
> > > > environment for CXL configuration complexity and corner cases speeds
> > > > development and deters regressions.
> > > >
> > > > The approach taken mirrors what was done for tools/testing/nvdimm/. I.e.
> > > > an external module, cxl_test.ko built out of the tools/testing/cxl/
> > > > directory, provides mock implementations of kernel APIs and kernel
> > > > objects to simulate a real world device hierarchy.
> > > >
> > > > One feedback for the tools/testing/nvdimm/ proposal was "why not do this
> > > > in QEMU?". In fact, the CXL development community has developed a QEMU
> > > > model for CXL [1]. However, there are a few blocking issues that keep
> > > > QEMU from being a tight fit for topology + provisioning unit tests:
> > > >
> > > > 1/ The QEMU community has yet to show interest in merging any of this
> > > >    support that has had patches on the list since November 2020. So,
> > > >    testing CXL to date involves building custom QEMU with out-of-tree
> > > >    patches.
> > >
> > > That's a separate discussion I've been meaning to kick off. I'd like
> > > to get that moving because there are various things we can do there
> > > which can't necessarily be done with this approach or at least are easier
> > > done in QEMU. I'll raise it on the qemu list and drag a few people in
> > > who might be able to help us get things moving + help find solutions to
> > > the bits that we can't currently do.
> > >
> > > >
> > > > 2/ CXL mechanisms like cross-host-bridge interleave do not have a clear
> > > >    path to be emulated by QEMU without major infrastructure work. This
> > > >    is easier to achieve with the alloc_mock_res() approach taken in this
> > > >    patch to shortcut-define emulated system physical address ranges with
> > > >    interleave behavior.
> > > >
> > > > The QEMU enabling has been critical to get the driver off the ground,
> > > > and may still move forward, but it does not address the ongoing needs of
> > > > a regression testing environment and test driven development.
> > >
> > > Different purposes, so I would see having both as beneficial
> >
> > Oh certainly, especially because cxl_test skips all the PCI details.
> > This regression environment is mainly for user space ABI regressions
> > and the PCI agnostic machinery in the subsystem. I'd love for the QEMU
> > work to move forward.
> >
> > > (in principle - I haven't played with this yet :)
> >
> > I have wondered if having a version of DOE emulation in tools/testing/
> > makes regression testing those protocols easier, but again that's PCI
> > details where QEMU is more suitable.
>
> Maybe, but I'm not convinced yet.  Particularly as the protocol complexity
> that we are interested in can get pretty nasty and I'm not sure we want
> the pain of implementing that anywhere near the kernel (e.g. CMA with
> having to hook an SPDM implementation in).
>
> Could do discovery only I guess which would exercise the basics.
> >
> > >
> > > >
> > > > This patch adds an ACPI CXL Platform definition with emulated CXL
> > > > multi-ported host-bridges. A follow on patch adds emulated memory
> > > > expander devices.
> > > >
> > > > Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> > > > Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> > > > Link: https://lore.kernel.org/r/20210202005948.241655-1-ben.widawsky@intel.com [1]
> > > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > > > ---
>
> ...
>
>
> >
> > >
> > > > +     struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> > > >
> > > >       if (!bridge)
> > > >               return 0;
> > > > @@ -319,7 +316,7 @@ static int add_host_bridge_dport(struct device *match, void *arg)
> > > >       struct acpi_cedt_chbs *chbs;
> > > >       struct cxl_port *root_port = arg;
> > > >       struct device *host = root_port->dev.parent;
> > > > -     struct acpi_device *bridge = to_cxl_host_bridge(match);
> > > > +     struct acpi_device *bridge = to_cxl_host_bridge(host, match);
> > > >
> > > >       if (!bridge)
> > > >               return 0;
> > > > @@ -371,6 +368,17 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
> > > >       return 1;
> > > >  }
> > > >
> > > ...
> > >
> > >
> > > > diff --git a/tools/testing/cxl/mock_acpi.c b/tools/testing/cxl/mock_acpi.c
> > > > new file mode 100644
> > > > index 000000000000..4c8a493ace56
> > > > --- /dev/null
> > > > +++ b/tools/testing/cxl/mock_acpi.c
> > > > @@ -0,0 +1,109 @@
> > >
> > > > +static int match_add_root_port(struct pci_dev *pdev, void *data)
> > >
> > > Hmm. Nice not to duplicate this code, but I guess a bit tricky to
> > > work around.  Maybe a comment next to the 'main' version so we
> > > remember to update this one as well if it is changed?
> >
> > I'd like to think that the __mock annotation next to the real one is
> > the indication that a unit test might need updating. Sufficient?
>
> Agreed in general, but this particular function isn't annotated, the
> caller of it is, so people have to notice that to be aware there is
> a possible issue.  If the change is something local to this they might
> not notice.

The regression test will notice. Its primary function is to catch
regressions of this nature.


[..]
> > > why that size?  Should take window_size into account I think..
> >
> > This *is* the window size, but you're right if ->interleave_ways is
> > populated above and used here ->window_size can also be populated
> > there. Then all that is left to do is dynamically populate the
> > emulated ->base_hpa.
>
> Ok, so my confusion is that this code is alays using SZ_256M * ways
> rather than say SZ_512M * ways.
>
> Perhaps a define at the top of the file or even a module parameter
> to allow larger sizes?

I changed this to put the size in the table definition directly so it
can be edited there. The intent is for this size to be static / known
to the unit test in advance. I.e. unlike QEMU testing where the test
would need to be told of the configuration that was specified to the
VM.
