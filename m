Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 099D721A6F107
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 09:54:10 -0700 (PDT)
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-8-git-send-email-logang@deltatee.com>
 <20170427035603.GA32212@gondor.apana.org.au>
 <94123cbf-3287-f05e-7267-0bcf08ab0a8b@deltatee.com>
 <20170428063039.GB6817@gondor.apana.org.au>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5a08708b-c3b8-41fe-96de-607a109eacbd@deltatee.com>
Date: Fri, 28 Apr 2017 10:53:45 -0600
MIME-Version: 1.0
In-Reply-To: <20170428063039.GB6817@gondor.apana.org.au>
Subject: Re: [PATCH v2 07/21] crypto: shash, caam: Make use of the new sg_map
 helper function
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>



On 28/04/17 12:30 AM, Herbert Xu wrote:
> You are right.  Indeed the existing code looks buggy as they
> don't take sg->offset into account when doing the kmap.  Could
> you send me some patches that fix these problems first so that
> they can be easily backported?

Ok, I think the only buggy one in crypto is hifn_795x. Shash and caam
both do have the sg->offset accounted for. I'll send a patch for the
buggy one shortly.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
