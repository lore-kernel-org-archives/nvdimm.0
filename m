Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A2512B66
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684518223; x=1716054223;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=pmwH08/+Qc7RdOvGIQelDLz28i6Rs8oh6OYMo5Gl8bw=;
  b=W5Vi5GBiGlRSEJqvcy43CjqhMc2R12pEkux4W03V42ae1zn3j312awf4
   fQd178S1zZEd+bPw3+RTNvvCsMXBm47WH9+83I5El/rskgyydlF5dqHRf
   fHweCgMvvUn2rhvnflx7Fw55ZsdAauXlGa7gc9xPivm0urIUF5lMihQaB
   ot1HgYHcCnAJkljcHuIseNvVNnUtbLOrObfHsD8FojnLHPad9WmN+sWw0
   oI2iwncoS9GI8J7PHc0SL/X62fn0frRBd/zZ5/FXWb4nUq+f1FhP+zIeV
   f/wGE4V2/SfnNrVw5g1miaSt0iWYtM1DCnQC43OsYDXbIExGBKbwWq+eX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="380654137"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="380654137"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:43:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="876918818"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="876918818"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 10:43:42 -0700
Message-ID: <3b1cd13c-8714-937b-637c-35772f8a96e9@intel.com>
Date: Fri, 19 May 2023 10:43:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 5/6] Documentation/cxl/cxl-monitor.txt: Fix
 inaccurate description
Content-Language: en-US
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-6-lizhijian@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230513142038.753351-6-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/23 7:20 AM, Li Zhijian wrote:
> No syslog is supported by cxl-monitor
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <davejiang@intel.com>

> ---
>   Documentation/cxl/cxl-monitor.txt | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-monitor.txt b/Documentation/cxl/cxl-monitor.txt
> index 3fc992e4d4d9..c284099f16c3 100644
> --- a/Documentation/cxl/cxl-monitor.txt
> +++ b/Documentation/cxl/cxl-monitor.txt
> @@ -39,8 +39,7 @@ OPTIONS
>   --log=::
>   	Send log messages to the specified destination.
>   	- "<file>":
> -	  Send log messages to specified <file>. When fopen() is not able
> -	  to open <file>, log messages will be forwarded to syslog.
> +	  Send log messages to specified <file>.
>   	- "standard":
>   	  Send messages to standard output.
>   
