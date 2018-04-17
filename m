Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F185A21F2E185
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 07:56:38 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id h55-v6so21671591ote.9
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 07:56:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
 <20180417063848.5585-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 17 Apr 2018 07:56:37 -0700
Message-ID: <CAPcyv4g16niVJ+X73nSB9vHn3kNdc_X3ydZ1wy22AwVEp-1Rdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl, util: add OPT_STRING_LIST to parse_option
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 11:38 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch adds OPT_STRING_LIST to parse_option in order to support
> multiple space seperated string objects in one option.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ccan/list/list.h     |  6 ++++++
>  util/parse-options.c | 25 +++++++++++++++++++++++++
>  util/parse-options.h |  3 +++
>  3 files changed, 34 insertions(+)
>
> diff --git a/ccan/list/list.h b/ccan/list/list.h
> index 4d1d34e..f6c927f 100644
> --- a/ccan/list/list.h
> +++ b/ccan/list/list.h
> @@ -26,6 +26,12 @@ struct list_node
>         struct list_node *next, *prev;
>  };
>
> +struct string_list_node
> +{
> +       char *str;
> +       struct list_node list;
> +};
> +
>  /**
>   * struct list_head - the head of a doubly-linked list
>   * @h: the list_head (containing next and prev pointers)
> diff --git a/util/parse-options.c b/util/parse-options.c
> index 751c091..cac18f0 100644
> --- a/util/parse-options.c
> +++ b/util/parse-options.c
> @@ -20,6 +20,7 @@
>  #include <util/util.h>
>  #include <util/strbuf.h>
>  #include <util/parse-options.h>
> +#include <ccan/list/list.h>
>
>  #define OPT_SHORT 1
>  #define OPT_UNSET 2
> @@ -695,3 +696,27 @@ int parse_opt_verbosity_cb(const struct option *opt,
>         }
>         return 0;
>  }
> +
> +int parse_opt_string_list(const struct option *opt, const char *arg, int unset)
> +{
> +       if (unset)
> +               return 0;
> +
> +       if (!arg)
> +               return -1;
> +
> +       struct list_head *v = opt->value;
> +       char *temp = strdup(arg);
> +       const char *deli = " ";
> +
> +       temp = strtok(temp, deli);
> +       while (temp != NULL) {
> +               struct string_list_node *sln = malloc(sizeof(*sln));
> +               sln->str = temp;
> +               list_add_tail(v, &sln->list);
> +               temp = strtok(NULL, deli);
> +       }
> +
> +       free(temp);
> +       return 0;
> +}

As far as I can see we do not need to allocate a list or add this new
OPT_STRING_LIST argument type. Just teach the util_<object>_filter()
routines that the 'ident' argument may be a space delimited list.  See
the attached patch:
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
