Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A3BC5D8
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 19:54:03 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id nd22so11292085qvb.1
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 11:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJDMbUxxlopxE0+UT0PcV5B275jnoEuIthQYsUuS7qk=;
        b=kA9utMcuYSEZ44wadP8wSyaa5TsBqpLRerJ/Mexk/v8BgT3V4lb+cW6pWtblgNt+k7
         Hw3czQBiArxezOOvimBSCqRV0jQUkU8jabuZ6KUsvX0Gs6+dWL+KUtxH8nMqKGg5EtIR
         15eYLNkVdoLYi2gkwc8Idf/O+0YiwcMrf4ZNr5Q4/gCw7t1mw7GriN3+7aJSLPf6xHk0
         6AtnBIWulPGe4KuiOtdyq6qBLqE2/B0dyyJKBnzbZ4vE8266E5ZfeFmLQIGysLlX0q24
         yUEHqEL8BZ0ot+4eIn04ds1PvpGsAj4d4Ht4wpRkRp23VQvSfIpTuO6iepeoPBGB17MP
         BMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJDMbUxxlopxE0+UT0PcV5B275jnoEuIthQYsUuS7qk=;
        b=BJHN1kppdS794NtLOe+zLG22I3Ucbw2P3Ftam4oAfg54nGEsyPLeN0GMJ+Ex5JAZxX
         0jQxQ5agfFj4JArNHHfSkbL8XFwUI5TQ6H1lpj7JFCCmEdJRC3f+x0AdxNQ1BAXs13e0
         q+dJDhDKAbX8um7XMR7AMvGO+d0+OlK36DF8WIRhCp1N3RyRz9NOdlbCKEGY6dYtOC+w
         WMmLufJxRWUmWesSAU+s3EBND6s0+vjZhkE4Xyg3wve/a6ekESQO1JlbmnjD8UTkvtjT
         764SlURt5nT9PAeIu3Jvrp8GgglRm9KjadkS+5tTKuyeX0jZ62Ni1nF61AclH95MWMzr
         OM/g==
X-Gm-Message-State: AO0yUKVrAEF+aILaMZtqjSSf7XxzIY0x1i5oAlKD4CY7M51zdzGGNCnK
	eR5K9/ESBDzCCDHIDE9MV/6xOg==
X-Google-Smtp-Source: AK7set8jIogdeOFsEjAofCAZN240wFqabix2RMokeCGC7GfmAfBeSrlX/nRcXFLpyHUez+r3fLZEPA==
X-Received: by 2002:a05:6214:2409:b0:56e:b16d:de64 with SMTP id fv9-20020a056214240900b0056eb16dde64mr6962762qvb.49.1676490842598;
        Wed, 15 Feb 2023 11:54:02 -0800 (PST)
Received: from [10.230.45.5] ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id p65-20020a37bf44000000b0073b2e678ffdsm8679657qkf.51.2023.02.15.11.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 11:54:02 -0800 (PST)
Message-ID: <6e8ff350-773a-8111-6276-38033f8db2eb@ixsystems.com>
Date: Wed, 15 Feb 2023 14:54:01 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [ndctl PATCH 2/4 v3] libndctl/msft: Replace nonsense
 NDN_MSFT_CMD_SMART command
Content-Language: en-US
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
References: <20230215164930.707170-1-mav@ixsystems.com>
 <20230215164930.707170-2-mav@ixsystems.com>
 <261ba9c4bbe2321f7fb0a80097209ac3ff5c7544.camel@intel.com>
From: Alexander Motin <mav@ixsystems.com>
In-Reply-To: <261ba9c4bbe2321f7fb0a80097209ac3ff5c7544.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15.02.2023 14:36, Verma, Vishal L wrote:
> On Wed, 2023-02-15 at 11:49 -0500, Alexander Motin wrote:
>> There is no NDN_MSFT_CMD_SMART command.  There are 3 relevant ones,
>> reporting different aspects of the module health.  Define those and
>> use NDN_MSFT_CMD_NHEALTH, while making the code more universal to
>> allow use of others later.
>>
>> Signed-off-by:  Alexander Motin <mav@ixsystems.com>
>> ---
>>   ndctl/lib/msft.c | 41 +++++++++++++++++++++++++++++++++--------
>>   ndctl/lib/msft.h |  8 ++++----
>>   2 files changed, 37 insertions(+), 12 deletions(-)
> 
> Just one question below, the rest looks good. Thanks for the re-spin.
> <..>
>>
>> +
>>   static int msft_smart_valid(struct ndctl_cmd *cmd)
>>   {
>>          if (cmd->type != ND_CMD_CALL ||
>> -           cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
> 
> Why is this size check dropped?

Primarily because intel_smart_valid(), which I tried to mimic with this 
commit, does not check the size.  Different commands have different data 
sizes.  With addition of size arguments to alloc_msft_cmd() this check 
looks more strict, but while no other commands are used now, either way 
could probably make sense.  Any way this check is redundant, and should 
have been made an assertion to begin with.

>>              CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
>> -           CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
>> +           CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_NHEALTH ||
>>              cmd->status != 0)
>>                  return cmd->status < 0 ? cmd->status : -EINVAL;
>>          return 0;
>> @@ -170,6 +194,7 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>>   }
>>   
>>   struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
>> +       .cmd_desc = msft_cmd_desc,
>>          .new_smart = msft_dimm_cmd_new_smart,
>>          .smart_get_flags = msft_cmd_smart_get_flags,
>>          .smart_get_health = msft_cmd_smart_get_health,
>> diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
>> index c462612..8d246a5 100644
>> --- a/ndctl/lib/msft.h
>> +++ b/ndctl/lib/msft.h
>> @@ -2,14 +2,14 @@
>>   /* Copyright (C) 2016-2017 Dell, Inc. */
>>   /* Copyright (C) 2016 Hewlett Packard Enterprise Development LP */
>>   /* Copyright (C) 2014-2020, Intel Corporation. */
>> +/* Copyright (C) 2022 iXsystems, Inc. */
>>   #ifndef __NDCTL_MSFT_H__
>>   #define __NDCTL_MSFT_H__
>>   
>>   enum {
>> -       NDN_MSFT_CMD_QUERY = 0,
>> -
>> -       /* non-root commands */
>> -       NDN_MSFT_CMD_SMART = 11,
>> +       NDN_MSFT_CMD_CHEALTH = 10,
>> +       NDN_MSFT_CMD_NHEALTH = 11,
>> +       NDN_MSFT_CMD_EHEALTH = 12,
>>   };
>>   
>>   /*
> 

-- 
Alexander Motin
