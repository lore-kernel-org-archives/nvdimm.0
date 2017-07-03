Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41DA021CAD9A7
 for <linux-nvdimm@lists.01.org>; Sun,  2 Jul 2017 21:52:01 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8472CAC0094
 for <linux-nvdimm@lists.01.org>; Mon,  3 Jul 2017 13:53:31 +0900 (JST)
Date: Mon, 03 Jul 2017 13:53:27 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Standardization of ACPI NVDIMM DSMs
In-Reply-To: <1b5d08fa-620b-0233-2cc4-8648a631931e@hpe.com>
References: <20170630101854.B36F.E1E9C6FF@jp.fujitsu.com>
 <1b5d08fa-620b-0233-2cc4-8648a631931e@hpe.com>
Message-Id: <20170703135324.2F89.E1E9C6FF@jp.fujitsu.com>
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


> On 6/29/2017 9:18 PM, Yasunori Goto wrote:
> > Hello, Linda-san,
> >
> >> There is more standardization that will likely happen.  The most
> >> interesting is probably standard health status information.  Today
> >> the Linux ndctl command can display health status for the NVDIMMs
> >> and it hides some of the differences by calling the appropriate
> >> DSM for the platform/NVDIMM combination but we need to do more
> >> work there.
> >
> > Could you tell me what works are necessary?
> 
> There is work in two areas.  One is standardization work, mostly
> likely through the ACPI NVM working group of the UEFI Forum, to define
> some common functions for health information.  There was a lot of work
> focused on getting standardization of label formats and access
> methods into ACPI 6.2 and UEFI 2.7 so not much effort yet on
> health information but perhaps that will be next.
> 
> The other area is work within the ndctl tool itself.  It already
> knows how to get some health information using the Intel, HPE, and
> MSFT SMART health DSMs but there is more information related to
> NVDIMM-N devices that we'd like to expose.
> 
> > I also have concern around here, and I'm investgating source code of
> > ndctl and NVDIMM drivers to check what works are still needed.
> > So, your opinion will be very helpful for me.
> 
> As an example, this is a patch I posted to expose more information.
> https://lists.01.org/pipermail/linux-nvdimm/2017-June/010682.html
> Dan had some feedback but I haven't had a chance to post a v2 patch yet.
> The patch touches a number of files/functions that are involved in getting
> the health information so you could look at those to see how it works today.

Thank you for your explanation. 

> 
> If there is a particular type of NVDIMM or existing DSM specification
> that you're interesting in supporting, that would be interesting to know.

Currently,  I feel the following things about _DSM and ndctl from user's point of view.

1) Though current _DSM has only the feature to get each threshold values, 
    I suppose that users may want to change each threshold values according to
     their own policy. So, maybe _DSM need to have "set threshold" interface.

2) I suppose a notification daemon may be necessary to inform the over
    threshold event  (to syslog, to other servers, or logging management OSS, etc....)

    Please correct me, if ndctl has this feature already...

> If you're thinking of defining something new, I encourage you to get
> involved in the standards activities.

If my idea is useful like the aboves, the standard activity looks quite interesting 
for me. Please tell me how to join it.

Thanks,
---
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
