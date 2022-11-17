Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A15A464
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 22:41:49 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id e15so2126101qts.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 14:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S1BGFqys7Jtb8lD7sSkTOW3GTBGqrLgy8xNbVbL5L4E=;
        b=awWF+a1HQsNMlPQAvF/m9sS7ZOKjach3uZ5ANelNPuQd8A5BcOgxIAWm6rvr0zThYS
         i2L5HA7GzibOt0CcNgG7SrNIaTE185MKrZXO1lTeBPUyILfN5l1SdY8QFd8Xk+Y5K4nG
         cPvOA6p+t3P+hGaPkJOWAa8B4K6uipDUwquUnhWlf7DBv00c9HUPfxB+A26MHIkRYvia
         me9f1wQy57GHfvFYnRI+EOTEdiik2JwqqY72YYht4h6mElILUWsMPbyFooGAHDfQ+UOG
         CX3sX/4als96JN+LloGZrdflZ1m20+yOoQzEfF2YugqA00F6XjpNpN+k4/VGKAYul88Y
         FMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1BGFqys7Jtb8lD7sSkTOW3GTBGqrLgy8xNbVbL5L4E=;
        b=g1VAmhtTrwyNRELpr6YuaFN/b9nqRFXJvcrPBkddo2a6F881jRhx2c9oAnoDtS0F4a
         q8lqCXDflVc9SoihOXRUQ8tGCbrMhCzs46kwTckSa8fswQK/BGqRQCK1YVtoIebjpFWc
         nXXgp1N0CH1KZ09L/7tgp4lZ7U7GPPLC9l85Xt0+VNrC3IF2e3IxFtCdDfw4AeghT4Il
         4ELOoIKyXE9KYwPub31OBCJJs2zsHE72JqiA51iE25EcH1rSmir03Rvn2pnq5D/M5fCo
         kzQAuRmpEkKcE+JWkN3B+PmZpA8dN2QPwnCCr71uIW9mgZlZvthtLGFOeJdhQcHwyvLu
         +Aow==
X-Gm-Message-State: ANoB5pmAntEzIhjR/NO0i9nk6FFI8+ghZhtZ7MDhn2UalxeKnYqriPJM
	v3E0snQF3t/DPNSgJUdwSx3gy2yB2Nsa9g==
X-Google-Smtp-Source: AA0mqf5tYQocK5EgpIYEWvsLdPmfSYi+wiGzy/wljp5BD//2Pj6ME1ZSaATCZLyvSiYK1VQSJAcgHg==
X-Received: by 2002:ac8:1286:0:b0:3a5:7a60:e9a4 with SMTP id y6-20020ac81286000000b003a57a60e9a4mr4270693qti.345.1668724908318;
        Thu, 17 Nov 2022 14:41:48 -0800 (PST)
Received: from [192.168.1.66] (104-55-12-234.lightspeed.knvltn.sbcglobal.net. [104.55.12.234])
        by smtp.gmail.com with ESMTPSA id m20-20020a05620a24d400b006b949afa980sm1402086qkn.56.2022.11.17.14.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 14:41:48 -0800 (PST)
Message-ID: <8de44383-d2a6-2dfd-098d-f221232fafbf@ixsystems.com>
Date: Thu, 17 Nov 2022 17:41:47 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [ndctl PATCH] libndctl/msft: Improve "smart" state reporting
Content-Language: en-US
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
References: <20221117210935.5717-1-mav@ixsystems.com>
 <Y3awuiWbbJFcqJdt@aschofie-mobl2>
From: Alexander Motin <mav@ixsystems.com>
In-Reply-To: <Y3awuiWbbJFcqJdt@aschofie-mobl2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.11.2022 17:07, Alison Schofield wrote:
> On Thu, Nov 17, 2022 at 04:09:36PM -0500, Alexander Motin wrote:
>> Previous code reported "smart" state based on number of bits
>> set in the module health field.  But actually any single bit
>> set there already means critical failure.  Rework the logic
>> according to specification, properly reporting non-critical
>> state in case of warning threshold reached, critical in case
>> of any module health bit set or error threshold reached and
>> fatal if NVDIMM exhausted its life time.  In attempt to
>> report the cause of failure in absence of better methods,
>> report reached thresholds as more or less matching alarms.
>>
>> While there clean up the code, making it more uniform with
>> others and allowing more methods to be implemented later.
> 
> Hi Alexander,
> 
> Perhaps this would be better presented in 2 patches:
> 1)the cleanup and then 2) improvement of smart state reporting.

Done.  Trying to convince myself it is not a waste of time...

