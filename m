Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x234.google.com (mail-it0-x234.google.com
 [IPv6:2607:f8b0:4001:c0b::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7221481EA0
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 22:18:49 -0800 (PST)
Received: by mail-it0-x234.google.com with SMTP id q124so98474444itd.1
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 22:18:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB01698F15BCE30750A06CBAFFABBB0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <147879993593.130465.16954973899565924428.stgit@djiang5-desk3.ch.intel.com>
 <20161110191711.GB26806@omniknight.lm.intel.com>
 <CAPcyv4j9-PsJ4T8EdiiLnq1-hOLvasV7FymuLbYpsDfu3G7=EA@mail.gmail.com>
 <20161110215629.GC26806@omniknight.lm.intel.com>
 <DF4PR84MB01698F15BCE30750A06CBAFFABBB0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Nov 2016 22:18:52 -0800
Message-ID: <CAPcyv4hRJvcp7gSeQ-KO5ioOpj+cAbb=nOM9LA-8dkW6660efw@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm: check and clear poison before writing to
 pmem
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 10, 2016 at 8:50 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
>> Behalf Of Vishal Verma
>> Sent: Thursday, November 10, 2016 3:56 PM
>> To: Dan Williams <dan.j.williams@intel.com>
>> Cc: linux-nvdimm@lists.01.org
>> Subject: Re: [PATCH v2] libnvdimm: check and clear poison before
>> writing to pmem
>>
> ...
>> >
>> > This feels like over-engineering a still not perfect solution to a
>> > rare problem.  Outside of atomic-write-and-clear we should just keep
>> > the code best effort and simple.
>>
>> Fair enough :) In that case I think the only change needed is to simply
>> remove the cleared != size check, do badblocks_clear for "cleared >> 9"
>> (as it is now), and then write "size", and return success. Sound good?
>
> Writing size is dangerous. The CPU might not have big enough write
> instructions to avoid causing reads and trigger more uncorrectable
> errors.

The writes are non-temporal and even if there were reads the cpu does
not consume them on a read-modify-write cycle.  They might trigger a
CMCI ("corrected" machine check), but should halt the cpu since the
error only ever appears in the cache.

> Plus, if the function supports size being less than the number
> of bytes covered by ECC (e.g. 8 bytes), then a read modify write
> must be done.  If those 8 bytes currently hold an ECC error, then
> this write must not fix that error and silently upgrade an error
> into bogus good data.  But, preserving the error would mean the
> bytes written (and just declared good) are immediately bad again.

We're only talking about partially completing a multi-sector transfer,
not a sub-sector transfer.  Sub-sector or unaligned transfers will not
attempt to clear errors.

> Writing cleared is unnecessary, since the caller is only told that
> this write function failed, not that it failed after writing a
> certain number of bytes.

This assumes that an application is prepared to handle indeterminate
data after a write error.  It may still be fatal, but trying to push
the state from "old data" to "new" rather than "old data" to
"indeterminate" is less likely to surprise an application.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
