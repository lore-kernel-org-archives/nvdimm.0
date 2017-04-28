Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A90621A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:39:04 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id c62so1250312oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:39:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493418523.30303.6.camel@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <CAPcyv4i+U62GMyK=xNXB9ZjzS-028q4Qch=kxa9_pkwXrFJdsA@mail.gmail.com>
 <1493418523.30303.6.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 15:39:03 -0700
Message-ID: <CAPcyv4jyH=kyBy7-NW77NdssqUKpE2=uf3VfOjk7A5zeUgMAMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] libnvdimm: fix clear length of nvdimm_forget_poison()
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

On Fri, Apr 28, 2017 at 3:29 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Fri, 2017-04-28 at 14:48 -0700, Dan Williams wrote:
>> On Thu, Apr 27, 2017 at 3:57 PM, Toshi Kani <toshi.kani@hpe.com>
>> wrote:
>> > ND_CMD_CLEAR_ERROR command returns 'clear_err.cleared', the length
>> > of error actually cleared, which may be smaller than its requested
>> > 'len'.
>> >
>> > Change nvdimm_clear_poison() to call nvdimm_forget_poison() with
>> > 'clear_err.cleared' when this value is valid.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Dave Jiang <dave.jiang@intel.com>
>> > Cc: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> > Based on 'libnvdimm-for-next'.
>> > ---
>> >  drivers/nvdimm/bus.c |    4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> > index d214ac44..43ddfd4 100644
>> > --- a/drivers/nvdimm/bus.c
>> > +++ b/drivers/nvdimm/bus.c
>> > @@ -219,7 +219,9 @@ long nvdimm_clear_poison(struct device *dev,
>> > phys_addr_t phys,
>> >         if (cmd_rc < 0)
>> >                 return cmd_rc;
>> >
>> > -       nvdimm_forget_poison(nvdimm_bus, phys, len);
>> > +       if (clear_err.cleared > 0)
>> > +               nvdimm_forget_poison(nvdimm_bus, phys,
>> > clear_err.cleared);
>> > +
>> >         return clear_err.cleared;
>>
>> Looks, good we need to mark this for -stable since the bug is also
>> present in current mainline.
>>
>> Fixes: e046114af5fc ("libnvdimm: clear the internal poison_list when
>> clearing badblocks")
>
> Shall I send a patch based on the current mainline with cc to -stable?
> The func name is nvdimm_clear_from_poison_list() in the mainline.

I thinks it's too late to get a fix into 4.11, especially when this
went in broken and not a regression. I'll just tag this for -stable
and handle the backport manually.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
