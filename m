Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09572107AD
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 12:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="138571083"
X-IronPort-AV: E=Sophos;i="6.03,289,1694703600"; 
   d="scan'208";a="138571083"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 21:46:47 +0900
Received: from oym-m2.gw.nic.fujitsu.com (oym-nat-oym-m2.gw.nic.fujitsu.com [192.168.87.59])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4C854DC146
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 21:46:44 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 796BABF3C0
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 21:46:43 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 00A1A20050190
	for <nvdimm@lists.linux.dev>; Thu,  9 Nov 2023 21:46:43 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 87A711A0074;
	Thu,  9 Nov 2023 20:46:41 +0800 (CST)
Message-ID: <8d9780de-f44f-5f63-5a3b-0e9d1f2ae6cf@fujitsu.com>
Date: Thu, 9 Nov 2023 20:46:40 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [NDCTL PATCH] cxl: Augment documentation on cxl operational
 behavior
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <169878439580.80025.16527732447076656149.stgit@djiang5-mobl3>
 <47d34bd4-de45-4743-9151-7e6a0cdd5c4a@intel.com>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <47d34bd4-de45-4743-9151-7e6a0cdd5c4a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27986.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27986.004
X-TMASE-Result: 10--16.137200-10.000000
X-TMASE-MatchedRID: Y0uQemhUR+GPvrMjLFD6eKpLARk+zpBZ2q80vLACqaeqvcIF1TcLYANw
	091XoRE6OsRVjShOPfX8Hq39FoLYeSgQpO8og5VKq0reih3E9rH1+9bO3CCbk+jMOEZ5AL0SdTe
	gpK7QnXFSHmZoogkDH+affHI8kAmiHY/bzRmIaZGqh5pv1eDPz8CY5/Mqi1Oidh2Rg67LFVLhDo
	h7wbP2f7X80TaNz00Yl8acA/69mB5MGF0Ua9spp7cPsR57JkIz2FA7wK9mP9eQx0NjGmV8+N6ur
	nXKpk/cLoD4tn9vWJIP+Fbf+/0nMrEdg3YlRRHLngIgpj8eDcBZDL1gLmoa/ALDAYP4AXVR7nY5
	1lwLq08gBwKKRHe+r3wQlhqfsX2sc7pw8xyOPoajzhAGxA8H8TRpkD673kluprkrETGdcEU=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2023/11/1 4:34, Dave Jiang 写道:
