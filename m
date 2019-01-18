Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63BD2211B85C5
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 21:03:58 -0800 (PST)
Date: Fri, 18 Jan 2019 13:03:33 +0800
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [PATCH] libnvdimm, pfn: not allocate nd_pfn->pfn_sb if already
 allocated
Message-ID: <20190118050333.GA4233@richard>
References: <20190118033544.3980-1-richardw.yang@linux.intel.com>
 <CAPcyv4jOA-S=Z-0mCUW7d4+6gwHNEe1egaFrbyNq5UJL7Uz=Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jOA-S=Z-0mCUW7d4+6gwHNEe1egaFrbyNq5UJL7Uz=Ow@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 17, 2019 at 08:31:56PM -0800, Dan Williams wrote:
>On Thu, Jan 17, 2019 at 7:36 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>>
>> In current implementation, we might re-allocate nd_pfn->pfn_sb.
>>
>> For example:
>>
>>     nd_dax_probe()
>>         nd_pfn->pfn_sb = devm_kzalloc()
>>
>>     dax_pmem_probe()
>>         nvdimm_setup_pfn()
>>             nd_pfn_init()
>>                 nd_pfn->pfn_sb = devm_kzalloc()
>>
>> This patch checks nd_pfn->pfn_sb before allocating it in nd_pfn_init().
>
>Ugh, this patch is unfortunately uncovering a deeper problem.
>nvdimm_setup_pfn() should not be calling nd_pfn_init(). This
>effectively is always re-initializing the info-block, benign but
>unnecessary. Instead it needs to be using nd_pfn_validate() followed
>by an __nvdimm_setup_pfn() in the dax_pmem_probe() path.
>
>Good find!

So we should fix this like:

dax_pmem_probe()
    nd_pfn_validate()
    __nvdimm_setup_pfn()

Is my understanding correct?

-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
