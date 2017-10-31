Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0DFE2034AB1A
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 16:15:41 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id v9so951719oif.13
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 16:19:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171031220552.GB22678@anatevka.americas.hpqcorp.net>
References: <150939641796.4577.379718469071595984.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150939642870.4577.1202379190708311186.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171031212725.GA22678@anatevka.americas.hpqcorp.net>
 <CAPcyv4j7pvto7AvbzcmpgiYXHHm69LnGyWduRKP8qou947qqXA@mail.gmail.com>
 <20171031220552.GB22678@anatevka.americas.hpqcorp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 16:19:32 -0700
Message-ID: <CAPcyv4g+pRApbhK5no=mJQnA8UaRP52JWQ8moz-2tHBzTRiF8Q@mail.gmail.com>
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

On Tue, Oct 31, 2017 at 3:05 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Tue, Oct 31, 2017 at 02:42:01PM -0700, Dan Williams wrote:
[..]
>> Yes, this can happen. However, for the kernel implementation it can
>> decide to move to rev-id2 at its leisure since ACPI mandates that
>> rev-id1 implementations stick around, and if the function number was
>> reserved in rev-id1 the kernel will already not support it.
>
> Unfortunately, we can't do that.  The kernel will still need to support
> firmware that only knows about Rev ID 1.
>
> Example, HPE currently supports customers w/ NVDIMMS with DSM that only
> responds to rev id 1.
>
> Say in the future we ship a new generation of NVDIMMs
> that extends the DSM health function.  We could make that
> additional info available only for rev id 2.  If the table
> above were extended to call health function with rev id 2
> so that we get the additional info for the new nvdimm, that
> call will stop working on what will then be legacy systems
> that only know rev id 1.

Right, I'm explicitly not supporting that degree of compatibility
freedom. If a platform wants to change the payload of an existing
function it had better expand the payload with new information that
can optionally be ignored by older kernels rather than spin the revid.
The kernel can't break legacy and neither should the platform, either
the kernel can call revid1 forever, the function is only available in
revid2 or later, or that function number is burned and we need to live
with the breakage that the platform shipped.

We are already in this position with the "smart threshold" payload
that has been broken in recent revisions of the Intel spec. In this
specific case we have ndctl binaries in the wild that are broken, but
are somewhat saved by the fact that the interface for *setting* alarms
and thresholds is brand new in v1.6. So my plan is to document that
smart threshold is broken and require new ndctl binaries with v1.6
support to implement the new format via the ND_CMD_CALL interface. The
fact that this compatibility management is on a case by case basis and
somewhat painful is a feature. Platform implementations must hide DSM
update thrash from the kernel and shipping binaries as much as
possible.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
