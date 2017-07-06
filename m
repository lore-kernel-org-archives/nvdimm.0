Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD650209455F4
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 21:11:35 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 76A84AC00E3
 for <linux-nvdimm@lists.01.org>;
 Thu,  6 Jul 2017 13:13:10 +0900 (JST)
Date: Thu, 06 Jul 2017 13:13:04 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC/PATCH] ndctl list should show more hardware information
In-Reply-To: <CAPcyv4hKFLE3FTnPXCvMRhaM_H05x_4d33V0Z6uZy9AJXQRsZw@mail.gmail.com>
References: <595D2B03.6010408@hpe.com>
 <CAPcyv4hKFLE3FTnPXCvMRhaM_H05x_4d33V0Z6uZy9AJXQRsZw@mail.gmail.com>
Message-Id: <20170706131301.4A07.E1E9C6FF@jp.fujitsu.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> >>>    This is the first trial patch. So any comments are welcome.
> >>
> >> This looks ok to me. The only change I would request is to not assume
> >> that all NVDIMMs have this NFIT-specific data available.
> >>
> >>>
> >>> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> >>> ---
> >>> diff --git a/util/json.c b/util/json.c
> >>> index b718d74..749a358 100644
> >>> --- a/util/json.c
> >>> +++ b/util/json.c
> >>> @@ -68,6 +68,9 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
> >>>  {
> >>>         struct json_object *jdimm = json_object_new_object();
> >>>         const char *id = ndctl_dimm_get_unique_id(dimm);
> >>> +       unsigned int handle = ndctl_dimm_get_handle(dimm);
> >>> +       short phys_id = ndctl_dimm_get_phys_id(dimm);
> >
> > Should phys_id be an unsigned short?
> 
> Yes, "NVDIMM Physical ID" is defined as a 16-bit field in the NFIT.

Ah, OK. I'll fix it.


> 
> >
> >>> +       char buf[11];
> >>>         struct json_object *jobj;
> >>>
> >>>         if (!jdimm)
> >>> @@ -85,6 +88,18 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
> >>>                 json_object_object_add(jdimm, "id", jobj);
> >>>         }
> >>>
> >>> +       snprintf(buf, 11, "0x%08x", handle);
> >>> +       jobj = json_object_new_string(buf);
> >>> +       if (!jobj)
> >>> +               goto err;
> >>> +       json_object_object_add(jdimm, "handle", jobj);
> >>
> >> For example, this should be in a "if (handle < UINIT_MAX)" branch...
> >
> > Is that check actually necessary when handle is an unsigned int?  Is there any illegal value?
> 
> Yes, if the DIMM is not defined by NFIT then we initialize the value
> to -1 since only ACPI defined DIMMs have handles. I think UINT_MAX is
> a safe value for an invalid handle. Otherwise, if you parse out
> UINT_MAX as a valid handle, that indicates the last DIMM on 4096 node
> system. If such a system is possible we can also use
> ndctl_bus_has_nfit() to gate whether the NFIT-specific properties of a
> DIMM are available.

Ok. 

> >>> +       snprintf(buf, 7, "0x%04x", phys_id );
> >>> +       jobj = json_object_new_string(buf);
> >>> +       if (!jobj)
> >>> +               goto err;
> >>> +       json_object_object_add(jdimm, "phys_id", jobj);
> >>> +
> >>
> >> ..., and this should be in a "if (phys < USHORT_MAX)" branch.
> >
> > Same question here.  What's an illegal value?
> 
> I think it is safe to assume that USHORT_MAX is invalid, but we can
> again use the ndctl_bus_has_nfit() if this might be a problem on some
> platform.

Ok.

> 
> >> Lastly, I think these should be json_object_new_int() types since they
> >> are numbers not strings.
> >
> > Is it possible to get hex values if they're numbers?  For the device handle, hex is
> > helpful.
> 
> Yes, that would be great. Last I checked the "json-c" library that
> ndctl is using did not support this, but I don't think anything
> prevents json-c from growing this support. I.e. as far as I know it
> supports hex numbers for input, so I think it is valid json either
> way.

Sorry, maybe I could not follow here. Please let me confirm.
In conclusion, json_object_new_int() should be used at here?

Since I tried to output hex values for user to compare with dmidecode's output easily,
I translated to hex strings at here. 
But, I should json_object_new_int() in conclusion, and should expect that json-c
library will be able to output hex value in future?

Bye,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
