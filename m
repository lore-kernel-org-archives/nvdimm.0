Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647594C77
	for <nvdimm@lists.linux.dev>; Tue, 19 Jul 2022 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658256832; x=1689792832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KlXROmbhy3+DYYvkDn3Lj6JCjAHxOGaTM4piOHf5Ngs=;
  b=Mwc7tOg9car+VblmLw6aJSZZJx3ADVZdj4h8nDBWQn3IY9WMhtJo8DoN
   cusM911rC60/fGvN2T4z00VpWgtJH6pxn2Rj0tgHbf8Vw+rXJHqAZ7cTA
   ZKX8mIdf2PYUch71k+4pPoqejOhfRmLgqGAZNSzhDO/VUfMit07ALkLij
   4gvnrVIPwmgW/oQfXu/iSX5u0wKemgyymj4kfXkayvexdEvN07OHZTw0X
   csW/rbrrfc2CguWZxMwl6PHBT9LyoFMyB68D9a0zJO+G4IKuSFKcx4NsO
   T1XViOSkGLpuSuzsxk/+rz8VO7yd5qrbmCsjNzGohbKeffmHS2sOHipAK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="350538510"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="350538510"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 11:53:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="724365569"
Received: from djiang5-mobl1.amr.corp.intel.com (HELO [10.213.175.55]) ([10.213.175.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 11:53:51 -0700
Message-ID: <81570006-34c9-4314-e085-c660ea826372@intel.com>
Date: Tue, 19 Jul 2022 11:53:50 -0700
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
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <20220715212933.yhg32x6vdlnpipas@offworld>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220715212933.yhg32x6vdlnpipas@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/15/2022 2:29 PM, Davidlohr Bueso wrote:
> On Fri, 15 Jul 2022, Dave Jiang wrote:
>
>> This series is seeking comments on the implementation. It has not 
>> been fully
>> tested yet.
>
> Sorry if this is already somewhere, but how exactly does one test the 
> mock device?
So you can do "make M=tools/testing/cxl" to build cxl_test drivers. It's 
similar to ndctl_test and the ndctl README has some instruction on how 
to build and load. Probably should add some information for cxl_test in 
that file. The run_qemu tool from Vishal also provides support for this 
if you add the --cxl-test switch.
