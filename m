Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3A412095D2C4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 01:50:05 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1C601AC0108
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 17:51:45 +0900 (JST)
Date: Mon, 10 Jul 2017 17:51:41 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Standardization of ACPI NVDIMM DSMs
In-Reply-To: <CAPcyv4hB=Ku-qJR5iE9uMaT_bDHhuVZfPE8f8HjDuDYhWd+Xmw@mail.gmail.com>
References: <20170703135324.2F89.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4hB=Ku-qJR5iE9uMaT_bDHhuVZfPE8f8HjDuDYhWd+Xmw@mail.gmail.com>
Message-Id: <20170710175139.7321.E1E9C6FF@jp.fujitsu.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> On Sun, Jul 2, 2017 at 9:53 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> [..]
> > 2) I suppose a notification daemon may be necessary to inform the over
> >     threshold event  (to syslog, to other servers, or logging management OSS, etc....)
> >
> >     Please correct me, if ndctl has this feature already...
> 
> ndctl doesn't have a daemon yet, but libndctl is growing helper
> library calls that would used for such a daemon one day.
> 
> ndctl_dimm_get_health_eventfd() is there today provides a file
> descriptor for DIMM events, and I'll be adding similar eventfd calls
> for the region and namespace level badblocks files so userspace is
> notified of new media errors.

I see. I'll check it when it is implemented.

Thanks,
---
Yasunori Goto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
