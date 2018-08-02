Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBDD321BADAB2
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 06:22:47 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id c15-v6so2254665qtp.0
 for <linux-nvdimm@lists.01.org>; Thu, 02 Aug 2018 06:22:47 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: Re: [ndclt PATCH] ndctl, monitor: Fix duplicate prefix in monitor.log
References: <20180731051503.30719-1-qi.fuli@jp.fujitsu.com>
 <533dc62c-bac1-15aa-0e8d-bc444e8ef06b@gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA9C5CB@g01jpexmbkw24>
Message-ID: <9c43a608-321c-e227-f95e-74ad477d55c8@gmail.com>
Date: Thu, 2 Aug 2018 09:22:45 -0400
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3223DA9C5CB@g01jpexmbkw24>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi QI,

On 08/02/2018 05:42 AM, Qi, Fuli wrote:
...
>>> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index c6419ad..4e5daf5
>>> 100644
>>> --- a/ndctl/monitor.c
>>> +++ b/ndctl/monitor.c
>>> @@ -614,7 +614,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>>>  		goto out;
>>>
>>>  	if (monitor.log) {
>>> -		fix_filename(prefix, (const char **)&monitor.log);
>>> +		if (strncmp(monitor.log, "./", 2) != 0)
>>> +			fix_filename(prefix, (const char **)&monitor.log);
>>
>> prefix is not needed to 'syslog' and 'standard', so why don't you move the strncmp()
>> before fix_filename(), like as:
>>
>> @@ -614,13 +619,14 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>>                 goto out;
>>
>>         if (monitor.log) {
>> -               fix_filename(prefix, (const char **)&monitor.log);
>>                 if (strncmp(monitor.log, "./syslog", 8) == 0)
>>                         ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>>                 else if (strncmp(monitor.log, "./standard", 10) == 0)
>>                         ; /*default, already set */
>> -               else
>> +               else {
>> +                       fix_filename(prefix, (const char
>> + **)&monitor.log);
>>                         ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
>> +               }
>>         }
>>
>>         if (monitor.daemon) {
>>
>> Thanks,
>> Masa
> 
> Hi Masa,
> 
> Thank you very much for your comments.
> 
> There are two ways to set monitor.log.
> a) setting the argument of [--log] option
> b) setting the value of [log] key in configuration file
> 
> When users set monitor.log by b, the prefix will not be added to monitor.log.
> Therefore, we should do fix_filename() before strncmp().

Oh, my proposal patch does not cover in case of user set 'syslog' or 'standard'in config_file.
I think your patch fixes the bug correctly, thanks.

Please feel free to add:

Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks,
Masa
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
