Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594F2F25
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 01:18:28 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d18so16901917plg.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 17:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GZoglC+ge1/99sWCkClXyTN7rb8YyTH+ODtl0a/JGbU=;
        b=18M2BdDfm/5B8kM8ilplUX6iGkgJTOHlDzgN2eNKlUZxamjhDokdAusL197I7R72eR
         tKAslpONvIyxbJhcyVg9kgjl4hInCrnaS+Snfo6yyEnqVHtCtksJFqAmBDV476GAuqJ1
         QqLFnyMnoNjSz65W6dPMkA89Vqdq0z+BgCwtXmnJsG/m6rsG4mNT4NcLsq41hndgbF84
         s0HlVR7LNc6Ulx3zzOHMKMBqc9b/MsFzNVFiqZAsT4k6OIehTyMz0tKwALOiPfA6LT5i
         Uitiq4H1dYIN9QGimJf/uTfQSga/JlnYqdQS41hrp1904oZRUQbp5nP2A3bLmdi+GZcx
         CXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GZoglC+ge1/99sWCkClXyTN7rb8YyTH+ODtl0a/JGbU=;
        b=rY37HiY/es6mO5m7ULRQJlpSOoBApV9D9/adjO0p3lMXjR2jp88n8olpy4R/yT4Ddq
         /dGscX6j/XFgSZBvWfRnD/ab16KaeFWgh3WXttDpFiHSvvbGK8hwzmA6RlXPwu02Wpsg
         D/5bI1bxzp0WpP9o9f0HADWWiteZvxPnuKaOi07wUGojhGTTCrJp/cXMjraa/jmql2Q8
         G0PKlc+G5I3bxJUMBmrPZsPRPdkf12qxED/NcN5O9z/md9CiJV5aOVE1EoP5Js7vOBuq
         j5vPwaZKPhcPucQPfjNv4k6v7bpU/cJjao6D1lG4Bo3TbWXEuDLGDnSfYkU1tfQkDfPi
         +KgA==
X-Gm-Message-State: AOAM531EghD+bXx8RwoAiFcePLhz61tR8YVL+BZ9qEFfSThOuzE40665
	jIIRHxksEkE70965JFQiyoE63kFJpJ7wELLiFRiJvQ==
X-Google-Smtp-Source: ABdhPJwk7Oc7NbOGM9oqNhNg31hkcCL0gPpe9YgWryGjzEvWTuEX48SKeDm5Vh0Tdbl3hybV1iwW5b6PeJpLQd7Iiso=
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr1232162pjb.220.1643764708061;
 Tue, 01 Feb 2022 17:18:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298428430.3018233.16409089892707993289.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220201153154.jpyxayuulbhdran4@intel.com>
In-Reply-To: <20220201153154.jpyxayuulbhdran4@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 17:18:21 -0800
Message-ID: <CAPcyv4jBZALQH1zhuMw5O6u+OfyXmdQN_j7jwvLbFB=X2zHQVg@mail.gmail.com>
Subject: Re: [PATCH v3 31/40] cxl/memdev: Add numa_node attribute
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 1, 2022 at 7:32 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-01-23 16:31:24, Dan Williams wrote:
> > While CXL memory targets will have their own memory target node,
> > individual memory devices may be affinitized like other PCI devices.
> > Emit that attribute for memdevs.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> This brings up an interesting question. Are all devices in a region affinitized
> to the same NUMA node? I think they must be - at which point, should this
> attribute be a part of a region, rather than a device?
>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl |    9 +++++++++
> >  drivers/cxl/core/memdev.c               |   17 +++++++++++++++++
> >  tools/testing/cxl/test/cxl.c            |    1 +
> >  3 files changed, 27 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 87c0e5e65322..0b51cfec0c66 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -34,6 +34,15 @@ Description:
> >               capability. Mandatory for CXL devices, see CXL 2.0 8.1.12.2
> >               Memory Device PCIe Capabilities and Extended Capabilities.
> >
> > +What:                /sys/bus/cxl/devices/memX/numa_node
> > +Date:                January, 2022
> > +KernelVersion:       v5.18
> > +Contact:     linux-cxl@vger.kernel.org
> > +Description:
> > +             (RO) If NUMA is enabled and the platform has affinitized the
> > +             host PCI device for this memory device, emit the CPU node
> > +             affinity for this device.
> > +
>
> I think you'd want to say something about the device actively decoding. Perhaps
> I'm mistaken though, can you affinitize without setting up HDM decoders for the
> device?

Missed replying to this.

No, the memory decode is independent of the CPU to device affinity.
This affinity is like the affinity of an NVME device i.e. the affinity
of PCI.mmio to a CPU, not the resulting CXL.mem node of which there
may be multiple for a single device.
