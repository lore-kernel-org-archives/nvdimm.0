Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB306ADE
	for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 22:43:05 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id q1so101672plx.4
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 14:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=90VyOnO9QTEuGNg0Al+WieJZeCRVo5q4tLdRZQugHhw=;
        b=EwI/kvpW6YCgnhWY7NyAk+nW9/zodnTJhLI7GFPfp4H00KXLqdkIXd8VTYVHGgjHq9
         Ys8yWiSHDchSG8O5V8dnhG/d5Y+VzPOYxDSDvrHycB3T1lLZmJMLvG7E6thefUNBv5OY
         o8p4lVrAL8X3nJclgVD7SpH8OzT61wk8XSgr0l/ZFcmCq3JVWRoOWspqX5z7f9kxq63d
         7YSRiSnpeVi9wcIsaJZ4j/CNw43fV7p2xoBXk01gxFm/tuRWeIX1r8tQoLYRQ8Ut4BoA
         I2rXBkf/Q7ygwTjw5zGdsoUn2QQoRTFuX0ahYu0WFxJeMRWqXWrL6Nysc7Os0DqLuIYJ
         3TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=90VyOnO9QTEuGNg0Al+WieJZeCRVo5q4tLdRZQugHhw=;
        b=Bpo4CwUnMx1U6ahnDj/TRPeAjXUnZuk/hMH0icEHhTnZ89z8VpzbAp4DKcjutNTWtZ
         lsqPSFa5h7CBkHxP67voAXCzAOGNYqlk2iAhe2OgTfBRJ3DUe0gcTtRP/yt0GWfaXuan
         1bMhtSaBDrzH1O/Pu+GB/QkCpu+oug/4RULUfzJWbiHMRKtnRi0wh2hA9n3hv+Y/MwN5
         GPnsJlh4FCYJx4zzj3m5GE26IM9fsa3UoLsGud1ClGUuZz4hlBIQsoMhGQBEV4jymrz3
         9dZ1qLDufhoA7Pv9cScCCl4RxcxSbzMcMKe6UXmBv5hc7M4dYGRLMKOPZDxEg719b7Ii
         xxcQ==
X-Gm-Message-State: AOAM530qaQxmdVXkPwWHjkseW+93FWbaHRuWfrgA7w9lN/mAzmssWZcw
	w9wVOkC2FLaHd/1fXrjUJPP9TqkY7PzV3Fv/yDUdTg==
X-Google-Smtp-Source: ABdhPJwKjiBwbFQ9i7qkd6gtVG08ZpVLbSUDcXDC1HbUvr7T61vgUQoB0k15ib1Z35i5vuC1LA9pUZBOMVOJ9pBV/dU=
X-Received: by 2002:a17:90b:d91:b0:1bc:ade1:54e3 with SMTP id
 bg17-20020a17090b0d9100b001bcade154e3mr3053825pjb.8.1645656184647; Wed, 23
 Feb 2022 14:43:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128002707.391076-1-ben.widawsky@intel.com>
 <20220128002707.391076-3-ben.widawsky@intel.com> <CAPcyv4hHJcPLRJM-7z+wKhjBhp9HH2qXuEeC0VfDnD6yU9H-Wg@mail.gmail.com>
 <20220217183628.6iwph6w3ndoct3o3@intel.com> <CAPcyv4gTgwmeX_WpsPdZ1K253XmwXwWU4629PKB__n4MF6CeFQ@mail.gmail.com>
 <20220223214955.riljjquteodtdyaj@intel.com> <CAPcyv4iqd-_37kfL0_UMq+17tt==P1Nq1yWFZkcJQ42A+03O7w@mail.gmail.com>
 <20220223223118.6syneumumjkmdtcy@intel.com>
