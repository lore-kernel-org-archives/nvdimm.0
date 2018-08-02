Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3CB6210C42B8
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 06:10:19 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id m13-v6so2194393qth.1
 for <linux-nvdimm@lists.01.org>; Thu, 02 Aug 2018 06:10:19 -0700 (PDT)
Subject: Re: [PATCH] ndctl, monitor: Change the fail log priority to err.
References: <20180801185538.27084-1-msys.mizuma@gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3223DA9C824@g01jpexmbkw24>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <9382e12e-05fc-19e4-ebd3-7cdef4d62a36@gmail.com>
Date: Thu, 2 Aug 2018 09:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3223DA9C824@g01jpexmbkw24>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
Cc: m.mizuma@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Hi QI,

On 08/02/2018 07:42 AM, Qi, Fuli wrote:
>> -----Original Message-----
>> From: Masayoshi Mizuma [mailto:msys.mizuma@gmail.com]
>> Sent: Thursday, August 2, 2018 3:56 AM
>> To: linux-nvdimm@lists.01.org
>> Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>; Qi, Fuli/斉 福利
>> <qi.fuli@jp.fujitsu.com>; Mizuma, Masayoshi/水間 理仁 <m.mizuma@jp.fujitsu.com>
>> Subject: [PATCH] ndctl, monitor: Change the fail log priority to err.
>>
>> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>
>> fail() is called if an error happens, but the log priority is debug, so user may
>> not notice the error.
>> Let's change the priority to err.
>>
>> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
>> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>> ---
>>  ndctl/monitor.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index 84d51c4..68bbf65 100644
>> --- a/ndctl/monitor.c
>> +++ b/ndctl/monitor.c
>> @@ -40,7 +40,7 @@ static int did_fail;
>>  #define fail(fmt, ...) \
>>  do { \
>>  	did_fail = 1; \
>> -	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
>> +	err(ctx, "ndctl-%s:%s:%d: " fmt, \
>>  			VERSION, __func__, __LINE__, ##__VA_ARGS__); \  } while (0)
>>
> 
> Hi Masa,
> 
> The debug messages which are from fail() include source code line numbers and function name,
> these are useful for developers not typical users. Therefore, we made it a debug level print.
> Currently the debug level cannot be outputted is a bug.
> I will make a patch for adding [--verbose] option to emit debug messages and changing the log level of some messages.

OK, make sense to me.

Thanks,
Masa

> 
> Thanks,
> QI
> 
>> --
>> 2.18.0
>>
>>
> 
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
