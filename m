Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68270
	for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 14:10:24 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 2EEBF22154;
	Mon, 12 Jul 2021 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1626098453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z3+Y/CCSj/j9HeyyRvGbYG4rqh1bjpzYMD0aMLWfQQ=;
	b=zug8T8mG9C9rFc19Q+d4/xM3Yyu0EVZ0Fip1BTu0wnlIOxBL54dKCHZhJcLftnB3iClU3p
	bOyYTOCWXwFmm7y1J8go0xxiNQgLulzpdXaKcU7DQSU3n3iTA3SuQ1Gnygwm0h0/qaVWan
	TrqZaxb2k3id2+nvKeHKNOh2Ct3X2E8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1626098453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Z3+Y/CCSj/j9HeyyRvGbYG4rqh1bjpzYMD0aMLWfQQ=;
	b=fitUrEwOOiclbhoK1H4zy9tSQpQ6Trcia7fQFz2jT4hi9/bGZ/eBY+1XJAywOvWYH+tcd0
	fmLg8tcerjgx2OCA==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 0F293A3B81;
	Mon, 12 Jul 2021 14:00:53 +0000 (UTC)
Date: Mon, 12 Jul 2021 16:00:51 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
	James Anandraj <james.sushanth.anandraj@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Adam Borowski <kilobyte@angband.pl>, bgurney@redhat.com,
	Coly Li <colyli@suse.de>, Raymund Will <rw@suse.com>
Subject: Re: [PATCH v1 0/4] ndctl: Add pcdctl tool with pcdctl list and
 reconfigure-region commands
Message-ID: <20210712140051.GD3829@kitsune.suse.cz>
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
 <CAPcyv4iQqL7dGxgN_pSR0Gu27DXX4-d6SNhi2nUs38Mrq+jB=Q@mail.gmail.com>
 <x49eec7zezu.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jTqY4hzdnTp4CpS5WWLsDS9Q0RsZkNZ7Bxr0oRXDLLFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jTqY4hzdnTp4CpS5WWLsDS9Q0RsZkNZ7Bxr0oRXDLLFw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[ CC people who have some experience with the ACPI pmem ]

Hello,

On Fri, Jul 09, 2021 at 11:58:49AM -0700, Dan Williams wrote:
> On Fri, Jul 9, 2021 at 8:24 AM Jeff Moyer <jmoyer@redhat.com> wrote:
> >
> > Dan Williams <dan.j.williams@intel.com> writes:
> >
> > > [ add Jeff, Michal, and Adam ]
> >
> > [ adding Bryan Gurney, who is helping out with RHEL packaging ]
> >
> > > Hey ndctl distro maintainers,
> > >
> > > Just wanted to highlight this new tool submission for your
> > > consideration. The goal here is to have a Linux native provisioning
> > > tool that covers the basics of the functionality that is outside of
> > > the ACPI specification, and reduce the need for ipmctl outside of
> > > exceptional device-specific debug scenarios. Recall that the ACPI NFIT
> > > communicates the static region configuration to the OS, but changing
> > > that configuration is a device-specific protocol plus a reboot. Until
> > > the arrival of pcdctl, region provisioning required ipmctl.
> >
> > It's great to see progress on this, thanks!  Shipping another utility as
> > part of the ndctl package is fine with me, though I'm not sure why we
> > wouldn't just make this an ndctl sub-command.  From a user's
> > perspective, these are all operations on or about nvdimms.  ipmctl
> > didn't have separate utilities for provisioning goals and namespace
> > configuration, for example.
> 
> True, but ipmctl also did not make an attempt to support anything
> other than Intel devices, and later versions abandoned the namespace
> setup code in favor of "native OS" capabilities (ndctl on Linux).
> 
> The main rationale for splitting region provisioning to dedicated
> tooling is the observation that region provisioning semantics are
> platform specific. It is already the case that IBM devices have their
> own provisioning tool with different semantics for the "PAPR" family.
> CXL region provisioning semantics again are much different than what
> is done for DDR-T devices (see below). So rather than try to abstract
> all that under ndctl that wants to be vendor agnostic, offload that to
> platform specific tools. My hope is that more tools like this do not
> proliferate as the industry unifies on common standards for persistent
> memory like CXL.
> 
> That said, the new commands could be placed under a
> vendor/platform-specific name in ndctl, like:
> 
> ndctl list-ipm-region
> ndctl reconfigure-ipm-region
> 
> ...just not my first choice given the success to date of keeping
> vendor details out of the command line interface of ndctl. The primary
> blocker for ndctl to generic region provisioning would be a kernel
> driver model for it, but I don't know how to reconcile "ipm-regions"
> requiring a reboot and a BIOS validation step vs buses like CXL that
> can reconfigure interleave sets at runtime.
> 
> > > I will note that CXL moves the region configuration into the base CXL
> > > specification so the ndctl project will pick up a "cxl-cli" tool for
> > > that purpose. In general, the ndctl project is open to carrying
> > > support for persistent memory devices with open specifications. In
> > > this case the provisioning specification for devices formerly driven
> > > by ipmctl was opened up and provided here:
> >
> > Is there a meaningful difference to the user?  Can you show some
> > examples of how configuration would be different between cxl-attached
> > pmem and memory-bus attached pmem?
> 
> Yes, CXL exposes several more details and degrees of freedom to system
> software. Before I list those I'll point out that to keep pcdctl
> simple it only handles the simple / common configurations: all
> performance-pmem (interleaved), all fault tolerant pmem
> (non-interleaved), all volatile with memory-side-caching. Any
> custom/expert configuration outside of those common cases is punted to
> ipmctl.

