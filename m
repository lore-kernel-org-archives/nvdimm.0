Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAC72
	for <nvdimm@lists.linux.dev>; Thu,  2 Sep 2021 17:56:10 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H0pTV6lbKz67kfy;
	Fri,  3 Sep 2021 01:54:22 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 2 Sep 2021 19:56:06 +0200
Received: from localhost (10.52.127.69) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 18:56:05 +0100
Date: Thu, 2 Sep 2021 18:56:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	"kernel test robot" <lkp@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3 17/28] cxl/mbox: Move mailbox and other non-PCI
 specific infrastructure to the core
Message-ID: <20210902185606.0000731b@Huawei.com>
In-Reply-To: <162982121720.1124374.4630115550776741892.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162982121720.1124374.4630115550776741892.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.127.69]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 24 Aug 2021 09:06:57 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Now that the internals of mailbox operations are abstracted from the PCI
> specifics a bulk of infrastructure can move to the core.
> 
> The CXL_PMEM driver intends to proxy LIBNVDIMM UAPI and driver requests
> to the equivalent functionality provided by the CXL hardware mailbox
> interface. In support of that intent move the mailbox implementation to
> a shared location for the CXL_PCI driver native IOCTL path and CXL_PMEM
> nvdimm command proxy path to share.
> 
> A unit test framework seeks to implement a unit test backend transport
> for mailbox commands to communicate mocked up payloads. It can reuse all
> of the mailbox infrastructure minus the PCI specifics, so that also gets
> moved to the core.
> 
> Finally with the mailbox infrastructure and ioctl handling being
> transport generic there is no longer any need to pass file
> file_operations to devm_cxl_add_memdev(). That allows all the ioctl
> boilerplate to move into the core for unit test reuse.
> 
> No functional change intended, just code movement.

This didn't give me the warm fuzzy feeling of a straight forward move patch.
A few oddities below, but more generally can you break this up a bit.
That "Finally" for examples feels like it could be done as a precursor to this.

This also has the updated docs thing I commented on in an earlier patch
that needs moving back to that patch.

Jonathan


> 
> Acked-by: Ben Widawsky <ben.widawsky@intel.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/driver-api/cxl/memory-devices.rst |    3 
>  drivers/cxl/core/Makefile                       |    1 
>  drivers/cxl/core/bus.c                          |    4 
>  drivers/cxl/core/core.h                         |    8 
>  drivers/cxl/core/mbox.c                         |  834 ++++++++++++++++++++
>  drivers/cxl/core/memdev.c                       |   81 ++
>  drivers/cxl/cxlmem.h                            |   81 ++
>  drivers/cxl/pci.c                               |  941 -----------------------
>  8 files changed, 987 insertions(+), 966 deletions(-)
>  create mode 100644 drivers/cxl/core/mbox.c



>  
>  #endif /* __CXL_CORE_H__ */
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> new file mode 100644
> index 000000000000..706fe007c8d6
> --- /dev/null
> +++ b/drivers/cxl/core/mbox.c
> @@ -0,0 +1,834 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2020 Intel Corporation. All rights reserved. */
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +#include <linux/security.h>
> +#include <linux/debugfs.h>
> +#include <linux/mutex.h>
> +#include <linux/pci.h>

Given stated aim is to have this pci free, I doubt this header is required!

> +#include <cxlmem.h>
> +#include <cxl.h>
> +
> +#include "core.h"
> +
> +static bool cxl_raw_allow_all;
> +
> +/**
> + * DOC: cxl mbox
> + *
> + * Core implementation of the CXL 2.0 Type-3 Memory Device Mailbox. The
> + * implementation is used by the cxl_pci driver to initialize the device
> + * and implement the cxl_mem.h IOCTL UAPI. It also implements the
> + * backend of the cxl_pmem_ctl() transport for LIBNVDIMM.
> + *

Trivial: No need for the last blank line.

> + */
> +
> +#define cxl_for_each_cmd(cmd)                                                  \
> +	for ((cmd) = &cxl_mem_commands[0];                                     \
> +	     ((cmd)-cxl_mem_commands) < ARRAY_SIZE(cxl_mem_commands); (cmd)++)

Spaces around the - 

> +
> +#define cxl_doorbell_busy(cxlm)                                                \
> +	(readl((cxlm)->regs.mbox + CXLDEV_MBOX_CTRL_OFFSET) &                  \
> +	 CXLDEV_MBOX_CTRL_DOORBELL)

I think we now have two copies of this which isn't ideal.
Something gone wrong with moving this?

> +
> +/* CXL 2.0 - 8.2.8.4 */
> +#define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)

Also this which still seems to be in pci.c

...

