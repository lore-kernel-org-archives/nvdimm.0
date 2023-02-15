Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57B6109
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 16:17:39 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id f10so22351532qtv.1
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 08:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I3uJNqa4Gpeh5yzXUYyWKsLl69uShwh5c4qlvAjJlaU=;
        b=aCfMoqIylGFofpkI8mFjbSlA6pBvZK1d7x1IaAXwd9bVebrkNWatNb5PEKJhTm01Aw
         gWMMrOoiMMOCvrK45hZjEOzJplHgF4GejTquRK0U3Pe3/tiQ79VYUUlG9ECcNN3ZfGgO
         A35RT2PAJLp6KwdFYHy14lxQYSzmFNVuZKIUqE2nCY9I7IMuxidbnJXmApclQtPWTzvi
         7m3SUpcxJYo8FktMEWNb0PsOc/xRzjKRAFFEfcUAFVhTEIHopHctTrX+D73eW4kWvs+5
         QuTOMgY/710UYxqDlXl9TlFePomkmGoYfropACLjAt5OmhRdycF09cqLqe1Ntth5mJzi
         gCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3uJNqa4Gpeh5yzXUYyWKsLl69uShwh5c4qlvAjJlaU=;
        b=k7ld7IjtlCBYplYcIkHARf7SdWdPv1NOmrBfk3NnUxJLuUsQZUlSU0nN03rYymfceI
         ZtoMW9ZOux557eGWNFFKKFD7duJP7dR5tr6sVIzz5+RpIUG7GZo/xnd+cnGl41+B9AY6
         gNFUfwVS2Vob3dDH4C3N1G823V+m6+biq/hUFPoVPorYfZ2Xp7f1uLu3d7GI1dSKEO9z
         F+K5gBHvU/T5ZjYBNmOMP08XPAwGgm58EUULrl+wCLjH1bDN7srSJJtiYlqWToEEe6hA
         qpRjNiPyPah4F4XipBklq/gnFKvWVDvw/hO4wGxQSNTWTCzFk5yGaeJk3GR1yGgMLX5Z
         vMKw==
X-Gm-Message-State: AO0yUKVQG4VimJCxmyOi8tQ0BbkC9EVLwkQ41OHw6Rqaoc3UOhxUf2kI
	9Ja9zcBLuc83H5TP60xcgHLb/w==
X-Google-Smtp-Source: AK7set/BfcDjt5ClJDSgbqCDMAE0wJovkBlBegfPV5IXk+cGXOjghHA6g7j89JMJSef0KYIGoi27/Q==
X-Received: by 2002:ac8:5f52:0:b0:3b6:895c:d18d with SMTP id y18-20020ac85f52000000b003b6895cd18dmr4309027qta.15.1676477858277;
        Wed, 15 Feb 2023 08:17:38 -0800 (PST)
Received: from [10.230.45.5] ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id q1-20020ac84101000000b003b9dca4cdf4sm13242199qtl.83.2023.02.15.08.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 08:17:37 -0800 (PST)
Message-ID: <127a0279-9d77-1982-9c67-a60da2de570c@ixsystems.com>
Date: Wed, 15 Feb 2023 11:17:36 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [ndctl PATCH 1/2 v2 RESEND] libndctl/msft: Cleanup the code
Content-Language: en-US
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
 "Lijun.Pan@dell.com" <Lijun.Pan@dell.com>
References: <20230113172732.1122643-1-mav@ixsystems.com>
 <f92606c0b951f23e2cc4db641f6c18cbb6647804.camel@intel.com>
From: Alexander Motin <mav@ixsystems.com>
In-Reply-To: <f92606c0b951f23e2cc4db641f6c18cbb6647804.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15.02.2023 00:00, Verma, Vishal L wrote:
> On Fri, 2023-01-13 at 12:27 -0500, Alexander Motin wrote:
>> Clean up the code, making it more uniform with others and
>> allowing more methods to be implemented later:
>>   - remove nonsense NDN_MSFT_CMD_SMART definition, replacing it
>> with real commands, primarity NDN_MSFT_CMD_NHEALTH;
>>   - allow sending arbitrary commands and add their descriptions;
>>   - add custom cmd_is_supported method to allow monitor mode.
> 
> Hi Alexander,
> 
> I think I had similar feedback earlier, but these would be reviewable
> more easily if these three unrelated things are broken up into three
> separate patches.

Hi Vishal,

You did ask me to add more details into commit message and possibly 
split the patch.  I've added the details, but about the second I pleaded 
to save few hours of my time on reshuffling trivial patches.  Apparently 
my plea was not good enough.  Apparently you have a long line of people 
who wish to fix this area.  Whatever, doing it now, hopefully to end 
this and focus on things that actually matter.

> A few other minor comments below.

Thanks for looking deeper.

