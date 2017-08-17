Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x236.google.com (mail-yw0-x236.google.com
 [IPv6:2607:f8b0:4002:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6744E21CFA608
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 17:28:09 -0700 (PDT)
Received: by mail-yw0-x236.google.com with SMTP id s143so32414992ywg.1
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 17:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1502739913.4405.17.camel@intel.com>
References: <20170809000746.10585-1-vishal.l.verma@intel.com>
 <20170809000746.10585-7-vishal.l.verma@intel.com>
 <CAPcyv4is9O=HCrHPJXoOOW2p2LyUE1n3WCi-5X0AKfU-pNWNPg@mail.gmail.com>
 <1502739913.4405.17.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 17:30:34 -0700
Message-ID: <CAPcyv4i+r084mLFzmj9tfHKaFEdOQnWWEPXZMKGx-ejMkWKC8g@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] libnvdimm,
 btt: refactor initial_offset calculations
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 14, 2017 at 12:47 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Fri, 2017-08-11 at 18:39 -0700, Dan Williams wrote:
>> On Tue, Aug 8, 2017 at 5:07 PM, Vishal Verma <vishal.l.verma@intel.com
>> > wrote:
>> > In preparation for BTT error clearing, refactor the initial offset
>> > calculations. Until now, all callers of arena_{read,write}_bytes
>> > assumed
>> > a relative offset to the arena, and it was later adjusted for the
>> > initial offset. Until now, every time we calculated a relative
>> > offset,
>> > we passed it to these functions to do reads or writes, and so where
>> > the
>> > offset calculations happened didn't matter.
>> >
>> > For error clearing, there will be places where we calculate offsets
>> > to
>> > check for the presence of media errors, and the above scheme becomes
>> > error prone.
>> >
>> > Make the initial_offset calculations explicit for all callers of
>> > arena_{read,write}_bytes, and provide a helper to do them. The error
>> > checking/clearing code can then use these same helpers.
>> >
>> > Reported-by: Toshi Kani <toshi.kani@hpe.com>
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> >  drivers/nvdimm/btt.c | 69 ++++++++++++++++++++++++++++++++---------
>> > -----------
>> >  1 file changed, 42 insertions(+), 27 deletions(-)
>> >
>> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
>> > index e9dd651..9acf06b 100644
>> > --- a/drivers/nvdimm/btt.c
>> > +++ b/drivers/nvdimm/btt.c
>> > @@ -31,14 +31,17 @@ enum log_ent_request {
>> >         LOG_OLD_ENT
>> >  };
>> >
>> > +static inline u64 calc_nsoff(struct nd_btt *nd_btt, u64
>> > relative_offset)
>> > +{
>> > +       return relative_offset + nd_btt->initial_offset;
>> > +}
>> > +
>> >  static int arena_read_bytes(struct arena_info *arena,
>> > resource_size_t offset,
>> >                 void *buf, size_t n, unsigned long flags)
>> >  {
>> >         struct nd_btt *nd_btt = arena->nd_btt;
>> >         struct nd_namespace_common *ndns = nd_btt->ndns;
>> >
>> > -       /* arena offsets may be shifted from the base of the device
>> > */
>> > -       offset += arena->nd_btt->initial_offset;
>> >         return nvdimm_read_bytes(ndns, offset, buf, n, flags);
>> >  }
>> >
>> > @@ -48,14 +51,13 @@ static int arena_write_bytes(struct arena_info
>> > *arena, resource_size_t offset,
>> >         struct nd_btt *nd_btt = arena->nd_btt;
>> >         struct nd_namespace_common *ndns = nd_btt->ndns;
>> >
>> > -       /* arena offsets may be shifted from the base of the device
>> > */
>> > -       offset += arena->nd_btt->initial_offset;
>> >         return nvdimm_write_bytes(ndns, offset, buf, n, flags);
>> >  }
>>
>> So let's get rid of arena_{read,write}_bytes(). The only point of the
>> wrapper was to include an arena specific offset, but now we're pushing
>> all offset calculations to the caller so arena_{read,write}_bytes() is
>> equivalent to nvdimm_{read,write}_bytes().
>
> That sounds fine, though that will require all callers to now
> dereference arena->nd->btt->ndns to do reads/writes.. Is that ok?

Sure, just put that in a to_ndns() helper.

>> However, since many of
>> these call sites now perform a common offset calculations maybe we can
>> provide a new helper for that to differentiate it from the error
>> clearing case?
>
> Not sure I follow - the offset calculations for the error clearing use
> and for data reads/writes are exactly the same (lba_to_nsoff). (See
> further below)
>
>> After patch 7 is applied it's no longer clear which
>> offset calculation is used where and for what reason, there's just too
>> many offset variables calculations and overload of the word 'offset'
>> for bugs to hide.
>
> Agreed on the ambiguity of 'offset'. The implicit rule I followed was
> any kind of 'nsoff' will mean the final namespace offset, after
> accounting for arenas, any initial offset etc. Any other 'offset' is
> relative to the context in which it is used.
>
>>
>> Maybe it's just late on a Friday and my eyes are going cross, but it
>> seems you have 2 classes of use cases between calc_nsoff and
>> lba_to_nsoff, perhaps separate read/write wrappers for those 2 cases?
>
> The difference between the two is that lba_to_nsoff is used when were
> talking about reading/writing a 'data' block, and where we are talking
> in terms of 'lba's, not raw offsets. calc_nsoff (which lba_to_nsoff
> calls internally), is a 'last stage' calculation, essentially just to
> add the initial_offset. Direct callers of calc_nsoff (i.e. functions
> that access the log, map, or info blocks) do their offset calculations
> 'manually' based on arena->{map,log,info}off, but these offsets are
> unaware of 'initial_offset', as they started out being relative to
> 'this' arena. So calc_nsoff is that last stage addition of
> initial_offset.
>
> I agree that if feels a bit clunky, but I'm not sure I see a clear way
> to improve it..

Since calc_nsoff is "last stage" and required I think it should be
hidden in the helper that does the read write. Why does it need to be
manually called by every read/write call site?

>> Also, I find something unreadable about calc_nsoff, and reading the
>> prototype "u64 calc_nsoff(struct nd_btt *nd_btt, u64 relative_offset)"
>> doesn't help clarify. What is 'relative_offset' relative to? Is it the
>> base namespace / device offset?
>
> Yeah, I cringed a bit too when I called it 'relative_offset'. But I
> couldn't find a more descriptive name. It is 'almost' the raw nsoff,
> with just the initial_offset calculation pending... Maybe
> btt_relative_offset?

I think this gets easier if the consumer of this ambiguity is reduced
to just the 2 leaf routines that do ->rw_bytes().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
