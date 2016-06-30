Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D29001A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 17:05:48 -0700 (PDT)
Date: Wed, 29 Jun 2016 18:05:09 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH] acpi, nfit: print command names instead of numbers
Message-ID: <20160630000509.GA109387@tevye.fc.hp.com>
References: <1467241230-15054-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4gFZc2CizeMhc7v+ZzdLpL5tWRO+0JrTY-GDTFMryVefA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gFZc2CizeMhc7v+ZzdLpL5tWRO+0JrTY-GDTFMryVefA@mail.gmail.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 29, 2016 at 04:12:50PM -0700, Dan Williams wrote:
> On Wed, Jun 29, 2016 at 4:00 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > For the debug prints in acpi_nfit_ctl(), all the prints except the input
> > buffer dump printed the command name. Make this also do the same for
> > better readability.
> >
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  drivers/acpi/nfit.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> We used to do this, but nvdimm_cmd_name() currently only knows the
> names for the "Intel" DSMs.  At a minimum we should force cmd_name to
> "unknown" for the other formats until support is added.


nvdimm_cmd_name has entry:

                [ND_CMD_CALL] = "cmd_call",

The change was to display string version of cmd which should be in
the table.


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
