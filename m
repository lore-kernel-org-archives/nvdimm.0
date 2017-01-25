Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x241.google.com (mail-ua0-x241.google.com
 [IPv6:2607:f8b0:400c:c08::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F3E2D81F81
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jan 2017 13:43:59 -0800 (PST)
Received: by mail-ua0-x241.google.com with SMTP id f2so20615346uaf.3
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jan 2017 13:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7780787.RVFXFXDN3H@morokweng>
References: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <7780787.RVFXFXDN3H@morokweng>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Jan 2017 13:43:58 -0800
Message-ID: <CAA9_cmc5gg39kDGcWRVzBd_9VaU8rTU1ZfHWu=01n7uTNKEkRA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/2] block: fix backing_dev_info lifetime
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
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Rabin Vincent <rabinv@axis.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Wei Fang <fangwei1@huawei.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 23, 2017 at 1:17 PM, Thiago Jung Bauermann
<bauerman@linux.vnet.ibm.com> wrote:
> Hello Dan,
>
> Am Freitag, 6. Januar 2017, 17:02:51 BRST schrieb Dan Williams:
>> v1 of these changes [1] was a one line change to bdev_get_queue() to
>> prevent a shutdown crash when del_gendisk() races the final
>> __blkdev_put().
>>
>> While it is known at del_gendisk() time that the queue is still alive,
>> Jan Kara points to other paths [2] that are racing __blkdev_put() where
>> the assumption that ->bd_queue, or inode->i_wb is valid does not hold.
>>
>> Fix that broken assumption, make it the case that if you have a live
>> block_device, or block_device-inode that the corresponding queue and
>> inode-write-back data is still valid.
>>
>> These changes survive a run of the libnvdimm unit test suite which puts
>> some stress on the block_device shutdown path.
>
> I realize that the kernel test robot found problems with this series, but FWIW
> it fixes the bug mentioned in [2].
>

Thanks for the test result. I might take a look at cleaning up the
test robot reports and resubmitting this approach unless Jan beats me
to the punch with his backing_devi_info lifetime change patches.

>> [2]: http://www.spinics.net/lists/linux-fsdevel/msg105153.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
