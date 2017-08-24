Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C34722095B9D9
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:33:40 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id j144so5518099oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:36:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503606666.22880.19.camel@intel.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com>
 <1503606666.22880.19.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 13:36:14 -0700
Message-ID: <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 1:32 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Wed, 2017-08-23 at 17:23 +0000, Kani, Toshimitsu wrote:
>> On Tue, 2017-08-22 at 16:19 -0600, Vishal Verma wrote:
>>  :
>> > +
>> > +/* The block had a media error, and needs to be
>> > cleared */
>> > +if (btt_is_badblock(btt, arena, arena-
>> > > freelist[lane].block)) {
>> >
>> > +arena->freelist[lane].has_err = 1;
>> > +nd_region_release_lane(btt->nd_region,
>> > lane);
>> > +
>> > +arena_clear_freelist_error(arena, lane);
>> > +/* OK to acquire a different lane/free block
>> > */
>> > +goto retry;
>>
>> I hit an infinite clear loop when DSM Clear Uncorrectable Error
>> function fails.  Haven't looked into the details, but I suspect this
>> unconditional retry is the cause of this.
>
> Thanks Toshi - that makes sense. I think the right thing to do would be
> if the DSM fails, return an EIO yes? (Or should we ignore the fact that
> there was an error, clear ->has_err, and let the write take its course
> (possibly generate a CMCI)
>
> It will still be in the badblock list, and for reads ->rw_bytes will
> still check and fail them.
>
> I'll send out a new series with a fix, but we really need to get a unit
> test for BTT error clearing, and I'm working on implementing the new
> error injection DSMs in libndctl and nfit_test to do that.
>

I think as much as possible we should try to not fail writes. Leave
the badblock entry in place so that we get an error on the next read.
Upper-level software reacts more aggressively to write errors than
read errors.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
