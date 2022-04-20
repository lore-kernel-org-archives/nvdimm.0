Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A99185B
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 15:32:52 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id v12so2098512plv.4
        for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXE5rwL9G2A41ELB44LpkE3yJsmwyolaHB1ZPKjmFOQ=;
        b=0SXGd8Ae3eImiVBD6ABuD0fsXiFcFNvWy5KkdAeY/lHkDA49w+yQI4qNYa59bp6t+2
         283Pj4uoCOZDNM9TduFm0HdsIrwhdFs9enJ/s2rBqPUVx/cZ5WyaqYQd6VrLRNUp8Fj7
         2y2HF9Vn0OVAfc3pugwCMvw4w5sRTRCBGS5DdF8h6jBHBt17pBvouhWv63c/YzSqRban
         5+pG+xaDeA1nOixh/UJXeULk1dAOgfYfB5Zo7lan6SA5ifoiRoNjxVFu57fOcCVc1Tai
         XNGD1dYGFtFaCQcsJ/erjzWgGK0nynZfU5qeauO+TZuJ4oC4tZoYGjkN+TU4WsljBuIe
         96vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXE5rwL9G2A41ELB44LpkE3yJsmwyolaHB1ZPKjmFOQ=;
        b=UqBosB6Do4PeUXeHMQSvBipG4wGyvCd06BRKjMzYBhQ5mhvTVadqiP6KN1xkeXepze
         TpNAA5dgDQ4P2gRcKvpeOPaZvr5kksmONHxHbTlQh67xl63vqM+FNR3dx2NKyVTOpF74
         fQxtr2mByD6TF27UqpIiOZAF3nPtL6WMdtqJD+ezmfSPxH90dfhq/MtKtPJb4O3E0KtE
         u9zStBxAfXW8kpmqDUK1MdRn+b4Q8B0LsilY9JTvoWsWOPDCt0uAYlV5W8qgVW754n6W
         MOwC8y4e5+oNipgs9bYAU+hoqnZJ+8IY56x6UVif3zb+Nh0F6vKZ9ucaLol/MCp2w0f2
         fGmg==
X-Gm-Message-State: AOAM530whFkySMOtUj+n4WoO6PHqbx+28S0m0LRQb83ainw14hi6mNZM
	SaO8mS6BxQpyIlZ8jD5fuKfQB7j/ZrxF7V4U/sXIhw==
X-Google-Smtp-Source: ABdhPJzxSLprMHwiebGFjIYgLqgnPEmnfHzZ+E1b9NgLe/j/RYYtesZJu7ti/Pt0NzfrUUWdkHUYvByBKWPEmHNRe0o=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr21203839pll.132.1650468771886; Wed, 20
 Apr 2022 08:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
 <20220413183720.2444089-6-ben.widawsky@intel.com> <CAPcyv4iM13nzCpnF5S4oHSWF769t4Av96gQM_3n4E=RAPSnSig@mail.gmail.com>
 <20220419164313.GT2120790@nvidia.com> <CAPcyv4hPBw0yJmu7qzSZ_gsbVuj+_R7-_r3+_W9-JsLTD6Uscw@mail.gmail.com>
 <CAPcyv4hyTRm7K8gu4wdL_gaMm2C+Agg1V2-BbnmJ8Kf0OH4sng@mail.gmail.com>
 <20220419230412.GU2120790@nvidia.com> <CAPcyv4i5MZcMcCq8V7sZQjqup6MPOoOj2Zuu8HEECADfFi2Tcg@mail.gmail.com>
 <20220420143406.GY2120790@nvidia.com>
In-Reply-To: <20220420143406.GY2120790@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Apr 2022 08:32:41 -0700
Message-ID: <CAPcyv4ju7vF7vaTgneVyPRX0SNncvsqz-BHkD9c8MhpAFAiNPw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] cxl/acpi: Reserve CXL resources from request_free_mem_region
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Christoph Hellwig <hch@infradead.org>, John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 20, 2022 at 7:35 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Apr 19, 2022 at 05:47:56PM -0700, Dan Williams wrote:
> > On Tue, Apr 19, 2022 at 4:04 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > On Tue, Apr 19, 2022 at 02:59:46PM -0700, Dan Williams wrote:
> > >
> > > > ...or are you suggesting to represent CXL free memory capacity in
> > > > iomem_resource and augment the FW list early with CXL ranges. That
> > > > seems doable, but it would only represent the free CXL ranges in
> > > > iomem_resource as the populated CXL ranges cannot have their resources
> > > > reparented after the fact, and there is plenty of code that expects
> > > > "System RAM" to be a top-level resource.
> > >
> > > Yes, something more like this. iomem_resource should represent stuff
> > > actually in use and CXL shouldn't leave behind an 'IOW' for address
> > > space it isn't actually able to currently use.
> >
> > So that's the problem, these gigantic windows need to support someone
> > showing up unannounced with a stack of multi-terabyte devices to add
> > to the system.
>
> In my experience PCIe hotplug is already extremely rare, you may need
> to do this reservation on systems with hotplug slots, but not
> generally. In PCIe world the BIOS often figures this out and bridge
> windows are not significantly over allocated on non-hotplug HW.
>
> (though even PCIe has the resizable bar extension and other things
> that are quite like hotplug and do trigger huge resource requirements)
>
> > > Your whole description sounds like the same problems PCI hotplug has
> > > adjusting the bridge windows.
> >
> > ...but even there the base bounds (AFAICS) are coming from FW (_CRS
> > entries for ACPI described PCIe host bridges). So if CXL follows that
> > model then the entire unmapped portion of the CXL ranges should be
> > marked as an idle resource in iomem_resource.
>
> And possibly yes, because part of the point of this stuff is to
> declare where HW is actually using the address space. So if FW has
> left a host bridge decoder setup to actually consume this space then
> it really has to be set aside to prevent hotplug of other bus types
> from trying to claim the same address space for their own usages.
>
> If no actual decoder is setup then it maybe it shouldn't be left as an
> IOW in the resource tree. In this case it might be better to teach the
> io resource allocator to leave gaps for future hotplug.

Yeah, it is the former. These CXL ranges are all actively decoded by
the CPU complex memory controller as "this range goes to DDR and this
other range is interleaved across this set of CXL host bridges". Even
if there is nothing behind those host bridges there is hardware
actively routing requests that fall into those ranges to those
downstream devices.

> > The improvement that offers over this current proposal is that it
> > allows for global visibility of CXL hotplug resources, but it does set
> > up a discontinuity between FW mapped and OS mapped CXL. FW mapped will
> > have top-level "System RAM" resources indistinguishable from typical
> > DRAM while OS mapped CXL will look like this:
>
> Maybe this can be reotractively fixed up in the resource tree?

I had been discouraged to go that route considering some code only
scans top-level iomem_resource entries, but it is probably better to
try to fix that legacy code to operate correctly when System RAM is
parented by a CXL Range.
