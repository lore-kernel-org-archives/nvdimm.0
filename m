Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on0709.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::709])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D863981C72
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 20:50:07 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v2] libnvdimm: check and clear poison before writing to
 pmem
Date: Fri, 11 Nov 2016 04:50:09 +0000
Message-ID: <DF4PR84MB01698F15BCE30750A06CBAFFABBB0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <147879993593.130465.16954973899565924428.stgit@djiang5-desk3.ch.intel.com>
 <20161110191711.GB26806@omniknight.lm.intel.com>
 <CAPcyv4j9-PsJ4T8EdiiLnq1-hOLvasV7FymuLbYpsDfu3G7=EA@mail.gmail.com>
 <20161110215629.GC26806@omniknight.lm.intel.com>
In-Reply-To: <20161110215629.GC26806@omniknight.lm.intel.com>
Content-Language: en-US
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
To: Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Vishal Verma
> Sent: Thursday, November 10, 2016 3:56 PM
> To: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: [PATCH v2] libnvdimm: check and clear poison before
> writing to pmem
> 
...
> >
> > This feels like over-engineering a still not perfect solution to a
> > rare problem.  Outside of atomic-write-and-clear we should just keep
> > the code best effort and simple.
> 
> Fair enough :) In that case I think the only change needed is to simply
> remove the cleared != size check, do badblocks_clear for "cleared >> 9"
> (as it is now), and then write "size", and return success. Sound good?

Writing size is dangerous. The CPU might not have big enough write 
instructions to avoid causing reads and trigger more uncorrectable 
errors.  Plus, if the function supports size being less than the number
of bytes covered by ECC (e.g. 8 bytes), then a read modify write 
must be done.  If those 8 bytes currently hold an ECC error, then
this write must not fix that error and silently upgrade an error
into bogus good data.  But, preserving the error would mean the
bytes written (and just declared good) are immediately bad again.

Writing cleared is unnecessary, since the caller is only told that
this write function failed, not that it failed after writing a
certain number of bytes.

This still needs to happen after badblocks_clear (or after the
memcpy_to_pmem and nvdimm_flush, if I haven't convinced you to
skip those steps):

>> +                             if (cleared != size)
>> +                                     return -EIO;


---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
