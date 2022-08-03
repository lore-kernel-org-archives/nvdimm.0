Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACD120E4
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 17:03:59 +0000 (UTC)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LydPv0Pd6z67PvV;
	Thu,  4 Aug 2022 00:59:47 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 3 Aug 2022 19:03:57 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 18:03:56 +0100
Date: Wed, 3 Aug 2022 18:03:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<dan.j.williams@intel.com>, <bwidawsk@kernel.org>, <ira.weiny@intel.com>,
	<vishal.l.verma@intel.com>, <alison.schofield@intel.com>, <dave@stgolabs.net>
Subject: Re: [PATCH RFC 00/15] Introduce security commands for CXL pmem
 device
Message-ID: <20220803180355.00006042@huawei.com>
In-Reply-To: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 15 Jul 2022 14:08:32 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> This series is seeking comments on the implementation. It has not been fully
> tested yet.
> 
> This series adds the support for "Persistent Memory Data-at-rest Security"
> block of command set for the CXL Memory Devices. The enabling is done through
> the nvdimm_security_ops as the operations are very similar to the same
> operations that the persistent memory devices through NFIT provider support.
> This enabling does not include the security pass-through commands nor the
> Santize commands.
> 
> Under the nvdimm_security_ops, this patch series will enable get_flags(),
> freeze(), change_key(), unlock(), disable(), and erase(). The disable() API
> does not support disabling of the master passphrase. To maintain established
> user ABI through the sysfs attribute "security", the "disable" command is
> left untouched and a new "disable_master" command is introduced with a new
> disable_master() API call for the nvdimm_security_ops().
> 
> This series does not include plumbing to directly handle the security commands
> through cxl control util. The enabled security commands will still go through
> ndctl tool with this enabling.
> 
> For calls such as unlock() and erase(), the CPU caches must be invalidated
> post operation. Currently, the implementation resides in
> drivers/acpi/nfit/intel.c with a comment that it should be implemented
> cross arch when more than just NFIT based device needs this operation.
> With the coming of CXL persistent memory devices this is now needed.
> Introduce ARCH_HAS_NVDIMM_INVAL_CACHE and implement similar to
> ARCH_HAS_PMEM_API where the arch can opt in with implementation.
> Currently only add x86_64 implementation where wbinvd_on_all_cpus()
> is called.
> 
Hi Dave,

Just curious.  What was reasoning behind this being a RFC?
What do you particular want comments on?

Thanks,

Jonathan

> ---
> 
> Dave Jiang (15):
>       cxl/pmem: Introduce nvdimm_security_ops with ->get_flags() operation
>       tools/testing/cxl: Create context for cxl mock device
>       tools/testing/cxl: Add "Get Security State" opcode support
>       cxl/pmem: Add "Set Passphrase" security command support
>       tools/testing/cxl: Add "Set Passphrase" opcode support
>       cxl/pmem: Add Disable Passphrase security command support
>       tools/testing/cxl: Add "Disable" security opcode support
>       cxl/pmem: Add "Freeze Security State" security command support
>       tools/testing/cxl: Add "Freeze Security State" security opcode support
>       x86: add an arch helper function to invalidate all cache for nvdimm
>       cxl/pmem: Add "Unlock" security command support
>       tools/testing/cxl: Add "Unlock" security opcode support
>       cxl/pmem: Add "Passphrase Secure Erase" security command support
>       tools/testing/cxl: Add "passphrase secure erase" opcode support
>       nvdimm/cxl/pmem: Add support for master passphrase disable security command
> 
> 
>  arch/x86/Kconfig             |   1 +
>  arch/x86/mm/pat/set_memory.c |   8 +
>  drivers/acpi/nfit/intel.c    |  28 +--
>  drivers/cxl/Kconfig          |  16 ++
>  drivers/cxl/Makefile         |   1 +
>  drivers/cxl/cxlmem.h         |  41 +++++
>  drivers/cxl/pmem.c           |  10 +-
>  drivers/cxl/security.c       | 182 ++++++++++++++++++
>  drivers/nvdimm/security.c    |  33 +++-
>  include/linux/libnvdimm.h    |  10 +
>  lib/Kconfig                  |   3 +
>  tools/testing/cxl/Kbuild     |   1 +
>  tools/testing/cxl/test/mem.c | 348 ++++++++++++++++++++++++++++++++++-
>  13 files changed, 644 insertions(+), 38 deletions(-)
>  create mode 100644 drivers/cxl/security.c
> 
> --
> 

