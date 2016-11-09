Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22d.google.com (mail-it0-x22d.google.com
 [IPv6:2607:f8b0:4001:c0b::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 817DC81CC4
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 15:47:23 -0800 (PST)
Received: by mail-it0-x22d.google.com with SMTP id q124so194039292itd.1
 for <linux-nvdimm@lists.01.org>; Wed, 09 Nov 2016 15:47:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478726177-21904-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1478726177-21904-1-git-send-email-ross.zwisler@linux.intel.com>
 <1478726177-21904-2-git-send-email-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Nov 2016 15:47:25 -0800
Message-ID: <CAPcyv4ju9KaaQAktJvGz6AJWoAFNfC4A46D+GhrWnWuaNY0bsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ndctl: fix return value for disable-namespace
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 9, 2016 at 1:16 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On success the "ndctl disable-namespace" returns the number of namespaces
> that were disabled to the shell as an exit value.  This non-zero value is
> interpreted by the shell as an error.
>
> Fix this by returning 0 on success, just like all the other ndctl commands.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  ndctl/builtin-xaction-namespace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
> index 9b1702d..c556252 100644
> --- a/ndctl/builtin-xaction-namespace.c
> +++ b/ndctl/builtin-xaction-namespace.c
> @@ -790,7 +790,7 @@ int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx)
>         } else {
>                 fprintf(stderr, "disabled %d namespace%s\n", disabled,
>                                 disabled > 1 ? "s" : "");
> -               return disabled;
> +               return 0;
>         }
>  }
>
> --
> 2.7.4
>

Thanks Ross. Applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
