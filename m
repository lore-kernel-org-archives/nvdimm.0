Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B770
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 18:59:01 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id u14so10855473pga.11
        for <nvdimm@lists.linux.dev>; Fri, 09 Jul 2021 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGN5e1WtHftW4hUIA4ldsmeCcIujaRoyn4Nx42NHDXg=;
        b=SKhq28WMlq8qMHJS9WmXIglIXcUKXuKukgu8D2F/xOeGW1WHsUtlH/ugJbxzhzUjeJ
         9XQpNqLyoSB/Ss0ShBTN/BDuu+Pt0q1ROhThxSshN8wipBwheH72rSBdrcDGcf5tRF3u
         K2pzDwJm/wcZFdqOTMNeY7y2O6uYmnuB3W4coS+FFL770GsogDVtbzEuUVsWHmptw6u1
         sVyFfESdeLnh2Lz0KaaB6i7jN0fhWxmboQMj6A5blBnN2uxUgFz7M4RQ0ex7nsitf2i8
         BUs1IRxCpu/14nzquFkSMzDGR8H02YHJUje47dRSyB+N4SjuA+MUuInxDmwOqerY5qEM
         r3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGN5e1WtHftW4hUIA4ldsmeCcIujaRoyn4Nx42NHDXg=;
        b=DMUiU8YAiUz0BlKnlCtvYqElEksqxVwGmUfbeUX3IS4iZ+aXuPKUtY+F5KAMRrn/V5
         qzO0292Qirt6nMR60O048h7SV2nHd8GPF5KKMuOapSRNI27b9XDVlpfraLJ8LnYb0KAO
         D4o68M5AAVcIJfgFI6jlMc+N6mPyNnIpI/9f+yt/vyCQHmRajOpMp5Vu6/xyS8upDpeK
         8JB8GdJMSSXx2NWRh/wmomNYms1O8icjlLGiovFjE5aRQtMEcKlTO4howPXyv0WMP9ti
         Q9xMDF00YyMSo6O1syhsIk3kfyyRxt956jKnfLyff8rE51FaPZHnqVIZ7PGKxV0ad43v
         pIUw==
X-Gm-Message-State: AOAM5317suVzai/n0sHtWsp0rOAUk2ZlXqnCZIPsPhQYQmEiRMsPDRvk
	61rG3k/DeURr+gBv+a9sWv/wegvqeE24UhVUgHzL9g==
X-Google-Smtp-Source: ABdhPJwlf6RZ0V5fJS5ZJgaN5m5aXxfPpcSszm2u3J4dzd/mte3XsX0aUniPtZpe85aHuB5a5dcuU/gXFwp6JaCFW9o=
X-Received: by 2002:a63:4c3:: with SMTP id 186mr29353636pge.240.1625857140941;
 Fri, 09 Jul 2021 11:59:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
 <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com> <x49eec7zezu.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49eec7zezu.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jul 2021 11:58:49 -0700
Message-ID: <CAPcyv4jTqY4hzdnTp4CpS5WWLsDS9Q0RsZkNZ7Bxr0oRXDLLFw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
To: Jeff Moyer <jmoyer@redhat.com>
Cc: James Anandraj <james.sushanth.anandraj@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, 
	Adam Borowski <kilobyte@angband.pl>, bgurney@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 9, 2021 at 8:24 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > [ add Jeff, Michal, and Adam ]
>
> [ adding Bryan Gurney, who is helping out with RHEL packaging ]
>
> > Hey ndctl distro maintainers,
> >
> > Just wanted to highlight this new tool submission for your
> > consideration. The goal here is to have a Linux native provisioning
> > tool that covers the basics of the functionality that is outside of
> > the ACPI specification, and reduce the need for ipmctl outside of
> > exceptional device-specific debug scenarios. Recall that the ACPI NFIT
> > communicates the static region configuration to the OS, but changing
> > that configuration is a device-specific protocol plus a reboot. Until
> > the arrival of pcdctl, region provisioning required ipmctl.
>
> It's great to see progress on this, thanks!  Shipping another utility as
> part of the ndctl package is fine with me, though I'm not sure why we
> wouldn't just make this an ndctl sub-command.  From a user's
> perspective, these are all operations on or about nvdimms.  ipmctl
> didn't have separate utilities for provisioning goals and namespace
> configuration, for example.

