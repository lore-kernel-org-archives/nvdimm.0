Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp-o-1.desy.de (smtp-o-1.desy.de
 [IPv6:2001:638:700:1038::1:9a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E57142034A7C4
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 22:54:43 -0700 (PDT)
Received: from smtp-map-1.desy.de (smtp-map-1.desy.de [131.169.56.66])
 by smtp-o-1.desy.de (DESY-O-1) with ESMTP id B6AB128066C
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 07:58:23 +0200 (CEST)
Date: Tue, 24 Oct 2017 07:58:19 +0200 (CEST)
From: "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>
Message-ID: <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
In-Reply-To: <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
 <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Serguei Sagalovitch <Serguei.Sagalovitch@amd.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, John Bridgman <John.Bridgman@amd.com>, linux-kernel <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Christian Koenig <Christian.Koenig@amd.com>, Ben Sander <ben.sander@amd.com>, David Laight <David.Laight@ACULAB.COM>, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Paul Blinzer <Paul.Blinzer@amd.com>, Linux-media <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Yes I agree it has to be started with the write transaction, according of PCIe standard all write transaction are address routed, and I agree with Logan:
if in write transaction TLP the endpoint address written in header the TLP should not touch CPU, the PCIe Switch has to route it to endpoint.
The idea was: in MTCA system there is PCIe Switch on MCH (MTCA crate HUB) this switch connects CPU to other Crate Slots, so one port is Upstream and others are Downstream  ports, DMA read from CPU is usual write on endpoint side, Xilinx DMA core has two registers Destination Address and Source Address,
device driver to make DMA has to set up these registers,
usually device driver to start DMA read from Board sets Source address as FPGA memory address and Destination address is DMA prepared system address,
in case of testing p2p I set Destination address as physical address of other endpoint.
More detailed:
we have so called pcie universal driver: the idea behind is
1. all pcie configuration staff, find enabled BARs, mapping BARs, usual read/write and common ioctl (get slot number, get driver version ...) implemented in universal driver and EXPORTed.
2. if some system function in new kernel are changed we change it only in universal parts (easy support a big number of drivers )
so the universal driver something like PCIe Driver API
3. the universal driver provides read/writ functions so we have the same device access API for any PCIe device, we could use the same user application with any PCIe device

now. during BARs finding and mapping universal driver keeps pcie endpoint physical address in some internal structures, any top driver may get physical address
of other pcie endpoint by slot number.
in may case during get_resorce the physical address is 0xB2000000, I check lspci -H1 -vvvv -s psie switch port bus address (the endpoint connected to this port, checked by lspci -H1 -t) the same address (0xB200000) is the memory behind bridge, 
I want to make p2p writes to offset 0x40000, so I set DMA destination address 0xB2400000
is something wrong?

thanks for help
regards

Ludwig

----- Original Message -----
From: "Logan Gunthorpe" <logang@deltatee.com>
To: "David Laight" <David.Laight@ACULAB.COM>, "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>
Cc: "Alexander Deucher" <Alexander.Deucher@amd.com>, "linux-kernel" <linux-kernel@vger.kernel.org>, "linux-rdma" <linux-rdma@vger.kernel.org>, "linux-nvdimm" <linux-nvdimm@lists.01.org>, "Linux-media" <Linux-media@vger.kernel.org>, "dri-devel" <dri-devel@lists.freedesktop.org>, "linux-pci" <linux-pci@vger.kernel.org>, "John Bridgman" <John.Bridgman@amd.com>, "Felix Kuehling" <Felix.Kuehling@amd.com>, "Serguei Sagalovitch" <Serguei.Sagalovitch@amd.com>, "Paul Blinzer" <Paul.Blinzer@amd.com>, "Christian Koenig" <Christian.Koenig@amd.com>, "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>, "Ben Sander" <ben.sander@amd.com>
Sent: Tuesday, 24 October, 2017 00:04:26
Subject: Re: Enabling peer to peer device transactions for PCIe devices

On 23/10/17 10:08 AM, David Laight wrote:
> It is also worth checking that the hardware actually supports p2p transfers.
> Writes are more likely to be supported then reads.
> ISTR that some intel cpus support some p2p writes, but there could easily
> be errata against them.

Ludwig mentioned a PCIe switch. The few switches I'm aware of support 
P2P transfers. So if everything is setup correctly, the TLPs shouldn't 
even touch the CPU.

But, yes, generally it's a good idea to start with writes and see if 
they work first.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