> Alison
> 
>>
>> Signed-off-by: Alexander Motin <mav@ixsystems.com>
>> ---
>>   ndctl/lib/msft.c | 111 ++++++++++++++++++++++++++++++++---------------
>>   ndctl/lib/msft.h |  13 ++----
>>   2 files changed, 79 insertions(+), 45 deletions(-)
>>
>> diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
>> index 3112799..8f66c97 100644
>> --- a/ndctl/lib/msft.c
>> +++ b/ndctl/lib/msft.c
>> @@ -2,6 +2,7 @@
>>   // Copyright (C) 2016-2017 Dell, Inc.
>>   // Copyright (C) 2016 Hewlett Packard Enterprise Development LP
>>   // Copyright (C) 2016-2020, Intel Corporation.
>> +/* Copyright (C) 2022 iXsystems, Inc. */
>>   #include <stdlib.h>
>>   #include <limits.h>
>>   #include <util/log.h>
>> @@ -12,12 +13,39 @@
>>   #define CMD_MSFT(_c) ((_c)->msft)
>>   #define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
>>   
>> +static const char *msft_cmd_desc(int fn)
>> +{
>> +	static const char * const descs[] = {
>> +		[NDN_MSFT_CMD_CHEALTH] = "critical_health",
>> +		[NDN_MSFT_CMD_NHEALTH] = "nvdimm_health",
>> +		[NDN_MSFT_CMD_EHEALTH] = "es_health",
>> +	};
>> +	const char *desc;
>> +
>> +	if (fn >= (int) ARRAY_SIZE(descs))
>> +		return "unknown";
>> +	desc = descs[fn];
>> +	if (!desc)
>> +		return "unknown";
>> +	return desc;
>> +}
>> +
>> +static bool msft_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
>> +{
>> +	/* Handle this separately to support monitor mode */
>> +	if (cmd == ND_CMD_SMART)
>> +		return true;
>> +
>> +	return !!(dimm->cmd_mask & (1ULL << cmd));
>> +}
>> +
>>   static u32 msft_get_firmware_status(struct ndctl_cmd *cmd)
>>   {
>>   	return cmd->msft->u.smart.status;
>>   }
>>   
>> -static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>> +static struct ndctl_cmd *alloc_msft_cmd(struct ndctl_dimm *dimm,
>> +		unsigned int func, size_t in_size, size_t out_size)
>>   {
>>   	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
>>   	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
>> @@ -30,12 +58,12 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>>   		return NULL;
>>   	}
>>   
>> -	if (test_dimm_dsm(dimm, NDN_MSFT_CMD_SMART) == DIMM_DSM_UNSUPPORTED) {
>> +	if (test_dimm_dsm(dimm, func) == DIMM_DSM_UNSUPPORTED) {
>>   		dbg(ctx, "unsupported function\n");
>>   		return NULL;
>>   	}
>>   
>> -	size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
>> +	size = sizeof(*cmd) + sizeof(struct nd_cmd_pkg) + in_size + out_size;
>>   	cmd = calloc(1, size);
>>   	if (!cmd)
>>   		return NULL;
>> @@ -45,25 +73,30 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>>   	cmd->type = ND_CMD_CALL;
>>   	cmd->size = size;
>>   	cmd->status = 1;
>> +	cmd->get_firmware_status = msft_get_firmware_status;
>>   
>>   	msft = CMD_MSFT(cmd);
>>   	msft->gen.nd_family = NVDIMM_FAMILY_MSFT;
>> -	msft->gen.nd_command = NDN_MSFT_CMD_SMART;
>> +	msft->gen.nd_command = func;
>>   	msft->gen.nd_fw_size = 0;
>> -	msft->gen.nd_size_in = offsetof(struct ndn_msft_smart, status);
>> -	msft->gen.nd_size_out = sizeof(msft->u.smart);
>> +	msft->gen.nd_size_in = in_size;
>> +	msft->gen.nd_size_out = out_size;
>>   	msft->u.smart.status = 0;
>> -	cmd->get_firmware_status = msft_get_firmware_status;
>>   
>>   	return cmd;
>>   }
>>   
>> +static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>> +{
>> +	return (alloc_msft_cmd(dimm, NDN_MSFT_CMD_NHEALTH,
>> +			0, sizeof(struct ndn_msft_smart)));
>> +}
>> +
>>   static int msft_smart_valid(struct ndctl_cmd *cmd)
>>   {
>>   	if (cmd->type != ND_CMD_CALL ||
>> -	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
>>   	    CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
>> -	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
>> +	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_NHEALTH ||
>>   	    cmd->status != 0)
>>   		return cmd->status < 0 ? cmd->status : -EINVAL;
>>   	return 0;
>> @@ -80,28 +113,33 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
>>   	}
>>   
>>   	/* below health data can be retrieved via MSFT _DSM function 11 */
>> -	return NDN_MSFT_SMART_HEALTH_VALID |
>> -		NDN_MSFT_SMART_TEMP_VALID |
>> -		NDN_MSFT_SMART_USED_VALID;
>> +	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
>> +	    ND_SMART_USED_VALID | ND_SMART_ALARM_VALID;
>>   }
>>   
>> -static unsigned int num_set_bit_health(__u16 num)
>> +static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
>>   {
>> -	int i;
>> -	__u16 n = num & 0x7FFF;
>> -	unsigned int count = 0;
>> +	unsigned int health = 0;
>> +	int rc;
>>   
>> -	for (i = 0; i < 15; i++)
>> -		if (!!(n & (1 << i)))
>> -			count++;
>> +	rc = msft_smart_valid(cmd);
>> +	if (rc < 0) {
>> +		errno = -rc;
>> +		return UINT_MAX;
>> +	}
>>   
>> -	return count;
>> +	if (CMD_MSFT_SMART(cmd)->nvm_lifetime == 0)
>> +		health |= ND_SMART_FATAL_HEALTH;
>> +	if (CMD_MSFT_SMART(cmd)->health != 0 ||
>> +	    CMD_MSFT_SMART(cmd)->err_thresh_stat != 0)
>> +		health |= ND_SMART_CRITICAL_HEALTH;
>> +	if (CMD_MSFT_SMART(cmd)->warn_thresh_stat != 0)
>> +		health |= ND_SMART_NON_CRITICAL_HEALTH;
>> +	return health;
>>   }
>>   
>> -static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
>> +static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
>>   {
>> -	unsigned int health;
>> -	unsigned int num;
>>   	int rc;
>>   
>>   	rc = msft_smart_valid(cmd);
>> @@ -110,21 +148,13 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
>>   		return UINT_MAX;
>>   	}
>>   
>> -	num = num_set_bit_health(CMD_MSFT_SMART(cmd)->health);
>> -	if (num == 0)
>> -		health = 0;
>> -	else if (num < 2)
>> -		health = ND_SMART_NON_CRITICAL_HEALTH;
>> -	else if (num < 3)
>> -		health = ND_SMART_CRITICAL_HEALTH;
>> -	else
>> -		health = ND_SMART_FATAL_HEALTH;
>> -
>> -	return health;
>> +	return CMD_MSFT_SMART(cmd)->temp * 16;
>>   }
>>   
>> -static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
>> +static unsigned int msft_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
>>   {
>> +	__u8 stat;
>> +	unsigned int flags = 0;
>>   	int rc;
>>   
>>   	rc = msft_smart_valid(cmd);
>> @@ -133,7 +163,13 @@ static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
>>   		return UINT_MAX;
>>   	}
>>   
>> -	return CMD_MSFT_SMART(cmd)->temp * 16;
>> +	stat = CMD_MSFT_SMART(cmd)->err_thresh_stat |
>> +	    CMD_MSFT_SMART(cmd)->warn_thresh_stat;
>> +	if (stat & 3) /* NVM_LIFETIME/ES_LIFETIME */
>> +		flags |= ND_SMART_SPARE_TRIP;
>> +	if (stat & 4) /* ES_TEMP */
>> +		flags |= ND_SMART_CTEMP_TRIP;
>> +	return flags;
>>   }
>>   
>>   static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
>> @@ -171,10 +207,13 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>>   }
>>   
>>   struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
>> +	.cmd_desc = msft_cmd_desc,
>> +	.cmd_is_supported = msft_cmd_is_supported,
>>   	.new_smart = msft_dimm_cmd_new_smart,
>>   	.smart_get_flags = msft_cmd_smart_get_flags,
>>   	.smart_get_health = msft_cmd_smart_get_health,
>>   	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
>> +	.smart_get_alarm_flags = msft_cmd_smart_get_alarm_flags,
>>   	.smart_get_life_used = msft_cmd_smart_get_life_used,
>>   	.xlat_firmware_status = msft_cmd_xlat_firmware_status,
>>   };
>> diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
>> index 978cc11..8d246a5 100644
>> --- a/ndctl/lib/msft.h
>> +++ b/ndctl/lib/msft.h
>> @@ -2,21 +2,16 @@
>>   /* Copyright (C) 2016-2017 Dell, Inc. */
>>   /* Copyright (C) 2016 Hewlett Packard Enterprise Development LP */
>>   /* Copyright (C) 2014-2020, Intel Corporation. */
>> +/* Copyright (C) 2022 iXsystems, Inc. */
>>   #ifndef __NDCTL_MSFT_H__
>>   #define __NDCTL_MSFT_H__
>>   
>>   enum {
>> -	NDN_MSFT_CMD_QUERY = 0,
>> -
>> -	/* non-root commands */
>> -	NDN_MSFT_CMD_SMART = 11,
>> +	NDN_MSFT_CMD_CHEALTH = 10,
>> +	NDN_MSFT_CMD_NHEALTH = 11,
>> +	NDN_MSFT_CMD_EHEALTH = 12,
>>   };
>>   
>> -/* NDN_MSFT_CMD_SMART */
>> -#define NDN_MSFT_SMART_HEALTH_VALID	ND_SMART_HEALTH_VALID
>> -#define NDN_MSFT_SMART_TEMP_VALID	ND_SMART_TEMP_VALID
>> -#define NDN_MSFT_SMART_USED_VALID	ND_SMART_USED_VALID
>> -
>>   /*
>>    * This is actually function 11 data,
>>    * This is the closest I can find to match smart
>> -- 
>> 2.30.2
>>
>>

-- 
Alexander Motin
