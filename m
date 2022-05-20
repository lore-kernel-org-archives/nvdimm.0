Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F82F37
	for <nvdimm@lists.linux.dev>; Fri, 20 May 2022 16:41:27 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id v10so8171080pgl.11
        for <nvdimm@lists.linux.dev>; Fri, 20 May 2022 09:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IFtPpD9qXc/Z7Be1IgF71qtJS0Ckif06LrmMNZuRix4=;
        b=Q5st6czyj9v41nOl0ztvpBN0b3Ya86hd7XczbYsh+0ymun6YfphyXfXlCdPeK+AH2n
         cG0krgpjmZ1vdpQk/8y5uro/p4Q5aZklM5uffo/MbbzHcw1plHuCZMMK70Rqs1fw+vRq
         HUjQBOngVba9EHhHhUOunubeK+UaL7er5Cl/hoPwLGQSOoh9oLsfqYHg6y4iGCp8Z0JU
         6OYeTZiavvoF+KVM7U2ZDa5BPap5C6uq8rsVO/W9Evbw+4PXVPYoqAepyVyV/+b+L/jq
         7HKJzbPadFNcyWTh47vZABXiGaRF2CtFX+z01BEiyDr/gdcbgcLFIQvt4tHwE+6zlCvB
         46kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IFtPpD9qXc/Z7Be1IgF71qtJS0Ckif06LrmMNZuRix4=;
        b=MgsC/xu0jLItj7ybR/Bt/vS9k73ofLddeS6B7Q85nY4zuTZZursmWFxai2mEw+N3XM
         Z1ost/eHqHErW3brjZtWACS41MQtZ5kPVx1q1FehsgxlohyIuyv3Vf5xgwwsjN8V/M5B
         +IQRw7PsgGiKN332XPljeA4Ejs3g1PLraFxTMv6REVCXCWhnllBk1cmGKcEWHZITqK+F
         OFtKg/W8e6qlCt/m0xJeFVUG1xK8YC0ydMGyx+a7lrcGvmBAj8zsC2wTKaay3MbdmOD5
         LtK1EyBPGp/xZiUQx9dSi55qE602jBiXn2QhSI7C9L9XuYHybukND3QKloCRZ5FwPlcL
         YjYA==
X-Gm-Message-State: AOAM532nwFidbyIUCc2Iuir7A/W8Vao2zRrWm8Ow69tPG6gpmfI3K8JW
	ZwLXX7R/EraDVBxTU6NggOpVFBZCE7ttJ9cAGOhB2w==
X-Google-Smtp-Source: ABdhPJyW6c8PYVdzbUL59HhLlat17HFYjWLUhN4a9PVeVCPDquidFBDnavL1ZInA2xzyfBVim8UFQajgKv6FbB2hS1I=
X-Received: by 2002:a05:6a00:84e:b0:510:5fbc:7738 with SMTP id
 q14-20020a056a00084e00b005105fbc7738mr11140052pfk.86.1653064887150; Fri, 20
 May 2022 09:41:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220520172325.000043d8@huawei.com>
In-Reply-To: <20220520172325.000043d8@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 May 2022 09:41:20 -0700
Message-ID: <CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
Subject: Re: [RFC PATCH 00/15] Region driver
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 20, 2022 at 9:23 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 13 Apr 2022 11:37:05 -0700
> Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> > Spring cleaning is here and we're starting fresh so I won't be referenc=
ing
> > previous postings and I've removed revision history from commit message=
s.
> >
> > This patch series introduces the CXL region driver as well as associate=
d APIs in
> > CXL core to create and configure regions. Regions are defined by the CX=
L 2.0
> > specification [1], a summary follows.
> >
> > A region surfaces a swath of RAM (persistent or volatile) that appears =
as normal
> > memory to the operating system. The memory, unless programmed by BIOS, =
or a
> > previous Operating System, is inaccessible until the CXL driver creates=
 a region
> > for it.A region may be strided (interleave granularity) across multiple=
 devices
> > (interleave ways). The interleaving may traverse multiple levels of the=
 CXL
