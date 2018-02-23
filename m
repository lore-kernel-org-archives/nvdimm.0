Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x241.google.com (mail-lf0-x241.google.com
 [IPv6:2a00:1450:4010:c07::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85961222630AF
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:09:55 -0800 (PST)
Received: by mail-lf0-x241.google.com with SMTP id 70so10808822lfw.2
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 22:15:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151933257703.36856.16473005119268194390.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
 <151933257703.36856.16473005119268194390.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:15:53 -0800
Message-ID: <CAPcyv4hzoC-ndvmaksz8+B6nZZOBSHFNBkBtQxASqhnPuubq5A@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ndctl: add "all" dimm-id option for update-firmware
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

On Thu, Feb 22, 2018 at 12:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Modifying the code so that when "all" option is passed in, we will process
> all the DIMMs on the platform.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/update.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/ndctl/update.c b/ndctl/update.c
> index fc26acf..4fb572d 100644
> --- a/ndctl/update.c
> +++ b/ndctl/update.c
> @@ -471,16 +471,22 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
>  {
>         struct ndctl_dimm *dimm;
>         struct ndctl_bus *bus;
> +       int rc = -ENODEV;
>
>         ndctl_bus_foreach(ctx, bus)
>                 ndctl_dimm_foreach(bus, dimm) {
>                         if (!util_dimm_filter(dimm, uctx->dimm_id))
>                                 continue;
>                         uctx->dimm = dimm;
> -                       return 0;
> +                       rc = update_firmware(uctx);
> +                       if (rc < 0) {
> +                               error("Update firmware for dimm %s failed\n",
> +                                               ndctl_dimm_get_devname(dimm));
> +                               continue;
> +                       }

This really wants the -b option to available as well, and we would get
that basically for free by moving all of this functionality into
ndctl/dimm.c along with all the other DIMM specific commands. So we
can apply this for now, but update.c really does not deserve to be
standalone command infrastructure away from the existing dimm-specific
utility infrastructure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
