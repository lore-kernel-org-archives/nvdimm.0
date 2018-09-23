Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 635A52114ACEA
 for <linux-nvdimm@lists.01.org>; Sat, 22 Sep 2018 17:11:06 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e21-v6so3852900otk.10
 for <linux-nvdimm@lists.01.org>; Sat, 22 Sep 2018 17:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 22 Sep 2018 17:10:54 -0700
Message-ID: <CAPcyv4gY6LkMLqTMW82Oz5TPHmWGRBs7==oBoR2DthLQPOiKng@mail.gmail.com>
Subject: Re: [PATCH v8 05/12] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 28, 2018 at 3:47 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add support to allow query the security status of the Intel nvdimms and
> also unlock the dimm via the kernel key management APIs. The passphrase is
> expected to be pulled from userspace through keyutils. Moving the Intel
> related bits to its own source file as well.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/Makefile |    1
>  drivers/acpi/nfit/core.c   |    3 +
>  drivers/acpi/nfit/intel.c  |  152 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/intel.h  |   15 ++++
>  drivers/nvdimm/Kconfig     |    1
>  drivers/nvdimm/dimm.c      |    7 ++
>  drivers/nvdimm/dimm_devs.c |  128 +++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h   |    4 +
>  drivers/nvdimm/nd.h        |    2 +
>  include/linux/libnvdimm.h  |   24 +++++++
>  10 files changed, 334 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/acpi/nfit/intel.c
>
> diff --git a/drivers/acpi/nfit/Makefile b/drivers/acpi/nfit/Makefile
> index a407e769f103..443c7ef4e6a6 100644
> --- a/drivers/acpi/nfit/Makefile
> +++ b/drivers/acpi/nfit/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_ACPI_NFIT) := nfit.o
>  nfit-y := core.o
> +nfit-$(CONFIG_X86) += intel.o
>  nfit-$(CONFIG_X86_MCE) += mce.o
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 21235d555b5f..9cb6a108ecba 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1904,7 +1904,8 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>                 nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
>                                 acpi_nfit_dimm_attribute_groups,
>                                 flags, cmd_mask, flush ? flush->hint_count : 0,
> -                               nfit_mem->flush_wpq, &nfit_mem->id[0]);
> +                               nfit_mem->flush_wpq, &nfit_mem->id[0],
> +                               acpi_nfit_get_security_ops(nfit_mem->family));
>                 if (!nvdimm)
>                         return -ENOMEM;
>
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> new file mode 100644
> index 000000000000..4bfc1c1da339
> --- /dev/null
> +++ b/drivers/acpi/nfit/intel.c
> @@ -0,0 +1,152 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +/*
> + * Intel specific NFIT ops
> + */
> +#include <linux/libnvdimm.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/ndctl.h>
> +#include <linux/sysfs.h>
> +#include <linux/delay.h>
> +#include <linux/acpi.h>
> +#include <linux/io.h>
> +#include <linux/nd.h>
> +#include <asm/cacheflush.h>
> +#include <asm/smp.h>
> +#include <acpi/nfit.h>
> +#include "intel.h"
> +#include "nfit.h"
> +
> +static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
> +               struct nvdimm *nvdimm, const struct nvdimm_key_data *nkey)
> +{
> +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +       int cmd_rc, rc = 0;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_unlock_unit cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_UNLOCK_UNIT,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = ND_INTEL_PASSPHRASE_SIZE,
> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
> +               },
> +               .cmd = {
> +                       .status = 0,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_UNLOCK_UNIT, &nfit_mem->dsm_mask))
> +               return -ENOTTY;
> +
> +       memcpy(nd_cmd.cmd.passphrase, nkey->data,
> +                       sizeof(nd_cmd.cmd.passphrase));
> +       rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
> +                       sizeof(nd_cmd), &cmd_rc);
> +       if (rc < 0)
> +               goto out;
> +       if (cmd_rc < 0) {
> +               rc = cmd_rc;
> +               goto out;
> +       }
> +
> +       switch (nd_cmd.cmd.status) {
> +       case 0:
> +               break;
> +       case ND_INTEL_STATUS_INVALID_PASS:
> +               rc = -EINVAL;
> +               goto out;
> +       case ND_INTEL_STATUS_INVALID_STATE:
> +       default:
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       /*
> +        * TODO: define a cross arch wbinvd when/if NVDIMM_FAMILY_INTEL
> +        * support arrives on another arch.
> +        */
> +       /* DIMM unlocked, invalidate all CPU caches before we read it */
> +       wbinvd_on_all_cpus();
> +
> + out:
> +       return rc;
> +}
> +
> +static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
> +               struct nvdimm *nvdimm, enum nvdimm_security_state *state)
> +{
> +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +       int cmd_rc, rc = 0;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_get_security_state cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = 0,
> +                       .nd_size_out =
> +                               sizeof(struct nd_intel_get_security_state),
> +                       .nd_fw_size =
> +                               sizeof(struct nd_intel_get_security_state),
> +               },
> +               .cmd = {
> +                       .status = 0,
> +                       .state = 0,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_GET_SECURITY_STATE, &nfit_mem->dsm_mask)) {
> +               *state = NVDIMM_SECURITY_UNSUPPORTED;
> +               return 0;
> +       }
> +
> +       *state = NVDIMM_SECURITY_DISABLED;
> +       rc = nd_desc->ndctl(nd_desc, nvdimm, ND_CMD_CALL, &nd_cmd,
> +                       sizeof(nd_cmd), &cmd_rc);
> +       if (rc < 0)
> +               goto out;
> +       if (cmd_rc < 0) {
> +               rc = cmd_rc;
> +               goto out;
> +       }
> +
> +       switch (nd_cmd.cmd.status) {
> +       case 0:
> +               break;
> +       case ND_INTEL_STATUS_RETRY:
> +               rc = -EAGAIN;
> +               goto out;
> +       case ND_INTEL_STATUS_NOT_READY:
> +       default:
> +               rc = -ENXIO;
> +               goto out;
> +       }
> +
> +       /* check and see if security is enabled and locked */
> +       if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_UNSUPPORTED)
> +               *state = NVDIMM_SECURITY_UNSUPPORTED;
> +       else if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_ENABLED) {
> +               if (nd_cmd.cmd.state & ND_INTEL_SEC_STATE_LOCKED)
> +                       *state = NVDIMM_SECURITY_LOCKED;
> +               else
> +                       *state = NVDIMM_SECURITY_UNLOCKED;
> +       } else
> +               *state = NVDIMM_SECURITY_DISABLED;
> +
> + out:
> +       if (rc < 0)
> +               *state = NVDIMM_SECURITY_INVALID;
> +       return rc;
> +}
> +
> +const struct nvdimm_security_ops intel_security_ops = {
> +       .state = intel_dimm_security_state,
> +       .unlock = intel_dimm_security_unlock,
> +};
> diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
> index a6f8f4bc8ebb..f9ac718776ca 100644
> --- a/drivers/acpi/nfit/intel.h
> +++ b/drivers/acpi/nfit/intel.h
> @@ -8,6 +8,8 @@
>
>  #ifdef CONFIG_X86
>
> +extern const struct nvdimm_security_ops intel_security_ops;
> +
>  #define ND_INTEL_STATUS_SIZE           4
>  #define ND_INTEL_PASSPHRASE_SIZE       32
>
> @@ -64,4 +66,17 @@ struct nd_intel_query_overwrite {
>  } __packed;
>  #endif /* CONFIG_X86 */
>
> +static inline const struct nvdimm_security_ops *
> +acpi_nfit_get_security_ops(int family)
> +{
> +       switch (family) {
> +#ifdef CONFIG_X86
> +       case NVDIMM_FAMILY_INTEL:
> +               return &intel_security_ops;
> +#endif
> +       default:
> +               return NULL;
> +       }
> +}
> +
>  #endif
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 9d36473dc2a2..830a7a5342e1 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -3,6 +3,7 @@ menuconfig LIBNVDIMM
>         depends on PHYS_ADDR_T_64BIT
>         depends on HAS_IOMEM
>         depends on BLK_DEV
> +       depends on KEYS
>         help
>           Generic support for non-volatile memory devices including
>           ACPI-6-NFIT defined resources.  On platforms that define an
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 6c8fb7590838..b6381ddbd6c1 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -51,6 +51,13 @@ static int nvdimm_probe(struct device *dev)
>         get_device(dev);
>         kref_init(&ndd->kref);
>
> +       nvdimm_security_get_state(dev);
> +
> +       /* unlock DIMM here before touch label */
> +       rc = nvdimm_security_unlock_dimm(dev);
> +       if (rc < 0)
> +               dev_warn(dev, "failed to unlock dimm %s\n", dev_name(dev));
> +
>         /*
>          * EACCES failures reading the namespace label-area-properties
>          * are interpreted as the DIMM capacity being locked but the
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index e753b2095402..fe61f2a2ad5d 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -20,6 +20,7 @@
>  #include <linux/mm.h>
>  #include <linux/key.h>
>  #include <linux/init_task.h>
> +#include <keys/user-type.h>
>  #include "nd-core.h"
>  #include "label.h"
>  #include "pmem.h"
> @@ -28,6 +29,129 @@
>  static DEFINE_IDA(dimm_ida);
>  static struct key *nvdimm_keyring;
>
> +#define NVDIMM_PREFIX          "nvdimm:"
> +
> +/*
> + * Find key in kernel keyring
> + */
> +static struct key *nvdimm_get_key(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +       if (!nvdimm->key)
> +               return NULL;
> +
> +       if (key_validate(nvdimm->key) < 0)
> +               return NULL;
> +
> +       key_get(nvdimm->key);
> +
> +       dev_dbg(dev, "%s: key found: %d\n", __func__,
> +                       key_serial(nvdimm->key));
> +       return nvdimm->key;
> +}
> +
> +/*
> + * Retrieve kernel key for DIMM and request from user space if necessary.
> + */
> +static struct key *nvdimm_request_key(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct key *key = NULL;
> +       char desc[NVDIMM_KEY_DESC_LEN + strlen(NVDIMM_PREFIX)];
> +
> +       sprintf(desc, "%s%s", NVDIMM_PREFIX, nvdimm->dimm_id);
> +       key = request_key(&key_type_logon, desc, desc);
> +       if (IS_ERR(key))
> +               key = NULL;
> +
> +       return key;
> +}
> +
> +static int nvdimm_check_key_len(unsigned short len, bool update)
> +{
> +       if (len == (NVDIMM_PASSPHRASE_LEN * 2) && update)
> +               return 0;
> +
> +       if (len == NVDIMM_PASSPHRASE_LEN)
> +               return 0;
> +
> +       return -EINVAL;
> +}
> +
> +int nvdimm_security_get_state(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +
> +       if (!nvdimm->security_ops)
> +               return 0;
> +
> +       return nvdimm->security_ops->state(nvdimm_bus, nvdimm,
> +                       &nvdimm->state);
> +}
> +
> +int nvdimm_security_unlock_dimm(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +       struct key *key;
> +       struct user_key_payload *payload;
> +       int rc;
> +       bool cached_key = false;
> +
> +       if (!nvdimm->security_ops)
> +               return 0;
> +
> +       if (nvdimm->state == NVDIMM_SECURITY_UNLOCKED ||

Hmm, if the DIMM is unlocked before the driver loads that means we'll
never ask for the current key which means we can't count on having it
around for change key requests. I think there needs to be a sysfs
interface to trigger loading the current key into the keyring cache so
it is available for future operations that need it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
