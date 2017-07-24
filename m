Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAC0021B06E91
 for <linux-nvdimm@lists.01.org>; Sun, 23 Jul 2017 22:49:43 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2D40AAC008E
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 14:51:34 +0900 (JST)
Date: Mon, 24 Jul 2017 14:50:44 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Daemon of NVDIMM event notification/monitoring(Re: Standardization of
 ACPI NVDIMM DSMs)
In-Reply-To: <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi,

> >   Another approach could be to integrate NVDIMM event
> > monitoring into some other utility, like the rasdaemon.  I'm interested in
> > your thoughts.
> 
> Though I'm not sure which (existing or new) utility is appropriate yet.
> I prefer this way. So, I'll think about it.

I investigated the issue that notification/monitoring feature of over-
threshold event with my co-worker. Here is current our understandings.


a) rasdaemon
  It is good tools for machine check error, and if machine check occurs on
  NVDIMM, I suppose it will work not only traditional RAM but also NVDIMM.
  But, it may not fit the purpose of notification/monitoring threshold event.


b) smartmontools (https://www.smartmontools.org/)
  This tool may fit the purpose of notification/monitoring of health of NVDIMMs.
  However, it may a bit troublesome due to the followings.

    - The smartd seems to check smart values of each devices with
      ioctl() periodically (In other words, "polling"). 
      Probably, other devices does not have the
      notification interface like "ndctl_dimm_get_health_eventfd()
      and poll()/select()".
      
    - smartmontools supports many OSs (Windows, darwin, xxxBSDs, os2(!)).
      I'm not sure other OSs have similar notification interface like Linux.
      So, it may need to "polling" like other devices.

c) udev
   Udev can kick any programs if udev.rules is created.
   However, there is no uevent for the event of over-threshold currently.
   In addition, I'm not sure that udev fits this type of event notification.


d) make a new tiny daemon in ndctl tree
   This may be simpler way. 
   It can use ndctl_dimm_get_health_eventfd() and poll()/select().
    
   But, ndctl may be included in kernel source,
   and I don't know whether kernel includes other daemon tools or not.


Though I feel like selecting d) now.....
Any thoughts? 


Thanks,
---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
