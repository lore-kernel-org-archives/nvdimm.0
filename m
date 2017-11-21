Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36AE621A134A8
 for <linux-nvdimm@lists.01.org>; Mon, 20 Nov 2017 17:55:41 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 280F3AC0160
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 10:59:51 +0900 (JST)
Subject: Re: [RFC PATCH v2 0/7] ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4iHPTEp9d4PwRF0c=THgJBRFw9NFa-AWJwTdbb78AKjBw@mail.gmail.com>
 <20171120190708.C229.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jK1=UUgaCPVcf=bdd=RvW6g0+RZQF7BMgw4cP1Owy1oQ@mail.gmail.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <4cfea9d4-50a2-df1c-3064-dbbc61e86708@jp.fujitsu.com>
Date: Tue, 21 Nov 2017 10:59:05 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jK1=UUgaCPVcf=bdd=RvW6g0+RZQF7BMgw4cP1Owy1oQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2017/11/21 1:13, Dan Williams wrote:
> On Mon, Nov 20, 2017 at 2:07 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>>> On Mon, Nov 13, 2017 at 11:46 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>>>> Hi, here is my second version of nvdimm daemon, It would be appreciated
>>>> if you could check it.
>>>>
>>>> Change log since v1:
>>>>   - Adding a config file(/etc/nvdimmd/nvdimmd.conf)
>>>>   - Using struct log_ctx instead of syslog()
>>>>     - Using log_syslog() to save the notify messages to syslog
>>>>     - Using log_file() to save the notify messages to special file
>>>>   - Adding LOG_NOTICE level into log_priority
>>>>   - Using automake instead of Makefile
>>>>   - Adding a new util file(nvdimmd/util.c) including helper functions needed
>>>>     for nvdimm daemon.
>>>>   - Adding nvdimmd_test program
>>>>
>>>> ---
>>>> This is a patch set of nvdimmd, a tiny daemon to monitor the features of over
>>>> threshold events. When an over thershold event fires, nvdimmd will output the
>>>> notification including dimm health status to syslog or a special file to
>>>> users' configuration. Users can choose the output format to be structured json
>>>> or text.
>>>>
>>>> Here are out put samples.
>>>> - json format:
>>>> 2017/11/10 11:15:03 [28065] log_notify: nvdimm dimm over threshold notify
>>>> {
>>>>    "dev":"nmem1",
>>>>    "id":"cdab-0a-07e0-feffffff",
>>>>    "handle":1,
>>>>    "phys_id":1,
>>>>    "health":{
>>>>      "health_state":"non-critical",
>>>>      "temperature_celsius":23,
>>>>      "spares_percentage":75,
>>>>      "alarm_temperature":true,
>>>>      "alarm_spares":true,
>>>>      "temperature_threshold":40,
>>>>      "spares_threshold":5,
>>>>      "life_used_percentage":5,
>>>>      "shutdown_state":"clean"
>>>>    }
>>>> }
>>>> - text format:
>>>> 2017/11/10 16:21:53 [12479] log_notify: nvdimm dimm over threshold notify
>>>> dev: nmem1
>>>>   health_state: non-critical
>>>>   spares_percentage: 75
>>> Are these formats that services like Scribe and Fluent can consume?
>>> I'd like to see a sample hook up to those applications.
>>>
>>> I'm also wondering that since this will be a long running service that
>>> may gain more functionality over time, if we should write it in a
>>> language that does not have the security sharp edges of C.
>>>
>>> I've been looking for an excuse to use the Go language on a project,
>>> and this seems a good opportunity.
>> Hmmmmm, This seems to be big change of direction of nvdimmd.
>>
>> Certainly, go-lang is good and interesting language in my impression.
>> But, if nvdimmd is re-created by go-lang, I suppose nvdimmd will need to
>> discard many functions of ndctl libraries, and need to re-create them by golang.
>>
>> (Though golang may be able to link C-lang libraries, then its security
>>   will be simlar with C-lang level, not go-lang level, I think.)
>>
>> Do you intent that we should re-create many functions for golang?
>>
>> In addition, do you include source code of go-lang nvdimmd in ndctl source code?
> Yes, but let's continue with C for now, I took a look and the impact
> is not quite as straightforward as I thought.
>
> The next step is to build a demonstration of Scribe or Fluentd
> consuming nvdimmd events.
>
Ok, I will make a sample hook up to Fluentd.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