In-Reply-To: <20220223223118.6syneumumjkmdtcy@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Feb 2022 14:42:53 -0800
Message-ID: <CAPcyv4hkTmFOg+3CW7L67StMVUgxvs5wdCA-kxTV8Qn55CzMYQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] cxl/region: Introduce concept of region configuration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	kernel test robot <lkp@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Bjorn Helgaas <helgaas@kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2022 at 2:31 PM Ben Widawsky <ben.widawsky@intel.com> wrote=
:
>
> On 22-02-23 14:24:00, Dan Williams wrote:
> > On Wed, Feb 23, 2022 at 1:50 PM Ben Widawsky <ben.widawsky@intel.com> w=
rote:
> > >
> > > On 22-02-17 11:57:59, Dan Williams wrote:
> > > > On Thu, Feb 17, 2022 at 10:36 AM Ben Widawsky <ben.widawsky@intel.c=
om> wrote:
> > > > >
> > > > > Consolidating earlier discussions...
> > > > >
> > > > > On 22-01-28 16:25:34, Dan Williams wrote:
> > > > > > On Thu, Jan 27, 2022 at 4:27 PM Ben Widawsky <ben.widawsky@inte=
l.com> wrote:
> > > > > > >
> > > > > > > The region creation APIs create a vacant region. Configuring =
the region
> > > > > > > works in the same way as similar subsystems such as devdax. S=
ysfs attrs
> > > > > > > will be provided to allow userspace to configure the region. =
 Finally
> > > > > > > once all configuration is complete, userspace may activate th=
e region.
> > > > > > >
> > > > > > > Introduced here are the most basic attributes needed to confi=
gure a
> > > > > > > region. Details of these attribute are described in the ABI
> > > > > >
> > > > > > s/attribute/attributes/
> > > > > >
> > > > > > > Documentation. Sanity checking of configuration parameters ar=
e done at
> > > > > > > region binding time. This consolidates all such logic in one =
place,
> > > > > > > rather than being strewn across multiple places.
> > > > > >
> > > > > > I think that's too late for some of the validation. The complex
> > > > > > validation that the region driver does throughout the topology =
is
> > > > > > different from the basic input validation that can  be done at =
the
> > > > > > sysfs write time. For example ,this patch allows negative
> > > > > > interleave_granularity values to specified, just return -EINVAL=
. I
> > > > > > agree that sysfs should not validate everything, I disagree wit=
h
> > > > > > pushing all validation to cxl_region_probe().
> > > > > >
> > > > >
> > > > > Okay. It might save us some back and forth if you could outline e=
verything you'd
> > > > > expect to be validated, but I can also make an attempt to figure =
out the
> > > > > reasonable set of things.
> > > >
> > > > Input validation. Every value that gets written to a sysfs attribut=
e
> > > > should be checked for validity, more below:
> > > >
> > > > >
> > > > > > >
> > > > > > > A example is provided below:
> > > > > > >
> > > > > > > /sys/bus/cxl/devices/region0.0:0
> > > > > > > =E2=94=9C=E2=94=80=E2=94=80 interleave_granularity
> > > >
> > > > ...validate granularity is within spec and can be supported by the =
root decoder.
> > > >
> > > > > > > =E2=94=9C=E2=94=80=E2=94=80 interleave_ways
> > > >
> > > > ...validate ways is within spec and can be supported by the root de=
coder.
> > >
> > > I'm not sure how to do this one. Validation requires device positions=
 and we
> > > can't set the targets until ways is set. Can you please provide some =
more
> > > insight on what you'd like me to check in addition to the value being=
 within
> > > spec?
> >
> > For example you could check that interleave_ways is >=3D to the root
> > level interleave. I.e. it would be invalid to attempt a x1 interleave
> > on a decoder that is x2 interleaved at the host-bridge level.
>
> I tried to convince myself that that assertion always holds and didn't fe=
el
> super comfortable. If you do, I can add those kinds of checks.

The only way to support a x1 region on an x2 interleave is to have the
size be equal to interleave granularity so that accesses stay
contained to that one device.

In fact that's another validation step, which you might already have,
region size must be >=3D and aligned to interleave_granularity *
interleave_ways.
