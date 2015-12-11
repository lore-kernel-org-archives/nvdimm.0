Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 11 Dec 2015 12:00:05 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
Message-ID: <20151211190005.GA58528@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
 <f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
 <CAPcyv4gFNnsbyTy8u-_jBF9JPYH_0a9dNX_R1oj2EH2sdrb=-g@mail.gmail.com>
 <20151210002442.GA104756@tevye.fc.hp.com>
 <CAPcyv4guEsT0KKivDkKP3YiW=8Ps8cDkjzY0seQuec3mkg0wMg@mail.gmail.com>
 <20151211180950.GA57513@tevye.fc.hp.com>
 <CAPcyv4h-8bm4nxO=5K6vRb3720rtaW8A-VHWRaZAhyw0_tjrvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h-8bm4nxO=5K6vRb3720rtaW8A-VHWRaZAhyw0_tjrvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 11, 2015 at 10:18:59AM -0800, Dan Williams wrote:
> On Fri, Dec 11, 2015 at 10:09 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Wed, Dec 09, 2015 at 04:48:55PM -0800, Dan Williams wrote:
> >> Yes, updating the acpi_evaluate_dsm() definition seems the best choice.
> >>
> >
> > I have a patch for this.  While not big (6 files), these files are
> > outside of nvdimm and will have a two line of over a dozen reviewers/lists
> > not previously reviewing this series.
> 
> For an acpi change no need to cc all those folks and lists.  Just cc
> the following for that change:
> 
> Bob Moore <robert.moore@intel.com>
> Lv Zheng <lv.zheng@intel.com>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> <linux-acpi@vger.kernel.org>
> 
> Why 6 files and not 2 for a prototype update?  I wouldn't go touch
> existing callers of acpi_evaluate_dsm() if they have been living with
> the potential truncation all this time there's no need to change.


Wasn't sure the level of lint checking being done on the linux kernel.
The examples were all of the variety of a caller using and int that
would be passed to a function with a parameter that would now be
an u64.  I think Lint can detect such issues.

In addition to acpi_evaluate_dsm,  there are also:
acpi_check_dsm, acpi_evaluate_dsm_typed using int for these.

Then there were other functions outside of acpica that passed
value in ints that went to one of the three functions above.

But, I can certainly limit the change to the acpica function
declaration/definition.  From what I could see the other
code would still work, just have potential lint issues.

> 
> > Do you want me to send this patch as one of this series (w/ the
> > extra reviewers?)
> 
> Yes, send that patch with the series so the acpi developers have the
> context for what motivated the change.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
