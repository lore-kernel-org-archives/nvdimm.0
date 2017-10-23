Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp-out4.electric.net (smtp-out4.electric.net
 [192.162.216.185])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88B7F202E59C8
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 09:04:56 -0700 (PDT)
From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 23 Oct 2017 16:08:48 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
In-Reply-To: <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
Content-Language: en-US
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
To: "'Petrosyan, Ludwig'" <ludwig.petrosyan@desy.de>, Logan Gunthorpe <logang@deltatee.com>
Cc: "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kuehling,, "John  <John.Bridgman@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Koenig,, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Petrosyan Ludwig
> Sent: 22 October 2017 07:14
> Could be I have done is stupid...
> But at first sight it has to be simple:
> The PCIe Write transactions are address routed, so if in the packet header the other endpoint address
> is written the TLP has to be routed (by PCIe Switch to the endpoint), the DMA reading from the end
> point is really write transactions from the endpoint, usually (Xilinx core) to start DMA one has to
> write to the DMA control register of the endpoint the destination address. So I have change the device
> driver to set in this register the physical address of the other endpoint (get_resource start called
> to other endpoint, and it is the same address which I could see in lspci -vvvv -s bus-address of the
> switch port, memories behind bridge), so now the endpoint has to start send writes TLP with the other
> endpoint address in the TLP header.
> But this is not working (I want to understand why ...), but I could see the first address of the
> destination endpoint is changed (with the wrong value 0xFF),
> now I want to try prepare in the driver of one endpoint the DMA buffer , but using physical address of
> the other endpoint,
> Could be it will never work, but I want to understand why, there is my error ...

It is also worth checking that the hardware actually supports p2p transfers.
Writes are more likely to be supported then reads.
ISTR that some intel cpus support some p2p writes, but there could easily
be errata against them.

I'd certainly test a single word write to read/write memory location.
First verify against kernel memory, then against a 'slave' board.

I don't know about Xilinx fpga, but we've had 'fun' getting Altera fpga
to do sensible PCIe cycles (I ended up writing a simple dma controller 
that would generate long TLP).
We also found a bug in the Altera logic that processed interleaved
read completions.

	David

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
