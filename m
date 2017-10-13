Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D740D202E5CD0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:10:07 -0700 (PDT)
Date: Fri, 13 Oct 2017 17:13:38 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] libnvdimm: add smart payload fields added in DSM 1.6
Message-ID: <20171013231338.GB9192@anatevka.fc.hp.com>
References: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jFXmmFriwc5+o0qjx7OoASijHAm3TRPBbF_yVdD2BOGw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jFXmmFriwc5+o0qjx7OoASijHAm3TRPBbF_yVdD2BOGw@mail.gmail.com>
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
Cc: "Balcer, Piotr" <piotr.balcer@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 11:01:26AM -0700, Dan Williams wrote:
> On Wed, Oct 11, 2017 at 10:57 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> > NVDIMM DSM interface v1.6 added additional smart health fields. Updating the
> > smart payload data structure accordingly.
> 
> I'll also add a note when I merge this that the only reason we are
> maintaining this structure in the kernel is in case we want to
> translate 3rd party SMART payload formats into the ND_IOCTL_SMART
> format. Outside of that we could just delete this since ndctl is
> already doing that translation.


Dan,

Function 2, Get Smart Threshold, in v1.6 is also different from what
Linux implemented in ndctl.h.  But, these changes don't appear to be
backward compatible.

Do you have plans for this?

Jerry

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
