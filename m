Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 472C520954BAD
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 04:21:18 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 67141AC0092
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 20:27:38 +0900 (JST)
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <f46164e9-676f-bd69-0e44-03139d275bfe@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 20:27:26 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


>> diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
>> new file mode 100644
>> index 0000000..2f1417b
>> --- /dev/null
>> +++ b/ndctl/ndctl-monitor.service
>> @@ -0,0 +1,7 @@
>> +[Unit]
>> +Description=Ndctl Monitor Daemon
>> +
>> +[Service]
>> +Type=forking
>> +ExecStart=/usr/bin/ndctl monitor -f
>> +ExecStop=/usr/bin/kill ${MAINPID}
>> diff --git a/ndctl/ndctl-monitor@.service b/ndctl/ndctl-monitor@.service
>> new file mode 100644
>> index 0000000..91c85d9
>> --- /dev/null
>> +++ b/ndctl/ndctl-monitor@.service
>> @@ -0,0 +1,9 @@
>> +[Unit]
>> +Description=Ndctl Monitor Daemon
>> +
>> +[Service]
>> +Type=forking
>> +EnvironmentFile=/etc/sysconfig/ndctl/%i
>> +ExecStart=/usr/bin/ndctl monitor $OPTIONS
>> +ExecStop=/usr/bin/kill ${MAINPID}
>> +ExecStopPost=/usr/bin/rm /etc/sysconfig/ndctl/%i
>> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
>> index d3c6db1..8938621 100644
>> --- a/ndctl/ndctl.c
>> +++ b/ndctl/ndctl.c
>> @@ -86,6 +86,7 @@ static struct cmd_struct commands[] = {
>>          { "inject-error", cmd_inject_error },
>>          { "update-firmware", cmd_update_firmware },
>>          { "inject-smart", cmd_inject_smart },
>> +       { "monitor", cmd_monitor },
>>          { "list", cmd_list },
>>          { "help", cmd_help },
>>          #ifdef ENABLE_TEST
>> diff --git a/util/filter.c b/util/filter.c
>> index b0b7fdf..fba2197 100644
>> --- a/util/filter.c
>> +++ b/util/filter.c
>> @@ -315,7 +315,7 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
>>                                  || !util_bus_filter_by_namespace(bus, param->namespace))
>>                          continue;
>>
>> -               if (!fctx->filter_bus(bus, fctx))
>> +               if (fctx->filter_bus && !fctx->filter_bus(bus, fctx))
>>                          continue;
>>
>>                  ndctl_dimm_foreach(bus, dimm) {
>> @@ -345,7 +345,8 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
>>                          if (type && ndctl_region_get_type(region) != type)
>>                                  continue;
>>
>> -                       if (!fctx->filter_region(region, fctx))
>> +                       if (fctx->filter_region &&
>> +                                       !fctx->filter_region(region, fctx))
> No, I don't agree with these change. The filter_bus() and
> filter_region() callbacks are mandatory because, like list, you need
> to be prepared to handle dimms underneath the bus, and namespaces
> underneath a region.

The filter_bus() and filter_region() callbacks are mandatory in ndctl list,
but not in ndctl monitor.
Current design only monitors the events coming from DIMMs, does not monitor
events coming from buses yet. When monitoring the events coming from DIMMs,
we just need to put the DIMMs which match filters into a linklist using
filter_dimm(). No additional actions will be taken on buses. It is the 
similar
case as in ndctl list, when the command does not contain [--buses] option,
filter_bus() will always return true.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
