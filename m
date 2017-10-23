Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C475D2034C0BE
 for <linux-nvdimm@lists.01.org>; Mon, 23 Oct 2017 15:00:49 -0700 (PDT)
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
Date: Mon, 23 Oct 2017 16:04:26 -0600
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
Content-Language: en-US
Subject: Re: Enabling peer to peer device transactions for PCIe devices
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: David Laight <David.Laight@ACULAB.COM>, "'Petrosyan, Ludwig'" <ludwig.petrosyan@desy.de>
Cc: "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kuehling,, "John  <John.Bridgman@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Koenig,, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



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
