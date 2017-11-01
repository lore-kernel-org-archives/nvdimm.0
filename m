Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 122EB21FCA270
 for <linux-nvdimm@lists.01.org>; Wed,  1 Nov 2017 10:31:54 -0700 (PDT)
Date: Wed, 1 Nov 2017 11:35:46 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v2 2/2] acpi, nfit: add support for NVDIMM_FAMILY_INTEL
 v1.6 DSMs
Message-ID: <20171101173546.GA31061@anatevka.americas.hpqcorp.net>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
 <CAPcyv4j7pvto7AvbzcmpgiYXHHm69LnGyWduRKP8qou947qqXA@mail.gmail.com>
 <20171031220552.GB22678@anatevka.americas.hpqcorp.net>
 <CAPcyv4g+pRApbhK5no=mJQnA8UaRP52JWQ8moz-2tHBzTRiF8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g+pRApbhK5no=mJQnA8UaRP52JWQ8moz-2tHBzTRiF8Q@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 31, 2017 at 04:19:32PM -0700, Dan Williams wrote:
> On Tue, Oct 31, 2017 at 3:05 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Tue, Oct 31, 2017 at 02:42:01PM -0700, Dan Williams wrote:
> [..]
> >> Yes, this can happen. However, for the kernel implementation it can
> >> decide to move to rev-id2 at its leisure since ACPI mandates that
> >> rev-id1 implementations stick around, and if the function number was
> >> reserved in rev-id1 the kernel will already not support it.
> >
> > Unfortunately, we can't do that.  The kernel will still need to support
> > firmware that only knows about Rev ID 1.
> >
> > Example, HPE currently supports customers w/ NVDIMMS with DSM that only
> > responds to rev id 1.
> >
> > Say in the future we ship a new generation of NVDIMMs
> > that extends the DSM health function.  We could make that
> > additional info available only for rev id 2.  If the table
> > above were extended to call health function with rev id 2
> > so that we get the additional info for the new nvdimm, that
> > call will stop working on what will then be legacy systems
> > that only know rev id 1.
> 
> Right, I'm explicitly not supporting that degree of compatibility
> freedom. If a platform wants to change the payload of an existing
> function it had better expand the payload with new information that
> can optionally be ignored by older kernels rather than spin the revid.
> The kernel can't break legacy and neither should the platform, either
> the kernel can call revid1 forever, the function is only available in
> revid2 or later, or that function number is burned and we need to live
> with the breakage that the platform shipped.


Old software would still be calling firmware with revision id 1 and
firmware would still respond with the revision id 1 version of the
call.  So there is no problem there.  This would be the case for
legacy firmware that only understand revision id 1, or new firmware
that understands both revision id 1 and revision id 2.  Calling a
function with revision id 1 should get the revision id 1 version
of the call.  If not, then bug in firmware.

The idea behind revision ids here is to allow both software and firmware
to progress but still work together.   Firmware can extend functionality
by increasing revision ID, but will still answer to old software that
calls with older revision IDS.

Likewise, OS can add support for new revision IDs/functions but still
needs to be aware that firmware at customer sites may be legacy firmware that
doesn't understand the newer firmware revision.  So software needs
to call firmware with revision IDs that the firmware understands.

Specifically, I am pushing back on the idea that the OS could
just start calling a function with revision ID 2.  That doesn't
work on firmware that only understands revision ID 1.  The call
will fail.


> 
> We are already in this position with the "smart threshold" payload
> that has been broken in recent revisions of the Intel spec. In this
> specific case we have ndctl binaries in the wild that are broken, but
> are somewhat saved by the fact that the interface for *setting* alarms
> and thresholds is brand new in v1.6. So my plan is to document that
> smart threshold is broken and require new ndctl binaries with v1.6
> support to implement the new format via the ND_CMD_CALL interface. The
> fact that this compatibility management is on a case by case basis and
> somewhat painful is a feature. Platform implementations must hide DSM
> update thrash from the kernel and shipping binaries as much as
> possible.


I haven't thought through the changes in v1.6.  The threshold one
doesn't seem backwards compatible and it would have been better for
this to have been caught during design review. Oh, well.....

Fortunately, this isn't a customer/legacy bios issue yet, so solutions
are a bit more flexible.

I am concerned how the ND_CMD_CALL interface can handle revision ID
changes in general.  The interface doesn't specify a revision ID so
it can't control the revision of data being returned to the level
it can handle.  Likewise,  there is no mechanism to communicate
back to the application the revision of the call being returned.
This make me think that any application that uses ND_CMD_CALL will
be rev locked to specific kernel revisions.  I need to think about
this more.



-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
