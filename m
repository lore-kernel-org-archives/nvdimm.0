Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF34420347105
 for <linux-nvdimm@lists.01.org>; Sun, 19 Nov 2017 22:29:00 -0800 (PST)
Received: by mail-ot0-x233.google.com with SMTP id g104so6799730otg.7
 for <linux-nvdimm@lists.01.org>; Sun, 19 Nov 2017 22:33:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 19 Nov 2017 22:33:12 -0800
Message-ID: <CAPcyv4iHPTEp9d4PwRF0c=THgJBRFw9NFa-AWJwTdbb78AKjBw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/7] ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 11:46 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Hi, here is my second version of nvdimm daemon, It would be appreciated
> if you could check it.
>
> Change log since v1:
>  - Adding a config file(/etc/nvdimmd/nvdimmd.conf)
>  - Using struct log_ctx instead of syslog()
>    - Using log_syslog() to save the notify messages to syslog
>    - Using log_file() to save the notify messages to special file
>  - Adding LOG_NOTICE level into log_priority
>  - Using automake instead of Makefile
>  - Adding a new util file(nvdimmd/util.c) including helper functions needed
>    for nvdimm daemon.
>  - Adding nvdimmd_test program
>
> ---
> This is a patch set of nvdimmd, a tiny daemon to monitor the features of over
> threshold events. When an over thershold event fires, nvdimmd will output the
> notification including dimm health status to syslog or a special file to
> users' configuration. Users can choose the output format to be structured json
> or text.
>
> Here are out put samples.
> - json format:
> 2017/11/10 11:15:03 [28065] log_notify: nvdimm dimm over threshold notify
> {
>   "dev":"nmem1",
>   "id":"cdab-0a-07e0-feffffff",
>   "handle":1,
>   "phys_id":1,
>   "health":{
>     "health_state":"non-critical",
>     "temperature_celsius":23,
>     "spares_percentage":75,
>     "alarm_temperature":true,
>     "alarm_spares":true,
>     "temperature_threshold":40,
>     "spares_threshold":5,
>     "life_used_percentage":5,
>     "shutdown_state":"clean"
>   }
> }
> - text format:
> 2017/11/10 16:21:53 [12479] log_notify: nvdimm dimm over threshold notify
> dev: nmem1
>  health_state: non-critical
>  spares_percentage: 75

Are these formats that services like Scribe and Fluent can consume?
I'd like to see a sample hook up to those applications.

I'm also wondering that since this will be a long running service that
may gain more functionality over time, if we should write it in a
language that does not have the security sharp edges of C.

I've been looking for an excuse to use the Go language on a project,
and this seems a good opportunity.

>
> TODO list:
>  - The dimms to monitor should be filtered by namespace and region

Yes, I'd like to make this equivalent to 'ndctl list' in terms filtering.

>  - Add more information into the notify message
>  - Make nvdimmd_test an ndctl command or an option of ndctl inject-error

Yes, the test events should originate from "ndctl inject-error".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
