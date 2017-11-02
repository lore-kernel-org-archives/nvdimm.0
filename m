Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75D202034A7D2
 for <linux-nvdimm@lists.01.org>; Wed,  1 Nov 2017 17:29:41 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id c47so256864otj.6
 for <linux-nvdimm@lists.01.org>; Wed, 01 Nov 2017 17:33:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171101173546.GA31061@anatevka.americas.hpqcorp.net>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
 <CAPcyv4j7pvto7AvbzcmpgiYXHHm69LnGyWduRKP8qou947qqXA@mail.gmail.com>
 <20171031220552.GB22678@anatevka.americas.hpqcorp.net>
 <CAPcyv4g+pRApbhK5no=mJQnA8UaRP52JWQ8moz-2tHBzTRiF8Q@mail.gmail.com>
 <20171101173546.GA31061@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 1 Nov 2017 17:33:32 -0700
Message-ID: <CAPcyv4j5_hM_GbDZ6-5=zHK_AQ9SZeUCW7SV7tciD_PKaWRCQw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] acpi, nfit: add support for NVDIMM_FAMILY_INTEL
 v1.6 DSMs
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 1, 2017 at 10:35 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Tue, Oct 31, 2017 at 04:19:32PM -0700, Dan Williams wrote:
>> On Tue, Oct 31, 2017 at 3:05 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Tue, Oct 31, 2017 at 02:42:01PM -0700, Dan Williams wrote:
>> [..]
>> >> Yes, this can happen. However, for the kernel implementation it can
>> >> decide to move to rev-id2 at its leisure since ACPI mandates that
>> >> rev-id1 implementations stick around, and if the function number was
>> >> reserved in rev-id1 the kernel will already not support it.
>> >
>> > Unfortunately, we can't do that.  The kernel will still need to support
>> > firmware that only knows about Rev ID 1.
>> >
>> > Example, HPE currently supports customers w/ NVDIMMS with DSM that only
>> > responds to rev id 1.
>> >
>> > Say in the future we ship a new generation of NVDIMMs
>> > that extends the DSM health function.  We could make that
>> > additional info available only for rev id 2.  If the table
>> > above were extended to call health function with rev id 2
>> > so that we get the additional info for the new nvdimm, that
>> > call will stop working on what will then be legacy systems
>> > that only know rev id 1.
>>
>> Right, I'm explicitly not supporting that degree of compatibility
>> freedom. If a platform wants to change the payload of an existing
>> function it had better expand the payload with new information that
>> can optionally be ignored by older kernels rather than spin the revid.
>> The kernel can't break legacy and neither should the platform, either
>> the kernel can call revid1 forever, the function is only available in
>> revid2 or later, or that function number is burned and we need to live
>> with the breakage that the platform shipped.
>
>
> Old software would still be calling firmware with revision id 1 and
> firmware would still respond with the revision id 1 version of the
> call.  So there is no problem there.  This would be the case for
> legacy firmware that only understand revision id 1, or new firmware
> that understands both revision id 1 and revision id 2.  Calling a
> function with revision id 1 should get the revision id 1 version
> of the call.  If not, then bug in firmware.
>
> The idea behind revision ids here is to allow both software and firmware
> to progress but still work together.   Firmware can extend functionality
> by increasing revision ID, but will still answer to old software that
> calls with older revision IDS.
>
> Likewise, OS can add support for new revision IDs/functions but still
> needs to be aware that firmware at customer sites may be legacy firmware that
> doesn't understand the newer firmware revision.  So software needs
> to call firmware with revision IDs that the firmware understands.
>
> Specifically, I am pushing back on the idea that the OS could
> just start calling a function with revision ID 2.  That doesn't
> work on firmware that only understands revision ID 1.  The call
> will fail.

Right, the OS can only switch to rev-id2 of the same function after a
long deprecation period. The timeframe to deprecate support for
rev-id1 and switch the kernel to start using rev-id2 of the same
function is on the order of several years until all old hardware with
only rev-id1 is end-of-life. The way to upgrade functionality in a
manner that does not break the world is to extend payloads with
optional functionality.

This is why DSM is a dangerous interface, it gives entirely too much
power to the platform to do something incompatible, so we should
mitigate that by communicating to platform implementers that the
kernel will continue to use rev-id1 indefinitely for a given function.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
