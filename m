Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D84821CB57B3
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 09:22:40 -0700 (PDT)
Date: Wed, 5 Jul 2017 10:24:18 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v4 3/6] libnvdimm, acpi, nfit: Add bus level dsm mask for
 pass thru.
Message-ID: <20170705162418.GA24924@anatevka.americas.hpqcorp.net>
References: <cover.1498810220.git.jerry.hoemann@hpe.com>
 <293ee143dcabb386ca06b384a384171c256a2ecc.1498810220.git.jerry.hoemann@hpe.com>
 <CAPcyv4gcpmmr9LdX3DBtdX_ncwoBmCdC7yVPpGdO6EP7N9NOKw@mail.gmail.com>
 <20170701195805.GA13259@anatevka.americas.hpqcorp.net>
 <CAPcyv4hAMHzi7OK-z-B9LpT83Q1evH2-B-NXUMB2ebtVbjOdsg@mail.gmail.com>
 <CAPcyv4hP0zuZ0bdcQ5R3K2p5CRfHKXMSC_ov1D4qGXsXAQen=A@mail.gmail.com>
 <20170701203813.GA13574@anatevka.americas.hpqcorp.net>
 <CAPcyv4iMNjea939-E8of0nuyze8nHMEOp3ecii8+Y3pyYE0Ecw@mail.gmail.com>
 <20170704200849.GA15713@anatevka.americas.hpqcorp.net>
 <CAPcyv4isR--WJVeVYngGnCGea8HbQzKozsDz4rn6XWGW5vv=OA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4isR--WJVeVYngGnCGea8HbQzKozsDz4rn6XWGW5vv=OA@mail.gmail.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 04, 2017 at 01:37:43PM -0700, Dan Williams wrote:
> On Tue, Jul 4, 2017 at 1:08 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Sat, Jul 01, 2017 at 01:46:03PM -0700, Dan Williams wrote:
> >> On Sat, Jul 1, 2017 at 1:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> > On Sat, Jul 01, 2017 at 01:10:31PM -0700, Dan Williams wrote:
> >> >> On Sat, Jul 1, 2017 at 1:08 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> >> >> > On Sat, Jul 1, 2017 at 12:58 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> >> >> On Fri, Jun 30, 2017 at 08:55:22PM -0700, Dan Williams wrote:
> >> >> >>
> >> >> >> ...

...

> >> >> >>>
> >> >> >>> This drops function number 0 which userspace has no need to call.
> >> >> >>
> >> >> >> Actually I like to call function 0.  Its an excellent test when
> >> >> >> modifying the code path as its a no side effects function whose output
> >> >> >> is known in advance and instantly recognizable.  I also use it when
> >> >> >> testing new firmware.
> >> >> >>
> >> >> >> What is the downside to allowing it?  What bad things happen?
> >> >> >
> >> >> > It allows implementations to bypass the standardization process and
> >> >> > ship new root DSMs. It's always possible to patch the kernel locally
> >> >> > for development, so I see no reason to ship this capability globally.
> >> >
> >> > I don't understand this comment, but I think your next comment
> >> > essentially says to disregard this comment?
> >>
> >> Yes, sorry.
> >>
> >> >> Actually, just the discovery portion does not lead to this leak, but
> >> >> it's redundant when we have the 'dsm_mask' sysfs attribute.
> >> >
> >> > No.  The generation of the mask in sysfs is not done by
> >> > executing the code in acpi_nfit_ctl.  One of the reasons I call
> >> > function 0 to test changes I am making to the ioctl path itself.
> >> > The sysfs has nothing to do with that path and cannot be used
> >> > to serve this purpose.
> >> >
> >> > And since the content of sysfs has been edited it also can not be
> >> > used as a basic test of firmware.
> >> >
> >> > What is the downside to allowing the calling of function 0?
> >>
> >> It needlessly expands the kernel ABI. I would suggest, if you want to
> >
> > No.  It is not needless.  It is not an ABI extension.
> > Same goes for the override feature.
> 
> If the need is testing then we have a tools/testing/nvdimm for that.



> Of course it's an ABI extension, it allows userspace to discover DSM
> function numbers the kernel didn't know about at compile time.


A modification to a library or kernel that changes the results of a
function (or system call) doesn't necessarily break (or extend) an ABI.
An obvious example is that of a random number generator function.
A library/kernel is completely free to change the implementation
of the random number generator (and the values it returns)
without breaking the ABI provided all other rules of ABI preservation
are followed.

Now lets look at problem at hand.  The pass thru mechanism has very
little semantic overhead.  Fill in the nd_cmd_pkg as described in ndctl.h,
call the ioctl w/ argument with ND_CMD_CALL, and the kernel will marshal
up the arguments, call the DSM and return the results.  The values
of nd_command could be any value and it is for the DSM to either accept
or reject the input argument.  I wrote this interface and this is how
I defined it.

The user application is not changing irrespective of if the kernel applies
a mask to the passed in nd_command argument.  The data structures are not
changing at either source level or binary level. The calling convention is not
changing.  No object file changes are required.  Nothing related to ABI
preservation is impacted.  The only question is whether the application
of a mask to special case function 0 breaks/extends the ABI.

It turns out that this point doesn't really matter as your position
is invalid either way.

The argument for this not being an API breakage/extension:

A DSM could either implement or not a function index for any value of N.
So, a correctly written application must take into account that for
any value of N, the DSM may return error or not.  Preserving an ABI
doesn't require the library/kernel preserve incorrect application
behavior.

Now, assume that the special casing of function zero does constitute
a breakage/extension of the ABI:

I'm not the one wishing to special case function 0, you are.
So, to this point I say, Dan please don't make needless extension to
the ABI. Its and extension and you've  provided no valid reason
for making it.

Your argument to disallow function zero is invalid.

There is nothing harmful per se to allow function 0.  All DSMs that return
non zero are required to have it. By excluding it, you actually create the
impression that the underlying DSM is violating the DSM specification.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
