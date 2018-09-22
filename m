Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FDAE211546FA
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 17:24:34 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c12-v6so14692017otl.6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 17:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20180919125848.6570-1-pagupta@redhat.com>
In-Reply-To: <20180919125848.6570-1-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 17:24:21 -0700
Message-ID: <CAPcyv4hnFHySmhiBeiYKNsCq0xmbqOXp6LWvUpnGHo+zAA=TUg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: remove duplicate include
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: zwisler@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 19, 2018 at 5:59 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> Removed duplicate include.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/nvdimm/nd-core.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index ac68072fb8cd..182258f64417 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -14,7 +14,6 @@
>  #define __ND_CORE_H__
>  #include <linux/libnvdimm.h>
>  #include <linux/device.h>
> -#include <linux/libnvdimm.h>
>  #include <linux/sizes.h>
>  #include <linux/mutex.h>
>  #include <linux/nd.h>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
