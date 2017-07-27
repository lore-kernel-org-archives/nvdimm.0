Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D51C821D491BA
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 18:51:03 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7BFFDAC00B8
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 10:52:57 +0900 (JST)
Date: Thu, 27 Jul 2017 10:52:36 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Daemon of NVDIMM event notification/monitoring(Re:
 Standardization of ACPI NVDIMM DSMs)
In-Reply-To: <CAPcyv4gwPA=bOC-3hyp6rGYgwqauAEgd7JY2uHdhnrbs4vW3rw@mail.gmail.com>
References: <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
 <CAPcyv4gwPA=bOC-3hyp6rGYgwqauAEgd7JY2uHdhnrbs4vW3rw@mail.gmail.com>
Message-Id: <20170727105231.091A.E1E9C6FF@jp.fujitsu.com>
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

> On Mon, Jul 24, 2017 at 9:11 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Sun, Jul 23, 2017 at 10:50 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> [..]
> >> d) make a new tiny daemon in ndctl tree
> >>    This may be simpler way.
> >>    It can use ndctl_dimm_get_health_eventfd() and poll()/select().
> >>
> >>    But, ndctl may be included in kernel source,
> >>    and I don't know whether kernel includes other daemon tools or not.
> >
> > The kernel does include a few daemons in the tools/ directory, so I
> > don't see this being a problem. Now, that said, Linus still has the
> > prerogative to not pull ndctl into the kernel for 4.14, but at this
> > point I feel more likely than not that the next version of ndctl will
> > be v4.14-rc1 instead of v58.
> 
> An update here... upstream would like to see ndctl move away from
> autotools before it is integrated into the kernel tree, so ndctl v58
> will be the next release from github. The 4.15 kernel is our next
> potential intercept.
> 

Year. Thanks for your notification.
I already asked my young co-worker to make a tiny daemon in ndctl.

Thanks,
----
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