True, but ipmctl also did not make an attempt to support anything
other than Intel devices, and later versions abandoned the namespace
setup code in favor of "native OS" capabilities (ndctl on Linux).

The main rationale for splitting region provisioning to dedicated
tooling is the observation that region provisioning semantics are
platform specific. It is already the case that IBM devices have their
own provisioning tool with different semantics for the "PAPR" family.
CXL region provisioning semantics again are much different than what
is done for DDR-T devices (see below). So rather than try to abstract
all that under ndctl that wants to be vendor agnostic, offload that to
platform specific tools. My hope is that more tools like this do not
proliferate as the industry unifies on common standards for persistent
memory like CXL.

That said, the new commands could be placed under a
vendor/platform-specific name in ndctl, like:

ndctl list-ipm-region
ndctl reconfigure-ipm-region

...just not my first choice given the success to date of keeping
vendor details out of the command line interface of ndctl. The primary
blocker for ndctl to generic region provisioning would be a kernel
driver model for it, but I don't know how to reconcile "ipm-regions"
requiring a reboot and a BIOS validation step vs buses like CXL that
can reconfigure interleave sets at runtime.

> > I will note that CXL moves the region configuration into the base CXL
> > specification so the ndctl project will pick up a "cxl-cli" tool for
> > that purpose. In general, the ndctl project is open to carrying
> > support for persistent memory devices with open specifications. In
> > this case the provisioning specification for devices formerly driven
> > by ipmctl was opened up and provided here:
>
> Is there a meaningful difference to the user?  Can you show some
> examples of how configuration would be different between cxl-attached
> pmem and memory-bus attached pmem?

Yes, CXL exposes several more details and degrees of freedom to system
software. Before I list those I'll point out that to keep pcdctl
simple it only handles the simple / common configurations: all
performance-pmem (interleaved), all fault tolerant pmem
(non-interleaved), all volatile with memory-side-caching. Any
custom/expert configuration outside of those common cases is punted to
ipmctl. In comparison, the CXL tool will need to handle the full range
of configuration complexity.

The main difference to end users when provisioning regions on CXL is
the wider range of resources they need to consider. The CXL specific
resources include:

- Available PMEM capable address space as described by the ACPI CFMWS

- Device performance that matches the address space traffic class

- Decoder resources at each level of the hierarchy. I.e. a device may
be able to participate in 4 different interleave configurations, but
depending on the switch topology upstream of that device it may be
constrained to a smaller set.

- Volatile memory vs PMEM partitioning on the device. The NVDIMM
sub-system and ndctl will not have any responsibility for the volatile
memory side of CXL.

To me that looks like sufficient complexity to warrant a dedicated CXL
tool rather than try to find a lowest-common-denominator abstraction
that melds with ipm-regions for ndctl to drive generically. The CXL
tool will also handle firmware update and other CXL generic
functionality outside of PMEM.

> > https://cdrdv2.intel.com/v1/dl/getContent/634430
> >
> > Please comment on its suitability for shipping in distros alongside
> > the ndctl tool.
>
> It's completely fine to ship more tools with ndctl.  I would like a
> better overall picture of configuration from the admin's perspective.
> At first glance, I think we're adding unneeded complexity.

You mean the complexity of having to determine which platform region
provisioning tool to use before you can use ndctl to do the rest?

>
> Cheers,
> Jeff
>
> p.s. I don't find the name 'pdctl' particularly endearing.  If we do
> stick with a separate utility, I'd suggest coming up with a more
> descriptive name.

How about "ipmregion"? Where "ipm" is already in the wild as an
identifier for DDR-T configuration, and unlike ipmctl it only handles
the region provisioning subset?
