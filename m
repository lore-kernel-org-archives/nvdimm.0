Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EDEA203B9909
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 01:49:26 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5E7C2AC01E4
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 17:49:22 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH v6 2/4] ndctl, monitor: add ndctl monitor daemon
Date: Fri, 25 May 2018 08:49:20 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3222766DC25@g01jpexmbkw01>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4jaqbaKwAAoXd3C_VGRQCcWUXCA545AGyPPXd6D1eEByA@mail.gmail.com>
In-Reply-To: <CAPcyv4jaqbaKwAAoXd3C_VGRQCcWUXCA545AGyPPXd6D1eEByA@mail.gmail.com>
Content-Language: ja-JP
MIME-Version: 1.0
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
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> As mentioned above this function seems to assume that the only DIMM events to
> send are DIMM health events. It's ok to save other object monitoring to a later patch,
> but let's at least support DIMM health
> events:
> 
> dimm-spares-remaining
> dimm-media-temperature
> dimm-controller-temperature
> dimm-health-state
> 
> ...and DIMM detected events:
> 
> dimm-unclean-shutdown
> dimm-detected
> 
> There should be an event type included in the json. Along with 'timestamp' and 'pid'
> I think we need an 'event' field so that consumer code can make assumptions about
> the format of the event record. I think 'dimm-health' and 'dimm-detect' are the only
> event record types we need to support in this initial version.
> 

Hi, Dan

I would like to confirm whether my understanding of the feature in each dimm-event is right or not.
 a) dimm-spares-remaining	
   Checking the Spare Block Remaining Trip in Alarm Trips, if set then the notification is dimm-spares-remaining.
 b) dimm-media-temperature
   Checking the NVDIMM Media Temperature Trip in Alarm Trips, if set then the notification is dimm-media-temperature.
 c) dimm-controller-temperature
   Checking the NVDIMM Controller Temperature Trip in Alarm Trips, if set then the notification is dimm-controller-temperature.
 d) dimm-health-state
   Checking the Health Status, if changed then the notification is dimm-health-state.
 e) dimm-unclean-shutdown
   Checking the Last Shutdown Status, if changed then the notification is dimm-unclean-shutdown.
 f) dimm-detected
   Checking the UUID of DIMM, if changed then the notification is dimm-detected.

Is there a possibility that a notification contains multiple dimm-events?

Should I need to turn off the event alarm after the notification logged?

Thank you very much.
 QI
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
