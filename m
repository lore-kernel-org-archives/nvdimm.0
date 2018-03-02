Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670101.outbound.protection.outlook.com [40.107.67.101])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A5FA21CF1D0E
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 13:32:37 -0800 (PST)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Date: Fri, 2 Mar 2018 21:38:43 +0000
Message-ID: <8D3B5C26-39E0-478D-B51F-A22B3F36C4D7@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com> <20180301205548.GA6742@redhat.com>
 <a512edf9-2d96-9229-fe60-e0ea60b3922b@deltatee.com>
 <20180301211036.GB6742@redhat.com>
In-Reply-To: <20180301211036.GB6742@redhat.com>
Content-Language: en-US
Content-ID: <0AF11F09DBD48946B0DE6C3030518A52@CANPRD01.PROD.OUTLOOK.COM>
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
To: Jerome Glisse <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> It seems people miss-understand HMM :( 

Hi Jerome

Your unhappy face emoticon made me sad so I went off to (re)read up on HMM. Along the way I came up with a couple of things.

While hmm.txt is really nice to read it makes no mention of DEVICE_PRIVATE and DEVICE_PUBLIC. It also gives no indication when one might choose to use one over the other. Would it be possible to update hmm.txt to include some discussion on this? I understand that DEVICE_PUBLIC creates a mapping in the kernel's linear address space for the device memory and DEVICE_PRIVATE does not. However, like I said, I am not sure when you would use either one and the pros and cons of doing so. I actually ended up finding some useful information in memremap.h but I don't think it is fair to expect people to dig *that* deep to find this information ;-).

A quick grep shows no drivers using the HMM API in the upstream code today. Is this correct? Are there any examples of out of tree drivers that use HMM you can point me too? As a driver developer what resources exist to help me write a HMM aware driver?

The (very nice) hmm.txt document is not references in the MAINTAINERS file? You might want to fix that when you have a moment.

Stephen


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
