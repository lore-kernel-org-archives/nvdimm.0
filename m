Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3956A28E7
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 10:03:59 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NRFr96sD3z686fV;
	Tue,  6 Dec 2022 17:44:41 +0800 (CST)
Received: from localhost (10.45.155.47) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 09:47:34 +0000
Date: Tue, 6 Dec 2022 09:47:33 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, <linux-cxl@vger.kernel.org>,
	<dave.jiang@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>, <catalin.marinas@arm.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, <anthony.jebson@huawei.com>, <ardb@kernel.org>
Subject: Re: [PATCH 5/5] cxl/region: Manage CPU caches relative to DPA
 invalidation events
Message-ID: <20221206094733.00007ed2@Huawei.com>
In-Reply-To: <638e502e1904a_3cbe0294e2@dwillia2-xfh.jf.intel.com.notmuch>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
	<166993222098.1995348.16604163596374520890.stgit@dwillia2-xfh.jf.intel.com>
	<20221205192054.mwhzyjrfwfn3tma5@offworld>
	<638e502e1904a_3cbe0294e2@dwillia2-xfh.jf.intel.com.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.45.155.47]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Mon, 5 Dec 2022 12:10:22 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> [ add linux-arm-kernel@lists.infradead.org ]
> 
> Background for ARM folks, CXL can dynamically reconfigure the target
> devices that back a given physical memory region. When that happens the
> CPU cache can be holding cache data from a previous configuration. The
> mitigation for that scenario on x86 is wbinvd, ARM does not have an
> equivalent. The result, dynamic region creation is disabled on ARM. In
> the near term, most CXL is configured pre-boot, but going forward this
> restriction is untenable.
> 
> Davidlohr Bueso wrote:
> > On Thu, 01 Dec 2022, Dan Williams wrote:
> >   
> > >A "DPA invalidation event" is any scenario where the contents of a DPA
> > >(Device Physical Address) is modified in a way that is incoherent with
> > >CPU caches, or if the HPA (Host Physical Address) to DPA association
> > >changes due to a remapping event.
> > >
> > >PMEM security events like Unlock and Passphrase Secure Erase already
> > >manage caches through LIBNVDIMM,  
> > 
> > Just to be clear, is this is why you get rid of the explicit flushing
> > for the respective commands in security.c?  
> 
> Correct, because those commands can only be executed through libnvdimm.
> 
> >   
> > >so that leaves HPA to DPA remap events
> > >that need cache management by the CXL core. Those only happen when the
> > >boot time CXL configuration has changed. That event occurs when
> > >userspace attaches an endpoint decoder to a region configuration, and
> > >that region is subsequently activated.
> > >
> > >The implications of not invalidating caches between remap events is that
> > >reads from the region at different points in time may return different
> > >results due to stale cached data from the previous HPA to DPA mapping.
> > >Without a guarantee that the region contents after cxl_region_probe()
> > >are written before being read (a layering-violation assumption that
> > >cxl_region_probe() can not make) the CXL subsystem needs to ensure that
> > >reads that precede writes see consistent results.  
> > 
> > Hmm where does this leave us remaping under arm64 which is doesn't have
> > ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION?
> > 
> > Back when we were discussing this it was all related to the security stuff,
> > which under arm it could just be easily discarded as not available feature.  
> 
> I can throw out a few strawman options, but really need help from ARM
> folks to decide where to go next.

+Cc bunch of relevant people. There are discussions underway but I'm not sure
anyone will want to give more details here yet.

> 
> 1/ Map and loop cache flushing line by line. It works, but for Terabytes
>    of CXL the cost is 10s of seconds of latency to reconfigure a region.
>    That said, region configuration, outside of test scenarios, is typically
>    a "once per bare metal provisioning" event.
> 
> 2/ Set a configuration dependency that mandates that all CXL memory be
>    routed through the page allocator where it is guaranteed that the memory
>    will be written (zeroed) before use. This restricts some planned use
>    cases for the "Dynamic Capacity Device" capability.

This is the only case that's really a problem (to my mind) I hope we will have
a more general solution before there is much hardware out there, particularly
where sharing is involved. 

> 
> 3/ Work with the CXL consortium to extend the back-invalidate concept
>    for general purpose usage to make devices capable of invalidating caches
>    for a new memory region they joined, and mandate it for ARM. This one
>    has a long lead time and a gap for every device in flight currently.

There are significant disadvantages in doing this that I suspect will mean
this never happens for some classes of device, or is turned off for performance
reasons. For anyone curious, go look at the protocol requirements of back
invalidate in the CXL 3.0 spec.

Jonathan
