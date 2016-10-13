Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA5FD1A1E93
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 12:24:30 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id m72so110816106oik.3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 12:24:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476382494.20881.58.camel@hpe.com>
References: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
 <1476374787.20881.34.camel@hpe.com>
 <CAPcyv4jvi0N1qbUeEy5qvxp5uctv9sW4oNZLcO5Vt2TsuuQh-A@mail.gmail.com>
 <1476382494.20881.58.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Oct 2016 12:24:29 -0700
Message-ID: <CAPcyv4jM597QagpQjPNeBYU=67_7Ab7TB_rYFNO5SsZ0tSqrtQ@mail.gmail.com>
Subject: Re: [PATCH] pmem: report error on clear poison failure
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

On Thu, Oct 13, 2016 at 11:16 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2016-10-13 at 10:22 -0700, Dan Williams wrote:
>> On Thu, Oct 13, 2016 at 9:08 AM, Kani, Toshimitsu <toshi.kani@hpe.com
>> > wrote:
>> >
>> > On Thu, 2016-10-13 at 09:01 -0700, Dan Williams wrote:
>> > >
>> > > On Thu, Oct 13, 2016 at 8:54 AM, Toshi Kani <toshi.kani@hpe.com>
>> > > wrote:
>> > > >
>> > > >
>> > > > ACPI Clear Uncorrectable Error DSM function may fail or may be
>> > > > unsupported on a platform.  pmem_clear_poison() returns without
>> > > > clearing badblocks in such cases, which leads to a silent data
>> > > > corruption.
>> > > >
>> > > > Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
>> > > > so that filesystem can log an error message.
>> > >
>> > > What's the silent data corruption scenario?  If the clear poison
>> > > fails I'm assuming that the poison will still be notified on the
>> > > next
>> > > read.
>> >
>> > I agree that the data is eventually read, but there is no guranteed
>> > that when it is read soon enough, i.e. user might not access to the
>> > data for a long time.
>>
>> ...but that's the same behavior for errors that we don't yet know
>> about.  That said, we indeed know that the write failed.  I'd feel
>> better about this patch if the justification / impact was clearer in
>> the changelog, because "silent data corruption" is not the impact.
>
> Agreed.  How about the following descritpion?
>
> ===
> ACPI Clear Uncorrectable Error DSM function may fail or may be
> unsupported on a platform.  pmem_clear_poison() returns without
> clearing badblocks in such cases.  This failure is detected at
> the next read (-EIO).
>
> This behavior can lead to an issue when user keeps writing but
> does not read immedicately.  For instance, flight recorder file
> may be only read when it is necessary for troubleshooting.
>
> Change pmem_do_bvec() and pmem_clear_poison() to return -EIO
> so that filesystem can log an error message on a write error.
> ===

Looks good, thanks Toshi.  I'll update the nvdimm.git branches after
-rc1 is out.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
