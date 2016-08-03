Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 83DCC1A1DF5
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 07:12:53 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id 4so72002864oih.2
 for <linux-nvdimm@lists.01.org>; Wed, 03 Aug 2016 07:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1470232916-82917-1-git-send-email-jthumshirn@suse.de>
References: <1470232916-82917-1-git-send-email-jthumshirn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Aug 2016 07:12:51 -0700
Message-ID: <CAPcyv4iWknDGXGsbOFutvWxxhC+reMBMfGYO01R5+_MCBHXd5A@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix memory leak in error path.
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NVDIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 3, 2016 at 7:01 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> If either device_register() or nvdimm_bus_create_ndclt() fails we leak the
> memory allocated for nvdimm_bus. Call kfree(nvdimm_bus) in the error path so
> it's not leaked.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/nvdimm/core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index be89764..8578365 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -366,6 +366,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
>         return nvdimm_bus;
>   err:
>         put_device(&nvdimm_bus->dev);
> +       kfree(nvdimm_bus);
>         return NULL;
>  }
>  EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
> --

This routine as moved to drivers/nvdimm/bus.c and I don't think this
is valid since device_register() initialize the reference count, and
the call to put_device() will trigger nvdimm_bus_release().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
