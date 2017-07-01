Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x231.google.com (mail-yw0-x231.google.com
 [IPv6:2607:f8b0:4002:c05::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E815421A00AD4
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:37:50 -0700 (PDT)
Received: by mail-yw0-x231.google.com with SMTP id a12so7139539ywh.3
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:39:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170701003252.13171-2-vishal.l.verma@intel.com>
References: <20170701003252.13171-1-vishal.l.verma@intel.com>
 <20170701003252.13171-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 18:39:24 -0700
Message-ID: <CAPcyv4jz_zOGieP+TeF0yPUMBgh1qDkFoms2W4g=+hN1-SZcBw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix the clear-error check in nsio_rw_bytes
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 30, 2017 at 5:32 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> A leftover from the 'bandaid' fix that disabled BTT error clearing in
> rw_bytes resulted in an incorrect check. After we converted these checks
> over to use the NVDIMM_IO_ATOMIC flag, the ndns->claim check was both
> redundant, and incorrect. Remove it.
>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/claim.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 8d23f68..f8ad92b 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -289,8 +289,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>                  * work around this collision.
>                  */
>                 if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
> -                               && !(flags & NVDIMM_IO_ATOMIC)
> -                               && !ndns->claim) {
> +                               && !(flags & NVDIMM_IO_ATOMIC)) {

Should this also go to -stable otherwise we won't clear errors on pmem
devices claimed by 'pfn' instances, right?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
