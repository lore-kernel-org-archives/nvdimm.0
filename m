Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188377A
	for <nvdimm@lists.linux.dev>; Mon,  8 Aug 2022 22:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659997121; x=1691533121;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xWoTkkfiIED94OupbBmVlI+GrUW8+wF4Sneiyh52FuI=;
  b=U70tmgAkd6+G2FkyVu+Q5uj/r3H97UdzNqkWHWTqYkkB84FYcSk7NsnU
   9MTuOdj5YLSDqM4yNEDqQzqvJisvaFXBF2XB9MxFA9xU9ajvrL6OxDLZv
   NyFry7Gb+t1UTJ0b1mNihdZDh9ZUpDguBMp+Hu2Vj9lbQTkx1z2a/4CVA
   vqE9JZ1cNfoEnXbLSNth+rmoJVywrt87OvFVs2nhzr/mR24vp5JQH87lR
   ZwsRIfYbRG1bOlQxUZM+ZBoyqDAGLIRsOEkQRjqY5KLALafcy4z+xrBE7
   pE6LP7e2dxLS18pkI1M2TIjGz0FSeVPwTJUi493AKjv32WMAzFgWQi1Ww
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="277637086"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="277637086"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 15:18:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="746810829"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.212.34.69]) ([10.212.34.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 15:18:39 -0700
Message-ID: <5f079f6b-65cb-fba1-9ecc-8b0f5d7d2677@intel.com>
Date: Mon, 8 Aug 2022 15:18:38 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH RFC 00/15] Introduce security commands for CXL pmem device
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <20220803180355.00006042@huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220803180355.00006042@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/3/2022 10:03 AM, Jonathan Cameron wrote:
> On Fri, 15 Jul 2022 14:08:32 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
>
>> This series is seeking comments on the implementation. It has not been fully
>> tested yet.
>>
>> This series adds the support for "Persistent Memory Data-at-rest Security"
>> block of command set for the CXL Memory Devices. The enabling is done through
>> the nvdimm_security_ops as the operations are very similar to the same
>> operations that the persistent memory devices through NFIT provider support.
>> This enabling does not include the security pass-through commands nor the
>> Santize commands.
>>
>> Under the nvdimm_security_ops, this patch series will enable get_flags(),
>> freeze(), change_key(), unlock(), disable(), and erase(). The disable() API
>> does not support disabling of the master passphrase. To maintain established
>> user ABI through the sysfs attribute "security", the "disable" command is
>> left untouched and a new "disable_master" command is introduced with a new
>> disable_master() API call for the nvdimm_security_ops().
>>
>> This series does not include plumbing to directly handle the security commands
>> through cxl control util. The enabled security commands will still go through
>> ndctl tool with this enabling.
>>
>> For calls such as unlock() and erase(), the CPU caches must be invalidated
>> post operation. Currently, the implementation resides in
>> drivers/acpi/nfit/intel.c with a comment that it should be implemented
>> cross arch when more than just NFIT based device needs this operation.
>> With the coming of CXL persistent memory devices this is now needed.
>> Introduce ARCH_HAS_NVDIMM_INVAL_CACHE and implement similar to
>> ARCH_HAS_PMEM_API where the arch can opt in with implementation.
>> Currently only add x86_64 implementation where wbinvd_on_all_cpus()
>> is called.
>>
> Hi Dave,
>
> Just curious.  What was reasoning behind this being a RFC?
> What do you particular want comments on?

Hi Jonathan. Thanks for reviewing the patches. When I posted the series, 
I haven't tested the code. I just wanted to make sure there are no 
objections to the direction of this enabling going with reusing the 
nvdimm security ops. Once I address Davidlohr and your comments and get 
it fully tested, I'll release v2 w/o RFC.


>
> Thanks,
>
> Jonathan
>
>> ---
>>
>> Dave Jiang (15):
>>        cxl/pmem: Introduce nvdimm_security_ops with ->get_flags() operation
>>        tools/testing/cxl: Create context for cxl mock device
>>        tools/testing/cxl: Add "Get Security State" opcode support
>>        cxl/pmem: Add "Set Passphrase" security command support
>>        tools/testing/cxl: Add "Set Passphrase" opcode support
>>        cxl/pmem: Add Disable Passphrase security command support
>>        tools/testing/cxl: Add "Disable" security opcode support
>>        cxl/pmem: Add "Freeze Security State" security command support
>>        tools/testing/cxl: Add "Freeze Security State" security opcode support
>>        x86: add an arch helper function to invalidate all cache for nvdimm
>>        cxl/pmem: Add "Unlock" security command support
>>        tools/testing/cxl: Add "Unlock" security opcode support
>>        cxl/pmem: Add "Passphrase Secure Erase" security command support
>>        tools/testing/cxl: Add "passphrase secure erase" opcode support
>>        nvdimm/cxl/pmem: Add support for master passphrase disable security command
>>
>>
>>   arch/x86/Kconfig             |   1 +
>>   arch/x86/mm/pat/set_memory.c |   8 +
>>   drivers/acpi/nfit/intel.c    |  28 +--
>>   drivers/cxl/Kconfig          |  16 ++
>>   drivers/cxl/Makefile         |   1 +
>>   drivers/cxl/cxlmem.h         |  41 +++++
>>   drivers/cxl/pmem.c           |  10 +-
>>   drivers/cxl/security.c       | 182 ++++++++++++++++++
>>   drivers/nvdimm/security.c    |  33 +++-
>>   include/linux/libnvdimm.h    |  10 +
>>   lib/Kconfig                  |   3 +
>>   tools/testing/cxl/Kbuild     |   1 +
>>   tools/testing/cxl/test/mem.c | 348 ++++++++++++++++++++++++++++++++++-
>>   13 files changed, 644 insertions(+), 38 deletions(-)
>>   create mode 100644 drivers/cxl/security.c
>>
>> --
>>
>
