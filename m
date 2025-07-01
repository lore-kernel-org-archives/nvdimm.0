Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30D9FC0A
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 02:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751338164; cv=none; b=R++41XmzQo5n0hDsRpwdyPstY/a5Spt8StHvLMmPy8kVvIlBUgBYYjibNdrinsGk0tdcyXTkDUEYzo0H+9LUBwIVOMH9/6O2iXpfFxbZyHYjSfI7L1DlfUHcoRW5VNAAx4Peyl4v5b4b/4ja+7aJhhi6++AVNAOSHRvICtlAN68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751338164; c=relaxed/simple;
	bh=Zm+b7msIzvUU1taQ+/eL2c5T/hzT63m/TqIPO/3nYWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4wTdRU/pv3umx41fhnQpYFwo/ra2DEfpKR90nJofbfhI19MlkdPVJXV1nXzeJLofCtZiKWbF8ieY3LWaVuzpDfUlxLqgjKcZYWQMsJO2C86KChBq5IQjFsAueVIUzkD8OPcTMHFYj4atGHeZXlqMfsTpUA1jSjFtW7m9RIst/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=btFVcFLf; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="btFVcFLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751338133;
	bh=iCikdi9PFpf0JfYQKaUXWT5hILOT0VaIoEga0SEMW7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=btFVcFLfQhoUuYUxZ1NlKgbGYmpxKNI6iIRvd/tur2dQ90SNivQOZWuc2NNewUSJH
	 4VdHWFIIc1mw+vyz3QUaxHjAUD8H5v/r+jk5NS0cUT74jWGmg5iViBnkwuAVpB5VNz
	 Udxkv5hL7Bf9s6IIDChkl01U7psYcBiV4o16YvS0=
Received: from [10.56.52.9] ([39.156.73.10])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id C3416C83; Tue, 01 Jul 2025 10:48:52 +0800
X-QQ-mid: xmsmtpt1751338132tf0fgvgo8
Message-ID: <tencent_985F05467310610C8284AEB2102E5955C009@qq.com>
X-QQ-XMAILINFO: OeJ9zRfntlNPfoTaewtNC7pEiF5g+52uKe2MG7zYislkbu/kAPq03gms+oHEoL
	 VLQfc3EhKonBWqmxHID4PYQrayfGrzfZpBPfwKe5ybQMulcDXm2aZLTlwd8p1i403/P49uQZJ6rX
	 NwP9MZXpebgIGpKjYsmx+S8DYuAHihx2z+Bc8TrEmH9UP+/p74JyYnTAB8i9p2IDg17vv4Ph32wQ
	 xv+O/Y1A8Yd7yExEDIuJOhbxa4C2p+z8q0fG1az4vqfDIKBTtHDdIa5DUCuuS6ENtkSTa1a+QMEQ
	 0RmqSG5CPWepCc8UkbfBhJDnLozgoHJrUHDv9AsEiA/q23WgilQ/TS64I5asKH/PxI/XsQuPb5QZ
	 rLlD+UDC/p35p4MYyUqc8AB9B34jC/G4uv4M+PInOQDthLpd/A3ck8v8Mo8lh3uayrsnNcTLnL/X
	 50DWCht27d8cgM/kXqImkG8Of3xy3wAtSfdSPveX0L8VRWHU1oGhk1wUHiwdZbd7pdyfIqcAqOxP
	 mazMKl24+SeunDGeN5RhtV/ictWnAnQKwZnD2MM+OqdF1iMnCu3J/4oeBgMHEu3CJUD3MMMxGZAt
	 tNVltN9+oztm8BtzIvnW3+/sjL+mUpQrUpTNT0OGZ/OLsEi3HMKv3jgm4yS+gpUHPeR5lH5BAmpp
	 teD0oGhT+BNg2JSiU0hV2K+c136PUxGTCL7D4BROuAVlu24MF5imVg7X7wrX/rug2+H+5O3JDUZb
	 oPeJ5IbgkMt8hVqr8xqnJCXgDDnIlTq/rnGqdRqMUmw/wb5Sbc8k/II1IYle9+T4NjnHa7kFKR71
	 dpCPmiHcnim2NMWk2Z6+mNQjHvAgHHN+hSqzAi/8bTspUf7uUpPFSpA6uACQEJDWo6R0lfVEbtph
	 /Z5nkoNvC1QVcDdOnUi0fbmJ+60R13apLBM0yqOPnjsV6JGX2V2L9x4LOEZxju2PATKtfQvQ5vOn
	 +gSy6ZDHCfIQr6VvuzNC4Z8raSqnSj5kzz3BYcYWUJmyirPJqGnk/2laC07eI0
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-OQ-MSGID: <b206022b-fefa-44dc-8bdb-4a5172e7c6bd@foxmail.com>
Date: Tue, 1 Jul 2025 10:48:51 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] Documentation: cxl,daxctl,ndctl add --list-cmds
 info
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Rong Tao <rongtao@cestc.cn>, rtoax@foxmail.com
References: <tencent_9A6812E28AC195905396EEE5A8CAD2ABD306@qq.com>
 <aGMw9JLysjOf2KWY@aschofie-mobl2.lan>
