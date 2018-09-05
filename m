Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3773121959CB2
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 12:33:48 -0700 (PDT)
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
 <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <1b4283da-44df-4a02-3167-e295243cef78@deltatee.com>
Date: Wed, 5 Sep 2018 13:33:23 -0600
MIME-Version: 1.0
In-Reply-To: <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
Content-Language: en-US
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
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
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 05/09/18 01:26 PM, Jens Axboe wrote:
> On 9/3/18 4:26 PM, Logan Gunthorpe wrote:
>> I personally agree with Christoph. But if there's consensus in the other
>> direction or this is a real blocker moving this forward, I can remove it
>> for the next version.
> 
> It's a simple branch because the check isn't exhaustive. It just checks
> the first page. At that point you may as well just require the caller to
> flag the bio/rq as being P2P, and then do a check for P2P compatibility
> with the queue.

Hmm, we had something like that in v4[1] but it just seemed redundant to
create a flag when the information was already in the bio and kind of
ugly for the caller to check for, then set, the flag. I'm not _that_
averse to going back to that though...

Logan

[1]
https://lore.kernel.org/lkml/20180423233046.21476-8-logang@deltatee.com/T/#u
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
