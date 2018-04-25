Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E39732282E5B9
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 18:42:37 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id t1-v6so4246441ott.13
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 18:42:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152461031638.17395.12751766602088283269.stgit@djiang5-desk3.ch.intel.com>
References: <152461031638.17395.12751766602088283269.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Apr 2018 18:42:36 -0700
Message-ID: <CAPcyv4iu6SHB3jEYFqMaFXt4S-=4Zpc7FKpqV61X2jNdjPGF9A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ndctl: convert namespace actions to use
 util_filter_params
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

On Tue, Apr 24, 2018 at 3:52 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> In preparation of moving to using util_filter_walk, moving parts of namespace
> params to util_filter_params.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c |  165 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 82 insertions(+), 83 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index fe86d826..e7173ce9 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -40,21 +40,20 @@ static struct parameters {
>         bool mode_default;
>         bool align_default;
>         bool autolabel;
> -       const char *bus;
>         const char *map;
> -       const char *type;
>         const char *uuid;
>         const char *name;
>         const char *size;
>         const char *mode;
> -       const char *region;
>         const char *reconfig;
>         const char *sector_size;
>         const char *align;
> -} param = {
> +} ndns_action = {
>         .autolabel = true,
>  };
>
> +struct util_filter_params param;

Lets cut down on the thrash in this patch by calling this something
other than 'param'. I.e. all the parameters that are not being
converted to util_filter_params should not need to be touched.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
