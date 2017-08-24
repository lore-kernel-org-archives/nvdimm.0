Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F07D2095AE43
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 14:04:38 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v6 6/6] libnvdimm, btt: rework error clearing
References: <20170822221915.1732-1-vishal.l.verma@intel.com>
 <20170822221915.1732-7-vishal.l.verma@intel.com>
 <1503508401.2042.174.camel@hpe.com>
 <1503606666.22880.19.camel@intel.com>
 <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
Date: Thu, 24 Aug 2017 17:07:02 -0400
In-Reply-To: <CAPcyv4gY+7C8jN8g84L3-7Y661vKWqxG5odamFqGF+HriF=Q2g@mail.gmail.com>
 (Dan Williams's message of "Thu, 24 Aug 2017 13:36:14 -0700")
Message-ID: <x4960dcoetl.fsf@segfault.boston.devel.redhat.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

>>> I hit an infinite clear loop when DSM Clear Uncorrectable Error
>>> function fails.  Haven't looked into the details, but I suspect this
>>> unconditional retry is the cause of this.
>>
>> Thanks Toshi - that makes sense. I think the right thing to do would be
>> if the DSM fails, return an EIO yes? (Or should we ignore the fact that
>> there was an error, clear ->has_err, and let the write take its course
>> (possibly generate a CMCI)
>>
>> It will still be in the badblock list, and for reads ->rw_bytes will
>> still check and fail them.
>>
>> I'll send out a new series with a fix, but we really need to get a unit
>> test for BTT error clearing, and I'm working on implementing the new
>> error injection DSMs in libndctl and nfit_test to do that.
>>
>
> I think as much as possible we should try to not fail writes. Leave
> the badblock entry in place so that we get an error on the next read.
> Upper-level software reacts more aggressively to write errors than
> read errors.

I don't think it's wise to lie about data integrity.  If a write cannot
be completed, it *needs* to fail.  You can't make any assumptions about
what applications will do with the result.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
