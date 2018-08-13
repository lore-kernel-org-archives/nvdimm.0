Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta24.messagelabs.com (mail1.bemta24.messagelabs.com
 [67.219.250.212])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7FC9210D97A4
 for <linux-nvdimm@lists.01.org>; Sun, 12 Aug 2018 19:53:42 -0700 (PDT)
From: Ocean HY1 He <hehy1@lenovo.com>
Subject: RE: [External]  Re: [PATCH v2] ACPI: nfit: remove redundant
 assignment if nfit_mem found
Date: Mon, 13 Aug 2018 02:53:24 +0000
Message-ID: <HK0PR03MB31708EFDDA3F29C4A697956889390@HK0PR03MB3170.apcprd03.prod.outlook.com>
References: <1533199444-29607-1-git-send-email-oceanhehy@gmail.com>
 <1533944734.6054.38.camel@intel.com>
In-Reply-To: <1533944734.6054.38.camel@intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "Jiang, Dave" <dave.jiang@intel.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Verma, Vishal L <vishal.l.verma@intel.com>
> Sent: Saturday, August 11, 2018 7:46 AM
> To: Williams, Dan J <dan.j.williams@intel.com>; ross.zwisler@linux.intel.com;
> oceanhehy@gmail.com; Jiang, Dave <dave.jiang@intel.com>; lenb@kernel.org;
> rjw@rjwysocki.net
> Cc: linux-kernel@vger.kernel.org; linux-nvdimm@lists.01.org; linux-
> acpi@vger.kernel.org; Ocean HY1 He <hehy1@lenovo.com>
> Subject: [External] Re: [PATCH v2] ACPI: nfit: remove redundant assignment if
> nfit_mem found
> 
> 
> On Thu, 2018-08-02 at 04:44 -0400, oceanhehy@gmail.com wrote:
> > From: Ocean He <hehy1@lenovo.com>
> >
> > When nfit_mem is found via list_for_each_entry, it has already been
> > assigned valid value. There is no need to assign it again in the
> > following
> > codes.
> >
> > Signed-off-by: Ocean He <hehy1@lenovo.com>
> > ---
> > v1: https://patchwork.kernel.org/patch/10553277/
> > v2: Sorry for noise. I got an email problem, so I have to resend to
> > loop
> > linux-nvdimm@lists.01.org.
> >
> >  drivers/acpi/nfit/core.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> > index 7c47900..85dde54 100644
> > --- a/drivers/acpi/nfit/core.c
> > +++ b/drivers/acpi/nfit/core.c
> > @@ -1048,9 +1048,7 @@ static int __nfit_mem_init(struct
> > acpi_nfit_desc *acpi_desc,
> >  				break;
> >  			}
> >
> > -		if (found)
> > -			nfit_mem = found;
> > -		else {
> > +		if (!found) {
> 
> Hi Ocean,
> 
> While this is technically correct, the old way was easier to read. We
> loop through and find the matching handle. If we found one, then
> nfit_mem was whatever was found. If not, we allocate it.
> 
> With this change, one has to go grok the list_for_.. loop to figure out
> where nfit_mem is coming from. I'd personally prefer to keep the
> existing way..
> 
Hi Verma,

You're right that it took me some time to find out where nfit_mem
was found, when I look these codes at first.

It's reasonable to keep the existing way for well readability.

Thanks,
Ocean.
> >  			nfit_mem = devm_kzalloc(acpi_desc->dev,
> >  					sizeof(*nfit_mem),
> > GFP_KERNEL);
> >  			if (!nfit_mem)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
