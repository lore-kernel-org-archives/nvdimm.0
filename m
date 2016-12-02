Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B410C81F51
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:45:28 -0800 (PST)
Received: by mail-oi0-x232.google.com with SMTP id w63so278114591oiw.0
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 11:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706397-20954-1-git-send-email-fabf@skynet.be>
References: <1480706397-20954-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 11:45:27 -0800
Message-ID: <CAPcyv4jWW+-uH-TE1wbe9eFdb0TYmubLvG6ONTKETgNZqoK+KA@mail.gmail.com>
Subject: Re: [PATCH 1/8 linux-next] libnvdimm, namespace: update message level
 on smaller reservations
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
To: Fabian Frederick <fabf@skynet.be>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 2, 2016 at 11:19 AM, Fabian Frederick <fabf@skynet.be> wrote:
> kernel command lines like memmap=1M!512M gave no pmem outputs
> without debugging.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/namespace_devs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index abe5c6b..b00045b 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1532,8 +1532,8 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
>
>         size = nvdimm_namespace_capacity(ndns);
>         if (size < ND_MIN_NAMESPACE_SIZE) {
> -               dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
> -                               &size, ND_MIN_NAMESPACE_SIZE);
> +               dev_warn(&ndns->dev, "%pa, too small must be at least %#x\n",
> +                        &size, ND_MIN_NAMESPACE_SIZE);

This is too noisy as it will fire every time a new namespace is
created since they always start out zero-sized.  I'd recommend booting
with libnvdimm.dyndbg on the kernel command or something similar.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
