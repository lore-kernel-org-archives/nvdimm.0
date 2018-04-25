Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8295E226612B9
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 07:10:39 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 11-v6so5410830ois.8
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 07:10:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180425073843.19900-1-qi.fuli@jp.fujitsu.com>
References: <20180425073843.19900-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Apr 2018 07:10:37 -0700
Message-ID: <CAPcyv4iEQdcH8CUfWbT03s90MDDkMcyrA93cQRogW7X_4yY=pw@mail.gmail.com>
Subject: Re: [PATCH] ndctl,
 filter: fix "keyword 'all' is ignored" in util_<obj>_filter()
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

On Wed, Apr 25, 2018 at 12:38 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This is a follow up patch for commit c70adc3cf6bf ("ndctl, filter: refactor
> util_<obj>_filter() to support multiple space-seperated arguments")
> refactored util_<obj>_filter() to support multiple space-seperated arguments.
> But, when the keyword "all" is included in space-seperated arguments,
> it will be treaded as <object>'s name. This patch fixes it.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  util/filter.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/util/filter.c b/util/filter.c
> index 0d3cc02..9081a6d 100644
> --- a/util/filter.c
> +++ b/util/filter.c
> @@ -40,6 +40,9 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *__ident)
>
>         for (name = strtok_r(ident, " ", &save); name;
>                         name = strtok_r(NULL, " ", &save)) {
> +               if (strcmp(ident, "all") == 0)
> +                       break;
> +

Let's also remove the strcmp(__ident, "all") at the top of each of
these routines to keep the check for "all" centralized.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
