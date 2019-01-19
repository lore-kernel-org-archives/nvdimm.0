Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C306207DF293
 for <linux-nvdimm@lists.01.org>; Sat, 19 Jan 2019 11:06:49 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id c206so11644741oib.0
 for <linux-nvdimm@lists.01.org>; Sat, 19 Jan 2019 11:06:49 -0800 (PST)
MIME-Version: 1.0
References: <154759163682.1953028.16995572958827750312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154759164721.1953028.2457688855956808647.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154759164721.1953028.2457688855956808647.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 19 Jan 2019 11:06:31 -0800
Message-ID: <CAPcyv4ixzBb_=6P4Vq39YArmxgUcdm+u2QK+CpTDHCTOa7DT1w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] acpi/nfit: Fix command-supported detection
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Sujith Pandel <sujith_pandel@dell.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 15, 2019 at 2:46 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> The _DSM function number validation only happens to succeed when the
> generic Linux command number translation corresponds with a
> DSM-family-specific function number. This breaks NVDIMM-N
> implementations that correctly implement _LSR, _LSW, and _LSI, but do
> not happen to publish support for DSM function numbers 4, 5, and 6.
>
> Recall that the support for _LS{I,R,W} family of methods results in the
> DIMM being marked as supporting those command numbers at
> acpi_nfit_register_dimms() time. The DSM function mask is only used for
> ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.
>
> Fixes: 31eca76ba2fc ("nfit, libnvdimm: limited/whitelisted dimm command...")
> Cc: <stable@vger.kernel.org>
> Link: https://github.com/pmem/ndctl/issues/78
> Reported-by: Sujith Pandel <sujith_pandel@dell.com>
> Tested-by: Sujith Pandel <sujith_pandel@dell.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   52 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 73281b19d3dd..9c95b82e5e5d 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -409,6 +409,32 @@ static bool payload_dumpable(struct nvdimm *nvdimm, unsigned int func)
>         return true;
>  }
>
> +static int cmd_to_func(struct nfit_mem *nfit_mem, unsigned int cmd,
> +               struct nd_cmd_pkg *call_pkg)
> +{
> +       if (cmd == ND_CMD_CALL) {
> +               int i;
> +
> +               if (call_pkg && nfit_mem->family != call_pkg->nd_family)
> +                       return -ENOTTY;
> +
> +               for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
> +                       if (call_pkg->nd_reserved2[i])
> +                               return -EINVAL;
> +               return call_pkg->nd_command;
> +       }
> +
> +       /* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
> +       if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
> +               return cmd;
> +
> +       /*
> +        * Force function number validation to fail since 0 is never
> +        * published as a valid function in dsm_mask.
> +        */
> +       return 0;
> +}
> +
>  int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>                 unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
>  {
> @@ -422,30 +448,21 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>         unsigned long cmd_mask, dsm_mask;
>         u32 offset, fw_status = 0;
>         acpi_handle handle;
> -       unsigned int func;
>         const guid_t *guid;
> -       int rc, i;
> +       int func, rc, i;
>
>         if (cmd_rc)
>                 *cmd_rc = -EINVAL;
> -       func = cmd;
> -       if (cmd == ND_CMD_CALL) {
> -               call_pkg = buf;

This breaks ND_CMD_CALL because now call_pkg is NULL for the rest of
this routine. v4 inbound, as well as a backlog item to add an
ND_CMD_CALL test-case to nfit_ctl_test(). The incremental fix is:

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 9c95b82e5e5d..71d03a4004fb 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -412,10 +412,10 @@ static bool payload_dumpable(struct nvdimm
*nvdimm, unsigned int func)
 static int cmd_to_func(struct nfit_mem *nfit_mem, unsigned int cmd,
                struct nd_cmd_pkg *call_pkg)
 {
-       if (cmd == ND_CMD_CALL) {
+       if (call_pkg) {
                int i;

-               if (call_pkg && nfit_mem->family != call_pkg->nd_family)
+               if (nfit_mem->family != call_pkg->nd_family)
                        return -ENOTTY;

                for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
@@ -460,7 +460,9 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor
*nd_desc, struct nvdimm *nvdimm,
                if (!adev)
                        return -ENOTTY;

-               func = cmd_to_func(nfit_mem, cmd, buf);
+               if (cmd == ND_CMD_CALL)
+                       call_pkg = buf;
+               func = cmd_to_func(nfit_mem, cmd, call_pkg);
                if (func < 0)
                        return func;
                dimm_name = nvdimm_name(nvdimm);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
