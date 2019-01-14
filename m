Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0433A21180F27
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:21:31 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3 4/4] ndctl: clean up usage of ndctl_cmd_submit
Date: Mon, 14 Jan 2019 18:21:28 +0000
Message-ID: <a5dbd65d944a2cf45e1ebbfbb4b2e898f3a86778.camel@intel.com>
References: <20190114181115.11983-1-vishal.l.verma@intel.com>
 <20190114181115.11983-5-vishal.l.verma@intel.com>
 <CAPcyv4j7R6_V4fkoOYavswCSZGXVLnAD=3E3gZy+RSedsuTgVA@mail.gmail.com>
In-Reply-To: <CAPcyv4j7R6_V4fkoOYavswCSZGXVLnAD=3E3gZy+RSedsuTgVA@mail.gmail.com>
Content-Language: en-US
Content-ID: <E98BC8F2C2A1544FBFCEB3472509E693@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-01-14 at 10:17 -0800, Dan Williams wrote:
> On Mon, Jan 14, 2019 at 10:11 AM Vishal Verma <
> vishal.l.verma@intel.com> wrote:
> > 
> > It is possible for ndctl_cmd_submit to return a positive number,
> > indicating a buffer underrun. It is only truly an error if it
> > returns a
> > negative number. Several places in the library, the ndctl utility,
> > and
> > in test/ were simply checking for an error with "if (rc)". Fix
> > these to
> > only error out for negative returns.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  ndctl/lib/dimm.c              |  6 +++---
> >  ndctl/lib/inject.c            |  8 ++++----
> >  ndctl/lib/nfit.c              |  2 +-
> >  ndctl/util/json-firmware.c    |  2 +-
> >  test/ack-shutdown-count-set.c |  8 ++------
> >  test/daxdev-errors.c          |  8 ++++----
> >  test/libndctl.c               | 32 ++++++++++++++++---------------
> > -
> >  test/smart-notify.c           |  8 ++++----
> >  8 files changed, 35 insertions(+), 39 deletions(-)
> > 
> > diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> > index 79e2ca0..12dc74a 100644
> > --- a/ndctl/lib/dimm.c
> > +++ b/ndctl/lib/dimm.c
> > @@ -332,7 +332,7 @@ static int nvdimm_set_config_data(struct
> > nvdimm_data *ndd, size_t offset,
> >                 goto out;
> > 
> >         rc = ndctl_cmd_submit(cmd_write);
> > -       if (rc || ndctl_cmd_get_firmware_status(cmd_write))
> > +       if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_write))
> 
> With ndctl_cmd_submit_xlat() the ndctl_cmd_get_firmware_status() can
> be dropped, right?
> 
>     rc = ndctl_cmd_submit_xlat(cmd_write);
>     if (rc < 0)
>         rc = -ENXIO;
> 
> 
> ...or are you saving that conversion for a follow on patch?

The config get/write commands are not dimm_ops right? I thought we
could only use _xlat for dimm_ops?


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
