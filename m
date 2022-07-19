Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A82C4C77
	for <nvdimm@lists.linux.dev>; Tue, 19 Jul 2022 18:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658256951; x=1689792951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AuXqu/mjKwQiyQqUKl6rU9Nf93+qz77SwzOoMwtRF2Q=;
  b=cYElFrhogd4X8vjy2IxJ7zlxQh/5ZUk06dfw1XwEF/MPMwCq4eAYm2f2
   7y8sTdWGDHVSMDkEk2xSiWMndSBe/+PEh29tNbbp/3TWk20EeUDd495GK
   5CDythLlcpjwvWigN7ERt3xH089hWpBZDv5T2Mz4oU+nSrPc6/OaNOyde
   yBZ92MIOePWoTZYg2SsmCeBAkAr2Ow9hVrF8UFVlWRbnWbdZw66Pp0haV
   ZSZh8knDab9JC5ycmc2mi2kBfWM6zNvSz7EyBZVAj4hLyYhDRL4dAOdpq
   TTSrxElk4m0QhYHVKzGde6XRUYhg5EigCjXBqsA71zyI6GCrr5EPD7j5W
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="269598285"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="269598285"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 11:55:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="724365948"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.175.55]) ([10.213.175.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 11:55:50 -0700
Message-ID: <90b4cc78-9a27-b369-ea5e-c89d1d889fdb@intel.com>
Date: Tue, 19 Jul 2022 11:55:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH RFC 4/15] cxl/pmem: Add "Set Passphrase" security command
 support
Content-Language: en-US
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791933557.2491387.2141316283759403219.stgit@djiang5-desk3.ch.intel.com>
 <20220718063652.osytkh3sji3mntfn@offworld>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220718063652.osytkh3sji3mntfn@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/17/2022 11:36 PM, Davidlohr Bueso wrote:
> On Fri, 15 Jul 2022, Dave Jiang wrote:
>
>> However, the spec leaves a gap WRT master passphrase usages. The spec 
>> does
>> not define any ways to retrieve the status of if the support of master
>> passphrase is available for the device, nor does the commands that 
>> utilize
>> master passphrase will return a specific error that indicates master
>> passphrase is not supported. If using a device does not support master
>> passphrase and a command is issued with a master passphrase, the error
>> message returned by the device will be ambiguos.
>
> In general I think that the 2.0 spec is brief at *best* wrt to these 
> topics.
> Even if a lot is redundant, there should be an explicit equivalent to the
> theory of operation found in 
> https://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf

I totally agree.


>
> Thanks,
> Davidlohr
