Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x242.google.com (mail-qt0-x242.google.com
 [IPv6:2607:f8b0:400d:c0d::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AEA9210DC1AB
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 09:24:56 -0700 (PDT)
Received: by mail-qt0-x242.google.com with SMTP id w26-v6so3097609qto.5
 for <linux-nvdimm@lists.01.org>; Wed, 08 Aug 2018 09:24:56 -0700 (PDT)
Subject: Re: [ndctl PATCH 2/4] ndctl, monitor: set default log destination to
 syslog if "--daemon" is specified
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
 <20180807131756.23673-3-qi.fuli@jp.fujitsu.com>
 <7aa147ac-9fa8-ace7-a782-6ba3cab88b20@gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA9DD3A@g01jpexmbkw24>
 <01b090d0-64ee-8484-3183-313f1071421b@gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA9F262@g01jpexmbkw24>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <2004bd25-6a93-3958-051f-08381b0aa625@gmail.com>
Date: Wed, 8 Aug 2018 12:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3223DA9F262@g01jpexmbkw24>
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

Hi Qi,

On 08/08/2018 11:59 AM, Qi, Fuli wrote:
...
>>>>> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index
>>>>> bf1f1d3..2f3d751
>>>>> 100644
>>>>> --- a/ndctl/monitor.c
>>>>> +++ b/ndctl/monitor.c
>>>>> @@ -93,7 +93,8 @@ static void log_file(struct ndctl_ctx *ctx, int
>>>>> priority, const
>>>> char *file,
>>>>>  	f = fopen(monitor.log, "a+");
>>>>>  	if (!f) {
>>>>>  		ndctl_set_log_fn(ctx, log_syslog);
>>>>> -		err(ctx, "open logfile %s failed\n", monitor.log);
>>>>> +		err(ctx, "open logfile %s failed, forward messages to syslog\n",
>>>>> +				monitor.log);
>>>>>  		did_fail = 1;
>>>>>  		notice(ctx, "%s\n", buf);
>>>>>  		goto end;
>>>>> @@ -644,6 +645,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>>>>>  	}
>>>>>
>>>>>  	if (monitor.daemon) {
>>>>
>>>> Why don't you add './standard' check? Like as:
>>>>
>>>>                 if (strncmp(monitor.log, "./standard", 10) == 0)
>>>>                         error("daemon doesn't work for 'standard' log option");
>>>>                         goto out;
>>>>
>>> Hi Masa,
>>>
>>> Thank you for your comment.
>>>
>>> When running monitor as a daemon, the messages will not be able to be logged in
>> following cases.
>>> a) Users set the log destination to standard by using [--log] option or setting value
>> of "log" in config file.
>>
>>> b) The log destination is standard by default.
>>
>> Ummm... is this right behavior...? If the monitor running as a daemon, shouldn't the
>> default log destination be standard...?
> 
> No, If the monitor runs as a daemon, the default log destination should not be standard.
> The default log destination should be syslog, otherwise the messages will not be able to be logged like now.

I see. This is what I want to say. Sorry for my explanation is not enough. 

> 
>> How about the following change?
>>
>> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index f10384b..3778334 100644
>> --- a/ndctl/monitor.c
>> +++ b/ndctl/monitor.c
>> @@ -611,8 +611,11 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>>         if (argc)
>>                 usage_with_options(u, options);
>>
>> -       /* default to log_standard */
>> -       ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
>> +       /* Set default log destination */
>> +       if (monitor.daemon)
>> +               ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>> +       else
>> +               ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_standard);
>>
> I think there is no need to additionally check the monitor.daemon, and we can just set the default log destination to standard here.
> The log destination can be changed to syslog by the following code if monitor.log is NULL, which means case b).
> 
> 	if (monitor.daemon) {
> +		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
> +			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
> 

Ah, you are right, thanks.

>>         if (monitor.verbose)
>>                 ndctl_set_log_priority((struct ndctl_ctx *)ctx, LOG_DEBUG);
>>
>>> c) Users set the log destination to a relative path of log file by using [--log] option
>> or setting value of "log" in config file.
>>>
>>> The './standard' check will only works for case a).
>>
>> I'm sorry, but I'm not clear about c)... The './standard' check should not have the
>> effect in case of c), right?
> 
> Yes, Let me use a sample to clarify the case c).
>  # ndctl monitor --daemon --log ./monitor.log
> In this case, the messages are not able to be logged.
> 
>> We should check the following three cases for monitor daemon, right?
>>
>> 1. '--log standard' option, or
>> 2. In config file 'log = standard'
>> 3. Both 1. and 2. is not set (default behavior).
>>
> Yes, and apart from the cases above, we should also check the case c). 

OK, thanks! I'm clear now, so please feel free to add:

    Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks,
Masa

> 
> Thanks,
> QI
> 
>> If I miss something, sorry about that...
>>
>> Thanks,
>> Masa
>>
>>>
>>> Also, it would be more friendly to set a default log destination to monitor daemon.
>>>
>>> Thanks,
>>> QI
>>>
>>  >> Thanks,
>>>> Masa
>>>>
>>>>> +		if (!monitor.log || strncmp(monitor.log, "./", 2) == 0)
>>>>> +			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>>>>
>>>>>  		if (daemon(0, 0) != 0) {
>>>>>  			err((struct ndctl_ctx *)ctx, "daemon start failed\n");
>>>>>  			goto out;
>>>>> diff --git a/ndctl/monitor.conf b/ndctl/monitor.conf index
>>>>> 857aadf..934e2c0 100644
>>>>> --- a/ndctl/monitor.conf
>>>>> +++ b/ndctl/monitor.conf
>>>>> @@ -38,4 +38,6 @@
>>>>>  # to standard output (log=standard) or to write into a special file
>>>>> (log=<file>)  # by setting key "log". If this value is in conflict
>>>>> with the value of  # [--log=<value>] option, this value will be ignored.
>>>>> +# Note: Setting value to "standard" or relative path for <file>
>>>>> +will not work # when running moniotr as a daemon.
>>>>>  # log = /var/log/ndctl/monitor.log
>>>>>
>>>>
>>>
>>
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
