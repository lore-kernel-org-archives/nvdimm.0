Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED77621F6A6E6
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 11:15:05 -0800 (PST)
Received: by mail-oi0-x22f.google.com with SMTP id c12so5326831oic.7
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 11:21:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519876569.4592.4.camel@au1.ibm.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Mar 2018 11:21:13 -0800
Message-ID: <CAPcyv4h7mcFphv3j_vW-CGxXa2pjQgLqpBOLzHuTzAFzygai-Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
To: benh@au1.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 28, 2018 at 7:56 PM, Benjamin Herrenschmidt
<benh@au1.ibm.com> wrote:
> On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
>> On Wed, 2018-02-28 at 16:39 -0700, Logan Gunthorpe wrote:
>> > Hi Everyone,
>>
>>
>> So Oliver (CC) was having issues getting any of that to work for us.
>>
>> The problem is that acccording to him (I didn't double check the latest
>> patches) you effectively hotplug the PCIe memory into the system when
>> creating struct pages.
>>
>> This cannot possibly work for us. First we cannot map PCIe memory as
>> cachable. (Note that doing so is a bad idea if you are behind a PLX
>> switch anyway since you'd ahve to manage cache coherency in SW).
>
> Note: I think the above means it won't work behind a switch on x86
> either, will it ?

The devm_memremap_pages() infrastructure allows placing the memmap in
"System-RAM" even if the hotplugged range is in PCI space. So, even if
it is an issue on some configurations, it's just a simple adjustment
to where the memmap is placed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