> > hierarchy.
> >
> > +-------------------------+      +-------------------------+
> > |                         |      |                         |
> > |   CXL 2.0 Host Bridge   |      |   CXL 2.0 Host Bridge   |
> > |                         |      |                         |
> > |  +------+     +------+  |      |  +------+     +------+  |
> > |  |  RP  |     |  RP  |  |      |  |  RP  |     |  RP  |  |
> > +--+------+-----+------+--+      +--+------+-----+------+--+
> >       |            |                   |               \--
> >       |            |                   |        +-------+-\--+------+
> >    +------+    +-------+            +-------+   |       |USP |      |
> >    |Type 3|    |Type 3 |            |Type 3 |   |       +----+      |
> >    |Device|    |Device |            |Device |   |     CXL Switch    |
> >    +------+    +-------+            +-------+   | +----+     +----+ |
> >                                                 | |DSP |     |DSP | |
> >                                                 +-+-|--+-----+-|--+-+
> >                                                     |          |
> >                                                 +------+    +-------+
> >                                                 |Type 3|    |Type 3 |
> >                                                 |Device|    |Device |
> >                                                 +------+    +-------+
> >
> > Region verification and programming state are owned by the cxl_region d=
river
> > (implemented in the cxl_region module). Much of the region driver is an
> > implementation of algorithms described in the CXL Type 3 Memory Device =
Software
> > Guide [2].
> >
> > The region driver is responsible for configuring regions found on persi=
stent
> > capacities in the Label Storage Area (LSA), it will also enumerate regi=
ons
> > configured by BIOS, usually volatile capacities, and will allow for dyn=
amic
> > region creation (which can then be stored in the LSA). Only dynamically=
 created
> > regions are implemented thus far.
> >
> > Dan has previously stated that he doesn't want to merge ABI until the w=
hole
> > series is posted and reviewed, to make sure we have no gaps. As such, t=
he goal
> > of posting this series is *not* to discuss the ABI specifically, feedba=
ck is of
> > course welcome. In other wordsIt has been discussed previously. The goa=
l is to find
> > architectural flaws in the implementation of the ABI that may pose prob=
lematic
> > for cases we haven't yet conceived.
> >
> > Since region creation is done via sysfs, it is left to userspace to pre=
vent
> > racing for resource usage. Here is an overview for creating a x1 256M
> > dynamically created region programming to be used by userspace clients.=
 In this
> > example, the following topology is used (cropped for brevity):
> > /sys/bus/cxl/devices/
> > =E2=94=9C=E2=94=80=E2=94=80 decoder0.0 -> ../../../devices/platform/ACP=
I0017:00/root0/decoder0.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder0.1 -> ../../../devices/platform/ACP=
I0017:00/root0/decoder0.1
> > =E2=94=9C=E2=94=80=E2=94=80 decoder1.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port1/decoder1.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder2.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port2/decoder2.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder3.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port1/endpoint3/decoder3.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder4.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port2/endpoint4/decoder4.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder5.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port1/endpoint5/decoder5.0
> > =E2=94=9C=E2=94=80=E2=94=80 decoder6.0 -> ../../../devices/platform/ACP=
I0017:00/root0/port2/endpoint6/decoder6.0
> > =E2=94=9C=E2=94=80=E2=94=80 endpoint3 -> ../../../devices/platform/ACPI=
0017:00/root0/port1/endpoint3
> > =E2=94=9C=E2=94=80=E2=94=80 endpoint4 -> ../../../devices/platform/ACPI=
0017:00/root0/port2/endpoint4
> > =E2=94=9C=E2=94=80=E2=94=80 endpoint5 -> ../../../devices/platform/ACPI=
0017:00/root0/port1/endpoint5
> > =E2=94=9C=E2=94=80=E2=94=80 endpoint6 -> ../../../devices/platform/ACPI=
0017:00/root0/port2/endpoint6
> > ...
> >
> > 1. Select a Root Decoder whose interleave spans the desired interleave =
config
> >    - devices, IG, IW, Large enough address space.
> >    - ie. pick decoder0.0
> > 2. Program the decoders for the endpoints comprising the interleave set=
.
> >    - ie. echo $((256 << 20)) > /sys/bus/cxl/devices/decoder3.0
> > 3. Create a region
> >    - ie. echo $(cat create_pmem_region) >| create_pmem_region
> > 4. Configure a region
> >    - ie. echo 256 >| interleave_granularity
> >        echo 1 >| interleave_ways
> >        echo $((256 << 20)) >| size
> >        echo decoder3.0 >| target0
> > 5. Bind the region driver to the region
> >    - ie. echo region0 > /sys/bus/cxl/drivers/cxl_region/bind
> >
> Hi Ben,
>
> I finally got around to actually trying this out on top of Dan's recent f=
ix set
> (I rebased it from the cxl/preview branch on kernel.org).
>
> I'm not having much luck actually bring up a region.
>
> The patch set refers to configuring the end point decoders, but all their
> sysfs attributes are read only.  Am I missing a dependency somewhere or
> is the intent that this series is part of the solution only?
>
> I'm confused!

There's a new series that's being reviewed internally before going to the l=
ist:

https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3

Given the proximity to the merge window opening and the need to get
the "mem_enabled" series staged, I asked Ben to hold it back from the
list for now.

There are some changes I am folding into it, but I hope to send it out
in the next few days after "mem_enabled" is finalized.
