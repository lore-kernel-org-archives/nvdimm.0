Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E1A68
	for <nvdimm@lists.linux.dev>; Thu,  9 Dec 2021 20:40:24 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so5803526pjq.4
        for <nvdimm@lists.linux.dev>; Thu, 09 Dec 2021 12:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbnZ/E4URHihgtZHF4wqH4/5cWskuEx8+U6VvgZmQXk=;
        b=jYdP8ut7OAkLsjT13nB0NrCaf8Vt3nhEFOVhNEKwp4ZyJXtR7C0m2JNfc6A2QBcD9H
         Do1fziV61QPuiBRifMS3vOYRiBpstfMnJtdOn7UuFVhekqWz/tHvC0XE10yhongh0kgS
         j5vU/Y/SgAjalYEPYThZr3FW/SmYqte2VlHwIqHzrCe/kOSmFOTaYJPPJWwN17jXM0mn
         fw2zZnFnPt7fKP0hhIEPSRtskRotBZGMFxEyzTSa+tC5VOw8Z6cpjhQzbX1EIgAvP4Gc
         zUpuo3eYIJaMt4Ru7stECN/HGsQ8N7+EX3+Sbonk0ckdOpuLfn59f079coCU7+z8QA9u
         b2gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbnZ/E4URHihgtZHF4wqH4/5cWskuEx8+U6VvgZmQXk=;
        b=7Vn2d2R36hMplVWh3Mfb7VtLbg0GiKHU+sV3Lvx3vgDyLT7SnwdTrxApbekhB3BzW1
         IH3iBFHS2yLzXmlbYAZ/tZq7aJyBwz8QVVM0yFhFcnlUs+DdMXz2kFBwFLXPz7R+bzaP
         CKgNR2n/LRpLnEeAV6w4cVBrtp4gDMrPx4l9VI0C9A9JcpWbKjC3e1H5pR0/maW5k8Cd
         /3SMWG3/G2JcolqVHBS8qfE2y8i39X7daVFamEF8XHRdKEs6ChMB4WXJfQUHne+wbjUd
         CmzRlVXFWFxAaOQlZT2aodQjQaVMXBzECKstcb2P7p5YH67TfjBcGqmlUmmGPYUJoo+a
         oZ+Q==
X-Gm-Message-State: AOAM530ZJxc8r727vbmsIsLfeu2mKNZm8IFIyg3zW/CtQ5eq4iMogn0D
	/ap1e6UrAQoZ4SNA7pHJh+wMrHcvUmYoFuu5v/jHgw==
X-Google-Smtp-Source: ABdhPJzeh5u2t+dJ13X9HlGpTj/a4Jy30c/oz5xsNaIdMp1ws38HqPRA/0oTQGBvT+5ii8RQTCnxLpnUm1Lo84Lk2gg=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
 s15-20020a170902a50f00b001437dec0567mr70599649plq.18.1639082423753; Thu, 09
 Dec 2021 12:40:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4g=Zc=KizTvVVeyA4gFJi=K8Amuok-kjBM6UqkVZHwd2g@mail.gmail.com>
 <20211209202337.3503757-1-vishal.l.verma@intel.com>
In-Reply-To: <20211209202337.3503757-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Dec 2021 12:40:12 -0800
Message-ID: <CAPcyv4hMzLsfCoKc7fD5NLNOfaRTddb42BVdhyN50PM3dSDM9w@mail.gmail.com>
Subject: Re: [ndctl PATCH v6] cxl: add a cxl utility and libcxl library
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 9, 2021 at 12:23 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> CXL - or Compute eXpress Link - is a new interconnect that extends PCIe
> to support a wide range of devices, including cache coherent memory
> expanders. As such, these devices can be new sources of 'persistent
> memory', and the 'ndctl' umbrella of tools and libraries needs to be able
> to interact with them.
>
> Add a new utility and library for managing these CXL memory devices. This
> is an initial bring-up for interacting with CXL devices, and only includes
> adding the utility and library infrastructure, parsing device information
> from sysfs for CXL devices, and providing a 'cxl-list' command to
> display this information in JSON formatted output.
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>
> Changes in v6:
> - Remove the cxl-list default of listing memdevs as we may want to list
>   regions by default, once that support is available. For now just error
>   out if memdevs are not explicitly asked for. (Dan)
>
>  Documentation/cxl/cxl-list.txt       |  64 +++++
>  Documentation/cxl/cxl.txt            |  34 +++
>  Documentation/cxl/human-option.txt   |   8 +
>  Documentation/cxl/verbose-option.txt |   5 +
>  configure.ac                         |   3 +
>  Makefile.am                          |   8 +-
>  Makefile.am.in                       |   4 +
>  cxl/lib/private.h                    |  29 +++
>  cxl/lib/libcxl.c                     | 345 +++++++++++++++++++++++++++
>  cxl/builtin.h                        |   8 +
>  cxl/libcxl.h                         |  55 +++++
>  util/filter.h                        |   2 +
>  util/json.h                          |   3 +
>  util/main.h                          |   3 +
>  cxl/cxl.c                            |  96 ++++++++
>  cxl/list.c                           | 121 ++++++++++
>  util/filter.c                        |  20 ++
>  util/json.c                          |  26 ++
>  .clang-format                        |   1 +
>  .gitignore                           |   4 +-
>  Documentation/cxl/Makefile.am        |  58 +++++
>  cxl/Makefile.am                      |  21 ++
>  cxl/lib/Makefile.am                  |  32 +++
>  cxl/lib/libcxl.pc.in                 |  11 +
>  cxl/lib/libcxl.sym                   |  25 ++
>  25 files changed, 982 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/cxl/cxl-list.txt
>  create mode 100644 Documentation/cxl/cxl.txt
>  create mode 100644 Documentation/cxl/human-option.txt
>  create mode 100644 Documentation/cxl/verbose-option.txt
>  create mode 100644 cxl/lib/private.h
>  create mode 100644 cxl/lib/libcxl.c
>  create mode 100644 cxl/builtin.h
>  create mode 100644 cxl/libcxl.h
>  create mode 100644 cxl/cxl.c
>  create mode 100644 cxl/list.c
>  create mode 100644 Documentation/cxl/Makefile.am
>  create mode 100644 cxl/Makefile.am
>  create mode 100644 cxl/lib/Makefile.am
>  create mode 100644 cxl/lib/libcxl.pc.in
>  create mode 100644 cxl/lib/libcxl.sym
>
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> new file mode 100644
> index 0000000..e761cfa
> --- /dev/null
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-list(1)
> +===========
> +
> +NAME
> +----
> +cxl-list - List CXL capable memory devices, and their attributes in json.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl list' [<options>]
> +
> +Walk the CXL capable device hierarchy in the system and list all device
> +instances along with some of their major attributes.
> +
> +Options can be specified to limit the output to specific memdevs.
> +By default, 'cxl list' with no options is equivalent to:
> +[verse]
> +cxl list --memdevs

