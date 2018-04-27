Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B97D2282E586
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 17:44:21 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id 77-v6so221488otd.4
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 17:44:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152476663350.70161.1906714489582336946.stgit@djiang5-desk3.ch.intel.com>
References: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
 <152476663350.70161.1906714489582336946.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Apr 2018 17:44:20 -0700
Message-ID: <CAPcyv4gL3Rd8jHNzYXjPyz4_5oCcU7k3Ro_gt_Op8SGgRJQfYw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ndctl: convert namespace actions to use
 util_filter_walk()
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

> diff --git a/util/filter.h b/util/filter.h
> index effda24b..ce3336a5 100644
> --- a/util/filter.h
> +++ b/util/filter.h
> @@ -13,6 +13,7 @@
>  #ifndef _UTIL_FILTER_H_
>  #define _UTIL_FILTER_H_
>  #include <stdbool.h>
> +#include <ndctl/action.h>
>
>  struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
>  struct ndctl_region *util_region_filter(struct ndctl_region *region,
> @@ -50,6 +51,12 @@ struct list_filter_arg {
>         unsigned long flags;
>  };
>
> +struct ndns_filter_arg {
> +       enum device_action action;
> +       const char *namespace;
> +       int rc;
> +};
> +
>  /*
>   * struct util_filter_ctx - control and callbacks for util_filter_walk()
>   * ->filter_bus() and ->filter_region() return bool because the
> @@ -67,6 +74,7 @@ struct util_filter_ctx {
>         union {
>                 void *arg;
>                 struct list_filter_arg *list;
> +               struct ndns_filter_arg *ndns;

This naming is throwing my brain for a loop because 'ndns' is the
abbreviation for 'struct namespace *' instances used everywhere else
in the code.  Let's call this type 'nsaction_filter_arg' and the
member instance as 'nsaction', or anything other than 'ndns'.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
