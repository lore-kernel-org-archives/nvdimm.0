Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2367481ED5
 for <linux-nvdimm@lists.01.org>; Wed, 23 Nov 2016 09:03:36 -0800 (PST)
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com>
 <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
 <CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
 <20161123074902.ph7a5cmlw3pclugx@phenom.ffwll.local>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <7ce9026f-871e-d50a-20cf-19f7e2d90649@linux.intel.com>
Date: Wed, 23 Nov 2016 09:03:33 -0800
MIME-Version: 1.0
In-Reply-To: <20161123074902.ph7a5cmlw3pclugx@phenom.ffwll.local>
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
To: Dan Williams <dan.j.williams@intel.com>, Serguei Sagalovitch <serguei.sagalovitch@amd.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Deucher, Alexander" <Alexander.Deucher@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/22/2016 11:49 PM, Daniel Vetter wrote:
> Yes, agreed. My idea with exposing vram sections using numa nodes wasn't
> to reuse all the existing allocation policies directly, those won't work.
> So at boot-up your default numa policy would exclude any vram nodes.
> 
> But I think (as an -mm layman) that numa gives us a lot of the tools and
> policy interface that we need to implement what we want for gpus.

Are you suggesting creating NUMA nodes for video RAM (I assume that's
what you mean by vram) where that RAM is not at all CPU-accessible?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
