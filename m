Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3910A01
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="138554051"
X-IronPort-AV: E=Sophos;i="6.03,288,1694703600"; 
   d="scan'208";a="138554051"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 17:35:38 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5EB42DC147
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 17:35:35 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 5F84213F70
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 17:35:34 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id EA3CB6B808
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 17:35:33 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 726CB1A0072;
	Thu,  9 Nov 2023 16:35:33 +0800 (CST)
Message-ID: <6dc5d1c3-3984-aa82-5e7a-436da62fba40@fujitsu.com>
Date: Thu, 9 Nov 2023 16:35:33 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [ISSUE] `cxl disable-region region0` twice but got same output
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
 <9b0f2cc0330197456bd5c810561b390a7606a26b.camel@intel.com>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <9b0f2cc0330197456bd5c810561b390a7606a26b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27986.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27986.003
X-TMASE-Result: 10--19.812300-10.000000
X-TMASE-MatchedRID: RsPxVIkBekyPvrMjLFD6eDzXNFWi6yZNr+LsAsPJG4vsBZ58WB1sx/3r
	0bsfgu7vGm7YqNxEHLKSxAk2dEaKNbBAQLqGlKivPMcAlOC0qrDYUDvAr2Y/12e7XiVqt/oW1w6
	ADg6BQG+vD9vPwbzd9LYO/gaH9TFyh2Em++ruuH92o0eWLPgBZ45UafLmrvaGauJSrIqqokQ6dE
	UNf2ygXPLXmWYFNSTT+hLkHfU9bp+8pqJQgPnFfY4V8tCoXo/SWmOfr3aLpwgtferJ/d7AbwewL
	2vPz9Rcbp4NcGxU+UgHcHqUK6tMz+VHGbcDbAq6gxsfzkNRlfK51H80nDYkdw1im+j3Fb6Yjocz
	muoPCq2UTGVAhB5EbQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/11/1 1:22, Verma, Vishal L 写道:
> On Mon, 2023-10-30 at 14:41 +0800, Cao, Quanquan/曹 全全 wrote:
>>
> [..]
>> After investigation, it was found that when disabling the region and
>> attempting to disable the same region again, the message "cxl region:
>> cmd_disable_region: disabled 1 region" is still returned.
>> I consider this to be unreasonable.
>>
>>
>> Test Example:
>>
>> [root@fedora-37-client memory]# cxl list
>> [
>>     {
>>       "memdevs":[
>>         {
>>           "memdev":"mem0",
>>           "ram_size":1073741824,
>>           "serial":0,
>>           "host":"0000:0d:00.0"
>>         }
>>       ]
>>     },
>>     {
>>       "regions":[
>>         {
>>           "region":"region0",
>>           "resource":27111981056,
>>           "size":1073741824,
>>           "type":"ram",
>>           "interleave_ways":1,
>>           "interleave_granularity":256,
>>           "decode_state":"commit"
>>         }
>>       ]
>>     }
>> ]
>>
>> [root@fedora-37-client ~]# cxl disable-region region0
>> cxl region: cmd_disable_region: disabled 1 region
>> [root@fedora-37-client ~]# cxl disable-region region0
>> cxl region: cmd_disable_region: disabled 1 region
>>
>> expectation:cmd_disable_region: disabled 0 region
> 
> This is by design, I think it would be more confusing if the user asks
> to disable-region, the response is "disabled 0 regions", and then finds
> that the region is actually in the disabled state.
> 
> There is also precedent for this, as all disable-<foo> commands in
> ndctl and cxl-cli behave the same way.
> 
> Perhaps a clarification in the man page makes sense noting this
> behavior?
> 
About this,i would like to ask if the design adopts the "idempotency" 
pattern
