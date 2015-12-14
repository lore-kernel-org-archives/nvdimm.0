Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 13 Dec 2015 20:20:58 -0700
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v3 1/6] acpica: Correct parameter type to
 acpi_evaluate_dsm
Message-ID: <20151214032058.GA19337@tevye.fc.hp.com>
Reply-To: Jerry.Hoemann@hpe.com
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
 <260ee0c6c9481ceae79b967a95b5e9fe76c2eabc.1450036445.git.jerry.hoemann@hpe.com>
 <CAJZ5v0jiR80vFxLUN-L7hcChb8m6gasf77TMV6onOprSh_CVHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0jiR80vFxLUN-L7hcChb8m6gasf77TMV6onOprSh_CVHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Dan Williams <dan.j.williams@intel.com>, elliott@hpe.com, jmoyer <jmoyer@redhat.com>, krivenok.dmitry@gmail.com, linda.knippers@hpe.com, Robert Moore <robert.moore@intel.com>, Lv <lv.zheng@intel.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, linux-nvdimm@lists.01.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 14, 2015 at 03:07:22AM +0100, Rafael J. Wysocki wrote:
> On Mon, Dec 14, 2015 at 2:54 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > The ACPI spec speicifies that arguments "Revision ID" and
> > "Function Index" to a _DSM are type "Integer."  Type Integers
> > are 64 bit quantities.
> >
> > The function evaluate_dsm specifies these types as simple "int"
> > which are 32 bits.  Correct type passed to acpi_evaluate_dsm
> > and its callers and derived callers to pass correct type.
> >
> > acpi_check_dsm and acpi_evaluate_dsm_typed had similar issue
> > and were corrected as well.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> 
> The changes look OK to me, but this is not ACPICA material.
> 
> Please change the subject to something like "ACPI / utils: Fix
> acpi_evaluate_dsm() argument type".
> 
> Thanks,
> Rafael

  Will do.  thanks.

-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
