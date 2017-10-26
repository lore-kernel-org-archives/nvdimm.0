Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp-o-1.desy.de (smtp-o-1.desy.de
 [IPv6:2001:638:700:1038::1:9a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E36E3203525FD
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 06:24:24 -0700 (PDT)
Received: from smtp-map-1.desy.de (smtp-map-1.desy.de [131.169.56.66])
 by smtp-o-1.desy.de (DESY-O-1) with ESMTP id B893C280739
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 15:28:07 +0200 (CEST)
Date: Thu, 26 Oct 2017 15:28:02 +0200 (CEST)
From: "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>
Message-ID: <2068822709.17434955.1509024482956.JavaMail.zimbra@desy.de>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD00A19B9@AcuExch.aculab.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
 <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
 <1264390131.14701401.1508824699016.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A19B9@AcuExch.aculab.com>
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
To: David Laight <David.Laight@ACULAB.COM>
Cc: Serguei Sagalovitch <Serguei.Sagalovitch@amd.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, John Bridgman <John.Bridgman@amd.com>, linux-kernel <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Christian Koenig <Christian.Koenig@amd.com>, Ben Sander <ben.sander@amd.com>, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alexander Deucher <Alexander.Deucher@amd.com>, Paul Blinzer <Paul.Blinzer@amd.com>, Linux-media <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



----- Original Message -----
> From: "David Laight" <David.Laight@ACULAB.COM>
> To: "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>, "Logan Gunthorpe" <logang@deltatee.com>
> Cc: "Alexander Deucher" <Alexander.Deucher@amd.com>, "linux-kernel" <linux-kernel@vger.kernel.org>, "linux-rdma"
> <linux-rdma@vger.kernel.org>, "linux-nvdimm" <linux-nvdimm@lists.01.org>, "Linux-media" <Linux-media@vger.kernel.org>,
> "dri-devel" <dri-devel@lists.freedesktop.org>, "linux-pci" <linux-pci@vger.kernel.org>, "John Bridgman"
> <John.Bridgman@amd.com>, "Felix Kuehling" <Felix.Kuehling@amd.com>, "Serguei Sagalovitch"
> <Serguei.Sagalovitch@amd.com>, "Paul Blinzer" <Paul.Blinzer@amd.com>, "Christian Koenig" <Christian.Koenig@amd.com>,
> "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>, "Ben Sander" <ben.sander@amd.com>
> Sent: Tuesday, 24 October, 2017 16:58:24
> Subject: RE: Enabling peer to peer device transactions for PCIe devices

> Please don't top post, write shorter lines, and add the odd blank line.
> Big blocks of text are hard to read quickly.
> 

OK this time I am very short. 
peer2peer works

Ludwig
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
