Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D45295536
	for <nvdimm@lists.linux.dev>; Wed, 30 Apr 2025 20:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746043670; cv=none; b=NsItNuIoIL/dIJrashoH6Q+Sa92VChO5XBjTFx56dLK3yo7icPXtosXUS2xFcwXur1sJGqtUy24P0S8HxffQr7RxM9Y28bPbpTfQh5GjZm7vIIGOviSPYvz8qzU/PxiVUL3OHyutMV2Kc9MZkfJWWG7fY9zNpyF6vjAECXq1knc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746043670; c=relaxed/simple;
	bh=/014ig/vOtXLleLlc5POQLGIpZfKag2WAJwe0NM0ssg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=twE5TvGVmh2UOUSaK2ziIVAZXXTczyFPJWAunChTIWq9jTJewE2BxZAYyBEFSKXXgxLkmKcrpgOeq0Ih/GwyYFSSwSb0BsrbPUXI+Ca8smnaNO826HY6RVcBBTee4QlS5Ubl7/6MAC2zF8Uh/wSlRUwawjx8fOfoitcRyAiUVoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=cIYp2AOr; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="cIYp2AOr"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id A3qpuCxndzZPaADiduvGYl; Wed, 30 Apr 2025 20:07:47 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id ADicuJ4w5SPIxADicuZmKa; Wed, 30 Apr 2025 20:07:46 +0000
X-Authority-Analysis: v=2.4 cv=MdZquY/f c=1 sm=1 tr=0 ts=68128312
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=efVMuJ2jJG67FGuSm7J3ww==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=oxfijZKff90vd35IHugA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=h2tkyVN64pIV8hWBO6rBTclvumzy8P9/KwD3hFpi4zU=; b=cIYp2AOrhsxIemYqDaRuFpGrUh
	bJfgWLnX+phxwlnYRTtMhW7GEMI2zjMZjy2NEia5ZnZMzo/jDnxaap5ZuoYxRjdSHv712CVjFs/N5
	6gJtMU4fIwZmfBt+qdWXhqlbl4lPZWqMEnkGgTGonu2CnkeP7a17k+Kj9hGTphKfKtTiR+GT3m6c5
	9BHkWIrA24bJUVfJhv2EhbnygO5ySM2KcWosv3FrtpmWd93keddzE8HczLETO7riL0fuU/VxtIED/
	+bk+hxUCVEaZ9JCbxySs61qCBHLjxcAIY6nqdFO/UNKFUu/eROWKpgPuNLRUs0uLH4St//wyjSggv
	n+AZC9yg==;
Received: from [177.238.17.151] (port=47562 helo=[192.168.0.101])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uADib-00000003MZY-0Vw0;
	Wed, 30 Apr 2025 15:07:45 -0500
Message-ID: <c4828c41-e46c-43c9-a73a-38ce8ab2c1c4@embeddedor.com>
Date: Wed, 30 Apr 2025 14:07:24 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2][next] acpi: nfit: intel: Avoid multiple
 -Wflex-array-member-not-at-end warnings
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
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
 <df338a70-fdfc-427e-9915-8b9e50de93ad@embeddedor.com>
Content-Language: en-US
In-Reply-To: <df338a70-fdfc-427e-9915-8b9e50de93ad@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.17.151
X-Source-L: No
X-Exim-ID: 1uADib-00000003MZY-0Vw0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.101]) [177.238.17.151]:47562
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJfuPwXWHJW5O4sls7sfIoOtxjiLTea3bewJVl6o0Li4Kj+6m8zLYu+/h7+26Efzc7pOXUGNpG4DvUD2ElklKcVl7uKxiZup9kvFngMsyVBuUi66RxPF
 utZ62IO7G0zQ84ghZG4agtWo5+yMEBOtZWSvzi7QzFlMaSIoO5IQBXaHRdqxoUB9pSxLTD83E5Mo6u9u6hGRcH9r6wpwTd7v4Xc=



