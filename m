Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B555223230F5
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 16:54:22 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id s4so4289818oth.7
 for <linux-nvdimm@lists.01.org>; Fri, 16 Feb 2018 17:00:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180213191222.258F.E1E9C6FF@jp.fujitsu.com>
References: <CAPcyv4i=XAsM2OuGgmqdrBJZVhAtPNJFGFdk=HiFAoUB6Re=Gw@mail.gmail.com>
 <20180213185839.258C.E1E9C6FF@jp.fujitsu.com>
 <20180213191222.258F.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Feb 2018 17:00:15 -0800
Message-ID: <CAPcyv4iAeJ9BSL1cO5q1GKgHtvFumErOjBuSvnL_irvCWcs72w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/5] ndctl: monitor: add ndctl create-monitor
 command
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 2:12 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> Hi,
[..]
> I would like to ask one more thing.
>
> What should nvdimm daemon do on detected events of bus/region/namespace/dimm ?
> IIRC, udev handles such hotplug events.
> What is relationship/roles between nvdimm daemon and udev?

UDEV handles the hotplug events, but I imagine device topology changes
are of interest to whatever agent is going to be consuming monitor
events, or monitoring changes that an administrator makes to a
machine. My inspiration for including these events in the monitor
comes from the monitor functionality in mdadm. It has events like:

           DeviceDisappeared
           RebuildStarted
           RebuildNN
           RebuildFinished
           Fail
           FailSpare
           SpareActive
           NewArray
           DegradedArray
           MoveSpare
           SparesMissing

To be clear, I'm not suggesting that all of these events need to be
supported in the first implementation of the monitor, but I want the
architecture and the user interface to be ready to support events from
any device in the topology.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
