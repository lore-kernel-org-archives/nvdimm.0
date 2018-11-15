Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
 [66.111.4.29])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A28C82118F37A
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 15:57:00 -0800 (PST)
Date: Fri, 16 Nov 2018 10:56:51 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [Ksummit-discuss] [RFC PATCH 2/3] MAINTAINERS, Handbook:
 Subsystem Profile
Message-ID: <20181115235651.GD5782@caerus>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
 <87pnv6ivl7.fsf@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87pnv6ivl7.fsf@intel.com>
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
To: Jani Nikula <jani.nikula@intel.com>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Steve French <stfrench@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 15, 2018 at 10:38:44AM +0200, Jani Nikula wrote:
> 
> Cc: linux-doc
> 
> On Wed, 14 Nov 2018, Dan Williams <dan.j.williams@intel.com> wrote:
> > As presented at the 2018 Linux Plumbers conference [1], the Subsystem
> > Profile is proposed as a way to reduce friction between committers and
> > maintainers and perhaps encourage conversations amongst maintainers
> > about best practice policies.
> >
> > The profile contains short answers to some of the common policy
> > questions a contributor might have, or that a maintainer might consider
> > formalizing. The current list of maintenance policies is:
> >
> > Overview: General introduction to maintaining the subsystem
> > Core: List of source files considered core
> > Leaf: List of source files that consume core functionality
> > Patches or Pull requests: Simple statement of expected submission format
> > Last -rc for new feature submissions: Expected lead time for submissions
> > Last -rc to merge features: Deadline for merge decisions
> > Non-author Ack / Review Tags Required: Patch review economics
> > Test Suite: Pass this suite before requesting inclusion
> > Resubmit Cadence: When to ping the maintainer
> > Trusted Reviewers: Help for triaging patches
> > Time Zone / Office Hours: When might a maintainer be available
> > Checkpatch / Style Cleanups: Policy on pure cleanup patches
> > Off-list review: Request for review gates
> > TODO: Potential development tasks up for grabs, or active focus areas
> >
> > The goal of the Subsystem Profile is to set expectations for
> > contributors and interim or replacement maintainers for a subsystem.
> 
> First of all, I welcome documentation efforts like this.
> 
> The cover letter mainly focuses on the maintainer aspect, and the
> documentation is added to the maintainer handbook. However, here you set
> the goal as setting expectations for contributors. The example nvdimm
> profile in patch 3/3 addresses the reader as a new maintainer, yet goes
> on to set expectations also for contributors, not just the maintainer.
> 
> I do think the documentation for contributors and maintainers/committers
> should be kept separate. Most contributors will never care about the
> documentation for the latter. We have Documentation/process for
> contributors, and I think the audience of Documentation/maintainer
> should be strictly maintainers.
> 
> In summary, I do think we need all of the documentation you propose, and
> I appreciate you taking this on, but I think this should be split by
> audience.

I got confused by this at first also Jani.  This document is a template
for use by maintainers.  The files created from the template (by a
subsystem maintainer) are for contributors.  So I believe this document
is in the correct place.

Hope this helps to clarify.

     Tobin
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
