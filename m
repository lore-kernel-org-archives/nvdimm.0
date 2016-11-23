Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0618.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::618])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D7C781EE1
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 09:27:50 -0800 (PST)
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
Date: Wed, 23 Nov 2016 09:27:42 -0800
MIME-Version: 1.0
In-Reply-To: <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>, Dan Williams <dan.j.williams@intel.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, Suravee, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/23/2016 09:13 AM, Logan Gunthorpe wrote:
> IMO any memory that has been registered for a P2P transaction should be
> locked from being evicted. So if there's a get_user_pages call it needs
> to be pinned until the put_page. The main issue being with the RDMA
> case: handling an eviction when a chunk of memory has been registered as
> an MR would be very tricky. The MR may be relied upon by another host
> and the kernel would have to inform user-space the MR was invalid then
> user-space would have to tell the remote application.

Hello Logan,

Are you aware that the Linux kernel already supports ODP (On Demand 
Paging)? See also the output of git grep -nHi on.demand.paging. See also 
https://www.openfabrics.org/images/eventpresos/workshops2014/DevWorkshop/presos/Tuesday/pdf/04_ODP_update.pdf.

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
