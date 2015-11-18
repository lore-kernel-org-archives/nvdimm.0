Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 18 Nov 2015 00:01:32 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v2 0/3] nvdimm: Add an IOCTL pass thru for DSM calls
Message-ID: <20151118070132.GA118986@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
 <CAPcyv4j_KcwztL3ACRafSFGEiaspCuM_+CwkcSeymVk5s5vYWg@mail.gmail.com>
 <20151116211011.GC10480@tevye.fc.hp.com>
 <CAPcyv4jhORsskTr_SPpNO=zJf9V7_zrYNnNn61SMWApnv7TK0g@mail.gmail.com>
 <20151117165645.GB91690@tevye.fc.hp.com>
 <CAPcyv4gryw5GT2CLHvgirGMudDrQBJaBojwbjxhgkPqR5Te5pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gryw5GT2CLHvgirGMudDrQBJaBojwbjxhgkPqR5Te5pg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 17, 2015 at 09:05:28AM -0800, Dan Williams wrote:
> On Tue, Nov 17, 2015 at 8:56 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Mon, Nov 16, 2015 at 05:29:41PM -0800, Dan Williams wrote:
> >> On Mon, Nov 16, 2015 at 1:10 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> > On Mon, Nov 16, 2015 at 11:00:20AM -0800, Dan Williams wrote:
> >> >> On Mon, Nov 16, 2015 at 10:38 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >> >> >
> >> >>
> >
> > ...
> >
> >> I want to do it in separate steps, I'd just like to see cmd number 100
> >> added to the existing __nd_ioctl and acpi_nfit_ctl routines.  That
> >
> >    Why?
> 
> Because there's no need for the intel vs passthru distinction, it's
> just yet another command.

  Yes and no.  The way the two marshal their arguments in prep for
  the copy in/copy out is different and are not compatible.

  Also, the existing upstream acpi_nfit_ctl does multiple things that
  we don't want done in the "semi" passthru case.

  To accomodate these differences, I implemented in separate functions.
  I can merge the functions together, it will not be clean.

  This approach also creates testing issues I didn't have previously.  I
  was confident w/ code inspection that I wasn't breaking the existing
  usage case.  I will need your help in testing on hardware that I don't
  have access to.

  You expressed a desire to depricate the existing ioctl commands
  and transition to the semi passthru structure.

  What do you anticipate that code looking like?

> 
> >> plus quibbling about the name "ND_CMD_PASSTHRU".  Given the plans to
> >> eventually replace the existing commands we can call it something like
> >> 'ND_DSM_GENERIC'.
> >
> >
> >   No problem.  I'll change the name for ndn_passthru_pkg in a similar fashion.
> >
> >
> >   Question:     Are you planning to add other CMDs to the IOCTL in the future?
> >                 (eg. ones not directly related to calling _dsm?)
> >
> >                 Or, is the ultimate goal to have an IOCTL that supports
> >                 only the generic DSM call?
> 
> I'm not ruling out the possibility that there may be a non-DSM command
> in the future, but I don't see any need for that on the horizon.  Why
> would it matter?

  Neither the existing upstream apci_nfit_ctl nor the semi pass thru
  marshal arguments in a traditional straight forward manner.  So likely
  the marshaling code for any new commands would be different.

  Also, since it doesn't call DSM it wouldn't be doing the evaluate dsm.



-- 

-----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer      Hewlett-Packard Enterprise
-----------------------------------------------------------------------------
