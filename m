Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 962D9211ADA21
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 15:01:40 -0800 (PST)
Subject: Re: [PATCH 2/4] mm/memory-hotplug: allow memory resources to be
 children
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181902.670EEBC3@viggo.jf.intel.com>
 <20190116191635.GD3617@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <2b52778d-f120-eec7-3e7a-3a9c182170f0@intel.com>
Date: Wed, 16 Jan 2019 15:01:39 -0800
MIME-Version: 1.0
In-Reply-To: <20190116191635.GD3617@redhat.com>
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
To: Jerome Glisse <jglisse@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 1/16/19 11:16 AM, Jerome Glisse wrote:
>> We also rework the old error message a bit since we do not get
>> the conflicting entry back: only an indication that we *had* a
>> conflict.
> We should keep the device private check (moving it in __request_region)
> as device private can try to register un-use physical address (un-use
> at time of device private registration) that latter can block valid
> physical address the error message you are removing report such event.

If a resource can't support having a child, shouldn't it just be marked
IORESOURCE_BUSY, rather than trying to somehow special-case
IORES_DESC_DEVICE_PRIVATE_MEMORY behavior?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
