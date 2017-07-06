Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1AA221CB57B3
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 22:47:09 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 79E94AC017F
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 14:48:38 +0900 (JST)
Date: Thu, 06 Jul 2017 14:48:33 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC/PATCH] ndctl list should show more hardware information
In-Reply-To: <CAPcyv4gNnuUugTotxtiHmv49MtVbmRD3V2nrHYf+S-egE9R1dQ@mail.gmail.com>
References: <20170706131301.4A07.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4gNnuUugTotxtiHmv49MtVbmRD3V2nrHYf+S-egE9R1dQ@mail.gmail.com>
Message-Id: <20170706144830.4A0D.E1E9C6FF@jp.fujitsu.com>
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

> On Wed, Jul 5, 2017 at 9:13 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> [..]
> >> Yes, that would be great. Last I checked the "json-c" library that
> >> ndctl is using did not support this, but I don't think anything
> >> prevents json-c from growing this support. I.e. as far as I know it
> >> supports hex numbers for input, so I think it is valid json either
> >> way.
> >
> > Sorry, maybe I could not follow here. Please let me confirm.
> > In conclusion, json_object_new_int() should be used at here?
> >
> 
> Yes.
> 
> > Since I tried to output hex values for user to compare with dmidecode's output easily,
> > I translated to hex strings at here.
> > But, I should json_object_new_int() in conclusion, and should expect that json-c
> > library will be able to output hex value in future?
> 
> I checked, it seems hex output is not valid json. However, I think
> what I will do is add a "--hex" option to "ndctl list" that will make
> util_display_json_array() manually print the json output object and
> convert all integers to hex in the process. While that option will
> make the output not machine readable by standards compliant json
> parsers it will make it easier for humans to read in some cases.

Ok! I understood!
Thank you for your comments.

Bye,


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
