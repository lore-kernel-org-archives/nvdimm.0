Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 434A4210FBEE9
 for <linux-nvdimm@lists.01.org>; Wed, 23 Jan 2019 12:03:55 -0800 (PST)
Subject: Re: [PATCH 2/4] mm/memory-hotplug: allow memory resources to be
 children
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181902.670EEBC3@viggo.jf.intel.com>
 <20190116191635.GD3617@redhat.com>
 <2b52778d-f120-eec7-3e7a-3a9c182170f0@intel.com>
 <20190116233849.GE3617@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <b1f22eda-b52f-af20-637f-b45971a12d33@intel.com>
Date: Wed, 23 Jan 2019 12:03:54 -0800
MIME-Version: 1.0
In-Reply-To: <20190116233849.GE3617@redhat.com>
Content-Language: en-US
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
To: Jerome Glisse <jglisse@redhat.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 1/16/19 3:38 PM, Jerome Glisse wrote:
> So right now i would rather that we keep properly reporting this
> hazard so that at least we know it failed because of that. This
> also include making sure that we can not register private memory
> as a child of an un-busy resource that does exist but might not
> have yet been claim by its rightful owner.

I can definitely keep the warning in.  But, I don't think there's a
chance of HMM registering a IORES_DESC_DEVICE_PRIVATE_MEMORY region as
the child of another.  The region_intersects() check *should* find that:

>         for (; addr > size && addr >= iomem_resource.start; addr -= size) {
>                 ret = region_intersects(addr, size, 0, IORES_DESC_NONE);
>                 if (ret != REGION_DISJOINT)
>                         continue;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
