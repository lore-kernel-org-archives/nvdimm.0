Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x234.google.com (mail-it0-x234.google.com
 [IPv6:2607:f8b0:4001:c0b::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BB8521A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 09:38:28 -0700 (PDT)
Received: by mail-it0-x234.google.com with SMTP id e65so26325975ita.1
 for <linux-nvdimm@lists.01.org>; Mon, 01 May 2017 09:38:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493655607.30303.19.camel@hpe.com>
References: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493652871.30303.15.camel@hpe.com>
 <CAPcyv4g4G_fJf6OOGpWbpyMdNioPWEFoJ2eO7+dSTcep+OerFw@mail.gmail.com>
 <CAPcyv4gxuez8BvtWwwcTXCKpzKp+oGQrRQG8+2iQ6XqRAfT_3g@mail.gmail.com>
 <1493655131.30303.17.camel@hpe.com>
 <CAPcyv4hwt8nf5+ADQyj_ahtACZq+if__SqC3dBZTCd==4OWZXA@mail.gmail.com>
 <1493655607.30303.19.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 1 May 2017 09:38:27 -0700
Message-ID: <CAPcyv4gLND=U9OUa7yFYDNDgmfk_Fx-pgdbxZpsaxhH8KU4xsA@mail.gmail.com>
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

On Mon, May 1, 2017 at 9:20 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Mon, 2017-05-01 at 09:16 -0700, Dan Williams wrote:
>> On Mon, May 1, 2017 at 9:12 AM, Kani, Toshimitsu <toshi.kani@hpe.com>
>> wrote:
>> > On Mon, 2017-05-01 at 08:52 -0700, Dan Williams wrote:
>> > > On Mon, May 1, 2017 at 8:43 AM, Dan Williams <dan.j.williams@inte
>> > > l.co
>> > > m> wrote:
>> > > > On Mon, May 1, 2017 at 8:34 AM, Kani, Toshimitsu <toshi.kani@hp
>> > > > e.co
>> > > > m> wrote:
>> > > > > On Sun, 2017-04-30 at 05:39 -0700, Dan Williams wrote:
>> >
>> >  :
>> > > > >
>> > > > > Hi Dan,
>> > > > >
>> > > > > I was testing the change with CONFIG_DEBUG_ATOMIC_SLEEP set
>> > > > > this time, and hit the following BUG with BTT.  This is a
>> > > > > separate issue (not introduced by this patch), but it shows
>> > > > > that we have an issue with the DSM call path as well.
>> > > >
>> > > > Ah, great find, thanks! We don't see this in the unit tests
>> > > > because the nfit_test infrastructure takes no sleeping actions
>> > > > in its simulated DSM path. Outside of converting btt to use
>> > > > sleeping locks I'm not sure I see a path forward. I wonder how
>> > > > bad the performance impact of that would be? Perhaps with
>> > > > opportunistic spinning it won't be so bad, but I don't see
>> > > > another choice.
>> > >
>> > > It's worse than that. Part of the performance optimization of BTT
>> > > I/O was to avoid locking altogether when we could rely on a BTT
>> > > lane percpu, so that would also need to be removed.
>> >
>> > I do not have a good idea either, but I'd rather disable this
>> > clearing in the regular BTT write path than adding sleeping locks
>> > to BTT. Clearing a bad block in the BTT write path is
>> > difficult/challenging since it allocates a new block.
>>
>> Actually, that may make things easier. Can we teach BTT to track
>> error blocks and clear them before they are reassigned?
>
> I was thinking the same after sending it.  I think we should be able to
> do that.

Ok, but we obviously can't develop something that detailed while the
merge window is open, so I think that means we need to revert commit
e88da7998d7d "Revert 'libnvdimm: band aid btt vs clear poison
locking'" and leave BTT I/O-error-clearing disabled for this cycle and
try again for 4.13.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
