Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35778D261
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="138071805"
X-IronPort-AV: E=Sophos;i="6.03,262,1694703600"; 
   d="scan'208";a="138071805"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 15:41:40 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id E509AD7AC6
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 15:41:38 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 2403ED9464
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 15:41:38 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id AA5066BF5F
	for <nvdimm@lists.linux.dev>; Mon, 30 Oct 2023 15:41:37 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 274071A006F;
	Mon, 30 Oct 2023 14:41:37 +0800 (CST)
Message-ID: <dc013f7b-2039-e2ed-01ad-705435d16862@fujitsu.com>
Date: Mon, 30 Oct 2023 14:41:36 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
Subject: [ISSUE] `cxl disable-region region0` twice but got same output
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27966.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27966.005
X-TMASE-Result: 10--11.317500-10.000000
X-TMASE-MatchedRID: RsPxVIkBekyGYAKJjm5IPTzXNFWi6yZNr+LsAsPJG4slYVv6LtrHl3WB
	CryV0eEg0No1mkr2A1g12eGIkrztuifTKFkLcSP/fzgVmnL/olWUq+GQ/zyJdCn8yHamPzPNqbs
	+nJ/tFJF+DMNbPFpRgVzO9zXj3kC+5Ibfb+rfK2P4vYawCsCC2pbRfsVvs4VI/gMNehoKqTvUd9
	aQiKn+Wq8P28/BvN30tg7+Bof1MXKzRnb8olvc599JA2lmQRNUKZV0aMRuHpOiC7BD4niBmD/bP
	m7tO5sUE3r+n32a9SXtYYIvaupuZpcFdomgH0lnOX/V8P8ail1ZDL1gLmoa/A2V/fR8BQ7CKrau
	Xd3MZDV9CEIFVHpQLcAC1/XUBa4/M6mxgFdgPCmMmb5mmPV1UIdgEbyB9Ypz
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Dear Linux Community Members,

I am writing to seek assistance with a issue that I have encountered 
while testing [Repeat executing the "cxl disable-region region0" 
command]. I have provided a detailed description of the problem along 
with relevant test for reference. I would greatly appreciate it if you 
could spare some time to help me resolve this issue.

Problem Description:

After investigation, it was found that when disabling the region and 
attempting to disable the same region again, the message "cxl region: 
cmd_disable_region: disabled 1 region" is still returned.
I consider this to be unreasonable.


Test Example:

[root@fedora-37-client memory]# cxl list
[
   {
     "memdevs":[
       {
         "memdev":"mem0",
         "ram_size":1073741824,
         "serial":0,
         "host":"0000:0d:00.0"
       }
     ]
   },
   {
     "regions":[
       {
         "region":"region0",
         "resource":27111981056,
         "size":1073741824,
         "type":"ram",
         "interleave_ways":1,
         "interleave_granularity":256,
         "decode_state":"commit"
       }
     ]
   }
]

[root@fedora-37-client ~]# cxl disable-region region0
cxl region: cmd_disable_region: disabled 1 region
[root@fedora-37-client ~]# cxl disable-region region0
cxl region: cmd_disable_region: disabled 1 region

expectation:cmd_disable_region: disabled 0 region


Thank you very much for taking the time to review my issue. I am 
grateful for your assistance and look forward to your response.

Best regards,
Quanquan Cao
caoqq@fujitsu.com
