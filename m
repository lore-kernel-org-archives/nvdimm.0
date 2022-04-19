Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72AA139D
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 21:50:41 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id bg24so64398pjb.1
        for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 14:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKEJvw7944mFTbNzuYAbD/7MWUBi7GLVpd8eZyVh4m8=;
        b=3iL0JOIOlfEfimu5P3N6jeF6u+AApac8og2dCZLjlRRFkC7UWH+AATRMVfrdqpOgFc
         Ul0WoVdzIK0rRGXQd9tyPxUdquYM4pPhCUxNcxhipNDe3kzYAETLWri5+HSnvCB7m1NH
         WGgby5O3We792CD17TyiBIM0A+O7FVEaHHBe0H1jM1wSL6GUuSRIHWNMwPI29Ykhh+R+
         YugGWNTBRTdmlIDKoKlWRveLxx14qfXWikS0BqoRNpQbpolPc2MCKH58l24JuWYOyv4v
         HL4LA8W4GxQ7ukL7WrHVXZcXWPsssKV3a+uhPHUFkviJgBRS6OTyNu5W67Z0iXn4+ssy
         3mtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKEJvw7944mFTbNzuYAbD/7MWUBi7GLVpd8eZyVh4m8=;
        b=rgtitr6RffEHN+ApAx1hLqbeE0bIRJU8FKPN66s/NSQh6ONpf8Z3oJLUwkAgVdGujJ
         b5NXYqeFbgi8K8HpWoEPcFAtem89NfbrrzEDtSxOzTJrtnj9IaRnezyc4O5+WbpuBX+K
         7QzrWl89kbXj7by0PGjc0m7jEwyDALU4Yh595d1YiANDE1vNdziuOrJs3DopLchmvQWC
         sS3jCODCrvFQUqJCku8q36JNYllm6gSmB6IuENshm0zYypTaYmOnKxPdgYE0Hy+cysQV
         pVukdwayTGrXRIUrP5sQxdFRpN5if8w3IC9V568QMtdSktqPNsU0UwT4kH3BvrHqpNUs
         8DAg==
X-Gm-Message-State: AOAM531XooRizQbOSfuT+n9vP7q96eQk/J2siJ4+Ft6EZ5vVb26jKzeu
	uRvCcBT4LqqsmvaiRwqiLGig8Rf/ocIe9/nwEFd43g==
X-Google-Smtp-Source: ABdhPJxvHKBJE9SsZQW3Cms+qCTAn4kphoiNVKjrAD32crS0cvDosC4MUNyMYT8E3+e35amXJAdgzb6SDQRuOzSkgow=
X-Received: by 2002:a17:90b:4b01:b0:1d2:abf5:c83f with SMTP id
 lx1-20020a17090b4b0100b001d2abf5c83fmr685519pjb.93.1650405041388; Tue, 19 Apr
 2022 14:50:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com> <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com>
In-Reply-To: <20220419164313.GT2120790@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 14:50:30 -0700
Message-ID: <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 9:43 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Mon, Apr 18, 2022 at 09:42:00AM -0700, Dan Williams wrote:
> > [ add the usual HMM suspects Christoph, Jason, and John ]
> >
> > On Wed, Apr 13, 2022 at 11:38 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
> > >
> > > Define an API which allows CXL drivers to manage CXL address space.
> > > CXL is unique in that the address space and various properties are only
> > > known after CXL drivers come up, and therefore cannot be part of core
> > > memory enumeration.
> >
> > I think this buries the lead on the problem introduced by
> > MEMORY_DEVICE_PRIVATE in the first place. Let's revisit that history
> > before diving into what CXL needs.
> >
> >
> > Commit 4ef589dc9b10 ("mm/hmm/devmem: device memory hotplug using
> > ZONE_DEVICE") introduced the concept of MEMORY_DEVICE_PRIVATE. At its
> > core MEMORY_DEVICE_PRIVATE uses the ZONE_DEVICE capability to annotate
> > an "unused" physical address range with 'struct page' for the purpose
> > of coordinating migration of buffers onto and off of a GPU /
> > accelerator. The determination of "unused" was based on a heuristic,
> > not a guarantee, that any address range not expressly conveyed in the
> > platform firmware map of the system can be repurposed for software
> > use. The CXL Fixed Memory Windows Structure  (CFMWS) definition
> > explicitly breaks the assumptions of that heuristic.
>
> So CXL defines an address map that is not part of the FW list?

It defines a super-set of 'potential' address space and a subset that
is active in the FW list. It's similar to memory hotplug where an
address range may come online after the fact, but unlike ACPI memory
hotplug, FW is not involved in the hotplug path, and FW cannot predict
what address ranges will come online. For example ACPI hotplug knows
in advance to publish the ranges that can experience an online /
insert event, CXL has many more degrees of freedom.

>
> > > It would be desirable to simply insert this address space into
> > > iomem_resource with a new flag to denote this is CXL memory. This would
> > > permit request_free_mem_region() to be reused for CXL memory provided it
> > > learned some new tricks. For that, it is tempting to simply use
> > > insert_resource(). The API was designed specifically for cases where new
> > > devices may offer new address space. This cannot work in the general
> > > case. Boot firmware can pass, some, none, or all of the CFMWS range as
> > > various types of memory to the kernel, and this may be left alone,
> > > merged, or even expanded.
>
> And then we understand that on CXL the FW is might pass stuff that
> intersects with the actual CXL ranges?
>
> > > As a result iomem_resource may intersect CFMWS
> > > regions in ways insert_resource cannot handle [2]. Similar reasoning
> > > applies to allocate_resource().
> > >
> > > With the insert_resource option out, the only reasonable approach left
> > > is to let the CXL driver manage the address space independently of
> > > iomem_resource and attempt to prevent users of device private memory
>
> And finally due to all these FW problems we are going to make a 2nd
> allocator for physical address space and just disable the normal one?

No, or I am misunderstanding this comment. The CXL address space
allocator is managing space that can be populated and become an
iomem_resource. So it's not supplanting iomem_resource it is
coordinating dynamic extensions to the FW map.

> Then since DEVICE_PRIVATE is a notable user of this allocator we now
> understand it becomes broken?
>
> Sounds horrible. IMHO you should fix the normal allocator somehow to
> understand that the ranges from FW have been reprogrammed by Linux

There is no reprogramming of the ranges from FW. CXL memory that is
mapped as System RAM at boot will have the CXL decode configuration
locked in all the participating devices. The remaining CXL decode
space is then available for dynamic reconfiguration of CXL resources
from the devices that the FW explicitly ignores, which is all
hot-added devices and all persistent-memory capacity.

> and
> not try to build a whole different allocator in CXL code.

I am not seeing much overlap for DEVICE_PRIVATE and CXL to share an
allocator. CXL explicitly wants ranges that have been set aside for
CXL and are related to 1 or more CXL host bridges. DEVICE_PRIVATE
wants to consume an unused physical address range to proxy
device-local-memory with no requirements on what range is chosen as
long as it does not collide with anything else.
