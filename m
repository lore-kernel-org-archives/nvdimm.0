Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22b.google.com (mail-yb0-x22b.google.com
 [IPv6:2607:f8b0:4002:c09::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D042321CF25AA
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 21:08:29 -0700 (PDT)
Received: by mail-yb0-x22b.google.com with SMTP id e201so15972557ybb.1
 for <linux-nvdimm@lists.01.org>; Fri, 07 Jul 2017 21:10:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170703135324.2F89.E1E9C6FF@jp.fujitsu.com>
References: <20170630101854.B36F.E1E9C6FF@jp.fujitsu.com>
 <1b5d08fa-620b-0233-2cc4-8648a631931e@hpe.com>
 <20170703135324.2F89.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Jul 2017 21:10:10 -0700
Message-ID: <CAPcyv4hB=Ku-qJR5iE9uMaT_bDHhuVZfPE8f8HjDuDYhWd+Xmw@mail.gmail.com>
Subject: Re: Standardization of ACPI NVDIMM DSMs
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 2, 2017 at 9:53 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
[..]
> 2) I suppose a notification daemon may be necessary to inform the over
>     threshold event  (to syslog, to other servers, or logging management OSS, etc....)
>
>     Please correct me, if ndctl has this feature already...

ndctl doesn't have a daemon yet, but libndctl is growing helper
library calls that would used for such a daemon one day.

ndctl_dimm_get_health_eventfd() is there today provides a file
descriptor for DIMM events, and I'll be adding similar eventfd calls
for the region and namespace level badblocks files so userspace is
notified of new media errors.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
