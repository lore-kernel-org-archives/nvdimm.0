Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF2E822620E68
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 15:51:44 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id 126-v6so2512403oig.0
 for <linux-nvdimm@lists.01.org>; Fri, 06 Apr 2018 15:51:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523054143.2693.346.camel@hpe.com>
References: <152298833162.13386.16059994933936258291.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152298834229.13386.9535080244838507823.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1523052334.2693.330.camel@hpe.com>
 <CAPcyv4i+xGYeO0qPuaoFTqZDe9BG1griYx0VwbUzfWs0As5yxQ@mail.gmail.com>
 <1523054143.2693.346.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Apr 2018 15:51:43 -0700
Message-ID: <CAPcyv4iV5O-08hfhhb1riuTxVzRUG0O2Pioyx7qcCWpY0rZMkA@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 2/3] nfit, address-range-scrub: rework and
 simplify ARS state machine
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 6, 2018 at 3:36 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
> On Fri, 2018-04-06 at 15:13 -0700, Dan Williams wrote:
>> On Fri, Apr 6, 2018 at 3:06 PM, Kani, Toshi <toshi.kani@hpe.com> wrote:
>> > On Thu, 2018-04-05 at 21:19 -0700, Dan Williams wrote:
>> > > ARS is an operation that can take 10s to 100s of seconds to find media
>> > > errors that should rarely be present. If the platform crashes due to
>> > > media errors in persistent memory, the expectation is that the BIOS will
>> > > report those known errors in a 'short' ARS request.
>> > >
>> > > A 'short' ARS request asks platform firmware to return an ARS payload
>> > > with all known errors, but without issuing a 'long' scrub. At driver
>> > > init a short request is issued to all PMEM ranges before registering
>> > > regions. Then, in the background, a long ARS is scheduled for each
>> > > region.
>> >
>> > I confirmed that this version addressed the WARN_ONCE issue.
>> >
>> > > The ARS implementation is simplified to centralize ARS completion work
>> > > in the ars_complete() helper called from ars_status_process_records().
>> > > The timeout is removed since there is no facility to cancel ARS, and
>> > > system init is never blocked waiting for a 'long' ARS. The ars_state
>> > > flags are used to coordinate ARS requests from driver init, ARS requests
>> > > from userspace, and ARS requests in response to media error
>> > > notifications.
>> >
>> > While I like the simplification of the code, I leaned that we need to
>> > handle both cases below:
>> >
>> >  1) No FW ARS Scan: ARS short scan and enable pmem devices without delay
>> > (new behavior by this patch)
>> >  2) FW ARS Scan: Wait for FW ARS scan to complete, and then enable pmem
>> > devices
>> >
>> > Case 2) is still necessary because:
>> >
>> >  - After a system crash in certain error scenario, FW may not be able to
>> > obtain all error records and need ARS long scan to retrieve them.
>> >  - Other OSes do not initiate an ARS long scan, and assume FW to start
>> > it at POST when necessary.
>>
>> Given that there is no specification for how long an ARS can take it
>> is not acceptable for system boot to be blocked indefinitely. In the
>> case where firmware can't populate enough errors into the short scan,
>
> I am less concerned if we get not-enough errors from the short scan in
> case 2).  A background ARS long scan can then fill the gap.  In this
> case, however, it does not get any error from ARS, including previously
> populated ones, since the short scan is not called before enabling pmem
> devices.

Right, if the BIOS kicks off ARS it is getting in the way of the OS
doing the short scan. My position is that the BIOS is being too
paranoid in that case, and should not be doing ARS at boot. We have
machine check recovery and the low expected rate of errors as
mitigations that allow namespaces to come up as early as possible. We
certainly do not do this type of paranoid waiting for disk devices,
why would NVDIMMs be any different?

So yes, the new proposed Linux ARS policy is deliberately ignoring
BIOSen that want to leave ARS running as the OS is booting. If a
platform BIOS implementation really wants all known errors to be found
before starting namespaces it should wait for ARS completion before
finishing POST. Hopefully, no BIOS does that because the OS has better
ways to make forward progress and mitigate errors.

>> *and* machine check error recovery can't handle the errors we're well
>> into "this system needs manual remediation" territory. In that case an
>> administrator can do the following:
>>
>> 1/ boot with "modprobe.blacklist=nd_pmem" to stop pmem namespaces from
>> starting automatically
>> 2/ call "ndctl wait-scrub" to wait for the OS or BIOS initiated ARS to complete
>> 3/ manually start up namespaces with the up to date error list
>> "modprobe nd_pmem"
>
> It's good to know that we have a remedy, but exposing all previously
> populated errors as a result does not sound right to me.

They're not exposed if they are not being actively consumed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
