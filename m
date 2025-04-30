Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3591311AC
	for <nvdimm@lists.linux.dev>; Wed, 30 Apr 2025 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746042122; cv=none; b=Y0k/Tu4i/a0PYxh7cbmVbveQwcTpODkDE7+Pd71ekym1bMbOrdYxVyS/W1mEZyHmSv7GPFuUTERGiPTaXoZTKI0TW6TQst7wWMM3u7kY/VIEOkeGFbDuCIzDYzTWLynbnpN18etoQZ2cfpIO6B8U3z0k9eOYMOvH11Nqex/7U98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746042122; c=relaxed/simple;
	bh=aNlI5doREuFnpNBygwYJ3vVeRE4exj3jm3zEaNbahzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fMYTKyPtSjpXXOywMvOVdnQ2L+Lv27qZHEZBE2swkB3suo3BaLxD1y93BnJ4J3hN4/3Rv6vwlMYgNmA9XmfnJ025PcjXINaN0kGBb+HgtKyS86pRl7np48x0VWPo0RFdYeZjicCfpmSw/UcCOrnbwmR0wBUl6qYGOFw1GcpmIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=Mj/tOxD9; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="Mj/tOxD9"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id A3qxuLuWKiuzSADJauOLBx; Wed, 30 Apr 2025 19:41:54 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id ADJZunbyE4LOpADJZuJbjn; Wed, 30 Apr 2025 19:41:53 +0000
X-Authority-Analysis: v=2.4 cv=L6MbQfT8 c=1 sm=1 tr=0 ts=68127d01
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=efVMuJ2jJG67FGuSm7J3ww==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=pWlpG66K428ilhL_DWUA:9 a=QEXdDO2ut3YA:10 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bjBrQjQU2afaw/LgDKWhKIXfjuWHuTWx5Msxh3WnN5Y=; b=Mj/tOxD9PutqF7L7pmpkZUOujQ
	zUq/sOjq3INBElVfO+dyqRIfdtf2RIGY61ahoAUVv8w1oNhos33PUewqsonq7E0ZPAGBqwKXYn2us
	0IOsf9uqAhD2HT1cySyw7qUzw8qgvMAhB942pmYdS0qvXG8utkUxxS3zgFttrThCStSu+eRBGgMrx
	ZYosA+tTCQYsfjprs7rs8CqstKr581CVKlzgp6XDUq16w7IRZSL81ezZ0U4TIYLR5efgCBLKNnLFR
	EgcsyglBIC7px8NLYB4Mn8z9wID9TL6B0Osuyg/8Rxo3LaWLiz5+/j64OagP8OYi+udUQZXNNvW3J
	dJLLsdoA==;
Received: from [177.238.17.151] (port=23848 helo=[192.168.0.101])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uADJY-00000002pqq-0b9b;
	Wed, 30 Apr 2025 14:41:52 -0500
Message-ID: <df338a70-fdfc-427e-9915-8b9e50de93ad@embeddedor.com>
Date: Wed, 30 Apr 2025 13:41:39 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] acpi: nfit: intel: Avoid multiple
 -Wflex-array-member-not-at-end warnings
To: Dan Williams <dan.j.williams@intel.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Len Brown <lenb@kernel.org>
Cc: nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <Z-QpUcxFCRByYcTA@kspp>
 <67e55ac4dfa2e_13cb29410@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <67e55ac4dfa2e_13cb29410@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.17.151
X-Source-L: No
X-Exim-ID: 1uADJY-00000002pqq-0b9b
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.101]) [177.238.17.151]:23848
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKe2bnIZvjrC2d+dVKCvGRkBtcUcIv8dNA7WMYlPdSkE5RKMvW9X27BV6HVsVKrQaawC0IHv8idTfr6GMtLualU5jw9Jx5cOQtBno6GL6RVvw09eiOiG
 IcwAK8pVHyanA6f1MD5GtELgadezApN+y1eGGr9dKfr3kV3j9yq0Ac57YppPi0PnYloQPdfyG4e6+twBdYr6iKJj5bVxQrpaWus=



On 27/03/25 08:03, Dan Williams wrote:
> Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Use the `DEFINE_RAW_FLEX()` helper for on-stack definitions of
>> a flexible structure where the size of the flexible-array member
>> is known at compile-time, and refactor the rest of the code,
>> accordingly.
>>
>> So, with these changes, fix a dozen of the following warnings:
>>
>> drivers/acpi/nfit/intel.c:692:35: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>> Changes in v2:
>>   - Use DEFINE_RAW_FLEX() instead of __struct_group().
>>
>> v1:
>>   - Link: https://lore.kernel.org/linux-hardening/Z618ILbAR8YAvTkd@kspp/
>>
>>   drivers/acpi/nfit/intel.c | 388 ++++++++++++++++++--------------------
>>   1 file changed, 179 insertions(+), 209 deletions(-)
>>
>> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
>> index 3902759abcba..114d5b3bb39b 100644
>> --- a/drivers/acpi/nfit/intel.c
>> +++ b/drivers/acpi/nfit/intel.c
>> @@ -55,21 +55,17 @@ static unsigned long intel_security_flags(struct nvdimm *nvdimm,
>>   {
>>   	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>>   	unsigned long security_flags = 0;
>> -	struct {
>> -		struct nd_cmd_pkg pkg;
>> -		struct nd_intel_get_security_state cmd;
>> -	} nd_cmd = {
>> -		.pkg = {
>> -			.nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
>> -			.nd_family = NVDIMM_FAMILY_INTEL,
>> -			.nd_size_out =
>> -				sizeof(struct nd_intel_get_security_state),
>> -			.nd_fw_size =
>> -				sizeof(struct nd_intel_get_security_state),
>> -		},
>> -	};
>> +	DEFINE_RAW_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
>> +			sizeof(struct nd_intel_get_security_state));
>> +	struct nd_intel_get_security_state *cmd =
>> +			(struct nd_intel_get_security_state *)nd_cmd->nd_payload;
>>   	int rc;
>>   
>> +	nd_cmd->nd_command = NVDIMM_INTEL_GET_SECURITY_STATE;
>> +	nd_cmd->nd_family = NVDIMM_FAMILY_INTEL;
>> +	nd_cmd->nd_size_out = sizeof(struct nd_intel_get_security_state);
>> +	nd_cmd->nd_fw_size = sizeof(struct nd_intel_get_security_state);
> 
> Can this keep the C99 init-style with something like (untested):
> 
> _DEFINE_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
>               sizeof(struct nd_intel_get_security_state), {
> 		.pkg = {
> 		        .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
> 		        .nd_family = NVDIMM_FAMILY_INTEL,
> 		        .nd_size_out =
> 		                sizeof(struct nd_intel_get_security_state),
> 		        .nd_fw_size =
> 		                sizeof(struct nd_intel_get_security_state),
> 		},
> 	});
> 	
> 
> ?

The code below works - however, notice that in this case we should
go through 'obj', which is an object defined in _DEFINE_FLEX().

         _DEFINE_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
                         sizeof(struct nd_intel_get_security_state), = {
                 .obj = {
                         .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
                         .nd_family = NVDIMM_FAMILY_INTEL,
                         .nd_size_out =
                                 sizeof(struct nd_intel_get_security_state),
                         .nd_fw_size =
                                 sizeof(struct nd_intel_get_security_state),
                 },
         });

Thanks
-Gustavo