With the default change these last 4 lines can be trimmed.

> +
> +EXAMPLE
> +-------
> +----
> +# cxl list --memdevs
> +{
> +  "memdev":"mem0",
> +  "pmem_size":268435456,
> +  "ram_size":0,
> +}
> +----
> +
> +OPTIONS
> +-------
> +-m::
> +--memdev=::
> +       Specify a cxl memory device name to filter the listing. For example:
> +----
> +# cxl list --memdev=mem0
> +{
> +  "memdev":"mem0",
> +  "pmem_size":268435456,
> +  "ram_size":0,
> +}
> +----
> +
> +-M::
> +--memdevs::
> +       Include all CXL memory devices in the listing

The -m is a filter so I think this can be: s/all//

> +
> +-i::
> +--idle::
> +       Include idle (not enabled / zero-sized) devices in the listing
> +
> +include::human-option.txt[]
> +
> +include::verbose-option.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:ndctl-list[1]
[..]
> diff --git a/cxl/list.c b/cxl/list.c
> new file mode 100644
> index 0000000..69201d9
> --- /dev/null
> +++ b/cxl/list.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2020-2021 Intel Corporation. All rights reserved. */
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <json-c/json.h>
> +#include <cxl/libcxl.h>
> +#include <util/parse-options.h>
> +#include <ccan/array_size/array_size.h>
> +
> +static struct {
> +       bool memdevs;
> +       bool idle;
> +       bool human;
> +} list;
> +
> +static unsigned long listopts_to_flags(void)
> +{
> +       unsigned long flags = 0;
> +
> +       if (list.idle)
> +               flags |= UTIL_JSON_IDLE;
> +       if (list.human)
> +               flags |= UTIL_JSON_HUMAN;
> +       return flags;
> +}
> +
> +static struct {
> +       const char *memdev;
> +} param;
> +
> +static int did_fail;
> +
> +#define fail(fmt, ...) \
> +do { \
> +       did_fail = 1; \
> +       fprintf(stderr, "cxl-%s:%s:%d: " fmt, \
> +                       VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +static int num_list_flags(void)
> +{
> +       return list.memdevs;
> +}
> +
> +int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +       const struct option options[] = {
> +               OPT_STRING('m', "memdev", &param.memdev, "memory device name",
> +                          "filter by CXL memory device name"),
> +               OPT_BOOLEAN('M', "memdevs", &list.memdevs,
> +                           "include CXL memory device info"),
> +               OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
> +               OPT_BOOLEAN('u', "human", &list.human,
> +                               "use human friendly number formats "),
> +               OPT_END(),
> +       };
> +       const char * const u[] = {
> +               "cxl list [<options>]",
> +               NULL
> +       };
> +       struct json_object *jdevs = NULL;
> +       unsigned long list_flags;
> +       struct cxl_memdev *memdev;
> +       int i;
> +
> +       argc = parse_options(argc, argv, options, u, 0);
> +       for (i = 0; i < argc; i++)
> +               error("unknown parameter \"%s\"\n", argv[i]);
> +
> +       if (argc)
> +               usage_with_options(u, options);
> +
> +       if (num_list_flags() == 0) {
> +               /*
> +                * TODO: We likely want to list regions by default if nothing
> +                * was explicitly asked for. But until we have region support,
> +                * print this error asking for devices explicitly.
> +                * Once region support is added, this TODO can be removed.
> +                */
> +               fprintf(stderr,

Should this be error() instead like the "unknown parameter" print above?

> +                       "please specify entities to list, e.g. using -m/-M\n");

Add a usage_with_options() call here to abort?
