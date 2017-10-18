Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBBF4202E60E0
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 09:09:20 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id a132so9838273oih.11
 for <linux-nvdimm@lists.01.org>; Wed, 18 Oct 2017 09:12:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171018154006.15431-2-ross.zwisler@linux.intel.com>
References: <20171018154006.15431-1-ross.zwisler@linux.intel.com>
 <20171018154006.15431-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Oct 2017 09:12:56 -0700
Message-ID: <CAPcyv4hn0xV8yy_p=Qpa3X5L9F2aMTaRECm=Ogyd3hVzqCmeaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Add entry for device DAX
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 18, 2017 at 8:40 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> And update the entry for filesystem DAX to differentiate them.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  MAINTAINERS | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a74227a..b2b2e75 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4162,7 +4162,7 @@ L:        linux-i2c@vger.kernel.org
>  S:     Maintained
>  F:     drivers/i2c/busses/i2c-diolan-u2c.c
>
> -DIRECT ACCESS (DAX)
> +FILESYSTEM DIRECT ACCESS (DAX)
>  M:     Matthew Wilcox <mawilcox@microsoft.com>
>  M:     Ross Zwisler <ross.zwisler@linux.intel.com>
>  L:     linux-fsdevel@vger.kernel.org
> @@ -4171,6 +4171,12 @@ F:       fs/dax.c
>  F:     include/linux/dax.h
>  F:     include/trace/events/fs_dax.h
>
> +DEVICE DIRECT ACCESS (DAX)
> +M:     Dan Williams <dan.j.williams@intel.com>
> +L:     linux-nvdimm@lists.01.org
> +S:     Supported
> +F:     drivers/dax/
> +

I guess I had a good run hiding from get_maintainers.pl...

Applied for 4.15.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
