Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C87A211B1113
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 18:03:39 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 2/4] ndctl, inject-smart: switch to
 ndctl_cmd_submit_xlat
Date: Sat, 12 Jan 2019 02:03:37 +0000
Message-ID: <a220a83ded81b6530234fb4ae6aec4e227c208d4.camel@intel.com>
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
 <20190112013035.32087-3-vishal.l.verma@intel.com>
 <CAPcyv4hTw1Q8kK2py1sySEYMBpGTYSfmHLzAHJ41c3p08BQDmw@mail.gmail.com>
In-Reply-To: <CAPcyv4hTw1Q8kK2py1sySEYMBpGTYSfmHLzAHJ41c3p08BQDmw@mail.gmail.com>
Content-Language: en-US
Content-ID: <96292F19FBEB894F8218F40C08BAB390@intel.com>
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
Cc: "Pathak, Ami G" <ami.g.pathak@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-01-11 at 17:58 -0800, Dan Williams wrote:
> On Fri, Jan 11, 2019 at 5:31 PM Vishal Verma <
> vishal.l.verma@intel.com> wrote:
> > 
> > The ndctl inject-smart command was neglecting to check the
> > 'firmware_status' field that is set by the platform firmware to
> > indicate
> > failure. Use the new ndctl_cmd_submit_xlat facility to include the
> > firmware_status check as part of the command submission.
> > 
> > Reported-by: Ami Pathak <ami.g.pathak@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> [..]
> > diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
> > index 3c1b917..92a9313 100644
> > --- a/ndctl/util/json-smart.c
> > +++ b/ndctl/util/json-smart.c
> > @@ -30,8 +30,8 @@ static void smart_threshold_to_json(struct
> > ndctl_dimm *dimm,
> >         if (!cmd)
> >                 return;
> > 
> > -       rc = ndctl_cmd_submit(cmd);
> > -       if (rc || ndctl_cmd_get_firmware_status(cmd))
> > +       rc = ndctl_cmd_submit_xlat(cmd);
> > +       if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd))
> >                 goto out;
> 
> Can't we just do:
> 
> rc = ndctl_cmd_submit_xlat(cmd);
> if (rc < 0)
>     goto out;
> 
> ...and drop the open coded ndctl_cmd_get_firmware_status()?
> 
> In general it seems like most users of
> ndctl_cmd_get_firmware_status()
> would be happy with ndctl_cmd_submit_xlat() instead.

Yes good catch - I'll see where else we can make this change and
respin. The users of ndctl_cmd_get_firmware_status that use ACPI DSMs
probably still stay since _xlat, at least for now, only handles
commands that are defined in dimm_ops.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
