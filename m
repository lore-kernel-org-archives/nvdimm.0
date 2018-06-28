Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4872F211F8866
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 20:53:01 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id c6-v6so3895896oiy.0
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 20:53:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E32237E95B86@g01jpexmbkw01>
References: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
 <20180627052426.26020-2-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jPrEYbwORjjkQa8M+ryzp4sNY=tvhJbxiKFazQdcJOmQ@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E32237E95B86@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Jun 2018 20:52:59 -0700
Message-ID: <CAPcyv4imzXawV769=-z1-_GHpbvLFFox12-SDB2GEchSkPWTdQ@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] ndctl, monitor: add ndctl monitor
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

On Wed, Jun 27, 2018 at 8:02 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> Thanks for your comments.
>

Thanks for continuing to work through the feedback.

>> > +static struct monitor_dimm *util_dimm_event_filter(struct monitor_dimm *mdimm,
>> > +               const char *__ident)
>> > +{
>> > +       char *ident, *save;
>> > +       const char *name;
>> > +       struct monitor_dimm *__mdimm;
>> > +       struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(mdimm->dimm);
>> > +
>> > +       __mdimm = calloc(1, sizeof(struct monitor_dimm));
>> > +       if (!__mdimm) {
>> > +               fail("\n");
>> > +               return NULL;
>> > +       }
>>
>> Why do we need a dynamic allocation? Can't this just live on the stack?
>>
> Actually, I just use the __dimm to compare current dimm health with the dimm health when the monitor started.
> When the dimm changed, the __dimm should be initialized. I think a dynamic allocation is smarter than live on the stack.

Allocating memory should always be avoided when not necessary because
it's so error prone in C. None of the other util_X_filter() routines
need to allocate memory, in fact the point is to validate that the
passed in object passes the filter, not to swap the passed in object
with a new one.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
