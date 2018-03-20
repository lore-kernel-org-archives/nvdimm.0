Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E5FA20954B86
 for <linux-nvdimm@lists.01.org>; Mon, 19 Mar 2018 17:57:30 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id D1E61AC0083
 for <linux-nvdimm@lists.01.org>;
 Tue, 20 Mar 2018 10:03:54 +0900 (JST)
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
References: <20180313113308.2136-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPghKyQ6AuVJ-R=fiKcQufzHs-DExzcyHTbshF-2bq1Q@mail.gmail.com>
 <f46164e9-676f-bd69-0e44-03139d275bfe@jp.fujitsu.com>
 <CAPcyv4jZ6zYWEdAeVM2DQKyroCSVc+-x4kHY-9wtLPX=ZdN9Tg@mail.gmail.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <8862cf22-1e78-2bdf-0abe-4403164d3240@jp.fujitsu.com>
Date: Tue, 20 Mar 2018 10:03:44 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jZ6zYWEdAeVM2DQKyroCSVc+-x4kHY-9wtLPX=ZdN9Tg@mail.gmail.com>
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


>>>> -                       if (!fctx->filter_region(region, fctx))
>>>> +                       if (fctx->filter_region &&
>>>> +                                       !fctx->filter_region(region,
>>>> fctx))
>>> No, I don't agree with these change. The filter_bus() and
>>> filter_region() callbacks are mandatory because, like list, you need
>>> to be prepared to handle dimms underneath the bus, and namespaces
>>> underneath a region.
>>
>> The filter_bus() and filter_region() callbacks are mandatory in ndctl list,
>> but not in ndctl monitor.
>> Current design only monitors the events coming from DIMMs, does not monitor
>> events coming from buses yet. When monitoring the events coming from DIMMs,
>> we just need to put the DIMMs which match filters into a linklist using
>> filter_dimm(). No additional actions will be taken on buses. It is the
>> similar
>> case as in ndctl list, when the command does not contain [--buses] option,
>> filter_bus() will always return true.
> Right, I'd prefer that you create a ->filter_bus() implementation for
> your use case that always returns true rather than change the core to
> allow a ->filter_bus() routine to be omitted. This way the core stays
> generic for all use cases and the bus monitoring can be added without
> touching the core.
>
>
OK, I see.
Thank you very much.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
