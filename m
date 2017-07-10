Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CC8D2095D2C4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 01:15:20 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 4B231AC012D
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 17:16:55 +0900 (JST)
Date: Mon, 10 Jul 2017 17:16:51 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Standardization of ACPI NVDIMM DSMs
In-Reply-To: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
References: <20170703135324.2F89.E1E9C6FF@jp.fujitsu.com>
 <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
Message-Id: <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


> > 2) I suppose a notification daemon may be necessary to inform the over
> >     threshold event  (to syslog, to other servers, or logging management OSS, etc....)
> >
> >     Please correct me, if ndctl has this feature already...
> 
> That feature doesn't exist in ndctl.  Intel has developed some tools that are
> mostly specific to their NVDIMMs and those tools include a monitoring daemon as
> well as a CLI.
> https://github.com/01org/ixpdimm_sw

Though I tried to compile this tools, I could not comple it, and 
I gave up to solve too many dependency... 

> 
> One approach could be to contribute changes to make those tools more useful for non-Intel NVDIMMs.

Hmmm, ixpdimm_sw seems to be too large software.
In my first impression, I don't think this is good way..... :(

>   Another approach could be to integrate NVDIMM event
> monitoring into some other utility, like the rasdaemon.  I'm interested in
> your thoughts.

Though I'm not sure which (existing or new) utility is appropriate yet.
I prefer this way. So, I'll think about it.

> 
> >> If you're thinking of defining something new, I encourage you to get
> >> involved in the standards activities.
> >
> > If my idea is useful like the aboves, the standard activity looks quite interesting
> > for me. Please tell me how to join it.
> 
> If your company is part of the UEFI Forum then I think you can participate in
> the ACPI working group.  There is a sub-team focused on standardizing NVDIMM
> FW/SW interfaces.  My suggestion is that you find the person in your company
> who can hook you up with the right group.

Ok, I'll try to find the contact person in my company.

> 
> You'll also see conversation/debate about what ought to be a standard
> on this mailing list so input here is welcome too.

I see.
Thank you for your information.

Bye,
---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
