Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22e.google.com (mail-io0-x22e.google.com
 [IPv6:2607:f8b0:4001:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D24D21A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 16:09:29 -0700 (PDT)
Received: by mail-io0-x22e.google.com with SMTP id r16so136215167ioi.2
 for <linux-nvdimm@lists.01.org>; Mon, 01 May 2017 16:09:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493674015.30303.28.camel@hpe.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493674015.30303.28.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 May 2017 16:09:28 -0700
Message-ID: <CAPcyv4hj-a3B7dXhpUYiG2+8_7reFvT6=bwUs3V9JRXKm+W7+Q@mail.gmail.com>
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

On Mon, May 1, 2017 at 2:26 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Sun, 2017-04-30 at 05:39 -0700, Dan Williams wrote:
>> Toshi noticed that the new support for a region-level badblocks
>> missed the case where errors are cleared due to BTT I/O.
>>
>> An initial attempt to fix this ran into a "sleeping while atomic"
>> warning due to taking the nvdimm_bus_lock() in the BTT I/O path to
>> satisfy the locking requirements of __nvdimm_bus_badblocks_clear().
>> However, that lock is not needed since we are not acting any data
>> that is subject to change due to a change of state of the bus /
>> region. The badblocks instance has its own internal lock to handle
>> mutations of the error list.
>>
>> So, to make it clear that we are just acting on region devices and
>> don't need the lock rename __nvdimm_bus_badblocks_clear() to
>> nvdimm_clear_badblocks_regions(). Eliminate the lock and consolidate
>> all routines in drivers/nvdimm/bus.c. Also, make some cleanups to
>> remove unnecessary casts, make the calling convention of
>> nvdimm_clear_badblocks_regions() clearer by replacing struct resource
>> with the minimal struct clear_badblocks_context, and use the
>> DEVICE_ATTR macro.
>>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Reported-by: Toshi Kani <toshi.kani@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Confirmed that the clear path to the region-level badblocks works with
> the btt workaround and ndctl fix.
>
> Tested-by: Toshi Kani <toshi.kani@hpe.com>

Thanks Toshi!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
