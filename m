Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2B0920352133
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 17:04:57 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id b130-v6so17698503oif.12
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 17:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180503185050.7559-2-vishal.l.verma@intel.com>
References: <20180503185050.7559-1-vishal.l.verma@intel.com>
 <20180503185050.7559-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 17:04:55 -0700
Message-ID: <CAPcyv4ihNH-wHAzYAOUaTuP=+Zj8UXVMYA8UTZQ8rPse9r_G4Q@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/4] libndctl: improve debug prints in
 wait_for_scrub_completion
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 3, 2018 at 11:50 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> ndctl_bus_wait_for_scrub_completion() printed the same debug message
> irrespective of whether we encountered a failure or not. Add a newe

*new

> debug message that is printed for failing cases.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/libndctl.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 2a3ef0c..6733b85 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1248,7 +1248,11 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
>                 }
>         }
>
> -       dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
> +       if (rc == 0)
> +               dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
> +       else
> +               dbg(ctx, "bus%d: error waiting for scrub completion: %s\n",
> +                       ndctl_bus_get_id(bus), strerror(-rc));
>         if (fd)
>                 close (fd);
>         return rc;
> --
> 2.14.3
>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
