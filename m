Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D92320988769
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:26:41 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id v8-v6so65174386oie.5
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 16:26:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153142853603.27297.14939716671780414552.stgit@djiang5-desk3.ch.intel.com>
References: <153142840572.27297.8070233763007198738.stgit@djiang5-desk3.ch.intel.com>
 <153142853603.27297.14939716671780414552.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 16:26:40 -0700
Message-ID: <CAPcyv4iViSK867XK_3SiszfNWGk5E70KvVpavkvi2SFuq61WWg@mail.gmail.com>
Subject: Re: [PATCH v4 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
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
Cc: David Howells <dhowells@redhat.com>, "Schofield, Alison  <alison.schofield@intel.com>, keyrings@vger.kernel.org, Kees Cook" <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 12, 2018 at 1:48 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Add support for setting and/or updating passphrase on the Intel nvdimms.
> The passphrase is pulled from userspace through the kernel key management.
> We trigger the update via writing "update" to the sysfs attribute
> "security". The state of the security can also be read via the "security"
> attribute. libnvdimm will generically support the key_change API call.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/intel.c  |   57 +++++++++++++++++++++++
>  drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h  |    5 ++
>  3 files changed, 172 insertions(+)
>
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index 9155b8e63f0e..b0a62248467d 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -18,6 +18,62 @@
>  #include "intel.h"
>  #include "nfit.h"
>
> +static int intel_dimm_security_update_passphrase(
> +               struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
> +               struct nvdimm_key_data *old_data,
> +               struct nvdimm_key_data *new_data)
> +{
> +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +       int cmd_rc, rc = 0;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +       struct {
> +               struct nd_cmd_pkg pkg;
> +               struct nd_intel_set_passphrase cmd;
> +       } nd_cmd = {
> +               .pkg = {
> +                       .nd_command = NVDIMM_INTEL_SET_PASSPHRASE,
> +                       .nd_family = NVDIMM_FAMILY_INTEL,
> +                       .nd_size_in = ND_INTEL_PASSPHRASE_SIZE * 2,
> +                       .nd_size_out = ND_INTEL_STATUS_SIZE,
> +                       .nd_fw_size = ND_INTEL_STATUS_SIZE,
> +               },
> +               .cmd = {
> +                       .status = 0,
> +               },
> +       };
> +
> +       if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
> +               return -ENOTTY;
> +
> +       if (old_data)
> +               memcpy(nd_cmd.cmd.old_pass, old_data->data,
> +                               ND_INTEL_PASSPHRASE_SIZE);
> +       memcpy(nd_cmd.cmd.new_pass, new_data->data, ND_INTEL_PASSPHRASE_SIZE);
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
> + out:
> +       return rc;
> +}
> +
>  static int intel_dimm_security_unlock(struct nvdimm_bus *nvdimm_bus,
>                 struct nvdimm *nvdimm, struct nvdimm_key_data *nkey)
>  {
> @@ -148,4 +204,5 @@ static int intel_dimm_security_state(struct nvdimm_bus *nvdimm_bus,
>  struct nvdimm_security_ops intel_security_ops = {
>         .state = intel_dimm_security_state,
>         .unlock = intel_dimm_security_unlock,
> +       .change_key = intel_dimm_security_update_passphrase,
>  };
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 5e190120f4aa..2ab846a2114a 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -171,6 +171,75 @@ int nvdimm_security_unlock_dimm(struct device *dev)
>         return rc;
>  }
>
> +static int nvdimm_security_change_key(struct device *dev)
> +{
> +       struct nvdimm *nvdimm = to_nvdimm(dev);
> +       struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> +       struct key *key = NULL, *old_key = NULL;
> +       int rc;
> +       void *old_data, *new_data;
> +
> +       if (!nvdimm->security_ops)
> +               return 0;
> +
> +       if (nvdimm->state == NVDIMM_SECURITY_FROZEN)
> +               return -EBUSY;
> +
> +       /* look for a key from keyring if exists and remove */
> +       old_key = nvdimm_search_key(dev);
> +       if (old_key) {
> +               dev_dbg(dev, "%s: killing old key: %#x\n",
> +                               __func__, old_key->serial);
> +               key_invalidate(old_key);
> +               key_put(old_key);
> +               /* need key garbage collection to take effect */
> +               cond_resched();

If we need it to take effect then this won't do it, this is a nop most
times, and even if it were plain schedule() what guarantees the
garbage collector runs before you get the cpu again?

I think you want define a new key_put_sync() api that calls
flush_work(&key_gc_work), or otherwise clarify what happens if we
don't wait for the garbage collector to run?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
