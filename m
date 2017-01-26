Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9733C81F55
 for <linux-nvdimm@lists.01.org>; Thu, 26 Jan 2017 08:39:55 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id w204so141530605oiw.0
 for <linux-nvdimm@lists.01.org>; Thu, 26 Jan 2017 08:39:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170126131756.GA18649@lst.de>
References: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <7780787.RVFXFXDN3H@morokweng>
 <CAA9_cmc5gg39kDGcWRVzBd_9VaU8rTU1ZfHWu=01n7uTNKEkRA@mail.gmail.com>
 <20170126100653.GB17099@quack2.suse.cz> <20170126131756.GA18649@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Jan 2017 08:39:54 -0800
Message-ID: <CAPcyv4gWnNsQmrPkWRW6WnJ2Ac3n4x-MkO8sdLZqTW7S77rgXw@mail.gmail.com>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, Jan Kara <jack@suse.cz>, Rabin Vincent <rabinv@axis.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>, Wei Fang <fangwei1@huawei.com>, Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 26, 2017 at 5:17 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Jan 26, 2017 at 11:06:53AM +0100, Jan Kara wrote:
>> Yeah, so my patches (and I suspect your as well), have a problem when the
>> backing_device_info stays around because blkdev inode still exists, device
>> gets removed (e.g. USB disk gets unplugged) but blkdev inode still stays
>> around (there doesn't appear to be anything that would be forcing blkdev
>> inode out of cache on device removal and there cannot be because different
>> processes may hold inode reference) and then some other device gets plugged
>> in and reuses the same MAJOR:MINOR combination. Things get awkward there, I
>> think we need to unhash blkdev inode on device removal but so far I didn't
>> make this work...
>
> The other option is to simply not release the dev_t until the backing_dev
> is gone.

I came to a similar conclusion here:

   https://marc.info/?l=linux-scsi&m=147103737421897&w=4

James had some concerns, but I think its now clear this problem is
bigger than something we can fix locally in scsi.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
