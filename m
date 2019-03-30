Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D19A211CFBE9
 for <linux-nvdimm@lists.01.org>; Sat, 30 Mar 2019 08:33:17 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id 3so3982445oir.7
 for <linux-nvdimm@lists.01.org>; Sat, 30 Mar 2019 08:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190330054205.28005-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190330054205.28005-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Mar 2019 08:33:05 -0700
Message-ID: <CAPcyv4h60V+1pnsF28AJQrFjNbU2jp6G+wVeEucxVbo-RETXOg@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers/dax: Allow to include DEV_DAX_PMEM as builtin
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 29, 2019 at 10:42 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> This move the dependency to DEV_DAX_PMEM_COMPAT such that only
> if DEV_DAX_PMEM is built as module we can allow the compat support.
>
> This allows to test the new code easily in a emulation setup where we
> often build things without module support.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/dax/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index 5ef624fe3934..e582e088b48c 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -23,7 +23,6 @@ config DEV_DAX
>  config DEV_DAX_PMEM
>         tristate "PMEM DAX: direct access to persistent memory"
>         depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
> -       depends on m # until we can kill DEV_DAX_PMEM_COMPAT
>         default DEV_DAX
>         help
>           Support raw access to persistent memory.  Note that this
> @@ -50,7 +49,7 @@ config DEV_DAX_KMEM
>
>  config DEV_DAX_PMEM_COMPAT
>         tristate "PMEM DAX: support the deprecated /sys/class/dax interface"
> -       depends on DEV_DAX_PMEM
> +       depends on DEV_DAX_PMEM=m

Looks ok, just also a needs a "depends on m" here, because
DEV_DAX_PMEM_COMPAT=y is an invalid config.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
