Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77A0820336ADA
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 15:48:52 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id k81-v6so7049700oib.4
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jul 2018 15:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153057477488.38125.10748005421631673877.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
 <153057477488.38125.10748005421631673877.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Jul 2018 15:48:50 -0700
Message-ID: <CAPcyv4jNGonyKNpmrfnN2GRQiXj41bk3bfW3Bw=8gqKy2=yywQ@mail.gmail.com>
Subject: Re: [PATCH 05/11] nfit/libnvdimm: add set passphrase support for
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

On Mon, Jul 2, 2018 at 4:39 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding support for setting and/or updating passphrase on the Intel nvdimms.
> The passphrase is pulled from userspace through the kernel key management.
> We trigger the update via writing "update" to the sysfs attribute
> "security". The state of the security can also be read via the "security"
> attribute. libnvdimm will generically support the key_change API call.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/intel.c  |   54 ++++++++++++++++++++++
>  drivers/nvdimm/dimm_devs.c |  110 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/libnvdimm.h  |    4 ++
>  3 files changed, 168 insertions(+)
>
> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
> index 1bdb493694e0..792a5c694a9e 100644
> --- a/drivers/acpi/nfit/intel.c
> +++ b/drivers/acpi/nfit/intel.c
> @@ -16,6 +16,59 @@
>  #include <acpi/nfit.h>
>  #include "nfit.h"
>
> +static int intel_dimm_security_update_passphrase(
> +               struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
> +               const char *old_pass, const char *new_pass)

Raw strings concern me especially if we have future security
implementations that are not string passphrase based. How about having
this routine and the other security ops take 'struct nvdimm_key_data
*' arguments where:

struct nvdmm_key_data {
    u8 data[NVDIMM_PASSPHRASE_LEN];
};

> +{
> +       struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
> +       int cmd_rc, rc = 0, pkg_size;
> +       struct nd_intel_set_passphrase *cmd;
> +       struct nd_cmd_pkg *pkg;
> +       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +
> +       if (!test_bit(NVDIMM_INTEL_SET_PASSPHRASE, &nfit_mem->dsm_mask))
> +               return -ENOTTY;
> +
> +       pkg_size = sizeof(*pkg) + sizeof(*cmd);
> +       pkg = kzalloc(pkg_size, GFP_KERNEL);
> +       if (!pkg)
> +               return -ENOMEM;

I think these commands are small enough to allocate on the stack, but
you would need to wrap it.

struct {
    struct nd_cmd_pkg pkg;
    struct nd_intel_set_passphrase cmd;
} cmd = {
    .pkg = {
    ...
    },
    .cmd = {
    ...
    },
};

This would save the memory allocation and the cast of nd_payload.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
