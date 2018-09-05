Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28AC82111FE4C
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 12:26:56 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id h23-v6so10971053ita.5
 for <linux-nvdimm@lists.01.org>; Wed, 05 Sep 2018 12:26:55 -0700 (PDT)
Subject: Re: [PATCH v5 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
References: <20180830185352.3369-1-logang@deltatee.com>
 <20180830185352.3369-8-logang@deltatee.com>
 <b5ab8fa3-34ac-3117-fa0d-5206c3939435@kernel.dk>
 <20180901082812.GB670@lst.de>
 <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <59b28977-8f2a-6228-2050-03fae6bdbedd@kernel.dk>
Date: Wed, 5 Sep 2018 13:26:51 -0600
MIME-Version: 1.0
In-Reply-To: <5f79c012-c6e1-56bb-62fd-0689181fb2c9@deltatee.com>
Content-Language: en-US
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
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On 9/3/18 4:26 PM, Logan Gunthorpe wrote:
> 
> 
> On 01/09/18 02:28 AM, Christoph Hellwig wrote:
>> On Thu, Aug 30, 2018 at 01:11:18PM -0600, Jens Axboe wrote:
>>> I think this belongs in the caller - both the validity check, and
>>> passing in NOMERGE for this type of request. I don't want to impose
>>> this overhead on everything, for a pretty niche case.
>>
>> It is just a single branch, which will be predicted as not taken
>> for non-P2P users.  The benefit is that we get proper error checking
>> by doing it in the block code.
> 
> I personally agree with Christoph. But if there's consensus in the other
> direction or this is a real blocker moving this forward, I can remove it
> for the next version.

It's a simple branch because the check isn't exhaustive. It just checks
the first page. At that point you may as well just require the caller to
flag the bio/rq as being P2P, and then do a check for P2P compatibility
with the queue.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
