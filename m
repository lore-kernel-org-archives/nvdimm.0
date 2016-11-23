Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF4FF81EE9
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 09:13:08 -0800 (PST)
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
Date: Wed, 23 Nov 2016 10:13:03 -0700
MIME-Version: 1.0
In-Reply-To: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>, Dan Williams <dan.j.williams@intel.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, Suravee, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hey,

On 22/11/16 11:59 AM, Serguei Sagalovitch wrote:
> -  How well we will be able to handle case when we need to "move"/"evict"
>    memory/data to the new location so CPU pointer should point to the
> new physical location/address
>     (and may be not in PCI device memory at all)?

IMO any memory that has been registered for a P2P transaction should be
locked from being evicted. So if there's a get_user_pages call it needs
to be pinned until the put_page. The main issue being with the RDMA
case: handling an eviction when a chunk of memory has been registered as
an MR would be very tricky. The MR may be relied upon by another host
and the kernel would have to inform user-space the MR was invalid then
user-space would have to tell the remote application. This seems like a
lot of burden to place on applications and may be subject to timing
issues. Either that or all RDMA applications need to be written with the
assumption that their target memory could go away at any time.

More generally, if you tell one PCI device to do a DMA transfer to
another PCI device's BAR space, and the target memory gets evicted then
DMA transaction needs to be aborted which means every driver doing the
transfer would need special support for this. If the memory can be
relied on to not be evicted than existing drivers should work unmodified
(ie O_DIRECT to/from an NVMe card would just work).

I feel the better approach is to pin memory subject to P2P transactions
as is typically done with DMA transfers to main memory.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
