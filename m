Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FECB81EEA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 13:17:30 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v0NLDf2E090383
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 16:17:29 -0500
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
 by mx0a-001b2d01.pphosted.com with ESMTP id 285m63pbjt-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 16:17:29 -0500
Received: from localhost
 by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <bauerman@linux.vnet.ibm.com>;
 Mon, 23 Jan 2017 19:17:27 -0200
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
 by d24dlp01.br.ibm.com (Postfix) with ESMTP id 3E7883520068
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 16:16:53 -0500 (EST)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
 by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 v0NLHPQT36044894
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 19:17:25 -0200
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
 by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 v0NLHOxU029626
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 19:17:25 -0200
From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 0/2] block: fix backing_dev_info lifetime
Date: Mon, 23 Jan 2017 19:17:21 -0200
In-Reply-To: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Message-Id: <7780787.RVFXFXDN3H@morokweng>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Rabin Vincent <rabinv@axis.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Wei Fang <fangwei1@huawei.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hello Dan,

Am Freitag, 6. Januar 2017, 17:02:51 BRST schrieb Dan Williams:
> v1 of these changes [1] was a one line change to bdev_get_queue() to
> prevent a shutdown crash when del_gendisk() races the final
> __blkdev_put().
> 
> While it is known at del_gendisk() time that the queue is still alive,
> Jan Kara points to other paths [2] that are racing __blkdev_put() where
> the assumption that ->bd_queue, or inode->i_wb is valid does not hold.
> 
> Fix that broken assumption, make it the case that if you have a live
> block_device, or block_device-inode that the corresponding queue and
> inode-write-back data is still valid.
> 
> These changes survive a run of the libnvdimm unit test suite which puts
> some stress on the block_device shutdown path.

I realize that the kernel test robot found problems with this series, but FWIW 
it fixes the bug mentioned in [2].

> [1]: http://marc.info/?l=linux-block&m=148366637105761&w=2
> [2]: http://www.spinics.net/lists/linux-fsdevel/msg105153.html

-- 
Thiago Jung Bauermann
IBM Linux Technology Center

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
