Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A475421FD73C6
 for <linux-nvdimm@lists.01.org>; Sun, 18 Feb 2018 18:30:33 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 398A1AC00DD
 for <linux-nvdimm@lists.01.org>; Mon, 19 Feb 2018 11:36:24 +0900 (JST)
Date: Mon, 19 Feb 2018 11:36:11 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor
 command
In-Reply-To: <CAPcyv4iAeJ9BSL1cO5q1GKgHtvFumErOjBuSvnL_irvCWcs72w@mail.gmail.com>
References: <20180213191222.258F.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4iAeJ9BSL1cO5q1GKgHtvFumErOjBuSvnL_irvCWcs72w@mail.gmail.com>
Message-Id: <20180219113606.D7E1.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> On Tue, Feb 13, 2018 at 2:12 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >> Hi,
> [..]
> > I would like to ask one more thing.
> >
> > What should nvdimm daemon do on detected events of bus/region/namespace/dimm ?
> > IIRC, udev handles such hotplug events.
> > What is relationship/roles between nvdimm daemon and udev?
> 
> UDEV handles the hotplug events, but I imagine device topology changes
> are of interest to whatever agent is going to be consuming monitor
> events, or monitoring changes that an administrator makes to a
> machine. My inspiration for including these events in the monitor
> comes from the monitor functionality in mdadm. It has events like:
> 
>            DeviceDisappeared
>            RebuildStarted
>            RebuildNN
>            RebuildFinished
>            Fail
>            FailSpare
>            SpareActive
>            NewArray
>            DegradedArray
>            MoveSpare
>            SparesMissing
> 
> To be clear, I'm not suggesting that all of these events need to be
> supported in the first implementation of the monitor, but I want the
> architecture and the user interface to be ready to support events from
> any device in the topology.
> 

Ok, I got it.
Thank you for your clarification.

Bye,
---
Yasunori Goto





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
