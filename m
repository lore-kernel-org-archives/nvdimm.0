Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 681DB2095DB90
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 15:09:00 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id t88so7424718oij.0
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 15:11:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503610260.2042.177.camel@hpe.com>
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com>
 <1503606666.22880.19.camel@intel.com>
 <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
 <x4960dcoetl.fsf@segfault.boston.devel.redhat.com>
 <1503610260.2042.177.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 15:11:34 -0700
Message-ID: <CAPcyv4hF-0Asic+sfXGhN+rvWb6mOb2GpSzWAqkr+U=zO-pt=A@mail.gmail.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 2:40 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2017-08-24 at 17:07 -0400, Jeff Moyer wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > > > I hit an infinite clear loop when DSM Clear Uncorrectable Error
>> > > > function fails.  Haven't looked into the details, but I suspect
>> > > > this unconditional retry is the cause of this.
>> > >
>> > > Thanks Toshi - that makes sense. I think the right thing to do
>> > > would be if the DSM fails, return an EIO yes? (Or should we
>> > > ignore the fact that there was an error, clear ->has_err, and let
>> > > the write take its course (possibly generate a CMCI)
>> > >
>> > > It will still be in the badblock list, and for reads ->rw_bytes
>> > > will still check and fail them.
>> > >
>> > > I'll send out a new series with a fix, but we really need to get
>> > > a unit test for BTT error clearing, and I'm working on
>> > > implementing the new error injection DSMs in libndctl and
>> > > nfit_test to do that.
>> > >
>> >
>> > I think as much as possible we should try to not fail writes. Leave
>> > the badblock entry in place so that we get an error on the next
>> > read. Upper-level software reacts more aggressively to write errors
>> > than read errors.
>>
>> I don't think it's wise to lie about data integrity.  If a write
>> cannot be completed, it *needs* to fail.  You can't make any
>> assumptions about what applications will do with the result.
>
> Agreed.  pmem driver returns with EIO on write in this scenario as
> well.

Ah true, I think we had this discussion before and you convinced me to
go the EIO route then as well. So consider me re-convinced.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
