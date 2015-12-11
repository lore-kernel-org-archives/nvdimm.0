Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 11 Dec 2015 11:09:50 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
Message-ID: <20151211180950.GA57513@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
 <f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
 <CAPcyv4gFNnsbyTy8u-_jBF9JPYH_0a9dNX_R1oj2EH2sdrb=-g@mail.gmail.com>
 <20151210002442.GA104756@tevye.fc.hp.com>
 <CAPcyv4guEsT0KKivDkKP3YiW=8Ps8cDkjzY0seQuec3mkg0wMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4guEsT0KKivDkKP3YiW=8Ps8cDkjzY0seQuec3mkg0wMg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 09, 2015 at 04:48:55PM -0800, Dan Williams wrote:
> 
> Yes, still very much interested in this path.  But the code will need
> to be around for quite awhile now that it has appeared in a released
> kernel and a released version of ndctl.  So anything that makes the
> code more maintainable in the interim is beneficial.
> 
> >  If yes, the work we need to do to integrate these two different approaches
> >  will just need to be undone.  Further if we deprecate the current IOCTLs,
> >  then the nd_cmd_desc tables and related nd_cmd_in_size and nd_cmd_out_size
> >  could then be removed.
> 
> I'm not seeing this as a large amount of work.  Do you want to hand
> off this task to me?


I have implemented this and will send as part of next version.


> 
> > ACPI defines arguments to a _DSM as 64 bit quantities. We want the interface
> > exported to the user to follow the ACPI spec.  The variables above collect
> > the value of rev or func from the two different sources (wrapper or legacy)
> > and then passes to acpi_evaluate_dsm which defines the parameters as simple
> > ints.
> >
> > So, going from user interface to call of acpi_evaluate_dsm there will be
> > a truncation somewhere.
> >
> > Looking at acpi_evaluate_dsm(), it uses union acpi_object and fills in
> > .integer.value for both rev and func.  These are defined as u64.
> >
> > So patching acpi_evaluate_dsm to make the rev and func parameters u64 might
> > be do'able, but we'd still have potential sign issues with other callers
> > to acpi_evaluate_dsm which look to be using simple ints in the call.
> >
> > Do you want me to look at patching acpi_evaluate_dsm (and possibly
> > its callers) as part of this patch set?
> 
> Yes, updating the acpi_evaluate_dsm() definition seems the best choice.
> 


I have a patch for this.  While not big (6 files), these files are
outside of nvdimm and will have a two line of over a dozen reviewers/lists
not previously reviewing this series.

Do you want me to send this patch as one of this series (w/ the
extra reviewers?)

Or as separate stand alone to just those reviewers (and yourself.)
(and if this option, before or after this series.)



-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
