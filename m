Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670138.outbound.protection.outlook.com [40.107.67.138])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E096A224E692A
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 10:03:51 -0800 (PST)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Thu, 1 Mar 2018 18:09:58 +0000
Message-ID: <B4151146-0490-40D4-BB0A-4FC9DE5841A4@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
In-Reply-To: <1519876569.4592.4.camel@au1.ibm.com>
Content-Language: en-US
Content-ID: <BE9423C2497B2D42829F0043A0C1D971@CANPRD01.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "benh@au1.ibm.com" <benh@au1.ibm.com>, Logan Gunthorpe <logang@deltatee.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

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
>   Note: I think the above means it won't work behind a switch on x86
>   either, will it ?
 
Ben 

We have done extensive testing of this series and its predecessors using PCIe switches from both Broadcom (PLX) and Microsemi. We have also done testing on x86_64, ARM64 and ppc64el based ARCH with varying degrees of success. The series as it currently stands only works on x86_64 but modified (hacky) versions have been made to work on ARM64. The x86_64 testing has been done on a range of (Intel) CPUs, servers, PCI EPs (including RDMA NICs from at least three vendors, NVMe SSDs from at least four vendors and P2P devices from four vendors) and PCI switches.

I do find it slightly offensive that you would question the series even working. I hope you are not suggesting we would submit this framework multiple times without having done testing on it....

Stephen

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
