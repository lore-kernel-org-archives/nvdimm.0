Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41E2B81C5A
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:59:23 -0800 (PST)
Received: by mail-oi0-x22f.google.com with SMTP id y198so278587494oia.1
 for <linux-nvdimm@lists.01.org>; Fri, 02 Dec 2016 11:59:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480706479-21162-1-git-send-email-fabf@skynet.be>
References: <1480706479-21162-1-git-send-email-fabf@skynet.be>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Dec 2016 11:59:22 -0800
Message-ID: <CAPcyv4isyZ8GVw0ggu54+CD09WgGwB38gtw5jM1AWsE8KC_q3Q@mail.gmail.com>
Subject: Re: [PATCH 5/8 linux-next] libnvdimm: remove else after return in
 nsio_rw_bytes()
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

On Fri, Dec 2, 2016 at 11:21 AM, Fabian Frederick <fabf@skynet.be> wrote:
> else after return is not needed.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/nvdimm/claim.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index d5dc80c..c0c113e 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -238,11 +238,10 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>                 if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
>                         return -EIO;
>                 return memcpy_from_pmem(buf, nsio->addr + offset, size);
> -       } else {
> -               memcpy_to_pmem(nsio->addr + offset, buf, size);
> -               nvdimm_flush(to_nd_region(ndns->dev.parent));
>         }
>
> +       memcpy_to_pmem(nsio->addr + offset, buf, size);
> +       nvdimm_flush(to_nd_region(ndns->dev.parent));
>         return 0;
>  }

Looks good, but this collides with

commit 82bf1037f2cab2d6960a08ae08513f2c3c0b335a
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Nov 11 12:37:36 2016 -0700

    libnvdimm: check and clear poison before writing to pmem

    We need to clear any poison when we are writing to pmem. The granularity
    will be sector size. If it's less then we can't do anything about it
    barring corruption.

    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
    [djbw: fixup 0-length write request to succeed]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Can you respin this on top of libnvdimm-pending?

https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
