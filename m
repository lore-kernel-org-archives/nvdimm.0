Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EFB32194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 08:34:50 -0700 (PDT)
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-2-git-send-email-logang@deltatee.com>
 <20170414083518.GA25471@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <18f05078-5b2c-2e9b-c8ad-e23c02942b58@deltatee.com>
Date: Fri, 14 Apr 2017 09:34:28 -0600
MIME-Version: 1.0
In-Reply-To: <20170414083518.GA25471@lst.de>
Subject: Re: [PATCH 01/22] scatterlist: Introduce sg_map helper functions
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



On 14/04/17 02:35 AM, Christoph Hellwig wrote:
>> +
>>  static inline int is_dma_buf_file(struct file *);
>>  
>>  struct dma_buf_list {
> 
> I think the right fix here is to rename the operation to unmap_atomic
> and send out a little patch for that ASAP.

Ok, I can do that next week.

> I'd rather have separate functions for kmap vs kmap_atomic instead of
> the flags parameter.  And while you're at it just always pass the 0
> offset parameter instead of adding a wrapper..
> 
> Otherwise this looks good to me.

I settled on the flags because I thought the interface could be expanded
to do more things like automatically copy iomem to a bounce buffer (with
a flag). It'd also be possible to add things like vmap and
physical_address to the interface which would cover even more sg_page
users. All the implementations would then share the common offset
calculations, and switching between them becomes a matter of changing a
couple flags.

If you're still not convinced by the above arguments  then I'll change
it but I did have reasons for choosing to do it this way.

I am fine with removing the offset versions. I will make that change.

Thanks,

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
