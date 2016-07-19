Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CB961A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 12:01:42 -0700 (PDT)
Date: Tue, 19 Jul 2016 13:00:49 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi_check_dsm() vs zero functions
 implemented
Message-ID: <20160719190048.GG140413@tevye.fc.hp.com>
References: <146679026571.24395.11569929364936343871.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160719171153.GA121461@tevye.fc.hp.com>
 <cfd9968d-9835-0ef1-fafd-54fd3b892d1c@hpe.com>
 <CAPcyv4gqmjMFveV+iE2NbvWnTb5kdy8w54VDgLYxeMJ5NJyzbw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gqmjMFveV+iE2NbvWnTb5kdy8w54VDgLYxeMJ5NJyzbw@mail.gmail.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Marvin Spinhirne <spin@hpe.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 19, 2016 at 11:52:53AM -0700, Dan Williams wrote:
> On Tue, Jul 19, 2016 at 11:50 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> >
> >
> > On 7/19/2016 1:11 PM, Jerry Hoemann wrote:
> >> On Fri, Jun 24, 2016 at 10:44:25AM -0700, Dan Williams wrote:
> >>> QEMU 2.6 implements nascent support for nvdimm DSMs. Depending on
> >>> configuration it may only implement the function0 dsm to indicate that
> >>> no other DSMs are available. Commit 31eca76ba2fc "nfit, libnvdimm:
> >>> limited/whitelisted dimm command marshaling mechanism" breaks QEMU, but
> >>> QEMU is spec compliant.  Per the spec the way to indicate that no
> >>> functions are supported is:
> >>>
> >>>     If Function Index is zero, the return is a buffer containing one bit
> >>>     for each function index, starting with zero. Bit 0 indicates whether
> >>>     there is support for any functions other than function 0 for the
> >>>     specified UUID and Revision ID. If set to zero, no functions are
> >>>     supported (other than function zero) for the specified UUID and
> >>>     Revision ID.
> >>
> >>
> >> Dan,
> >>
> >> This breaks calling DSM on HPE platforms and is a regression.
> >>
> >> E-mail context can be found at:
> >>
> >>       https://lists.01.org/pipermail/linux-nvdimm/2016-June/006099.html
> >>
> >> The problem with this change is that it assumes that ACPI returning an
> >> object means that the UUID is supported on that platform.
> >>
> >> However, looking at ACPI v 6.1 section 9.1.1, the example for
> >> evaluating a _DSM shows that if the UUID is not supported at all,
> >> a zeroed out buffer of length 1 is returned:
> >>
> >>       //
> >>       // If not one of the UUIDs we recognize, then return a buffer
> >>       // with bit 0 set to 0 indicating no functions supported.
> >>       //
> >>       return(Buffer(){0})
> >>
> >> HPE firmware has been following this practice for a long long time.
> >> I suspect other manufacturer's firmware do so as well.
> >>
> >> The problem is that this creates an ambiguity and the linux code
> >> is no longer differentiating the case where the DSM/UUID is
> >> supported but only implements function 0 (the QEMU case you're
> >> trying to accommodate) and the case that the DSM/UUID is not
> >> supported at all.
> >>
> >> The result is that the code in acpi_nfit_add_dimm:
> >>
> >>       for (i = NVDIMM_FAMILY_INTEL; i <= NVDIMM_FAMILY_HPE2; i++)
> >> -             if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 1))
> >> +             if (acpi_check_dsm(adev_dimm->handle, to_nfit_uuid(i), 1, 0))
> >>                       break;
> >>
> >>
> >> always matches NVDIMM_FAMILY_INTEL.  This is either because its
> >> is an Intel nvdimm, or because the unsupported UUID returns back
> >> a zeroed out buffer of length 1.
> >>
> >>
> >> As nfit_mem->family always equals NVDIMM_FAMILY_INTEL, no subsequent
> >> DSM call will succeed for NVDIMM_FAMILY_HPE1 or any other
> >> family.
> >>
> >> I don't have a fix as of yet, but wanted to make you aware of
> >> the problem.
> >
> > Could we try the all known UUIDs looking for one that returns a non-zero
> > value?
> >
> 
> Yes, that seems like the way forward, and also make not finding a DSM
> family non-fatal.

Reverting this change would address for HPE, but I do not fully understand
the nature of the problem this change was attempting to address.

Can you expand a bit?

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
