Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x232.google.com (mail-io0-x232.google.com
 [IPv6:2607:f8b0:4001:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E09C921A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 08:52:23 -0700 (PDT)
Received: by mail-io0-x232.google.com with SMTP id p80so122597407iop.3
 for <linux-nvdimm@lists.01.org>; Mon, 01 May 2017 08:52:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493652871.30303.15.camel@hpe.com>
 <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 May 2017 08:52:22 -0700
Message-ID: <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: rework region badblocks clearing
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 1, 2017 at 8:43 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Mon, May 1, 2017 at 8:34 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Sun, 2017-04-30 at 05:39 -0700, Dan Williams wrote:
>>> Toshi noticed that the new support for a region-level badblocks
>>> missed the case where errors are cleared due to BTT I/O.
>>>
>>> An initial attempt to fix this ran into a "sleeping while atomic"
>>> warning due to taking the nvdimm_bus_lock() in the BTT I/O path to
>>> satisfy the locking requirements of __nvdimm_bus_badblocks_clear().
>>> However, that lock is not needed since we are not acting any data
>>> that is subject to change due to a change of state of the bus /
>>> region. The badblocks instance has its own internal lock to handle
>>> mutations of the error list.
>>>
>>> So, to make it clear that we are just acting on region devices and
>>> don't need the lock rename __nvdimm_bus_badblocks_clear() to
>>> nvdimm_clear_badblocks_regions(). Eliminate the lock and consolidate
>>> all routines in drivers/nvdimm/bus.c. Also, make some cleanups to
>>> remove unnecessary casts, make the calling convention of
>>> nvdimm_clear_badblocks_regions() clearer by replacing struct resource
>>> with the minimal struct clear_badblocks_context, and use the
>>> DEVICE_ATTR macro.
>>
>> Hi Dan,
>>
>> I was testing the change with CONFIG_DEBUG_ATOMIC_SLEEP set this time,
>> and hit the following BUG with BTT.  This is a separate issue (not
>> introduced by this patch), but it shows that we have an issue with the
>> DSM call path as well.
>
> Ah, great find, thanks! We don't see this in the unit tests because
> the nfit_test infrastructure takes no sleeping actions in its
> simulated DSM path. Outside of converting btt to use sleeping locks
> I'm not sure I see a path forward. I wonder how bad the performance
> impact of that would be? Perhaps with opportunistic spinning it won't
> be so bad, but I don't see another choice.

It's worse than that. Part of the performance optimization of BTT I/O
was to avoid locking altogether when we could rely on a BTT lane
percpu, so that would also need to be removed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
