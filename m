Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7868
	for <nvdimm@lists.linux.dev>; Wed,  8 Dec 2021 05:12:15 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so3523772pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 07 Dec 2021 21:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U9Sm+CJj+k97c2G0Smxb6+UAPlWADPCiIL9dHkctAHo=;
        b=vaU8gj1feFuClW2Z6UMKFtOCODGZiaYDtUstYrXqS7au42szcbAIi2kyXk5vViHxFa
         RwKG9yEw1e0COtPjeMGZ58HuaRTqLj0GOXE7/q7i9J+NIla5djncLqdGUR/rFuZVuCDO
         JqBAhyV3YZdGDel246lmCZkMX2JpP3VvN+ABtz8+XINAYE8Hk2/jErC4VUEHA8dB5fhG
         ARr6RtX8EeZBEF2miwpZBhZt/3ifm/BBjz+8tdie04Scm8FjxWR1WPUOStFU5uM3V8qo
         /+j+IcQzNED+C6rRJ7K3eJNKJDW+HE/Yp5ZZszmPQYeXzOi1N2+fwjjHQfIh/U1eo05l
         Yw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U9Sm+CJj+k97c2G0Smxb6+UAPlWADPCiIL9dHkctAHo=;
        b=OYvZ3RKzbA1Br0PDr1+MfUFjSt36ymFOc5O02DCQd2vws/b8S0GV79zrAvV8Uir5bU
         8LEe7k2TdiXAinpqSJsf5eb9Lm9MlHa5zqhUtl2U/qewXyei7FK/8MyA4T5NflcRiA26
         SOE9uFjLT/YGZjRJkLgaCbNZ+L+Pb8llZalY3agDZSj2Nvc2Uzr5GFnekFbiZ0OJx/yl
         VEzOjHXqRQPFntkIDGr/hUXYz5l+AghlXytBYRDzEdKgtbdKsUgJT7Jb4mTSX9MTiVCr
         R9TZi7JGOwZuHceQdv6Tgm+ArY3a/+FafEauNxF+BhRqqXxMdckkRwO+nkLw6VMK5ooS
         H8Xg==
X-Gm-Message-State: AOAM533symHdltl3MUceKONBvCAq9qCbESwaliZz6fcgBVNqS4L9aCre
	dgkB1d4C5vOg/yH2e5mYziY4tvNuFyQOznMFyCE2lw==
X-Google-Smtp-Source: ABdhPJzny71lJbtdinrKM61/8j9NMWVL9fklbA7/j/YKiNIdhokDCNcxS3st0TVnv+CDtswukl5IdQLTi/dOCl1twZ4=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr4424098pjb.93.1638940335434;
 Tue, 07 Dec 2021 21:12:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211111204436.1560365-1-vishal.l.verma@intel.com> <20211111204436.1560365-3-vishal.l.verma@intel.com>
In-Reply-To: <20211111204436.1560365-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Dec 2021 21:12:04 -0800
Message-ID: <CAPcyv4g=Zc=KizTvVVeyA4gFJi=K8Amuok-kjBM6UqkVZHwd2g@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 02/16] cxl: add a cxl utility and libcxl library
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 11, 2021 at 12:45 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
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
[..]
> +int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
> +{
> +       const struct option options[] = {
> +               OPT_STRING('d', "memdev", &param.memdev, "memory device name",
> +                          "filter by CXL memory device name"),
> +               OPT_BOOLEAN('D', "memdevs", &list.memdevs,
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
> +       if (num_list_flags() == 0)
> +               list.memdevs = true;

It strikes me that we may regret this default. In the interest of
giving us flexibility to pick a new default later (i.e. to not grow
any maintenance dependencies on this default), let's fail for now if
no list options are specified. I expect "cxl list" to enumerate the
active and most relevant end user devices by default. For ndctl its
namespaces, but for cxl-cli I expect it should be regions by default
to show all the CXL address ranges. Likely it should be "--regions
--namespaces" by default since regions are the primary user relevant
devices for volatile memory and namespaces are the end user relevant
devices for persistent memory, but the "--regions" vs "--regions
--namespaces" decision can be made later.
