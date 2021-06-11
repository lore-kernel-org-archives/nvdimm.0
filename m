Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9103870
	for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 19:28:39 +0000 (UTC)
IronPort-SDR: 5nUOt6kcRUOLg7VyLHJWAKXxNBwQWsa9Rt7qQEiaz2Ql/7kZrC8ArvO67ZtSE7Va389Rks3pv5
 1FINQFC4+8pw==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="291225115"
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="291225115"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 12:28:30 -0700
IronPort-SDR: XUCaJtT5tJX6zzsOnpujw9apdxCvWYuDKwylKPWMaowYV3+tRG0cr3Um58QKUZKzqgUQ0Hd/Bi
 JKDl0p0emNTA==
X-IronPort-AV: E=Sophos;i="5.83,267,1616482800"; 
   d="scan'208";a="483371383"
Received: from chtanaka-mobl2.amr.corp.intel.com (HELO intel.com) ([10.252.138.239])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 12:28:30 -0700
Date: Fri, 11 Jun 2021 12:28:29 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>,
	"Schofield, Alison" <alison.schofield@intel.com>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] cxl/core: Add cxl-bus driver infrastructure
Message-ID: <20210611192829.bwdj322uwlsbdrjs@intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162336396329.2462439.16556923116284874437.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210611174736.ttzpk5uniyoyd4vw@intel.com>
 <CAPcyv4i7_RhfiYMX=QP2Ts4ye1Q2e0=_aBCP4rsuopo=0HWKVw@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i7_RhfiYMX=QP2Ts4ye1Q2e0=_aBCP4rsuopo=0HWKVw@mail.gmail.com>

On 21-06-11 11:55:39, Dan Williams wrote:
> On Fri, Jun 11, 2021 at 10:47 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> >
> > On 21-06-10 15:26:03, Dan Williams wrote:
> > > Enable devices on the 'cxl' bus to be attached to drivers. The initial
> > > user of this functionality is a driver for an 'nvdimm-bridge' device
> > > that anchors a libnvdimm hierarchy attached to CXL persistent memory
> > > resources. Other device types that will leverage this include:
> > >
> > > cxl_port: map and use component register functionality (HDM Decoders)
> >
> > Since I'm looking at this now, perhaps I can open the discussion here. Have you
> > thought about how this works yet? Right now I'm thinking there are two "drivers":
> > cxl_port: Switches (and ACPI0016)
> > cxl_mem: The memory device's HDM decoders
> >
> > For port, probe() will figure out that the thing is an upstream port, call
> > cxl_probe_component_regs and then call devm_cxl_add_port(). I think that's
> > straight forward.
> 
> I was expecting cxl_port_driver.probe() comes *after* port discovery.
> Think of it like PCI discovery. Some agent does the hardware topology
> scan to add devices, in this case devm_cxl_add_port(), and that
> triggers cxl_port_driver to load. So the initial enumeration done by
> the cxl_acpi driver will populate the first two levels of the port
> hierarchy with port objects and populate their component register
> physical base addresses. For any other port deeper in the hierarchy I
> was expecting that to be scanned after the discovery of a cxl_memdev
> that is not attached to the current hierarchy. So, for example imagine
> a config like:
> 
> Platform --> Host Bridge --> Switch --> Endpoint
> 
> ...where in sysfs that's modeled as:
> 
> root0 --> port1 --> port2 --> port3
> 
> Where port3 is assuming that the CXL core models the device's
> connection to the topology as yet another cxl_port. At the beginning
> of time after cxl_acpi has loaded but before cxl_pci has discovered
> the endpoint the topology is:
> 
> root0 --> port1
> 
> Upon the detection of the endpoint the CXL core can assume that all
> intermediary switches between the root and this device have been
> registered as PCI devices. So, it follows that endpoint device arrival
> triggers "cxl_bus_rescan()" that goes and enumerates all the CXL
> resources in the topology to produce:
> 
> root0 --> port1 --> port2 --> port3
> 

Ah, I had written about scan/rescan in an earlier version of my email but
dropped it. I was actually going to suggest it being a sysfs attr, but I'm fine
with it being implicit so long as...

How do we assert that cxl_pci doesn't run before cxl_acpi has done anything? I
like the idea that the endpoint device can simply ask cxl_acpi to rescan, I just
don't see how it works. I suppose we can queue up the requests to rescan in
cxl_acpi if the ordering can't be guaranteed.

> > For the memory device we've already probed the thing via class code so there is
> > no need to use this driver registration, however, I think it would be nice to do
> > so. Is there a clean way to do that?
> 
> The PCI device associated with the endpoint is already probed, but the
> cxl_memdev itself can have a driver on the CXL bus. So I think the
> cxl_memdev driver should try to register a cxl_port after telling
> cxl_acpi to rescan. If a check like "is_cxl_dport(pdev->dev.parent)"
> for the endpoint returns false it means that the cxl_bus_rescan()
> failed to enumerate the CXL topology to this endpoint and this
> endpoint is limited to only CXL.io operation.

What is going to invoke the memdev driver's probe? That is where we're talking
about putting that is_cxl_dport(...) right? That is the part that tripped me up
and inspired the original email FWIW.

> 
> > Also, I'd like to make sure we're on the same page about struct cxl_decoder.
> > Right now they are only created for active HDM decoders.
> 
> No, I was expecting they are also created for inactive ones. I am
> thinking that all decoders ultimately belong to the cxl_acpi driver,
> or whatever driver is acting as the root on a non-ACPI system. All
> decoder programming is driven by region activation stimulus that asks
> the root driver to try to establish a decode chain through the
> hieararchy per a given region.
> 
> > Going forward, we can
> > either maintain a count of unused decoders on the given CXL component, or we can
> > instantiate a struct cxl_decoder that isn't active, ie. no interleave ways
> > granularit, base, etc. What's your thinking there?
> 
> All resources are enumerated, just like PCI. Decode setup belongs to
> the core, just like PCI MMIO resource setup. The difference is that
> port drivers are needed to map component registers and service
> requests from cxl_acpi to reconfigure, but other than that
> cxl_decoders themselves don't have drivers and just reflect the
> current state of what cxl_acpi / cxl_core have established.

Okay.
