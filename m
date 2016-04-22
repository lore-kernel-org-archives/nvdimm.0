Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDDE81A201B
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 10:55:28 -0700 (PDT)
Date: Fri, 22 Apr 2016 11:55:26 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [RFC v9 4/5] nvdimm: Add concept of cmd mask
Message-ID: <20160422175526.GA126763@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4hgAqdUV8mB1mr-B1mcHTjTYLtdRdRLXYmZjWx=1f7YDg@mail.gmail.com>
 <20160421172825.GB115325@tevye.fc.hp.com>
 <CAPcyv4gt9_KbhYJb0RQ0_Pd8wx98HH6u0_Z+zy25f=wj5F8FHA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gt9_KbhYJb0RQ0_Pd8wx98HH6u0_Z+zy25f=wj5F8FHA@mail.gmail.com>
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

On Thu, Apr 21, 2016 at 11:25:37AM -0700, Dan Williams wrote:
> On Thu, Apr 21, 2016 at 10:28 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> > On Mon, Apr 18, 2016 at 08:03:14PM -0700, Dan Williams wrote:
> >> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> >
> > ...
> >
> >
> >> >  struct cmd_family_tbl nfit_cmd_family_tbl[] = {
> >> > -       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1},
> >> > -       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1},
> >> > -       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1},
> >> > +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1, 1},
> >> > +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1, 0},
> >> > +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1, 0},
> >>
> >> Lets replace does_ioctl with a mask of the valid function numbers see below...
> >>


I think that the masking of dsm_mask is in addition to, not in
replacement of what does_ioctl is doing in creating the cmd_mask.
cmd_mask for *_N_HPE1 should only be (1 << ND_CMD_CALL) at least
for now.


> >
> > Is this new mask to be used in the construction of cmd_mask or in a bit
> > and with dsm_mask?
> >
> 
> The latter, "and with dsm_mask".
> 


-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
