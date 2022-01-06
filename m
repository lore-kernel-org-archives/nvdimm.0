Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220C42C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:35:15 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id g22so3727249pgn.1
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 13:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=35ojMSYwIvgEsuuGh69OMMKtHULIXG00CitHuqBTcw0=;
        b=CJEBeAj/nZWT2MyfajUj9d2s1ZNjDMgp0T+HRxUZv2U/LaZ3OGoHXnb7/m6wzcjPji
         OjqaFPBzP2MsuTEj0UiEXIqxX89q/p3uo98F86XilDAjxOydTvB+99EFbnE3q7DSswmL
         rkpBuwnduQc57lygATBnvSV36BWHhihdG1sErEA6YfY5GBoXnsKndIpH/IeLjh2Aq97I
         jEF/8wBSm2qVSOW54Ku5HH3PxzKjtwQJPUGIRRqGnPB/L35bcu6S92/bq2O8NCjByYe6
         GmuFjvAffH0OJtE5xEkSXWYQJsHkH958VIcf8fMnKUzs79E8CvO28AZJ5HlfR3O66yAV
         FlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=35ojMSYwIvgEsuuGh69OMMKtHULIXG00CitHuqBTcw0=;
        b=3YjFdEyr6i37cg8m6+LWhXcP8DNgRDCM8ICwArbpolCmvFQqaeSlvPYt80Sif/02F2
         vPX2VjbtW+MhGtuMNF4QNe4CRDec4cPhiFx8DMsJk6Co/nIdP8dTHnNbDHto/EmEjoaQ
         9BH+lO6pzCsTS/ZSWjbA+wCeZwAo1vnfe3GBIoIAwwObpaNcHvvuRFkoQaQ0DSQKl+Wz
         nuzP1Au3tvsIdv/mGgPsPQr3sRbTYZICROA43RlN1WDc3zjGL3hz2SoMVzHBtbyP7hkB
         mVc4jWilVasfqlpq6UcIPc+u3c2rQsG8cU2sWxBOLbd9cBWTZe3KNjVfIEBAADvMoqua
         83Jg==
X-Gm-Message-State: AOAM533VRaEqAYHGVrl2kkFndi3gbpG9Q4RxRdVV1SzfilZs44QMqETl
	shK85Kuof0Or8u6s/KxGFIsPTXQui6nvuolvpoEWCw==
X-Google-Smtp-Source: ABdhPJwmEX2g8BALD4pA29y6kZXZUB42q8MmTye6C59853IQD0o9PptQhGPOlN7Pz67lmoA5szSS02j8S21CetF1YA8=
X-Received: by 2002:a63:ab01:: with SMTP id p1mr5889471pgf.437.1641504914623;
 Thu, 06 Jan 2022 13:35:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1641233076.git.alison.schofield@intel.com> <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
In-Reply-To: <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 13:35:03 -0800
Message-ID: <CAPcyv4iPJb8AGOcgW5ncid2GTtft5UzxmXWD4U8bNn1JCCMaLA@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> The command 'cxl set-partition-info' operates on a CXL memdev,
> or a set of memdevs, allowing the user to change the partition
> layout of the device.
>
> Synopsis:
> Usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]
>
>     -v, --verbose         turn on debug
>     -s, --volatile_size <n>
>                           next volatile partition size in bytes
>
> The MAN page explains how to find partitioning capabilities and
> restrictions.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
[..]
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 5ee38e5..fa63317 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -6,6 +6,7 @@
>  #include <unistd.h>
>  #include <limits.h>
>  #include <util/log.h>
> +#include <util/size.h>
>  #include <util/filter.h>
>  #include <cxl/libcxl.h>
>  #include <util/parse-options.h>
> @@ -23,6 +24,7 @@ static struct parameters {
>         unsigned len;
>         unsigned offset;
>         bool verbose;
> +       unsigned long long volatile_size;

This should be a string.

See parse_size64() that handles suffixes like K,M,G,T, so you can do
things like "cxl set-partition -s 256M" and behave like the other
"--size" options in ndctl.
