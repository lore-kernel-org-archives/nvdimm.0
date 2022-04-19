Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982C61399
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 21:59:57 +0000 (UTC)
Received: by mail-pg1-f174.google.com with SMTP id h5so25313176pgc.7
        for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 14:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sR98hz91urG8rGVBWs/VxoZhhRVYAMX6GA9PTcrPHIc=;
        b=fhGNuCDQRD87uej4cP+psfRnYjhkYdmQ6qXXGlMNhV0E4ZnKgllJ0ZA2dHjM4vKWkf
         IRjpW5fBOtGxvqmLlAZ7gM+UyG0lalReD0lR2hcV1DL34N72dsh7AyXGlZnLC5PmZTew
         toQVInH9/SFwnBnQwQ37XN0XU+U9vcLwMfjvCrdBm8eFayZrpDPzQ5b2AEold0gtHCyQ
         ISaqKZoQjdBkbJrfRBVz1IjaGylBnCmvUlN98GsHY2CcRHiCzZuEf0xDvgY7CW1a1ZWB
         1/5kQyz+xSJAEmLafOZM8rtDXwePBOPPa8VP/MeGOwlFghTw5BbCo19vQ5uGIjQhxs3U
         zVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sR98hz91urG8rGVBWs/VxoZhhRVYAMX6GA9PTcrPHIc=;
        b=wIrjpKR9OG2P5t37hGe8ydjl9nSurq2PqINd2n5cBoTExZ57Nf6a2z8w/1VCKMd5dR
         /qLZTlasmCjB4aoZBEyMVwR5d4pclCYBkRm5GBsddM0SDJfOzBi7uLyUn8HcWGtage6G
         9VxsXkmcY+5i1OPrgQP6WrlY/9tzW0PhOk5oeLbYRD1uOw00UogICd6tDghnHsUyRUYE
         KSYenor9udFRReQZCohBW//9Y8K4gFZiZTndnDPKstqsSuY9Lda+/8f8L7gmJZGxk+wQ
         +6HGQAoS4l2Y/Ahq+RueBtThpLGgqfIpOHGi5SHSNOiJxcC8oiXpj7CC5WiMiL6YBsSz
         cKvA==
X-Gm-Message-State: AOAM531r2L20CSYfyQ+TrIfhtq96wW4myospJmbpYO1ZrNpi/5lcfi3W
	InFYCBxA6eq2QZ95OgP55ZLWjx3T4bAqe+UmnDoXbA==
X-Google-Smtp-Source: ABdhPJxJ9kPLnx6f0kvLp/SgCsMT2Zwz+eHxWEK3ifo5Xw8xRXwZmWRtD1KM34+Umk2FwPqZ4R8bEX/AylKiiUjuHsk=
X-Received: by 2002:a65:6e0e:0:b0:399:26d7:a224 with SMTP id
 bd14-20020a656e0e000000b0039926d7a224mr16380475pgb.437.1650405596986; Tue, 19
 Apr 2022 14:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com> <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com> <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
In-Reply-To: <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 14:59:46 -0700
Message-ID: <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 2:50 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Apr 19, 2022 at 9:43 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Mon, Apr 18, 2022 at 09:42:00AM -0700, Dan Williams wrote:
> > > [ add the usual HMM suspects Christoph, Jason, and John ]
> > >
> > > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > > >
> > > > Define an API which allows CXL drivers to manage CXL address space.
> > > > CXL is unique in that the address space and various properties are only
> > > > known after CXL drivers come up, and therefore cannot be part of core
> > > > memory enumeration.
> > >
> > > I think this buries the lead on the problem introduced by
> > > MEMORY_DEVICE_PRIVATE in the first place. Let's revisit that history
> > > before diving into what CXL needs.
> > >
> > >
> > > Commit 4ef589dc9b10 ("mm/hmm/devmem: device memory hotplug using
> > > ZONE_DEVICE") introduced the concept of MEMORY_DEVICE_PRIVATE. At its
> > > core MEMORY_DEVICE_PRIVATE uses the ZONE_DEVICE capability to annotate
> > > an "unused" physical address range with 'struct page' for the purpose
> > > of coordinating migration of buffers onto and off of a GPU /
> > > accelerator. The determination of "unused" was based on a heuristic,
> > > not a guarantee, that any address range not expressly conveyed in the
> > > platform firmware map of the system can be repurposed for software
> > > use. The CXL Fixed Memory Windows Structure  (CFMWS) definition
> > > explicitly breaks the assumptions of that heuristic.
> >
> > So CXL defines an address map that is not part of the FW list?
>
> It defines a super-set of 'potential' address space and a subset that
> is active in the FW list. It's similar to memory hotplug where an
> address range may come online after the fact, but unlike ACPI memory
> hotplug, FW is not involved in the hotplug path, and FW cannot predict
> what address ranges will come online. For example ACPI hotplug knows
> in advance to publish the ranges that can experience an online /
> insert event, CXL has many more degrees of freedom.
>
> >
> > > > It would be desirable to simply insert this address space into
> > > > iomem_resource with a new flag to denote this is CXL memory. This would
> > > > permit request_free_mem_region() to be reused for CXL memory provided it
> > > > learned some new tricks. For that, it is tempting to simply use
> > > > insert_resource(). The API was designed specifically for cases where new
> > > > devices may offer new address space. This cannot work in the general
> > > > case. Boot firmware can pass, some, none, or all of the CFMWS range as
> > > > various types of memory to the kernel, and this may be left alone,
> > > > merged, or even expanded.
> >
> > And then we understand that on CXL the FW is might pass stuff that
> > intersects with the actual CXL ranges?
> >
> > > > As a result iomem_resource may intersect CFMWS
> > > > regions in ways insert_resource cannot handle [2]. Similar reasoning
> > > > applies to allocate_resource().
> > > >
> > > > With the insert_resource option out, the only reasonable approach left
> > > > is to let the CXL driver manage the address space independently of
> > > > iomem_resource and attempt to prevent users of device private memory
> >
> > And finally due to all these FW problems we are going to make a 2nd
> > allocator for physical address space and just disable the normal one?
>
> No, or I am misunderstanding this comment. The CXL address space
> allocator is managing space that can be populated and become an
> iomem_resource. So it's not supplanting iomem_resource it is
> coordinating dynamic extensions to the FW map.
>
> > Then since DEVICE_PRIVATE is a notable user of this allocator we now
> > understand it becomes broken?
> >
> > Sounds horrible. IMHO you should fix the normal allocator somehow to
> > understand that the ranges from FW have been reprogrammed by Linux
>
> There is no reprogramming of the ranges from FW. CXL memory that is
> mapped as System RAM at boot will have the CXL decode configuration
> locked in all the participating devices. The remaining CXL decode
> space is then available for dynamic reconfiguration of CXL resources
> from the devices that the FW explicitly ignores, which is all
> hot-added devices and all persistent-memory capacity.
>
> > and
> > not try to build a whole different allocator in CXL code.
>
> I am not seeing much overlap for DEVICE_PRIVATE and CXL to share an
> allocator. CXL explicitly wants ranges that have been set aside for
> CXL and are related to 1 or more CXL host bridges. DEVICE_PRIVATE
> wants to consume an unused physical address range to proxy
> device-local-memory with no requirements on what range is chosen as
> long as it does not collide with anything else.

...or are you suggesting to represent CXL free memory capacity in
iomem_resource and augment the FW list early with CXL ranges. That
seems doable, but it would only represent the free CXL ranges in
iomem_resource as the populated CXL ranges cannot have their resources
reparented after the fact, and there is plenty of code that expects
"System RAM" to be a top-level resource.
