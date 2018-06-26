Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF97B209605D2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 09:14:08 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id h79-v6so16514606oig.13
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 09:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E32237E93462@g01jpexmbkw01>
References: <20180618082701.12326-1-qi.fuli@jp.fujitsu.com>
 <20180618082701.12326-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jwgsVxTFB5OdfUetcJ5xzLwM0=GCxn3E_ODYA8uHBMgA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E32237E93462@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 09:14:07 -0700
Message-ID: <CAPcyv4hus6K6A+ASuf30z6mB_JTYPzjyWkS1crh_q7LPjtWAKA@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] ndctl, monitor: add main ndctl monitor
 configuration file
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 8:15 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Hi Dan,
> Thanks for your comments.
>
[..]
>> > +               if (strcmp(buf, "bus") == 0) {
>> > +                       set_config((const char **)&param.bus, value);
>>
>> The cast is unnecessary, and I think we can clean this up further by having the helper
>> do the strcmp() and return the value. Something
>> like:
>>
>> param.bus = parse_config("bus", value);
>>
> Could you please tell me more about the helper which do the strcmp() and return the value?
> I think the helper should return a flag, because we need to use continue statement to
> cause a jump in the while loop.
>

Why is the continue statement needed? Imagine the configuration file
had "xyz = abc". All the statements would fail and the loop would
naturally continue to the next iteration.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
