Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB24421DFA7A9
 for <linux-nvdimm@lists.01.org>; Sun,  2 Apr 2017 21:26:21 -0700 (PDT)
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
 <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
 <f0448277-9381-5c3d-d194-1efa1d1b44a6@codeaurora.org>
 <63d73995-4dfa-6270-ca13-972e0628011b@deltatee.com>
 <bed80d4e-7709-5991-498e-0ac361ca96a6@codeaurora.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ef507444-d3e5-0454-86a0-b5c4ae4b4dd9@deltatee.com>
Date: Sun, 2 Apr 2017 22:26:08 -0600
MIME-Version: 1.0
In-Reply-To: <bed80d4e-7709-5991-498e-0ac361ca96a6@codeaurora.org>
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
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
To: Sinan Kaya <okaya@codeaurora.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 02/04/17 03:03 PM, Sinan Kaya wrote:
> Push the decision all the way to the user. Let them decide whether they
> want this feature to work on a root port connected port or under the
> switch.

Yes, I prefer this too. If other folks agree with that I'd be very happy
to go back to user chooses. I think Sagi was the most vocal proponent
for kernel chooses at LSF so hopefully he will read this thread and
offer some opinion.

> I thought the issue was feature didn't work at all with some root ports
> or there was some kind of memory corruption issue that you were trying to
> avoid with the existing systems.

I *think* there are some much older root ports where P2P TLPs don't even
get through. But it doesn't really change the situation: in the nvmet
case, the user would enable p2pmem and then be unable to connect and
thus choose to disable it going forward. Not a big difference from the
user seeing bad performance and not choosing to enable it.

> I think you should get rid of all pci searching business in your code.

Yes, my original proposal was when you configure the nvme target you
chose the specific p2pmem device to use. That code had no tie ins to PCI
code and could, in theory, work generically with any device and bus.

Logan


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
