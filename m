Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71562F80
	for <nvdimm@lists.linux.dev>; Fri, 11 Jun 2021 13:00:01 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G1gkK36kDz6K5mg;
	Fri, 11 Jun 2021 20:53:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 14:59:59 +0200
Received: from localhost (10.52.120.251) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 13:59:58 +0100
Date: Fri, 11 Jun 2021 13:59:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] cxl/pmem: Add core infrastructure for PMEM support
Message-ID: <20210611135955.00004d58@Huawei.com>
In-Reply-To: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.120.251]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 10 Jun 2021 15:25:57 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> CXL Memory Expander devices (CXL 2.0 Type-3) support persistent memory
> in addition to volatile memory expansion. The most significant changes
> this requires of the existing LIBNVDIMM infrastructure, compared to what
> was needed to support ACPI NFIT defined PMEM, is the ability to
> dynamically provision regions in addition to namespaces, and a formal
> model for hotplug.
> 
> Before region provisioning can be added the CXL enabling needs to
> enumerate "nvdimm" devices on a CXL nvdimm-bus. This is modeled as a
> CXL-nvdimm-bridge device (bridging CXL to nvdimm) and an associated
> driver to activate and deactivate that bus-bridge. Once the bridge is
> registered it scans for CXL nvdimm devices registered by endpoints.  The
> CXL core bus is used as a rendezvous for nvdimm bridges and endpoints
> allowing them to be registered and enabled in any order.
> 
> At the end of this series the ndctl utility can see CXL nvdimm resources
> just like any other nvdimm bus.
> 
>     # ndctl list -BDiu -b CXL
>     {
>       "provider":"CXL",
>       "dev":"ndbus1",
>       "dimms":[
>         { 
>           "dev":"nmem1",
>           "state":"disabled"
>         },
>         { 
>           "dev":"nmem0",
>           "state":"disabled"
>         }
>       ]
>     }
> 
> Follow-on patches extend the nvdimm core label support for CXL region
> and namespace labels. For now just add the machinery to register the
> bus and nvdimm base objects.

Hi Dan,

Nice set. I won't claim to know all that much about the nvdimm
side of things. With that in mind and the fact all my comments
were trivial stuff you can clean up without me reading it again.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

for whole set.

Thanks,

Jonathan

> 
> ---
> 
> Dan Williams (5):
>       cxl/core: Add cxl-bus driver infrastructure
>       cxl/pmem: Add initial infrastructure for pmem support
>       libnvdimm: Export nvdimm shutdown helper, nvdimm_delete()
>       libnvdimm: Drop unused device power management support
>       cxl/pmem: Register 'pmem' / cxl_nvdimm  devices
> 
> 
>  drivers/cxl/Kconfig        |   13 ++
>  drivers/cxl/Makefile       |    2 
>  drivers/cxl/acpi.c         |   37 +++++-
>  drivers/cxl/core.c         |  281 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h          |   57 +++++++++
>  drivers/cxl/mem.h          |    2 
>  drivers/cxl/pci.c          |   23 +++-
>  drivers/cxl/pmem.c         |  230 ++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/bus.c       |   64 ++++++----
>  drivers/nvdimm/dimm_devs.c |   18 +++
>  include/linux/libnvdimm.h  |    1 
>  11 files changed, 697 insertions(+), 31 deletions(-)
>  create mode 100644 drivers/cxl/pmem.c
> 
> base-commit: 40ba17afdfabb01688c61565dbe02a916241bc05