What is the purpose of having the new tool when it cannot handle the
full configuration, and users still need to refer to the old tool for
some cases?

Then to make life or users simpler I vould completely skip the new
partial tool.

Other than that if the new tools provide some value but are
platform-specific it is slight annoyance to package different set of
tools depending on target architecture but it's not something that
cannot be managed.

Thanks

Michal

> In comparison, the CXL tool will need to handle the full range
> of configuration complexity.
> 
> The main difference to end users when provisioning regions on CXL is
> the wider range of resources they need to consider. The CXL specific
> resources include:
> 
> - Available PMEM capable address space as described by the ACPI CFMWS
> 
> - Device performance that matches the address space traffic class
> 
> - Decoder resources at each level of the hierarchy. I.e. a device may
> be able to participate in 4 different interleave configurations, but
> depending on the switch topology upstream of that device it may be
> constrained to a smaller set.
> 
> - Volatile memory vs PMEM partitioning on the device. The NVDIMM
> sub-system and ndctl will not have any responsibility for the volatile
> memory side of CXL.
> 
> To me that looks like sufficient complexity to warrant a dedicated CXL
> tool rather than try to find a lowest-common-denominator abstraction
> that melds with ipm-regions for ndctl to drive generically. The CXL
> tool will also handle firmware update and other CXL generic
> functionality outside of PMEM.
> 
> > > https://cdrdv2.intel.com/v1/dl/getContent/634430
> > >
> > > Please comment on its suitability for shipping in distros alongside
> > > the ndctl tool.
> >
> > It's completely fine to ship more tools with ndctl.  I would like a
> > better overall picture of configuration from the admin's perspective.
> > At first glance, I think we're adding unneeded complexity.
> 
> You mean the complexity of having to determine which platform region
> provisioning tool to use before you can use ndctl to do the rest?
> 
> >
> > Cheers,
> > Jeff
> >
> > p.s. I don't find the name 'pdctl' particularly endearing.  If we do
> > stick with a separate utility, I'd suggest coming up with a more
> > descriptive name.
> 
> How about "ipmregion"? Where "ipm" is already in the wild as an
> identifier for DDR-T configuration, and unlike ipmctl it only handles
> the region provisioning subset?
