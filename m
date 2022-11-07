Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A8815C99
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 23:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667864791; x=1699400791;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UHyCzYnsoG4p5IiHmuB7OkrqtYurFGZe+Hv87a3j1xk=;
  b=M5ZQRLPVnkg9u9ljUxDW/I1oa79as5bG/fFekkfRbIeEdkPyYWBwIjNq
   pwOjmANfb//W3LVtqB+wALd+XZUmnCYvkccUoF7OajsxgwGVxhrLX8TTj
   m/kSJ5eM4XzLcH8lpDyibiqoGdX3UfvTEgG4+1mP8HxpeI8Y4VELvM0R0
   oQ8UQN8b8Yo/KIzM8xQP0yiB60wDkD3fYQq2CL4Uqmw1K0DXJW6O2LtsW
   3qAv0j/CgEVrnvzLyz7WvDbpi7K6qj2hxTodyhXgyvIXUsK9aXB/cyibc
   Jpww5g7AOK9UA10zXij8mzy1KmbL+csgME4yIyYA0RmOSPfzUKBb548hx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308176233"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308176233"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:46:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630670182"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630670182"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.213.168.235]) ([10.213.168.235])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:46:30 -0800
Message-ID: <88e62c8a-bf56-3a9d-dd73-1809f94e0709@intel.com>
Date: Mon, 7 Nov 2022 15:46:29 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH v2 18/19] libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST
 flag
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377439534.430546.10690686781480251163.stgit@djiang5-desk3.ch.intel.com>
 <20221107160124.00005223@Huawei.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20221107160124.00005223@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2022 8:01 AM, Jonathan Cameron wrote:
> On Wed, 21 Sep 2022 08:33:15 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> nfit_test overrode the security_show() sysfs attribute function in nvdimm
>> dimm_devs in order to allow testing of security unlock. With the
>> introduction of CXL security commands, the trick to override
>> security_show() becomes significantly more complicated. By introdcing a
>> security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
>> check via a compile option. In addition the original override can can be
>> removed from tools/testing/nvdimm/.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>   drivers/nvdimm/Kconfig           |    9 +++++++++
>>   drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
>>   drivers/nvdimm/security.c        |    4 ++++
>>   tools/testing/nvdimm/Kbuild      |    1 -
>>   tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
>>   5 files changed, 21 insertions(+), 32 deletions(-)
>>   delete mode 100644 tools/testing/nvdimm/dimm_devs.c
>>
>> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
>> index 5a29046e3319..fd336d138eda 100644
>> --- a/drivers/nvdimm/Kconfig
>> +++ b/drivers/nvdimm/Kconfig
>> @@ -114,4 +114,13 @@ config NVDIMM_TEST_BUILD
>>   	  core devm_memremap_pages() implementation and other
>>   	  infrastructure.
>>   
>> +config NVDIMM_SECURITY_TEST
>> +	bool "Nvdimm security test code toggle"
>> +	depends on NVDIMM_KEYS
>> +	help
>> +	  Debug flag for security testing when using nfit_test or cxl_test
>> +	  modules in tools/testing/.
>> +
>> +	  Select Y if using nfit_test or cxl_test for security testing.
> 
> Probably want to say it if has any unfortunate side effects when not doing
> such testing.  Distros will want guidance on whether to enable.

Ok will add.
> 
> Jonathan
> 
>> +
> 
> 
