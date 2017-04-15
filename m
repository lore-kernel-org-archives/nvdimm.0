Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x241.google.com (mail-qt0-x241.google.com
 [IPv6:2607:f8b0:400d:c0d::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A10FA2194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 21:53:34 -0700 (PDT)
Received: by mail-qt0-x241.google.com with SMTP id r49so13182309qta.1
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 21:53:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1492121135-4437-9-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-9-git-send-email-logang@deltatee.com>
From: Harsh Jain <harshjain.prof@gmail.com>
Date: Sat, 15 Apr 2017 10:23:33 +0530
Message-ID: <CAFXBA=k74+9jRZQX4r_iGoL8yiDbXPDTLw+AELEb1LeT_jeKiQ@mail.gmail.com>
Subject: Re: [PATCH 08/22] crypto: chcr: Make use of the new sg_map helper
 function
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
To: Logan Gunthorpe <logang@deltatee.com>, harsh@chelsio.com
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 14, 2017 at 3:35 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> The get_page in this area looks *highly* suspect due to there being no
> corresponding put_page. However, I've left that as is to avoid breaking
> things.
chcr driver will post the request to LLD driver cxgb4 and put_page is
implemented there. it will no harm. Any how
we have removed the below code from driver.

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg24561.html

After this merge we can ignore your patch. Thanks

>
> I've also removed the KMAP_ATOMIC_ARGS check as it appears to be dead
> code that dates back to when it was first committed...


>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 41bc7f4..a993d1d 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -1489,22 +1489,21 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
>         return ERR_PTR(-EINVAL);
>  }
>
> -static void aes_gcm_empty_pld_pad(struct scatterlist *sg,
> -                                 unsigned short offset)
> +static int aes_gcm_empty_pld_pad(struct scatterlist *sg,
> +                                unsigned short offset)
>  {
> -       struct page *spage;
>         unsigned char *addr;
>
> -       spage = sg_page(sg);
> -       get_page(spage); /* so that it is not freed by NIC */
> -#ifdef KMAP_ATOMIC_ARGS
> -       addr = kmap_atomic(spage, KM_SOFTIRQ0);
> -#else
> -       addr = kmap_atomic(spage);
> -#endif
> -       memset(addr + sg->offset, 0, offset + 1);
> +       get_page(sg_page(sg)); /* so that it is not freed by NIC */
> +
> +       addr = sg_map(sg, SG_KMAP_ATOMIC);
> +       if (IS_ERR(addr))
> +               return PTR_ERR(addr);
> +
> +       memset(addr, 0, offset + 1);
> +       sg_unmap(sg, addr, SG_KMAP_ATOMIC);
>
> -       kunmap_atomic(addr);
> +       return 0;
>  }
>
>  static int set_msg_len(u8 *block, unsigned int msglen, int csize)
> @@ -1940,7 +1939,10 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
>         if (req->cryptlen) {
>                 write_sg_to_skb(skb, &frags, src, req->cryptlen);
>         } else {
> -               aes_gcm_empty_pld_pad(req->dst, authsize - 1);
> +               err = aes_gcm_empty_pld_pad(req->dst, authsize - 1);
> +               if (err)
> +                       goto dstmap_fail;
> +
>                 write_sg_to_skb(skb, &frags, reqctx->dst, crypt_len);
>
>         }
> --
> 2.1.4
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
