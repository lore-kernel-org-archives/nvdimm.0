Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033C16921
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 22:24:11 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id y11so187162pfa.6
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 14:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wSfnY1jrUHT045ynXxSqai3/ReuSGEynEzyKZuuRD+I=;
        b=Y92RNAEFkE4R63tnmc2DVjwW/kQnWEm8l9I6fmsZW5Lv64v74cS7DPvkfWRarWh67Y
         4iRtMW9xrJKHsoC5x3BvsqS5SHDDVx3/1qA+/9PDqn4OloV4mKLtEezyzOfoV3ii1R8C
         DUky6NMbI+7P+FmIfjzmJrUYC/ktwA51N4vAU8zZhtCKWri0V+2IwkzRTQ6khNObC3dJ
         omumqRUk339uBg6WnxLm/BsspECj3Qt6fscfJWJcRorvu8dYgCQsD7+hNGuW8sYry1NB
         TOCAwxSOx/sigLPDWIZYF5mAq+uvzkKamv7HS1jH3xfdpXtO1IY+sIToT92iUbcnqwD0
         TbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wSfnY1jrUHT045ynXxSqai3/ReuSGEynEzyKZuuRD+I=;
        b=3GWT8mvmQHnR7WQDHHXOEw7M6PE7bd/FGIre1NVDlTgJN6iXHqTRFhK0SOv/Xmg5dK
         UJQ/JTUcNpGjH+i1Nvnl28aX8c2Mai93w/H2b3Ru9MnzjEmGvzPzrFICjM9ozS03eqoa
         YuJaqcQ57i2sezw7SunxhEIJejNoq2h0FrxSgJH33G4LZBxA08obhkMns8Dy+Rsm1hta
         CytWU/zRVcjen7oVwIgRquDUZu+lnzKm4aeIIf5rZTGsf5Y1xdviN3IEM8+KB1LE0xR0
         2DXM67LwW0rHSDh6lHKs/Kj20G2t7zFgq1X1KiPi1oBCS6Y5NzTUuMKsHwK7UGOAWU1P
         TQhQ==
X-Gm-Message-State: AOAM532VUk8aCe8lfA1PWCzzBPj+PQ774z+2pm9Y4UCoUatCk5XJFqCM
	sYWKCqALT0KXVa2COtB+hlm+vG29K5wzq+gh5j3b0A==
X-Google-Smtp-Source: ABdhPJz5pwRMBb33eHf5ww5yqV3iQsX8w1OPV0cCpEiO++GxfehuXPEyY7g7mOISymIWZAKdrlP3e3K3/PBlVTehiQA=
X-Received: by 2002:a63:2354:0:b0:372:c945:bfd1 with SMTP id
 u20-20020a632354000000b00372c945bfd1mr1324317pgm.437.1645655051483; Wed, 23
 Feb 2022 14:24:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-3-ben.widawsky@intel.com> <CAPcyv4hHJcPLRJM-7z+wKhjBhp9HH2qXuEeC0VfDnD6yU9H-Wg@mail.gmail.com>
 <20220217183628.6iwph6w3ndoct3o3@intel.com> <CAPcyv4gTgwmeX_WpsPdZ1K253XmwXwWU4629PKB__n4MF6CeFQ@mail.gmail.com>
 <20220223214955.riljjquteodtdyaj@intel.com>
In-Reply-To: <20220223214955.riljjquteodtdyaj@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Feb 2022 14:24:00 -0800
Message-ID: <CAPcyv4iqd-_37kfL0_UMq+17tt==P1Nq1yWFZkcJQ42A+03O7w@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] cxl/region: Introduce concept of region configuration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Bjorn Helgaas <helgaas@kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2022 at 1:50 PM Ben Widawsky <ben.widawsky@intel.com> wrote=
:
>
> On 22-02-17 11:57:59, Dan Williams wrote:
> > On Thu, Feb 17, 2022 at 10:36 AM Ben Widawsky <ben.widawsky@intel.com> =
wrote:
> > >
> > > Consolidating earlier discussions...
> > >
> > > On 22-01-28 16:25:34, Dan Williams wrote:
> > > > On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@intel.co=
m> wrote:
> > > > >
> > > > > The region creation APIs create a vacant region. Configuring the =
region
> > > > > works in the same way as similar subsystems such as devdax. Sysfs=
 attrs
> > > > > will be provided to allow userspace to configure the region.  Fin=
ally
> > > > > once all configuration is complete, userspace may activate the re=
gion.
> > > > >
> > > > > Introduced here are the most basic attributes needed to configure=
 a
> > > > > region. Details of these attribute are described in the ABI
> > > >
> > > > s/attribute/attributes/
> > > >
> > > > > Documentation. Sanity checking of configuration parameters are do=
ne at
> > > > > region binding time. This consolidates all such logic in one plac=
e,
> > > > > rather than being strewn across multiple places.
> > > >
> > > > I think that's too late for some of the validation. The complex
> > > > validation that the region driver does throughout the topology is
> > > > different from the basic input validation that can  be done at the
> > > > sysfs write time. For example ,this patch allows negative
> > > > interleave_granularity values to specified, just return -EINVAL. I
> > > > agree that sysfs should not validate everything, I disagree with
> > > > pushing all validation to cxl_region_probe().
> > > >
> > >
> > > Okay. It might save us some back and forth if you could outline every=
thing you'd
> > > expect to be validated, but I can also make an attempt to figure out =
the
> > > reasonable set of things.
> >
> > Input validation. Every value that gets written to a sysfs attribute
> > should be checked for validity, more below:
> >
> > >
> > > > >
> > > > > A example is provided below:
> > > > >
> > > > > /sys/bus/cxl/devices/region0.0:0
> > > > > =E2=94=9C=E2=94=80=E2=94=80 interleave_granularity
> >
> > ...validate granularity is within spec and can be supported by the root=
 decoder.
> >
> > > > > =E2=94=9C=E2=94=80=E2=94=80 interleave_ways
> >
> > ...validate ways is within spec and can be supported by the root decode=
r.
>
> I'm not sure how to do this one. Validation requires device positions and=
 we
> can't set the targets until ways is set. Can you please provide some more
> insight on what you'd like me to check in addition to the value being wit=
hin
> spec?

For example you could check that interleave_ways is >=3D to the root
level interleave. I.e. it would be invalid to attempt a x1 interleave
on a decoder that is x2 interleaved at the host-bridge level.
