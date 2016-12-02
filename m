Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B76881F47
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 12:53:36 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id w63so280025546oiw.0
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 12:53:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706413-21004-1-git-send-email-fabf@skynet.be>
References: <1480706413-21004-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 12:53:34 -0800
Message-ID: <CAPcyv4hLrOVfGiZ5Y1QVLY2rkTHcGQqF1n4V5wqvKnE6qghueA@mail.gmail.com>
Subject: Re: [PATCH 2/8 linux-next] libnvdimm, namespace: add verbosity to
 persistence warning
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

On Fri, Dec 2, 2016 at 11:20 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/pmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 2461843..822a712 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -267,7 +267,7 @@ static int pmem_attach_disk(struct device *dev,
>         pmem->phys_addr = res->start;
>         pmem->size = resource_size(res);
>         if (nvdimm_has_flush(nd_region) < 0)
> -               dev_warn(dev, "unable to guarantee persistence of writes\n");
> +               dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");

I'll pass on this one. Another reason could be that the flushing
capability is present but disabled.  Just seeing it's not guaranteed
is sufficient.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
