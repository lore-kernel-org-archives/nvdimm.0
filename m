Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp-out4.electric.net (smtp-out4.electric.net
 [192.162.216.186])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1B9E203525FF
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 07:54:29 -0700 (PDT)
From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 24 Oct 2017 14:58:24 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD00A19B9@AcuExch.aculab.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
 <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
 <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
In-Reply-To: <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
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
Cc: Serguei Sagalovitch <Serguei.Sagalovitch@amd.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, John Bridgman <John.Bridgman@amd.com>, linux-kernel <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Christian Koenig <Christian.Koenig@amd.com>, Ben Sander <ben.sander@amd.com>, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Paul Blinzer <Paul.Blinzer@amd.com>, Linux-media <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Please don't top post, write shorter lines, and add the odd blank line.
Big blocks of text are hard to read quickly.

> From: Petrosyan, Ludwig [mailto:ludwig.petrosyan@desy.de]
> Yes I agree it has to be started with the write transaction, according of PCIe standard all write
> transaction are address routed, and I agree with Logan:
> if in write transaction TLP the endpoint address written in header the TLP should not touch CPU, the
> PCIe Switch has to route it to endpoint.

That depends, IIRC there is a feature for PCIe switches to force them
to send all transactions to the root hub.
This is there so that the host can enforce rules to stop p2p transfers.
It might enabled on the switch you have.

> The idea was: in MTCA system there is PCIe Switch on MCH (MTCA crate HUB) this switch connects CPU to
> other Crate Slots, so one port is Upstream and others are Downstream  ports, DMA read from CPU is
> usual write on endpoint side, Xilinx DMA core has two registers Destination Address and Source
> Address,
> device driver to make DMA has to set up these registers,
> usually device driver to start DMA read from Board sets Source address as FPGA memory address and
> Destination address is DMA prepared system address,
> in case of testing p2p I set Destination address as physical address of other endpoint.

Unnecessary detail...

> More detailed:
> we have so called pcie universal driver: the idea behind is
> 1. all pcie configuration staff, find enabled BARs, mapping BARs, usual read/write and common ioctl
> (get slot number, get driver version ...) implemented in universal driver and EXPORTed.
> 2. if some system function in new kernel are changed we change it only in universal parts (easy
> support a big number of drivers )
> so the universal driver something like PCIe Driver API
> 3. the universal driver provides read/writ functions so we have the same device access API for any
> PCIe device, we could use the same user application with any PCIe device

More crap...

> now. during BARs finding and mapping universal driver keeps pcie endpoint physical address in some
> internal structures, any top driver may get physical address
> of other pcie endpoint by slot number.
> in may case during get_resorce the physical address is 0xB2000000, I check lspci -H1 -vvvv -s psie
> switch port bus address (the endpoint connected to this port, checked by lspci -H1 -t) the same
> address (0xB200000) is the memory behind bridge,

Overly verbose...

> I want to make p2p writes to offset 0x40000, so I set DMA destination address 0xB2400000
> is something wrong?

Possibly.

You almost certainly need the address that is written into the BAR of the
target endpoint.
This could well be different from the physical address that the cpu uses
to write to the endpoint (as well as the cpu virtual address).

lspci lies [1], run lspci -x  (or hexdump config space through /sys/devices)
to see what is actually in the BAR.

[1] The addresses come from somewhere other than reading the BAR.
If the endpoint resets the BAR lspci will still report the old
addresses.

	David

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
