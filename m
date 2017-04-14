Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77C722194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 09:03:57 -0700 (PDT)
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-10-git-send-email-logang@deltatee.com>
 <20170414083921.GC25471@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <302ae5ab-d515-5427-2e54-d58a9cdb8241@deltatee.com>
Date: Fri, 14 Apr 2017 10:03:43 -0600
MIME-Version: 1.0
In-Reply-To: <20170414083921.GC25471@lst.de>
Subject: Re: [PATCH 09/22] dm-crypt: Make use of the new sg_map helper in 4
 call sites
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
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 14/04/17 02:39 AM, Christoph Hellwig wrote:
> On Thu, Apr 13, 2017 at 04:05:22PM -0600, Logan Gunthorpe wrote:
>> Very straightforward conversion to the new function in all four spots.
> 
> I think the right fix here is to switch dm-crypt to the ahash API
> that takes a scatterlist.

Hmm, well I'm not sure I understand the code enough to make that
conversion. But I was looking at it. One tricky bit seems to be that
crypt_iv_lmk_one adds a seed, skips the first 16 bytes in the page and
then hashes another 16 bytes from other data. What would you do
construct a new sgl for it and pass it to the ahash api?

The other thing is crypt_iv_lmk_post also seems to modify the page after
the hash with a  crypto_xor so you'd still need at least one kmap in there.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
