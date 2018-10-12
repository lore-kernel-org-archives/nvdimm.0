Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36B972116DFA2
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:37:08 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e17-v6so11017900oig.12
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20181010060812.20068-1-oohall@gmail.com>
 <20181010060812.20068-3-oohall@gmail.com>
In-Reply-To: <20181010060812.20068-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 15:36:55 -0700
Message-ID: <CAPcyv4jhs9f2DdOk30KU9___mWMtowQi0LP-OD1E+_5xFbxWgA@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/pseries: Add driver for PAPR SCM regions
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Oliver O'Halloran <oohall@gmail.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 9, 2018 at 11:21 PM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> Adds a driver that implements support for enabling and accessing PAPR
> SCM regions. Unfortunately due to how the PAPR interface works we can't
> use the existing of_pmem driver (yet) because:
>
>  a) The guest is required to use the H_SCM_BIND_MEM h-call to add
>     add the SCM region to it's physical address space, and
>  b) There is currently no mechanism for relating a bare of_pmem region
>     to the backing DIMM (or not-a-DIMM for our case).
>
> Both of these are easily handled by rolling the functionality into a
> seperate driver so here we are...
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> The alternative implementation here is that we have the pseries code
> do the h-calls and craft a pmem-region@<addr> node based on that.
> However, that doesn't solve b) and mpe has expressed his dislike of
> adding new stuff to the DT at runtime so i'd say that's a non-starter.
> ---
>  arch/powerpc/platforms/pseries/Kconfig    |   7 +
>  arch/powerpc/platforms/pseries/Makefile   |   1 +
>  arch/powerpc/platforms/pseries/papr_scm.c | 340 ++++++++++++++++++++++++++++++
>  3 files changed, 348 insertions(+)
>  create mode 100644 arch/powerpc/platforms/pseries/papr_scm.c
>
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
> index 0c698fd6d491..4b0fcb80efe5 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -140,3 +140,10 @@ config IBMEBUS
>         bool "Support for GX bus based adapters"
>         help
>           Bus device driver for GX bus based adapters.
> +
> +config PAPR_SCM
> +       depends on PPC_PSERIES && MEMORY_HOTPLUG
> +       select LIBNVDIMM
> +       tristate "Support for the PAPR Storage Class Memory interface"
> +       help
> +         Enable access to hypervisor provided storage class memory.
> diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
> index 892b27ced973..a43ec843c8e2 100644
> --- a/arch/powerpc/platforms/pseries/Makefile
> +++ b/arch/powerpc/platforms/pseries/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_IO_EVENT_IRQ)    += io_event_irq.o
>  obj-$(CONFIG_LPARCFG)          += lparcfg.o
>  obj-$(CONFIG_IBMVIO)           += vio.o
>  obj-$(CONFIG_IBMEBUS)          += ibmebus.o
> +obj-$(CONFIG_PAPR_SCM)         += papr_scm.o
>
>  ifdef CONFIG_PPC_PSERIES
>  obj-$(CONFIG_SUSPEND)          += suspend.o
> diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> new file mode 100644
> index 000000000000..87d4dbc18845
> --- /dev/null
> +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define pr_fmt(fmt)    "papr-scm: " fmt
> +
> +#include <linux/of.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/ioport.h>
> +#include <linux/slab.h>
> +#include <linux/ndctl.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/plpar_wrappers.h>
> +
> +#define BIND_ANY_ADDR (~0ul)
> +
> +#define PAPR_SCM_DIMM_CMD_MASK \
> +       ((1ul << ND_CMD_GET_CONFIG_SIZE) | \
> +        (1ul << ND_CMD_GET_CONFIG_DATA) | \
> +        (1ul << ND_CMD_SET_CONFIG_DATA))
> +
> +struct papr_scm_priv {
> +       struct platform_device *pdev;
> +       struct device_node *dn;
> +       uint32_t drc_index;
> +       uint64_t blocks;
> +       uint64_t block_size;
> +       int metadata_size;
> +
> +       uint64_t bound_addr;
> +
> +       struct nvdimm_bus_descriptor bus_desc;
> +       struct nvdimm_bus *bus;
> +       struct nvdimm *nvdimm;
> +       struct resource res;
> +       struct nd_region *region;
> +       struct nd_interleave_set nd_set;
> +};
> +
> +static int drc_pmem_bind(struct papr_scm_priv *p)
> +{
> +       unsigned long ret[PLPAR_HCALL_BUFSIZE];
> +       uint64_t rc, token;
> +
> +       /*
> +        * When the hypervisor cannot map all the requested memory in a single
> +        * hcall it returns H_BUSY and we call again with the token until
> +        * we get H_SUCCESS. Aborting the retry loop before getting H_SUCCESS
> +        * leave the system in an undefined state, so we wait.
> +        */
> +       token = 0;
> +
> +       do {
> +               rc = plpar_hcall(H_SCM_BIND_MEM, ret, p->drc_index, 0,
> +                               p->blocks, BIND_ANY_ADDR, token);
> +               token = be64_to_cpu(ret[0]);

Does plpar_hcall sleep? Should there be a cond_resched() here if not?

> +       } while (rc == H_BUSY);
> +
> +       if (rc) {
> +               dev_err(&p->pdev->dev, "bind err: %lld\n", rc);
> +               return -ENXIO;
> +       }
> +
> +       p->bound_addr = be64_to_cpu(ret[1]);
> +
> +       dev_dbg(&p->pdev->dev, "bound drc %x to %pR\n", p->drc_index, &p->res);
> +
> +       return 0;
> +}
> +
> +static int drc_pmem_unbind(struct papr_scm_priv *p)
> +{
> +       unsigned long ret[PLPAR_HCALL_BUFSIZE];
> +       uint64_t rc, token;
> +
> +       token = 0;
> +
> +       /* NB: unbind has the same retry requirements mentioned above */
> +       do {
> +               rc = plpar_hcall(H_SCM_UNBIND_MEM, ret, p->drc_index,
> +                               p->bound_addr, p->blocks, token);
> +               token = be64_to_cpu(ret);

...same busy loop comment.

> +       } while (rc == H_BUSY);
> +
> +       if (rc)
> +               dev_err(&p->pdev->dev, "unbind error: %lld\n", rc);
> +
> +       return !!rc;
> +}
> +
> +static int papr_scm_meta_get(struct papr_scm_priv *p,
> +                       struct nd_cmd_get_config_data_hdr *hdr)
> +{
> +       unsigned long data[PLPAR_HCALL_BUFSIZE];
> +       int64_t ret;
> +
> +       if (hdr->in_offset >= p->metadata_size || hdr->in_length != 1)
> +               return -EINVAL;
> +
> +       ret = plpar_hcall(H_SCM_READ_METADATA, data, p->drc_index,
> +                       hdr->in_offset, 1);
> +
> +       if (ret == H_PARAMETER) /* bad DRC index */
> +               return -ENODEV;
> +       if (ret)
> +               return -EINVAL; /* other invalid parameter */
> +
> +       hdr->out_buf[0] = data[0] & 0xff;
> +
> +       return 0;
> +}
> +
> +static int papr_scm_meta_set(struct papr_scm_priv *p,
> +                       struct nd_cmd_set_config_hdr *hdr)
> +{
> +       int64_t ret;
> +
> +       if (hdr->in_offset >= p->metadata_size || hdr->in_length != 1)
> +               return -EINVAL;
> +
> +       ret = plpar_hcall_norets(H_SCM_WRITE_METADATA,
> +                       p->drc_index, hdr->in_offset, hdr->in_buf[0], 1);
> +
> +       if (ret == H_PARAMETER) /* bad DRC index */
> +               return -ENODEV;
> +       if (ret)
> +               return -EINVAL; /* other invalid parameter */
> +
> +       return 0;
> +}
> +
> +int papr_scm_ndctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
> +               unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
> +{
> +       struct nd_cmd_get_config_size *get_size_hdr;
> +       struct papr_scm_priv *p;
> +
> +       /* Only dimm-specific calls are supported atm */
> +       if (!nvdimm)
> +               return -EINVAL;
> +
> +       p = nvdimm_provider_data(nvdimm);
> +
> +       switch (cmd) {
> +       case ND_CMD_GET_CONFIG_SIZE:
> +               get_size_hdr = buf;
> +
> +               get_size_hdr->status = 0;
> +               get_size_hdr->max_xfer = 1;
> +               get_size_hdr->config_size = p->metadata_size;
> +               *cmd_rc = 0;
> +               break;
> +
> +       case ND_CMD_GET_CONFIG_DATA:
> +               *cmd_rc = papr_scm_meta_get(p, buf);
> +               break;
> +
> +       case ND_CMD_SET_CONFIG_DATA:
> +               *cmd_rc = papr_scm_meta_set(p, buf);
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       dev_dbg(&p->pdev->dev, "returned with cmd_rc = %d\n", *cmd_rc);
> +
> +       return 0;
> +}
> +
> +static const struct attribute_group *region_attr_groups[] = {
> +       &nd_region_attribute_group,
> +       &nd_device_attribute_group,
> +       &nd_mapping_attribute_group,
> +       &nd_numa_attribute_group,
> +       NULL,
> +};
> +
> +static const struct attribute_group *bus_attr_groups[] = {
> +       &nvdimm_bus_attribute_group,
> +       NULL,
> +};
> +
> +static const struct attribute_group *papr_scm_dimm_groups[] = {
> +       &nvdimm_attribute_group,
> +       &nd_device_attribute_group,
> +       NULL,
> +};
> +
> +static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
> +{
> +       struct device *dev = &p->pdev->dev;
> +       struct nd_mapping_desc mapping;
> +       struct nd_region_desc ndr_desc;
> +       unsigned long dimm_flags;
> +
> +       p->bus_desc.ndctl = papr_scm_ndctl;
> +       p->bus_desc.module = THIS_MODULE;
> +       p->bus_desc.of_node = p->pdev->dev.of_node;
> +       p->bus_desc.attr_groups = bus_attr_groups;
> +       p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
> +
> +       if (!p->bus_desc.provider_name)
> +               return -ENOMEM;
> +
> +       p->bus = nvdimm_bus_register(NULL, &p->bus_desc);
> +       if (!p->bus) {
> +               dev_err(dev, "Error creating nvdimm bus %pOF\n", p->dn);
> +               return -ENXIO;
> +       }
> +
> +       dimm_flags = 0;
> +       set_bit(NDD_ALIASING, &dimm_flags);
> +
> +       p->nvdimm = nvdimm_create(p->bus, p, papr_scm_dimm_groups,
> +                               dimm_flags, PAPR_SCM_DIMM_CMD_MASK, 0, NULL);

Looks good, although I'm just about to push out commits that change
this function signature to take a 'security_ops' pointer. If you need
a stable branch to base this on, let me know.

> +       if (!p->nvdimm) {
> +               dev_err(dev, "Error creating DIMM object for %pOF\n", p->dn);
> +               goto err;
> +       }
> +
> +       /* now add the region */
> +
> +       memset(&mapping, 0, sizeof(mapping));
> +       mapping.nvdimm = p->nvdimm;
> +       mapping.start = p->res.start;
> +       mapping.size = p->blocks * p->block_size; // XXX: potential overflow?

Ideally, should be nvdimm relative addresses. Since you have just a
single DIMM per-region I would expect this to be 0 to
nvdimm->region_size. That said I don't think anything breaks if you
make the nvdimm address equal to the system-physical address, just
wanted to point out the intent. This only matters when you have
multiple DIMMs per region and need to record the per-DIMM contribution
in the labels on each DIMM.

Other than that looks ok to me:

Acked-by: Dan Williams <dan.j.williams@intel.com>

...just the matter of what to do about function signature change.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
