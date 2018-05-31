Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45697203BA4E2
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 15:23:47 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id h79-v6so14389941oig.13
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 15:23:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222766DC25@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jaqbaKwAAoXd3C_VGRQCcWUXCA545AGyPPXd6D1eEByA@mail.gmail.com>
 <0DEDF3B159719A448A49EF0E7B11E3222766DC25@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 May 2018 15:23:46 -0700
Message-ID: <CAPcyv4gO6HDXb6ZG4M6NJcvc9CCTC9nE5ibr6cg5kF==OqvTPw@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] ndctl, monitor: add ndctl monitor daemon
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

On Fri, May 25, 2018 at 1:49 AM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> As mentioned above this function seems to assume that the only DIMM events to
>> send are DIMM health events. It's ok to save other object monitoring to a later patch,
>> but let's at least support DIMM health
>> events:
>>
>> dimm-spares-remaining
>> dimm-media-temperature
>> dimm-controller-temperature
>> dimm-health-state
>>
>> ...and DIMM detected events:
>>
>> dimm-unclean-shutdown
>> dimm-detected
>>
>> There should be an event type included in the json. Along with 'timestamp' and 'pid'
>> I think we need an 'event' field so that consumer code can make assumptions about
>> the format of the event record. I think 'dimm-health' and 'dimm-detect' are the only
>> event record types we need to support in this initial version.
>>
>
> Hi, Dan
>
> I would like to confirm whether my understanding of the feature in each dimm-event is right or not.
>  a) dimm-spares-remaining
>    Checking the Spare Block Remaining Trip in Alarm Trips, if set then the notification is dimm-spares-remaining.

Yes.

>  b) dimm-media-temperature
>    Checking the NVDIMM Media Temperature Trip in Alarm Trips, if set then the notification is dimm-media-temperature.

Yes.

>  c) dimm-controller-temperature
>    Checking the NVDIMM Controller Temperature Trip in Alarm Trips, if set then the notification is dimm-controller-temperature.

Yes.

>  d) dimm-health-state
>    Checking the Health Status, if changed then the notification is dimm-health-state.

Yes.

>  e) dimm-unclean-shutdown
>    Checking the Last Shutdown Status, if changed then the notification is dimm-unclean-shutdown.

Yes.

>  f) dimm-detected
>    Checking the UUID of DIMM, if changed then the notification is dimm-detected.

No, this would fire for each DIMM detected when the daemon starts up,
and for any future DIMM that is hot plugged into the system. The
notification of hotplugged DIMM devices would be a uevent. We can save
this notification for later as it is different from the
'health_event_fd' that these other notifications are communicated.

> Is there a possibility that a notification contains multiple dimm-events?

Yes, we may only get 1 notification from the kernel, but all of these
items might have changed / tripped.

>
> Should I need to turn off the event alarm after the notification logged?

No, if the kernel continues to send events then the monitor should log them.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