> 
> 
> On 10/31/23 13:33, Dave Jiang wrote:
>> If a cxl operation is executed resulting in no-op, the tool will still
>> emit the number of targets the operation has succeeded on. For example, if
>> disable-region is issued and the region is already disabled, the tool will
>> still report 1 region disabled. Add verbiage to man pages to document the
>> behavior.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> Cc Quanquan
> 
>> ---
>>   Documentation/cxl/cxl-disable-bus.txt    |    2 ++
>>   Documentation/cxl/cxl-disable-memdev.txt |    1 +
>>   Documentation/cxl/cxl-disable-port.txt   |    2 ++
>>   Documentation/cxl/cxl-disable-region.txt |    2 ++
>>   Documentation/cxl/cxl-enable-memdev.txt  |    2 ++
>>   Documentation/cxl/cxl-enable-port.txt    |    2 ++
>>   Documentation/cxl/cxl-enable-region.txt  |    2 ++
>>   Documentation/cxl/meson.build            |    1 +
>>   Documentation/cxl/operations.txt         |   17 +++++++++++++++++
>>   9 files changed, 31 insertions(+)
>>   create mode 100644 Documentation/cxl/operations.txt
>>
>> diff --git a/Documentation/cxl/cxl-disable-bus.txt b/Documentation/cxl/cxl-disable-bus.txt
>> index 65f695cd06c8..992a25ec8506 100644
>> --- a/Documentation/cxl/cxl-disable-bus.txt
>> +++ b/Documentation/cxl/cxl-disable-bus.txt
>> @@ -15,6 +15,8 @@ SYNOPSIS
>>   For test and debug scenarios, disable a CXL bus and any associated
>>   memory devices from CXL.mem operations.
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   -f::
>> diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
>> index d39780250939..fc7eeee61c3e 100644
>> --- a/Documentation/cxl/cxl-disable-memdev.txt
>> +++ b/Documentation/cxl/cxl-disable-memdev.txt
>> @@ -12,6 +12,7 @@ SYNOPSIS
>>   [verse]
>>   'cxl disable-memdev' <mem0> [<mem1>..<memN>] [<options>]
>>   
>> +include::operations.txt[]
>>   
>>   OPTIONS
>>   -------
>> diff --git a/Documentation/cxl/cxl-disable-port.txt b/Documentation/cxl/cxl-disable-port.txt
>> index 7a22efc3b821..451aa01fefdd 100644
>> --- a/Documentation/cxl/cxl-disable-port.txt
>> +++ b/Documentation/cxl/cxl-disable-port.txt
>> @@ -15,6 +15,8 @@ SYNOPSIS
>>   For test and debug scenarios, disable a CXL port and any memory devices
>>   dependent on this port being active for CXL.mem operation.
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   -e::
>> diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
>> index 6a39aee6ea69..4b0625e40bf6 100644
>> --- a/Documentation/cxl/cxl-disable-region.txt
>> +++ b/Documentation/cxl/cxl-disable-region.txt
>> @@ -21,6 +21,8 @@ EXAMPLE
>>   disabled 2 regions
>>   ----
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   include::bus-option.txt[]
>> diff --git a/Documentation/cxl/cxl-enable-memdev.txt b/Documentation/cxl/cxl-enable-memdev.txt
>> index 5b5ed66eadc5..436f063e5517 100644
>> --- a/Documentation/cxl/cxl-enable-memdev.txt
>> +++ b/Documentation/cxl/cxl-enable-memdev.txt
>> @@ -18,6 +18,8 @@ it again. This involves detecting the state of the HDM (Host Managed
>>   Device Memory) Decoders and validating that CXL.mem is enabled for each
>>   port in the device's hierarchy.
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   <memory device(s)>::
>> diff --git a/Documentation/cxl/cxl-enable-port.txt b/Documentation/cxl/cxl-enable-port.txt
>> index 50b53d1f48d1..8b51023d2e16 100644
>> --- a/Documentation/cxl/cxl-enable-port.txt
>> +++ b/Documentation/cxl/cxl-enable-port.txt
>> @@ -18,6 +18,8 @@ again. This involves detecting the state of the HDM (Host Managed Device
>>   Memory) Decoders and validating that CXL.mem is enabled for each port in
>>   the device's hierarchy.
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   -e::
>> diff --git a/Documentation/cxl/cxl-enable-region.txt b/Documentation/cxl/cxl-enable-region.txt
>> index f6ef00fb945d..f3d3d9db1674 100644
>> --- a/Documentation/cxl/cxl-enable-region.txt
>> +++ b/Documentation/cxl/cxl-enable-region.txt
>> @@ -21,6 +21,8 @@ EXAMPLE
>>   enabled 2 regions
>>   ----
>>   
>> +include::operations.txt[]
>> +
>>   OPTIONS
>>   -------
>>   include::bus-option.txt[]
>> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
>> index c5533572ef75..7c70956c3b53 100644
>> --- a/Documentation/cxl/meson.build
>> +++ b/Documentation/cxl/meson.build
>> @@ -25,6 +25,7 @@ filedeps = [
>>     'debug-option.txt',
>>     'region-description.txt',
>>     'decoder-option.txt',
>> +  'operations.txt',
>>   ]
>>   
>>   cxl_manpages = [
>> diff --git a/Documentation/cxl/operations.txt b/Documentation/cxl/operations.txt
>> new file mode 100644
>> index 000000000000..046e2bc19532
>> --- /dev/null
>> +++ b/Documentation/cxl/operations.txt
>> @@ -0,0 +1,17 @@
>> +// SPDX-License-Identifier: gpl-2.0
>> +
>> +Given any en/disabling operation, if the operation is a no-op due to the
>> +current state of a target, it is still considered successful when executed
>> +even if no actual operation is performed. The target applies to a bus,
>> +decoder, memdev, or region.
>> +
>> +For example:
>> +If a CXL region is already disabled and the cxl disable-region is called:
>> +
>> +----
>> +# cxl disable-region region0
>> +disabled 1 regions
>> +----
>> +
>> +The operation will still succeed with the number of regions operated on
>> +reported, even if the operation is a non-action.
>>

Hi Dave,

Thanks for adding this description. It's easier for our user to understand.

Reviewed-by: Quanquan Cao <caoqq@fujitsu.com>

