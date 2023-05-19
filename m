Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F6712B66
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684518479; x=1716054479;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=NzUYE7Z11xYDGbKyqEyh9TfzYEanBFntCBDzKu1/f6c=;
  b=SopUmgaX+froHEFmlfvPqqDZ06TZogPs5G5Ee79pDTiC5yqvLfBIxGHf
   JnCj6cWFHtA2E6SFMkRr5Ja6ls/80N7Zc9pdE/UnuM/OVCvlYM5nYyHtB
   LGByy1qqSL6E4nn7sa/g54HeJSSgjLB+58Q2H1kc7gJ3coj25vnwEpd1m
   0zPxyJa3GzoY1ICJBDT+/SfhWhR1UN1j7rLjn7rbC3cHu7DwsrL01tJi6
   HDCPsw/D1vavVhvtX2qhMF9M343JCNU3AtkerARg+054dRsbZVxHGlEy/
   OXYlGuYU5O7azTuirB577NiXG6gpCNsaVgIlzi9D8+s1m2Q05ficv3/Tx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="415899864"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="415899864"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:47:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="653129444"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="653129444"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:47:58 -0700
Message-ID: <931ad127-4ff5-20b3-d551-9a144b3cd7c8@intel.com>
Date: Fri, 19 May 2023 10:47:57 -0700
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
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> It mainly fix monitor not working when log file is specified. For
> example
> $ cxl monitor -l ./cxl-monitor.log
> It seems that someone missed something at the begining.
> 
> Furture, it compares the filename with reserved works more accurately
> 
> Li Zhijian (6):
>    cxl/monitor: Fix monitor not working
>    cxl/monitor: compare the whole filename with reserved words
>    cxl/monitor: Enable default_log and refactor sanity check
>    cxl/monitor: always log started message
>    Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
>    ndctl/monitor: compare the whole filename with reserved words
> 
>   Documentation/cxl/cxl-monitor.txt |  3 +-
>   cxl/monitor.c                     | 47 ++++++++++++++++---------------
>   ndctl/monitor.c                   |  4 +--
>   3 files changed, 27 insertions(+), 27 deletions(-)
> 

Please cc linux-cxl@vger.kernel.org as well for future revs since this 
impacts CXL CLI.