>>
>> Signed-off-by: Alexander Motin <mav@ixsystems.com>
>> ---
>>   ndctl/lib/msft.c | 58 ++++++++++++++++++++++++++++++++++++++----------
>>   ndctl/lib/msft.h | 13 ++++-------
>>   2 files changed, 50 insertions(+), 21 deletions(-)
>>
>> diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
>> index 3112799..efc7fe1 100644
>> --- a/ndctl/lib/msft.c
>> +++ b/ndctl/lib/msft.c
>> @@ -2,6 +2,7 @@
>>   // Copyright (C) 2016-2017 Dell, Inc.
>>   // Copyright (C) 2016 Hewlett Packard Enterprise Development LP
>>   // Copyright (C) 2016-2020, Intel Corporation.
>> +/* Copyright (C) 2022 iXsystems, Inc. */
>>   #include <stdlib.h>
>>   #include <limits.h>
>>   #include <util/log.h>
>> @@ -12,12 +13,39 @@
>>   #define CMD_MSFT(_c) ((_c)->msft)
>>   #define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
>>   
>> +static const char *msft_cmd_desc(int fn)
>> +{
>> +       static const char * const descs[] = {
>> +               [NDN_MSFT_CMD_CHEALTH] = "critical_health",
>> +               [NDN_MSFT_CMD_NHEALTH] = "nvdimm_health",
>> +               [NDN_MSFT_CMD_EHEALTH] = "es_health",
>> +       };
>> +       const char *desc;
>> +
>> +       if (fn >= (int) ARRAY_SIZE(descs))
>> +               return "unknown";
>> +       desc = descs[fn];
>> +       if (!desc)
>> +               return "unknown";
>> +       return desc;
>> +}
>> +
>> +static bool msft_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
>> +{
>> +       /* Handle this separately to support monitor mode */
>> +       if (cmd == ND_CMD_SMART)
>> +               return true;
>> +
>> +       return !!(dimm->cmd_mask & (1ULL << cmd));
>> +}
>> +
>>   static u32 msft_get_firmware_status(struct ndctl_cmd *cmd)
>>   {
>>          return cmd->msft->u.smart.status;
>>   }
>>   
>> -static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>> +static struct ndctl_cmd *alloc_msft_cmd(struct ndctl_dimm *dimm,
>> +               unsigned int func, size_t in_size, size_t out_size)
>>   {
>>          struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
>>          struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
>> @@ -30,12 +58,12 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>>                  return NULL;
>>          }
>>   
>> -       if (test_dimm_dsm(dimm, NDN_MSFT_CMD_SMART) == DIMM_DSM_UNSUPPORTED) {
>> +       if (test_dimm_dsm(dimm, func) == DIMM_DSM_UNSUPPORTED) {
>>                  dbg(ctx, "unsupported function\n");
>>                  return NULL;
>>          }
>>   
>> -       size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
>> +       size = sizeof(*cmd) + sizeof(struct nd_cmd_pkg) + in_size + out_size;
>>          cmd = calloc(1, size);
>>          if (!cmd)
>>                  return NULL;
>> @@ -45,25 +73,30 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>>          cmd->type = ND_CMD_CALL;
>>          cmd->size = size;
>>          cmd->status = 1;
>> +       cmd->get_firmware_status = msft_get_firmware_status;
>>   
>>          msft = CMD_MSFT(cmd);
>>          msft->gen.nd_family = NVDIMM_FAMILY_MSFT;
>> -       msft->gen.nd_command = NDN_MSFT_CMD_SMART;
>> +       msft->gen.nd_command = func;
>>          msft->gen.nd_fw_size = 0;
>> -       msft->gen.nd_size_in = offsetof(struct ndn_msft_smart, status);
>> -       msft->gen.nd_size_out = sizeof(msft->u.smart);
>> +       msft->gen.nd_size_in = in_size;
>> +       msft->gen.nd_size_out = out_size;
>>          msft->u.smart.status = 0;
>> -       cmd->get_firmware_status = msft_get_firmware_status;
> 
> Moving this line up seems unnecessary?

Yes, it is unnecesary, but it looked cleaner and more contained to 
assign fields of each structure together.  But once you say so, returned 
back.

>>   
>>          return cmd;
>>   }
>>   
>> +static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
>> +{
>> +       return (alloc_msft_cmd(dimm, NDN_MSFT_CMD_NHEALTH,
>> +                       0, sizeof(struct ndn_msft_smart)));
> 
> The outermost parenthesis here are unnecessary and unconventional for
> the code base.

Thanks.  Removed.

> Also sizeof(*foo_ptr) is more canonical than sizeof(struct foo).
> Checkpatch should warn about this.

Yes, I would totally agree, would I have the variable here.  Adding 
variable just for that purpose is IMO a code obfuscation.

>> +}
>> +
>>   static int msft_smart_valid(struct ndctl_cmd *cmd)
>>   {
>>          if (cmd->type != ND_CMD_CALL ||
>> -           cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
>>              CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
>> -           CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
>> +           CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_NHEALTH ||
>>              cmd->status != 0)
>>                  return cmd->status < 0 ? cmd->status : -EINVAL;
>>          return 0;
>> @@ -80,9 +113,8 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
>>          }
>>   
>>          /* below health data can be retrieved via MSFT _DSM function 11 */
>> -       return NDN_MSFT_SMART_HEALTH_VALID |
>> -               NDN_MSFT_SMART_TEMP_VALID |
>> -               NDN_MSFT_SMART_USED_VALID;
>> +       return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
>> +           ND_SMART_USED_VALID;
>>   }
>>   
>>   static unsigned int num_set_bit_health(__u16 num)
>> @@ -171,6 +203,8 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
>>   }
>>   
>>   struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
>> +       .cmd_desc = msft_cmd_desc,
>> +       .cmd_is_supported = msft_cmd_is_supported,
>>          .new_smart = msft_dimm_cmd_new_smart,
>>          .smart_get_flags = msft_cmd_smart_get_flags,
>>          .smart_get_health = msft_cmd_smart_get_health,
>> diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
>> index 978cc11..8d246a5 100644
>> --- a/ndctl/lib/msft.h
>> +++ b/ndctl/lib/msft.h
>> @@ -2,21 +2,16 @@
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
>> -/* NDN_MSFT_CMD_SMART */
>> -#define NDN_MSFT_SMART_HEALTH_VALID    ND_SMART_HEALTH_VALID
>> -#define NDN_MSFT_SMART_TEMP_VALID      ND_SMART_TEMP_VALID
>> -#define NDN_MSFT_SMART_USED_VALID      ND_SMART_USED_VALID
>> -
>>   /*
>>    * This is actually function 11 data,
>>    * This is the closest I can find to match smart
> 

-- 
Alexander Motin
