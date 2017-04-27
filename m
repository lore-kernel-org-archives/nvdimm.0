Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2688921951C90
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 08:44:33 -0700 (PDT)
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
 <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
 <20170427065338.GA20677@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3b7f3aba-d609-dca7-149f-107757d63fb0@deltatee.com>
Date: Thu, 27 Apr 2017 09:44:18 -0600
MIME-Version: 1.0
In-Reply-To: <20170427065338.GA20677@lst.de>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
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
To: Christoph Hellwig <hch@lst.de>
Cc: dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>



On 27/04/17 12:53 AM, Christoph Hellwig wrote:
> I think you'll need to follow the existing kmap semantics and never
> fail the iomem version either.  Otherwise you'll have a special case
> that's almost never used that has a different error path.
>
> Again, wrong way.  Suddenly making things fail for your special case
> that normally don't fail is a receipe for bugs.

I don't disagree but these restrictions make the problem impossible to
solve? If there is iomem behind a page in an SGL and someone tries to
map it, we either have to fail or we break iomem safety which was your
original concern.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
