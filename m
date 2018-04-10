Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9A2E2261814F
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 14:36:39 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id e123-v6so12635629oih.13
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 14:36:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152339572662.31576.8455896889778879725.stgit@djiang5-desk3.ch.intel.com>
References: <152339572662.31576.8455896889778879725.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 14:36:38 -0700
Message-ID: <CAPcyv4iUMeJwSGwTVdKSPHs326sQnV_M7=St-pXz2mnzP2DouA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: add support in libndctl to provide deep flush
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 10, 2018 at 2:28 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Providing an API call in libndctl to support accessing the region deep_flush
> in sysfs.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  0 files changed
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 580a450e..fb4dca73 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
[..]
> @@ -1866,6 +1877,22 @@ static void *add_region(void *parent, int id, const char *region_base)
>         else
>                 region->persistence_domain = region_get_pd_type(buf);
>
> +       sprintf(path, "%s/deep_flush", region_base);
> +       region->flush_fd = open(path, O_RDWR);
> +       if (region->flush_fd == -1)
> +               goto err_read;

Have you tried this on a config that does not export the 'deep_flush'
attribute? Seems like this would kill listing those regions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
