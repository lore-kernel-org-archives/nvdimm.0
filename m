Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB3E7F1
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 01:17:10 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="127884784"
X-IronPort-AV: E=Sophos;i="6.01,163,1684767600"; 
   d="scan'208";a="127884784"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2023 10:15:58 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 95E69CD7E3
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 10:15:56 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id CB847BF4A5
	for <nvdimm@lists.linux.dev>; Fri, 11 Aug 2023 10:15:55 +0900 (JST)
Received: from [10.167.215.54] (unknown [10.167.215.54])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E7BBC200649E2;
	Fri, 11 Aug 2023 10:15:54 +0900 (JST)
Message-ID: <acb201df-0c24-15f8-a8e8-d540e7bc88ee@fujitsu.com>
Date: Fri, 11 Aug 2023 09:15:54 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [NDCTL PATCH] daxctl: Remove unused mem_zone variable
To: Fan Ni <fan.ni@gmx.us>
Cc: vishal.l.verma@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20230809154636.11887-1-yangx.jy@fujitsu.com>
 <ZNUYFSTHC6kEirhm@debian>
From: Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <ZNUYFSTHC6kEirhm@debian>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27806.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27806.003
X-TMASE-Result: 10--2.841300-10.000000
X-TMASE-MatchedRID: 2UwwcHKl5CGPvrMjLFD6eK5i3jK3KDOoC/ExpXrHizx/iZ1aNsYG7jm0
	6SVjjUzh4vM1YF6AJbZFi+KwZZttL8wvFGpbh1azBOQ+j4qQlXRMECZBMumdcI2j49Ftap9Esjv
	NV98mpPOxcTWnW31zc34K3GG6eAgrX20LPwwRkz+MTqeF52Ei21TUC56N6QJlu+/rqBF+glcGHm
	qEGnqhtqa8Z7flSDKrqWo38hoFmHI=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

On 2023/8/11 1:02, Fan Ni wrote:
> The enum definition is not used also.
Hi Fan,

Good catch, I will send v2 patch to remove it.

Best Regards,
Xiao Yang
> 
> Fan