On 30/04/25 13:41, Gustavo A. R. Silva wrote:
> 
> 
> On 27/03/25 08:03, Dan Williams wrote:
>> Gustavo A. R. Silva wrote:
>>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>>> getting ready to enable it, globally.
>>>
>>> Use the `DEFINE_RAW_FLEX()` helper for on-stack definitions of
>>> a flexible structure where the size of the flexible-array member
>>> is known at compile-time, and refactor the rest of the code,
>>> accordingly.
>>>
>>> So, with these changes, fix a dozen of the following warnings:
>>>
>>> drivers/acpi/nfit/intel.c:692:35: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
>>>
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>> ---
>>> Changes in v2:
>>>   - Use DEFINE_RAW_FLEX() instead of __struct_group().
>>>
>>> v1:
>>>   - Link: https://lore.kernel.org/linux-hardening/Z618ILbAR8YAvTkd@kspp/
>>>
>>>   drivers/acpi/nfit/intel.c | 388 ++++++++++++++++++--------------------
>>>   1 file changed, 179 insertions(+), 209 deletions(-)
>>>
>>> diff --git a/drivers/acpi/nfit/intel.c b/drivers/acpi/nfit/intel.c
>>> index 3902759abcba..114d5b3bb39b 100644
>>> --- a/drivers/acpi/nfit/intel.c
>>> +++ b/drivers/acpi/nfit/intel.c
>>> @@ -55,21 +55,17 @@ static unsigned long intel_security_flags(struct nvdimm *nvdimm,
>>>   {
>>>       struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
>>>       unsigned long security_flags = 0;
>>> -    struct {
>>> -        struct nd_cmd_pkg pkg;
>>> -        struct nd_intel_get_security_state cmd;
>>> -    } nd_cmd = {
>>> -        .pkg = {
>>> -            .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
>>> -            .nd_family = NVDIMM_FAMILY_INTEL,
>>> -            .nd_size_out =
>>> -                sizeof(struct nd_intel_get_security_state),
>>> -            .nd_fw_size =
>>> -                sizeof(struct nd_intel_get_security_state),
>>> -        },
>>> -    };
>>> +    DEFINE_RAW_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
>>> +            sizeof(struct nd_intel_get_security_state));
>>> +    struct nd_intel_get_security_state *cmd =
>>> +            (struct nd_intel_get_security_state *)nd_cmd->nd_payload;
>>>       int rc;
>>> +    nd_cmd->nd_command = NVDIMM_INTEL_GET_SECURITY_STATE;
>>> +    nd_cmd->nd_family = NVDIMM_FAMILY_INTEL;
>>> +    nd_cmd->nd_size_out = sizeof(struct nd_intel_get_security_state);
>>> +    nd_cmd->nd_fw_size = sizeof(struct nd_intel_get_security_state);
>>
>> Can this keep the C99 init-style with something like (untested):
>>
>> _DEFINE_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
>>               sizeof(struct nd_intel_get_security_state), {
>>         .pkg = {
>>                 .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
>>                 .nd_family = NVDIMM_FAMILY_INTEL,
>>                 .nd_size_out =
>>                         sizeof(struct nd_intel_get_security_state),
>>                 .nd_fw_size =
>>                         sizeof(struct nd_intel_get_security_state),
>>         },
>>     });
>>
>>
>> ?
> 
> The code below works - however, notice that in this case we should
> go through 'obj', which is an object defined in _DEFINE_FLEX().
> 
>          _DEFINE_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
>                          sizeof(struct nd_intel_get_security_state), = {
>                  .obj = {
>                          .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
>                          .nd_family = NVDIMM_FAMILY_INTEL,
>                          .nd_size_out =
>                                  sizeof(struct nd_intel_get_security_state),
>                          .nd_fw_size =
>                                  sizeof(struct nd_intel_get_security_state),
>                  },
>          });
> 

Now, I can modify the helper like this:

diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 69533e703be5..170d3cfe7ecc 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -404,7 +404,7 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
         union {                                                                 \
                 u8 bytes[struct_size_t(type, member, count)];                   \
                 type obj;                                                       \
-       } name##_u initializer;                                                 \
+       } name##_u = { .obj initializer };                                      \
         type *name = (type *)&name##_u

  /**

and then we can use the helper as follows:

         _DEFINE_FLEX(struct nd_cmd_pkg, nd_cmd, nd_payload,
                         sizeof(struct nd_intel_get_security_state), = {
                         .nd_command = NVDIMM_INTEL_GET_SECURITY_STATE,
                         .nd_family = NVDIMM_FAMILY_INTEL,
                         .nd_size_out =
                                 sizeof(struct nd_intel_get_security_state),
                         .nd_fw_size =
                                 sizeof(struct nd_intel_get_security_state),
         });

OK, I'll go and update the helper.

-Gustavo

