Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE307C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663795423; x=1695331423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j7IEyZ8mHXGZNhB2CbhcFqd8VtBwVACR0GYmCCQSVvA=;
  b=dRscK/5uFUv7y5MM8q5fCMxFS+Nlp7o4buIEluXrO5hHxe+m+zTHJfxp
   DYT9jStRQrMFegjp34JFF62o2xxUt6/cfJpz7TaOxbOax/iygJ7//vRLi
   NOkIuEvEmaU9NbixFZHZLW1MalR48IU3Numx2nMgUQ8deuwFj0JR0uJas
   l/Hkzhm0qy74qKahU5t4UUSPI086hQ3YD9s4tA1hsWLTAnHcezqY1Z0C/
   KNksAbjj90jL6TPl2wElkppTDVLk48iGpgeSOkjvBR75Vrrtk4cfWDKY8
   fxntiqDNeRZWWVBHG3aQLhBMdY7ckqF5mUdTJxsTNcOFId9DsQlTJaaQc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="287203593"
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="287203593"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:23:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,334,1654585200"; 
   d="scan'208";a="652705062"
Received: from djiang5-mobl2.amr.corp.intel.com (HELO [10.212.36.150]) ([10.212.36.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 14:23:41 -0700
Message-ID: <27395834-da66-c3f7-3f8d-01a64431df25@intel.com>
Date: Wed, 21 Sep 2022 14:23:41 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v2 12/19] cxl/pmem: Add "Passphrase Secure Erase" security
 command support
Content-Language: en-US
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com,
 Jonathan.Cameron@huawei.com
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377436014.430546.12077333298585882653.stgit@djiang5-desk3.ch.intel.com>
 <20220921201512.7tjaquhroo6qezfe@offworld>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220921201512.7tjaquhroo6qezfe@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/21/2022 1:15 PM, Davidlohr Bueso wrote:
> On Wed, 21 Sep 2022, Dave Jiang wrote:
>
>> +static int cxl_pmem_security_passphrase_erase(struct nvdimm *nvdimm,
>> +                          const struct nvdimm_key_data *key,
>> +                          enum nvdimm_passphrase_type ptype)
>> +{
>> +    struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>> +    struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
>> +    struct cxl_dev_state *cxlds = cxlmd->cxlds;
>> +    struct cxl_pass_erase erase;
>> +    int rc;
>> +
>> +    if (!cpu_cache_has_invalidate_memregion())
>> +        return -EOPNOTSUPP;
>
> The error code should be the same as the nvdimm user. I went with 
> EINVAL, but
> don't really have strong preferences.


EOPNOTSUPP seems more appropriate?

