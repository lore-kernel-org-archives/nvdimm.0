Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from deadmen.hmeau.com (unknown [198.176.57.175])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F048721951C80
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 20:57:07 -0700 (PDT)
Date: Thu, 27 Apr 2017 11:56:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 07/21] crypto: shash, caam: Make use of the new sg_map
 helper function
Message-ID: <20170427035603.GA32212@gondor.apana.org.au>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-8-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1493144468-22493-8-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 12:20:54PM -0600, Logan Gunthorpe wrote:
> Very straightforward conversion to the new function in the caam driver
> and shash library.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  crypto/shash.c                | 9 ++++++---
>  drivers/crypto/caam/caamalg.c | 8 +++-----
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/crypto/shash.c b/crypto/shash.c
> index 5e31c8d..5914881 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -283,10 +283,13 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>  	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
>  		void *data;
>  
> -		data = kmap_atomic(sg_page(sg));
> -		err = crypto_shash_digest(desc, data + offset, nbytes,
> +		data = sg_map(sg, 0, SG_KMAP_ATOMIC);
> +		if (IS_ERR(data))
> +			return PTR_ERR(data);
> +
> +		err = crypto_shash_digest(desc, data, nbytes,
>  					  req->result);
> -		kunmap_atomic(data);
> +		sg_unmap(sg, data, 0, SG_KMAP_ATOMIC);
>  		crypto_yield(desc->flags);
>  	} else
>  		err = crypto_shash_init(desc) ?:

Nack.  This is an optimisation for the special case of a single
SG list entry.  In fact in the common case the kmap_atomic should
disappear altogether in the no-highmem case.  So replacing it
with sg_map is not acceptable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
