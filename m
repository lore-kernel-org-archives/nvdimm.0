Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE8C34C9BE;
	Wed, 22 Oct 2025 14:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761144470; cv=none; b=hgiG+xBTUPSbJ1qZ/TdbsEXcUAwRZ1WsDEaLZzW2n/F7enJwsrmtVTlWt1IepQhjcUxWvDrE/U4dlq1VZaBaYBJ15Q+6f1u6njEwNLWlmQogD4zvFAznXXYpl8iaHuZPYnEjOiV3/6CZiVzOB1u8m9rQg21tTICvZQS4umBRnPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761144470; c=relaxed/simple;
	bh=Z1awYP775zcmRIPxtIP7LDM5gU9pja6nxuYhnSfCHwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDewiGv6/OeH8wzBbVxR1y621yfYH3eI1IlJpURMJli8/w/3hXcLq1ipTgeCRFAY3ywY6wYkt9IF4NdH+sJm3YnyImoSm1NFmziBtUd1DlTBSJ/SEeOkIJsUgnsoscjFjjbKEgO5GFhKyJADzoT+LVae7LDB/gsrPzcF4rvcd3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1QpJ40o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1QpJ40o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13DBC4CEE7;
	Wed, 22 Oct 2025 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761144469;
	bh=Z1awYP775zcmRIPxtIP7LDM5gU9pja6nxuYhnSfCHwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U1QpJ40o66G6/TVUkWpx0/dz1vlGkwNZ1VOIZyJUGJszkMRpjvNLXc4+vcHL+cvuQ
	 nuTA8alGqU9uNl/jhWZ3gdqiEK5Z7UHaISu50Nc2LJR5xXdrj+Pj9LxPo5NwVW6TX2
	 zSxS14I0cjYf94gFsOxjidhXAWTe7sztaWJn/xrkNSMbvpRveODQTtos9GFonls1+8
	 Ce+PVi6NsMeDMZUyDq5pF2ZGhQ8193V7agtk1l2CQOW/sDEhIWTuXfh88E6smHURsz
	 qHEVeawHqp9S5XSnwz537mLA+9ZdtA8udXLXr/B7Tk7uxEW+Mc7DsWNoumPnZrqW3I
	 p3nvHrkxxctJQ==
Date: Wed, 22 Oct 2025 17:47:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: dan.j.williams@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v2 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
Message-ID: <aPjujSjgLSWsAtsb@kernel.org>
References: <20251015080020.3018581-1-rppt@kernel.org>
 <20251015080020.3018581-2-rppt@kernel.org>
 <68f2da6bd013e_2a201008c@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68f2da6bd013e_2a201008c@dwillia2-mobl4.notmuch>

On Fri, Oct 17, 2025 at 05:08:11PM -0700, dan.j.williams@intel.com wrote:
> Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > There are use cases, for example virtual machine hosts, that create
> > "persistent" memory regions using memmap= option on x86 or dummy
> > pmem-region device tree nodes on DT based systems.
> > 
> > Both these options are inflexible because they create static regions and
> > the layout of the "persistent" memory cannot be adjusted without reboot
> > and sometimes they even require firmware update.
> > 
> > Add a ramdax driver that allows creation of DIMM devices on top of
> > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > 
> > The DIMMs support label space management on the "device" and provide a
> > flexible way to access RAM using fsdax and devdax.
> > 
> > Signed-off-by: Mike Rapoport (Mircosoft) <rppt@kernel.org>
> > ---
> >  drivers/nvdimm/Kconfig  |  17 +++
> >  drivers/nvdimm/Makefile |   1 +
> >  drivers/nvdimm/ramdax.c | 272 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 290 insertions(+)
> >  create mode 100644 drivers/nvdimm/ramdax.c
> > 
> > diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> > index fde3e17c836c..9ac96a7cd773 100644
> > --- a/drivers/nvdimm/Kconfig
> > +++ b/drivers/nvdimm/Kconfig
> > @@ -97,6 +97,23 @@ config OF_PMEM
> >  
> >  	  Select Y if unsure.
> >  
> > +config RAMDAX
> > +	tristate "Support persistent memory interfaces on RAM carveouts"
> > +	depends on OF || X86
> 
> I see no compile time dependency for CONFIG_OF. The one call to
> dev_of_node() looks like it still builds in the CONFIG_OF=n case. For
> CONFIG_X86 the situation is different because the kernel needs
> infrastructure to build the device.
> 
> So maybe change the dependency to drop OF and make it:
> 
> 	depends on X86_PMEM_LEGACY if X86

We can't put if in a depends statement :(
My intention with "depends on OF || X86" was that if it's not really
possible to use this driver if it's not X86 or OF because there's nothing
to define a platform device for ramdax to bind.

Maybe what we actually need is

	select X86_PMEM_LEGACY_DEVICE if X86
	default n

so that it could be only explicitly enabled in the configuration and if it
is, it will also enable X86_PMEM_LEGACY_DEVICE on x86.
With default set to no it won't be build "accidentailly", but OTOH cloud
providers can disable X86_PMEM_LEGACY and enable RAMDAX and distros can
build them as modules on x86 and architectures that support OF. 

What do you think?

> > +	select X86_PMEM_LEGACY_DEVICE
> 
> ...and drop this select.
> 
> > +	default LIBNVDIMM
> > +	help
> > +	  Allows creation of DAX devices on RAM carveouts.
> > +
> > +	  Memory ranges that are manually specified by the
> > +	  'memmap=nn[KMG]!ss[KMG]' kernel command line or defined by dummy
> > +	  pmem-region device tree nodes would be managed by this driver as DIMM
> > +	  devices with support for dynamic layout of namespaces.
> > +	  The driver can be bound to e820_pmem or pmem-region platform
> > +	  devices using 'driver_override' device attribute.
> 
> Maybe some notes for details like:
> 
> * 128K stolen at the end of the memmap range
> * supports 509 namespaces (see 'ndctl create-namespace --help')
> * must be force bound via driver_override

Sure.
 
> [..]
> > +static int ramdax_probe(struct platform_device *pdev)
> > +{
> > +	static struct nvdimm_bus_descriptor nd_desc;
> > +	struct device *dev = &pdev->dev;
> > +	struct nvdimm_bus *nvdimm_bus;
> > +	struct device_node *np;
> > +	int rc = -ENXIO;
> > +
> > +	nd_desc.provider_name = "ramdax";
> > +	nd_desc.module = THIS_MODULE;
> > +	nd_desc.ndctl = ramdax_ctl;
> > +	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
> > +	if (!nvdimm_bus)
> > +		goto err;
> > +
> > +	np = dev_of_node(&pdev->dev);
> > +	if (np)
> > +		rc = ramdax_probe_of(pdev, nvdimm_bus, np);
> 
> Hmm, I do not see any confirmation that this node is actually a
> "pmem-region". If you attach the kernel to the wrong device I think you
> get fireworks that could be avoided with a manual of_match_node() check
> of the same device_id list as the of_pmem driver.
> 
> That still would not require a "depends on OF" given of_match_node()
> compiles away in the CONFIG_OF=n case.

With how driver_override is implemented it's possible to get fireworks with
any platform device :)

I'll add a manual check for of_match_node() to be on the safer side.

> [..]
> 
> This looks good to me. With the above comments addressed you can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

-- 
Sincerely yours,
Mike.
