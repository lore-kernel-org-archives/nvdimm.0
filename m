Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE3E381FAE
 for <linux-nvdimm@lists.01.org>; Thu, 26 Jan 2017 05:17:59 -0800 (PST)
Date: Thu, 26 Jan 2017 14:17:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH v2 0/2] block: fix backing_dev_info lifetime
Message-ID: <20170126131756.GA18649@lst.de>
References: <148375097100.37020.495735345355345658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <7780787.RVFXFXDN3H@morokweng>
 <CAA9_cmc5gg39kDGcWRVzBd_9VaU8rTU1ZfHWu=01n7uTNKEkRA@mail.gmail.com>
 <20170126100653.GB17099@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170126100653.GB17099@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Rabin Vincent <rabinv@axis.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>, Wei Fang <fangwei1@huawei.com>, Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 26, 2017 at 11:06:53AM +0100, Jan Kara wrote:
> Yeah, so my patches (and I suspect your as well), have a problem when the
> backing_device_info stays around because blkdev inode still exists, device
> gets removed (e.g. USB disk gets unplugged) but blkdev inode still stays
> around (there doesn't appear to be anything that would be forcing blkdev
> inode out of cache on device removal and there cannot be because different
> processes may hold inode reference) and then some other device gets plugged
> in and reuses the same MAJOR:MINOR combination. Things get awkward there, I
> think we need to unhash blkdev inode on device removal but so far I didn't
> make this work...

The other option is to simply not release the dev_t until the backing_dev
is gone.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
