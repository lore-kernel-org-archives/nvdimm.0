Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 463DC21B02845
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 20:43:02 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id c6-v6so27025139oiy.0
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 20:43:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5B401C00.6010100@jp.fujitsu.com>
References: <20180706052227.14393-1-qi.fuli@jp.fujitsu.com>
 <a1142e7a-c88c-7ae6-a229-da42dcff405c@gmail.com>
 <5B401C00.6010100@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Jul 2018 20:43:01 -0700
Message-ID: <CAPcyv4h36Nr7=_ZS8zT9pO-z0sEy2DUXP67-TLwDpO+VP+cvtQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl, test: add a new unit test for monitor
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 6, 2018 at 6:48 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Hi Masa,
>
> Thank you for your comments.
>
> On 7/7/2018 12:08 AM, Masayoshi Mizuma wrote:
>>
>> Hi Qi,
>>
>> On 07/06/2018 01:22 AM, QI Fuli wrote:
>>>
>>> Add a new unit test to test the following options of the monitor command.
>>>     --dimm
>>>     --bus
>>>     --region
>>>     --namespace
>>>     --logfile
>>>     --config-file
>>>
>>> Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>>> Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>
>> I think this Acked-by is wrong because I'm not a maintainer :-)
>
> I'm sorry for this mistake.

I'm perfectly fine to take reviewed-by's and acked-by's from
non-maintainers. In fact I'd prefer to have more. I'm sure Vishal
feels the same.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