Content-Language: en-US
From: Rong Tao <rtoax@foxmail.com>
In-Reply-To: <aGMw9JLysjOf2KWY@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/1/25 08:51, Alison Schofield wrote:
> On Mon, Jun 30, 2025 at 03:28:25PM +0800, Rong Tao wrote:
>> From: Rong Tao <rongtao@cestc.cn>
>>
>> Such as daxctl(1) manual.
> What does the 'Such as ...' mean?  I thought that it meant you saw
> the --list-cmds as an option in another of our family of commands,
> but I don't see it.

Thanks for your reply, There are three commands has --list-cmds argument:

$ cxl --list-cmds

$ daxctl --list-cmds

$ ndctl --list-cmds

Thus, this patch add --list-cmds in man-page for those three tools.

>
> For these, the --list-cmds, is a suggestion in the --help option,
> like this:
>
> $ ndctl -h
>
>   usage: ndctl [--version] [--help] COMMAND [ARGS]
>
>   See 'ndctl help COMMAND' for more information on a specific command.
>   ndctl --list-cmds to see all available commands
>
>
>
>> Signed-off-by: Rong Tao <rongtao@cestc.cn>
>> ---
>>   Documentation/cxl/cxl.txt       | 3 +++
>>   Documentation/daxctl/daxctl.txt | 3 +++
>>   Documentation/ndctl/ndctl.txt   | 3 +++
>>   3 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/cxl/cxl.txt b/Documentation/cxl/cxl.txt
>> index 41a51c7d3892..546207d885eb 100644
>> --- a/Documentation/cxl/cxl.txt
>> +++ b/Documentation/cxl/cxl.txt
>> @@ -14,6 +14,9 @@ SYNOPSIS
>>   
>>   OPTIONS
>>   -------
>> +--list-cmds::
>> +  Display all available commands.
>> +
>>   -v::
>>   --version::
>>     Display the version of the 'cxl' utility.
>> diff --git a/Documentation/daxctl/daxctl.txt b/Documentation/daxctl/daxctl.txt
>> index f81b161c9771..606abc3e9635 100644
>> --- a/Documentation/daxctl/daxctl.txt
>> +++ b/Documentation/daxctl/daxctl.txt
>> @@ -14,6 +14,9 @@ SYNOPSIS
>>   
>>   OPTIONS
>>   -------
>> +--list-cmds::
>> +  Display all available commands.
>> +
>>   -v::
>>   --version::
>>     Display daxctl version.
>> diff --git a/Documentation/ndctl/ndctl.txt b/Documentation/ndctl/ndctl.txt
>> index c2919de4692d..08c3e949418a 100644
>> --- a/Documentation/ndctl/ndctl.txt
>> +++ b/Documentation/ndctl/ndctl.txt
>> @@ -14,6 +14,9 @@ SYNOPSIS
>>   
>>   OPTIONS
>>   -------
>> +--list-cmds::
>> +  Display all available commands.
>> +
>>   -v::
>>   --version::
>>     Display ndctl version.
>> -- 
>> 2.50.0
>>
>>

