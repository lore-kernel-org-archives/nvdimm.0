Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 452B922489CBB
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 02:55:40 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E2F3CAC005E
 for <linux-nvdimm@lists.01.org>; Fri, 16 Mar 2018 19:01:57 +0900 (JST)
Subject: Re: [RFC PATCH v4] ndctl: monitor: add ndctl monitor daemon
References: <58684e81-ac3a-718e-a717-0a1b54766100@jp.fujitsu.com>
 <CAPcyv4jRxaVu6XXcRDatr8VHJAdR-nn7DVb9Z3oUs_MmK9sBAQ@mail.gmail.com>
 <20180316163309.7296.E1E9C6FF@jp.fujitsu.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <d4c441ad-0607-3cca-6740-63861488eaf6@jp.fujitsu.com>
Date: Fri, 16 Mar 2018 19:01:47 +0900
MIME-Version: 1.0
In-Reply-To: <20180316163309.7296.E1E9C6FF@jp.fujitsu.com>
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2018/03/16 16:33, Yasunori Goto wrote:
>>>   b) About using systemctl command
>>>      3) Should we need to limit the maximum number of running daemons to be one?
>>>         If yes, I am thinking the option should support multiple values, then
>>>         users can modify the default configuration by using [--conf-file] option.
>>>         # ndctl monitor --dimm nmem1,nmem2 --conf-file
> I talked about here with Qi-san, and probably I understand what he really
> wanted to ask here.
>
> Currently, ndctl user can specify just "one" filter option, like --dimm nmem1,
> but he/she can not specify 2 or more options like --dimm nmem1,nmem2,nmem3.
>
> So, he would like to ask which we should select in the following.
>
>    a) Change ndctl for users to be able to specify multiple filter option.
>       This change affects not only daemon, but also ndctl list command.
>       In addition, we need to decide how much filter can be specified.
>    b) Keep current filter.
>       To monitor plural area(dimm/region/namespace/bus), plural daemons
>       are executed for each area which is specified one option.
>       This does not require option change.
>
> Though Qi-san wanted to select b) at this question,
> it is just workaround, we should select a) I think...
>
> Thanks,
>
Goto-san, Thank you for your follow.

I am not sure if it is needed to support "one option multiple arguments" 
in ndctl list.
Think more about it, I am thinking it should be supported in ndctl 
monitor daemon.
If ndctl list does not need it, it can be implemented only in monitor 
daemon.
If list also needs it, we can discuss more details about how to make a 
given one
which can be shared between list and monitor.

Thank you.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
