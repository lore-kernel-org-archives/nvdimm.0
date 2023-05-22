Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278DEC2F6
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684768743; x=1716304743;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gt5kZ1g2Hm68dDnO8etBAEt8IovhDNYiTb23E49oOss=;
  b=J164PCx8p5V0Ve9dUg3kGcCZlcJJJl0odq2nOMrli/XlVQ9beNVxGXZu
   x5WTSljzQOgKaFwawHiTC7/Sm4kZTlh4Xk3eS3+AlFT0sPTOYQ9kzFx9j
   QEpRmpanmcePYGsLCtl/L7S6A4oJLwAmoXkssmUDaqs0sGx11IHcGRqcb
   Z4OKu2WMZYojyrjnIVdNl3l+svm2KjkqPM+Y/fEQq5K5VG25LouYDqmLP
   MlDcQJvDVQwZ3DHrJ91yTQusLAiC9pzUAORSXi5khM+PDNX0BPWwcPHTQ
   MDKcGpyoAJ9F7V84rZZWE9sqJAggT0nuFPtXpkk0LOB+TDs9OwnXD6eo0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="332562758"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="332562758"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:19:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="773395721"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773395721"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.173.219]) ([10.213.173.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:19:02 -0700
Message-ID: <2393ba5c-853b-1b09-00f4-0b81d17bebe4@intel.com>
Date: Mon, 22 May 2023 08:19:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 0/6] cxl/monitor and ndctl/monitor fixes
Content-Language: en-US
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <931ad127-4ff5-20b3-d551-9a144b3cd7c8@intel.com>
 <29c0e53f-689e-62d3-dcf7-bcf0ca88d919@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <29c0e53f-689e-62d3-dcf7-bcf0ca88d919@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/21/23 11:25 PM, Zhijian Li (Fujitsu) wrote:
> 
> 
> On 20/05/2023 01:47, Dave Jiang wrote:
>>
>>
>> On 5/13/23 7:20 AM, Li Zhijian wrote:
>>> It mainly fix monitor not working when log file is specified. For
>>> example
>>> $ cxl monitor -l ./cxl-monitor.log
>>> It seems that someone missed something at the begining.
>>>
>>> Furture, it compares the filename with reserved works more accurately
>>>
>>> Li Zhijian (6):
>>>     cxl/monitor: Fix monitor not working
>>>     cxl/monitor: compare the whole filename with reserved words
>>>     cxl/monitor: Enable default_log and refactor sanity check
>>>     cxl/monitor: always log started message
>>>     Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
>>>     ndctl/monitor: compare the whole filename with reserved words
>>>
>>>    Documentation/cxl/cxl-monitor.txt |  3 +-
>>>    cxl/monitor.c                     | 47 ++++++++++++++++---------------
>>>    ndctl/monitor.c                   |  4 +--
>>>    3 files changed, 27 insertions(+), 27 deletions(-)
>>>
>>
>> Please cc linux-cxl@vger.kernel.org as well for future revs since this impacts CXL CLI.
> Yeah
> 
> I have double confirmed recipient in this repo by 'git grep @', look we have to document it
> in the CONTRIBUTING.md as well :)

Please feel free to submit a patch and rectify this. :)
