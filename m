Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F6C52034D8D2
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:46:53 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id f11so3061603otj.12
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:52:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
References: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
 <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Feb 2018 15:52:51 -0800
Message-ID: <CAPcyv4j2GqXJtM9pstjO4y_w-df3UDWps4fQ0xN1OkLC8CpzLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ndctl: add "all" dimm-id option for update-firmware
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 2:06 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding all option to allow ndctl to update all DIMMs at once.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/update.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/ndctl/update.c b/ndctl/update.c
> index fc26acf..1b771ff 100644
> --- a/ndctl/update.c
> +++ b/ndctl/update.c
> @@ -77,6 +77,7 @@ struct update_context {
>         struct ndctl_dimm *dimm;
>         struct fw_info dimm_fw;
>         struct ndctl_cmd *start;
> +       bool all;
>  };
>
>  /*
> @@ -471,16 +472,23 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
>  {
>         struct ndctl_dimm *dimm;
>         struct ndctl_bus *bus;
> +       int rc = -ENODEV;
>
>         ndctl_bus_foreach(ctx, bus)
>                 ndctl_dimm_foreach(bus, dimm) {
> -                       if (!util_dimm_filter(dimm, uctx->dimm_id))
> +                       if (!uctx->all &&
> +                               !util_dimm_filter(dimm, uctx->dimm_id))
>                                 continue;
>                         uctx->dimm = dimm;
> -                       return 0;
> +                       rc = update_firmware(uctx);
> +                       if (rc < 0) {
> +                               error("Update firmware for dimm %s failed\n",
> +                                               ndctl_dimm_get_devname(dimm));
> +                               continue;
> +                       }

No need to special case "all" support, it's handled explicitly as a
supported dimm-id string in util_dimm_filter(). In fact, all the
util_<object>_filter() helpers support "all" as a special case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
