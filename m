Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FF170
	for <nvdimm@lists.linux.dev>; Mon, 14 Jun 2021 21:40:30 +0000 (UTC)
IronPort-SDR: igfDR7l74lbVKtEIz25DGV2cgv6Of5no1FYoSwqcDH1Y9/WE/N3Ap3oTS8q/ECfZGAodoq6KZB
 ifUCbapWme0A==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="185576704"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="185576704"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 14:40:30 -0700
IronPort-SDR: TDuw5AqFWVR0OV4f0sLfsrZpTqQJ5qfJAmELlMtTDw2pwt3mumeKcim3AimxYEXCNKepo+hPyr
 Zxc0Bw7zIEbA==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="484220411"
Received: from smothe-mobl.amr.corp.intel.com (HELO intel.com) ([10.252.143.124])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 14:40:29 -0700
Date: Mon, 14 Jun 2021 14:40:28 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] cxl/core: Add cxl-bus driver infrastructure
Message-ID: <20210614214028.5ts7qvox2rmqrvrz@intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336396329.2462439.16556923116284874437.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210611174736.ttzpk5uniyoyd4vw@intel.com>
 <CAPcyv4i7_RhfiYMX=QP2Ts4ye1Q2e0=_aBCP4rsuopo=0HWKVw@mail.gmail.com>
 <20210611192829.bwdj322uwlsbdrjs@intel.com>
 <CAPcyv4gwUiQLfPGe9kKi7JJdbSk-aaSywo29x=kFKdeEROdMcQ@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwUiQLfPGe9kKi7JJdbSk-aaSywo29x=kFKdeEROdMcQ@mail.gmail.com>

On 21-06-11 16:25:05, Dan Williams wrote:
> On Fri, Jun 11, 2021 at 12:28 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > On 21-06-11 11:55:39, Dan Williams wrote:
> > > On Fri, Jun 11, 2021 at 10:47 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > >
> > > > On 21-06-10 15:26:03, Dan Williams wrote:
> > > > > Enable devices on the 'cxl' bus to be attached to drivers. The initial
> > > > > user of this functionality is a driver for an 'nvdimm-bridge' device
> > > > > that anchors a libnvdimm hierarchy attached to CXL persistent memory
> > > > > resources. Other device types that will leverage this include:
> > > > >
> > > > > cxl_port: map and use component register functionality (HDM Decoders)
> > > >
> > > > Since I'm looking at this now, perhaps I can open the discussion here. Have you
> > > > thought about how this works yet? Right now I'm thinking there are two "drivers":
> > > > cxl_port: Switches (and ACPI0016)
> > > > cxl_mem: The memory device's HDM decoders
> > > >
> > > > For port, probe() will figure out that the thing is an upstream port, call
> > > > cxl_probe_component_regs and then call devm_cxl_add_port(). I think that's
> > > > straight forward.
> > >
> > > I was expecting cxl_port_driver.probe() comes *after* port discovery.
> > > Think of it like PCI discovery. Some agent does the hardware topology
> > > scan to add devices, in this case devm_cxl_add_port(), and that
> > > triggers cxl_port_driver to load. So the initial enumeration done by
> > > the cxl_acpi driver will populate the first two levels of the port
> > > hierarchy with port objects and populate their component register
> > > physical base addresses. For any other port deeper in the hierarchy I
> > > was expecting that to be scanned after the discovery of a cxl_memdev
> > > that is not attached to the current hierarchy. So, for example imagine
> > > a config like:
> > >
> > > Platform --> Host Bridge --> Switch --> Endpoint
> > >
> > > ...where in sysfs that's modeled as:
> > >
> > > root0 --> port1 --> port2 --> port3
> > >
> > > Where port3 is assuming that the CXL core models the device's
> > > connection to the topology as yet another cxl_port. At the beginning
> > > of time after cxl_acpi has loaded but before cxl_pci has discovered
> > > the endpoint the topology is:
> > >
> > > root0 --> port1
> > >
> > > Upon the detection of the endpoint the CXL core can assume that all
> > > intermediary switches between the root and this device have been
> > > registered as PCI devices. So, it follows that endpoint device arrival
> > > triggers "cxl_bus_rescan()" that goes and enumerates all the CXL
> > > resources in the topology to produce:
> > >
> > > root0 --> port1 --> port2 --> port3
> > >
> >
> > Ah, I had written about scan/rescan in an earlier version of my email but
> > dropped it. I was actually going to suggest it being a sysfs attr, but I'm fine
> > with it being implicit so long as...
> >
> > How do we assert that cxl_pci doesn't run before cxl_acpi has done anything?
> 
> I don't think we need to, or it's broken if the driver load order
> matters. The nvdimm enabling code is an example of how to handle this.
> The cxl_nvdimm object can be registered before the cxl_nvdimm_bridge,
> or after, does not matter. If the cxl_nvdimm comes first it will
> trigger the cxl_nvdimm_driver to load. The cxl_nvdimm_driver.probe()
> routine finds no bridge present and probe() returns with a failure.
> When the bridge arrives it does a rescan  of the cxl_bus_type device
> list and if it finds a cxl_nvdimm it re-triggers
> cxl_nvdimm_driver.probe(). This time through cxl_nvdimm_driver.probe()
> finds the bridge and registers the real nvdimm on the nvdimm_bus.
> 
> > I
> > like the idea that the endpoint device can simply ask cxl_acpi to rescan, I just
> > don't see how it works. I suppose we can queue up the requests to rescan in
> > cxl_acpi if the ordering can't be guaranteed.
> 
> I think this means that the devm_cxl_add_port() would be triggered by
> cxl_memdev_driver.probe() if and only if the parent pci_device of the
> CXL endpoint is listed as a dport. If the cxl_memdev is registered
> first the search it will search for the CXL root port on the
> cxl_bus_type device list. If that fails then cxl_memdev_driver.probe()
> fails. If that succeeds it asks the root to scan to the CXL endpoint
> parent pci_device and return the confirmation that it is registered as
> a dport. If that fails then the device is plugged into a pure PCIe
> slot.
> 
> When cxl_acpi loads it retriggers all cxl_memdev_driver.probe() to
> reconsider all cxl_memdev instances that failed to probe previously.
> 
> >
> > > > For the memory device we've already probed the thing via class code so there is
> > > > no need to use this driver registration, however, I think it would be nice to do
> > > > so. Is there a clean way to do that?
> > >
> > > The PCI device associated with the endpoint is already probed, but the
> > > cxl_memdev itself can have a driver on the CXL bus. So I think the
> > > cxl_memdev driver should try to register a cxl_port after telling
> > > cxl_acpi to rescan. If a check like "is_cxl_dport(pdev->dev.parent)"
> > > for the endpoint returns false it means that the cxl_bus_rescan()
> > > failed to enumerate the CXL topology to this endpoint and this
> > > endpoint is limited to only CXL.io operation.
> >
> > What is going to invoke the memdev driver's probe? That is where we're talking
> > about putting that is_cxl_dport(...) right? That is the part that tripped me up
> > and inspired the original email FWIW.
> 
> I *think* I worked that out above, but yes please do poke at it to see
> if it holds up.

I think it works. I have some concerns around synchronization of memdev probing
and cxl_acpi enumerating, but I believe it's workable.

Thanks for the thought.
