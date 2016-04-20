Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91C7B1A20B2
 for <linux-nvdimm@lists.01.org>; Wed, 20 Apr 2016 10:41:07 -0700 (PDT)
Date: Wed, 20 Apr 2016 11:41:05 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
Message-ID: <20160420174105.GC29474@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 19, 2016 at 10:45:48AM -0700, Dan Williams wrote:
> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > The pass thru calls return command mask.  Previously, bit zero
> > wasn't part of command mask, but as it is now, this left commands_show
> > displaying "unknown" for function zero.  Add an ioctl interface
> > to return command mask.
> >
> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
> > ---
> >  drivers/nvdimm/bus.c       | 10 ++++++++--
> >  include/uapi/linux/ndctl.h |  9 +++++++++
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> Let's not add yet another ioctl for this...  just add a 'dsm_mask'
> attribute to the nfit_mem device in acpi_nfit_dimm_attributes.

I don't understand this comment.

I can change just 
        static const char * const names[] = {
+               [ND_CMD_IMPLEMENTED] = "cmd_mask",
                [ND_CMD_ARS_CAP] = "ars_cap",
                [ND_CMD_ARS_START] = "ars_start",
                [ND_CMD_ARS_STATUS] = "ars_status",
@@ -150,6 +155,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
 static inline const char *nvdimm_cmd_name(unsigned cmd)
 {
        static const char * const names[] = {
+               [ND_CMD_IMPLEMENTED] = "cmd_mask",

And have same effect w/o adding the full ioctl support.

But I don't see how modifying acpi_nfit_dimm_attributes affects what
commands show will display.

Are you asking me to also add a new attribute to sysfs to display the
command mask?


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
