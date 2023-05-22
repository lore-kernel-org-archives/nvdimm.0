Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8C14A8E
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684768592; x=1716304592;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XWcSXzP5mz+Am4FnnTw7pHzD7yOmen6xnonXHFmAYvk=;
  b=S4c4QPRdLTy6SrCfxOaIlRqwbrEmkQ7O0UrzONFDMc8qYJRDr1vXX8fG
   RWkaaEkUHJqAbFnxzoYHcfu3NB+vkwSSn5ObRpUetr6fzpdg409rGIsSA
   cPQJiduPVR0irwnSpKHGt/NSn3raITFErjilXxM2J4QyK10+HFjFhFfoM
   zN3CZ/xIXwe+7yW5l7IrAWvzf2gI09E3SMr3LX7DFPkgiRnoJUWJ6U1k2
   P4qECc+FYiYNYWpY3elsdv6DOVmGTXlIfHeTjflrW210GMoseHb3tLAoU
   ZDAAV+5yHHvUmZLxx6T5wyDajPCYUfBa2rcgzoS3ux2x3GHpf5MkFjusA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381178946"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381178946"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="877791441"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="877791441"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.173.219]) ([10.213.173.219])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:15:58 -0700
Message-ID: <15a8cd60-1549-d21c-02a0-987600237cc8@intel.com>
Date: Mon, 22 May 2023 08:15:57 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 2/6] cxl/monitor: compare the whole filename with
 reserved words
Content-Language: en-US
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <20230513142038.753351-1-lizhijian@fujitsu.com>
 <20230513142038.753351-3-lizhijian@fujitsu.com>
 <e4ebdde3-e51a-be42-135f-f0b3d78259b0@intel.com>
 <875487b1-6495-851e-ba63-28c722d1470f@fujitsu.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <875487b1-6495-851e-ba63-28c722d1470f@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/21/23 11:08 PM, Zhijian Li (Fujitsu) wrote:
> Dave
> 
> 
> On 20/05/2023 01:31, Dave Jiang wrote:
>>
>>
>> On 5/13/23 7:20 AM, Li Zhijian wrote:
>>> For example:
>>> $ cxl monitor -l standard.log
>>>
>>> User is most likely want to save log to ./standard.log instead of stdout.
>>>
>>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>>> ---
>>>    cxl/monitor.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/cxl/monitor.c b/cxl/monitor.c
>>> index 4043928db3ef..842e54b186ab 100644
>>> --- a/cxl/monitor.c
>>> +++ b/cxl/monitor.c
>>> @@ -181,7 +181,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
>>>        if (monitor.log) {
>>>            if (strncmp(monitor.log, "./", 2) != 0)
>>>                fix_filename(prefix, (const char **)&monitor.log);
>>> -        if (strncmp(monitor.log, "./standard", 10) == 0 && !monitor.daemon) {
>>> +
>>> +        if (strcmp(monitor.log, "./standard") == 0 && !monitor.daemon) {
>>
>> The code change doesn't match the commit log. Here it just changed from strncmp() to strcmp(). Please explain what's going on here.
>>
> 
> 
> Okay, i will update more in the commit log. something like:
> 
>       cxl/monitor: use strcmp to compare the reserved word
>       
>       According to its document, when '-l standard' is specified, log would be

s/its document/the tool's documentation/

>       output to the stdout. But actually, since it's using strncmp(a, b, 10)

s/But actually, since/But since/

>       to compare the former 10 characters, it will also wrongly treat a filename

s/treat/detect/

>       starting with a substring 'standard' to stdout.

s/to/as/

>       
>       For example:
>       $ cxl monitor -l standard.log
>       
>       User is most likely want to save log to ./standard.log instead of stdout.
>       
>       Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>       ---
>       V2: commit log updated # Dave

This makes it significantly clearer. Thank you.


> 
> 
> Thanks
> Zhijian
> 
> 
> 
>>>                monitor.ctx.log_fn = log_standard;
>>>            } else {
>>>                const char *log = monitor.log;
