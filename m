Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B3B921954084
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 15:56:51 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id w12so41126572oiw.3
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 15:56:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493073410-80159-1-git-send-email-jerry.hoemann@hpe.com>
References: <1493073410-80159-1-git-send-email-jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 15:56:50 -0700
Message-ID: <CAPcyv4jzOdQKTQ-iLxcR+uU25bi3dD7ujONvi9pMSg_JR3PKSg@mail.gmail.com>
Subject: Re: [RFC] nvdimm: Unitialized variable used in DSM calls
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 24, 2017 at 3:36 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> nd_cmd_out_size is called by __nd_ioctl to size the buffer passed to
> acpi_nfit_ctl.  If the DSM function being called has a variable
> sized output, nd_cmd_out_size will look at the return field to
> determine buffer size.   However, the DSM call hasn't been made yet,
> so output size is core residue.
>
> Have nd_cmd_out_size be bimodal with version "early" to be called
> before the DSM call is made.  For variable sized output fields
> have it return ND_IOCTL_MAX_BUFLEN.  __nd_ioctl sees new return
> values and adjust buffer size accordingly.
>
> The downside to this approach are:
> 1) Requires user buffer input size to be ND_IOCTL_MAX_BUFLEN (4 MB) for
>    calls to DSM with variable return.
> 2) The needless copyin of 4MB
>
> An alternative approach (not yet prototyped) would move the call
> to nd_cmd_out_size until after the return from acpi_nfit_ctl.  Here,
> the call has been made and return size would be known.
>
> The size of the buffer allocated in would always be ND_IOCTL_MAX_BUFLEN.
>
> Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> ---
>  drivers/nvdimm/bus.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 23d4a17..50f8cc6 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -713,9 +713,9 @@ u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,
>  }
>  EXPORT_SYMBOL_GPL(nd_cmd_in_size);
>
> -u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
> +u32 nd_cmd_out_size_early(struct nvdimm *nvdimm, int cmd,
>                 const struct nd_cmd_desc *desc, int idx, const u32 *in_field,
> -               const u32 *out_field, unsigned long remainder)
> +               const u32 *out_field, unsigned long remainder, int early)
>  {
>         if (idx >= desc->out_num)
>                 return UINT_MAX;
> @@ -725,9 +725,13 @@ u32 nd_cmd_out_size(struct nvdimm *nvdimm, int cmd,
>
>         if (nvdimm && cmd == ND_CMD_GET_CONFIG_DATA && idx == 1)
>                 return in_field[1];
> -       else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2)
> +       else if (nvdimm && cmd == ND_CMD_VENDOR && idx == 2) {
> +               if (early)
> +                       return ND_IOCTL_MAX_BUFLEN;
>                 return out_field[1];

Are you using ndctl_dimm_cmd_new_vendor_specific() to submit a vendor
specific command? It already pre-populates out_field[1] with the
initial output size.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
