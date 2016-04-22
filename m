Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22d.google.com (mail-ob0-x22d.google.com
 [IPv6:2607:f8b0:4003:c01::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9F9C1A1E80
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 11:16:39 -0700 (PDT)
Received: by mail-ob0-x22d.google.com with SMTP id j9so52895631obd.3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 11:16:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160422175526.GA126763@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <f94e58ce44103ee3990e611ddb4e63269e278de3.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4hgAqdUV8mB1mr-B1mcHTjTYLtdRdRLXYmZjWx=1f7YDg@mail.gmail.com>
 <20160421172825.GB115325@tevye.fc.hp.com>
 <CAPcyv4gt9_KbhYJb0RQ0_Pd8wx98HH6u0_Z+zy25f=wj5F8FHA@mail.gmail.com>
 <20160422175526.GA126763@tevye.fc.hp.com>
Date: Fri, 22 Apr 2016 11:16:38 -0700
Message-ID: <CAPcyv4juap_2N_AZhVdCYwU4TbWoqkJo_DjM-r3x58ekhqvNig@mail.gmail.com>
Subject: Re: [RFC v9 4/5] nvdimm: Add concept of cmd mask
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 22, 2016 at 10:55 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Thu, Apr 21, 2016 at 11:25:37AM -0700, Dan Williams wrote:
>> On Thu, Apr 21, 2016 at 10:28 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > On Mon, Apr 18, 2016 at 08:03:14PM -0700, Dan Williams wrote:
>> >> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >
>> > ...
>> >
>> >
>> >> >  struct cmd_family_tbl nfit_cmd_family_tbl[] = {
>> >> > -       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1},
>> >> > -       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1},
>> >> > -       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1},
>> >> > +       { NFIT_DEV_DIMM,        ND_TYPE_DIMM_INTEL1,    1, 1},
>> >> > +       { NFIT_DEV_DIMM_N_HPE1, ND_TYPE_DIMM_N_HPE1,    1, 0},
>> >> > +       { NFIT_DEV_DIMM_N_HPE2, ND_TYPE_DIMM_N_HPE2,    1, 0},
>> >>
>> >> Lets replace does_ioctl with a mask of the valid function numbers see below...
>> >>
>
>
> I think that the masking of dsm_mask is in addition to, not in
> replacement of what does_ioctl is doing in creating the cmd_mask.
> cmd_mask for *_N_HPE1 should only be (1 << ND_CMD_CALL) at least
> for now.
>

Sorry, I'm still not seeing the need for 'does_ioctl'.  If anything
down the road we might end up with a translation *routine*, per-family
or otherwise, to translate from ND_CMD to DSM.  For now just set the
cmd_mask to (1 << ND_CMD_CALL) for all families and 'or' in the other
commands explicitly for the Intel family in acpi_nfit_add_dimm().  In
other words, just code this into the acpi_nfit_add_dimm() directly
rather than having a flag in a table, I'm not seeing it's utility.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
