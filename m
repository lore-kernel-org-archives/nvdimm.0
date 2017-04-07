Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AB6521942349
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 07:58:41 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id b187so88914613oif.0
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 07:58:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <148970515290.49411.8476575932675475933.stgit@djiang5-desk3.ch.intel.com>
References: <148970513650.49411.10791297905780906216.stgit@djiang5-desk3.ch.intel.com>
 <148970515290.49411.8476575932675475933.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Apr 2017 07:58:40 -0700
Message-ID: <CAPcyv4jaA__vomT6tjGZNRxGTNrfTSP37wc90YhVU_FBeeShag@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] acpi_nfit, libnvdimm: Add support for clear poison
 list and bad blocks
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 16, 2017 at 3:59 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
> call. We will update the poison list and also the badblocks at region level
> if the region is in dax mode or in pmem mode and not active.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/acpi/nfit/core.c         |   24 ++++++++++++++
>  drivers/acpi/nfit/nfit.h         |    2 +
>  drivers/nvdimm/bus.c             |   64 ++++++++++++++++++++++++++++++++++----
>  drivers/nvdimm/core.c            |   17 ++++++++--
>  drivers/nvdimm/region.c          |   25 +++++++++++++++
>  include/linux/libnvdimm.h        |    7 ++++
>  tools/testing/nvdimm/test/nfit.c |   21 +++++++-----
>  7 files changed, 139 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index e7b05df..706eccd 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -94,6 +94,28 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
>         return to_acpi_device(acpi_desc->dev);
>  }
>
> +void acpi_nfit_forget_poison(struct nvdimm_bus_descriptor *nd_desc,
> +               unsigned int cmd, void *buf)
> +{
> +       struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
> +       struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
> +       struct nd_cmd_clear_error *clear_err = buf;
> +       struct resource res;
> +
> +       if (!nvdimm_bus || !clear_err->cleared)
> +               return;
> +
> +       /* clearing the poison list we keep track of */
> +       __nvdimm_forget_poison(nvdimm_bus, clear_err->address,
> +                       clear_err->cleared);
> +
> +       /* now sync the badblocks lists from the poison list */
> +       res.start = clear_err->address;
> +       res.end = clear_err->address + clear_err->cleared - 1;
> +       __nvdimm_bus_badblocks_clear(nvdimm_bus, &res);
> +}
> +EXPORT_SYMBOL_GPL(acpi_nfit_forget_poison);
> +
>  static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
>  {
>         struct nd_cmd_clear_error *clear_err;
> @@ -353,6 +375,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>         }
>
>         xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
> +       if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && xlat_rc >= 0)
> +               acpi_nfit_forget_poison(nd_desc, cmd, buf);

I think this needs to move out to __nd_ioctl(), otherwise we'll be
calling this in response to a kernel internal ND_CMD_CLEAR_ERROR. This
should only be invoked for external clear error. This also means we
don't need the previous patch to unconditionally retrieve xlat_rc.
Instead we can just have __nd_ioctl() provide a valid cmd_rc parameter
rather than NULL.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
