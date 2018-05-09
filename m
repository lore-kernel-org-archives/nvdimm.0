Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0055.outbound.protection.outlook.com [104.47.32.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC02E2096AEDA
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 06:40:45 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
References: <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
Date: Wed, 9 May 2018 15:40:29 +0200
MIME-Version: 1.0
In-Reply-To: <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
Content-Language: en-US
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
To: Stephen Bates <sbates@raithlin.com>, Jerome Glisse <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Am 09.05.2018 um 15:12 schrieb Stephen Bates:
> Jerome and Christian
>      
>> I think there is confusion here, Alex properly explained the scheme
>> PCIE-device do a ATS request to the IOMMU which returns a valid
>> translation for a virtual address. Device can then use that address
>> directly without going through IOMMU for translation.
> So I went through ATS in version 4.0r1 of the PCI spec. It looks like even a ATS translated TLP is still impacted by ACS though it has a separate control knob for translated address TLPs (see 7.7.7.2 of 4.0r1 of the spec). So even if your device supports ATS a P2P DMA will still be routed to the associated RP of the domain and down again unless we disable ACS DT P2P on all bridges between the two devices involved in the P2P DMA.
>
> So we still don't get fine grained control with ATS and I guess we still have security issues because a rogue or malfunctioning EP could just as easily issue TLPs with TA set vs not set.

Still need to double check the specification (had a busy morning today), 
but that sounds about correct.

The key takeaway is that when any device has ATS enabled you can't 
disable ACS without breaking it (even if you unplug and replug it).

>> Also ATS is meaningless without something like PASID as far as i know.
>      
> ATS is still somewhat valuable without PSAID in the sense you can cache IOMMU address translations at the EP. This saves hammering on the IOMMU as much in certain workloads.
>
> Interestingly Section 7.7.7.2 almost mentions that Root Ports that support ATS AND can implement P2P between root ports should advertise "ACS Direct Translated P2P (T)" capability. This ties into the discussion around P2P between route ports we had a few weeks ago...

Interesting point, give me a moment to check that. That finally makes 
all the hardware I have standing around here valuable :)

Christian.

>
> Stephen
>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