> +/**
> + * cxl_mem_get_partition_info - Get partition info
> + * @cxlm: The device to act on
> + * @active_volatile_bytes: returned active volatile capacity; in bytes
> + * @active_persistent_bytes: returned active persistent capacity; in bytes
> + * @next_volatile_bytes: return next volatile capacity; in bytes
> + * @next_persistent_bytes: return next persistent capacity; in bytes
> + *
> + * Retrieve the current partition info for the device specified.  The active
> + * values are the current capacity in bytes.  If not 0, the 'next' values are

No problem with the updated comment, but shouldn't be in this patch without
at least being called out.

> + * the pending values, in bytes, which take affect on next cold reset.
> + *
> + * Return: 0 if no error: or the result of the mailbox command.
> + *
> + * See CXL @8.2.9.5.2.1 Get Partition Info
> + */
> +static int cxl_mem_get_partition_info(struct cxl_mem *cxlm)
> +{
> +	struct cxl_mbox_get_partition_info {
> +		__le64 active_volatile_cap;
> +		__le64 active_persistent_cap;
> +		__le64 next_volatile_cap;
> +		__le64 next_persistent_cap;
> +	} __packed pi;
> +	int rc;
> +
> +	rc = cxl_mem_mbox_send_cmd(cxlm, CXL_MBOX_OP_GET_PARTITION_INFO,
> +				   NULL, 0, &pi, sizeof(pi));
> +
> +	if (rc)
> +		return rc;
> +
> +	cxlm->active_volatile_bytes =
> +		le64_to_cpu(pi.active_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->active_persistent_bytes =
> +		le64_to_cpu(pi.active_persistent_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->next_volatile_bytes =
> +		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;
> +	cxlm->next_persistent_bytes =
> +		le64_to_cpu(pi.next_volatile_cap) * CXL_CAPACITY_MULTIPLIER;

I'd have kept this bit of cleanup separate. For a code move patch I don't want
to have to spot the places where things weren't just a move. Same in other places.

Not a bit thing though so if you don't want to pull these out separately then
I don't mind that much.

> +
> +	return 0;
> +}

> +
> +struct cxl_mem *cxl_mem_create(struct device *dev)

The parameter change from struct pci_dev * is a bit more than I'd
expect in a code move patch. I would have done that in a precursor if possible.

> +{
> +	struct cxl_mem *cxlm;
> +
> +	cxlm = devm_kzalloc(dev, sizeof(*cxlm), GFP_KERNEL);
> +	if (!cxlm)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_init(&cxlm->mbox_mutex);
> +	cxlm->dev = dev;
> +	cxlm->enabled_cmds =
> +		devm_kmalloc_array(dev, BITS_TO_LONGS(cxl_cmd_count),
> +				   sizeof(unsigned long),
> +				   GFP_KERNEL | __GFP_ZERO);
> +	if (!cxlm->enabled_cmds)
> +		return ERR_PTR(-ENOMEM);
> +
> +	return cxlm;
> +}
> +EXPORT_SYMBOL_GPL(cxl_mem_create);
> +

...


> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index a56d8f26a157..b7122ded3a04 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2020-2021 Intel Corporation. */
>  #ifndef __CXL_MEM_H__
>  #define __CXL_MEM_H__
> +#include <uapi/linux/cxl_mem.h>
>  #include <linux/cdev.h>
>  #include "cxl.h"
>  
> @@ -28,21 +29,6 @@
>  	(FIELD_GET(CXLMDEV_RESET_NEEDED_MASK, status) !=                       \
>  	 CXLMDEV_RESET_NEEDED_NOT)
>  

...

>  /**
> - * struct mbox_cmd - A command to be submitted to hardware.
> + * struct cxl_mbox_cmd - A command to be submitted to hardware.

Ah. Here it is ;)  Move to earlier patch.

>   * @opcode: (input) The command set and command submitted to hardware.
>   * @payload_in: (input) Pointer to the input payload.
>   * @payload_out: (output) Pointer to the output payload. Must be allocated by
> @@ -147,4 +132,62 @@ struct cxl_mem {
>  
>  	int (*mbox_send)(struct cxl_mem *cxlm, struct cxl_mbox_cmd *cmd);
>  };
>  #endif /* __CXL_MEM_H__ */
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index a211b35af4be..b8075b941a3a 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -1,17 +1,12 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
> -#include <uapi/linux/cxl_mem.h>
> -#include <linux/security.h>
> -#include <linux/debugfs.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/module.h>
>  #include <linux/sizes.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
> -#include <linux/cdev.h>
> -#include <linux/idr.h>

Why was this here in the first place?
If it's unrelated, then separate patch ideally.


>  #include <linux/pci.h>
>  #include <linux/io.h>
> -#include <linux/io-64-nonatomic-lo-hi.h>
>  #include "cxlmem.h"
>  #include "pci.h"
>  #include "cxl.h"
> @@ -38,162 +33,6 @@

...
