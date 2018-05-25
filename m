Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E020620965DC6
 for <linux-nvdimm@lists.01.org>; Thu, 24 May 2018 22:03:01 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 548D6AC0148
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 14:02:56 +0900 (JST)
Date: Fri, 25 May 2018 14:02:30 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Questions about vNVDIMM on qemu/KVM
In-Reply-To: <CAPcyv4h3RHymfKXxebBf+4DJs7vyJyhOVOuhDUJtchBnGOFrDw@mail.gmail.com>
References: <20180524161922.EC59.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4h3RHymfKXxebBf+4DJs7vyJyhOVOuhDUJtchBnGOFrDw@mail.gmail.com>
Message-Id: <20180525140226.04D7.E1E9C6FF@jp.fujitsu.com>
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
Cc: Qemu Developers <qemu-devel@nongnu.org>, NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


> >
> > But ,I would like understand one more thing.
> > In the following mail, it seems that e820 bus will be used for fake DAX.
> >
> > https://lists.01.org/pipermail/linux-nvdimm/2018-January/013926.html
> >
> > Could you tell me what is relationship between "fake DAX" in this mail
> > and Guest DAX?
> > Why e820 is necessary for this case?
> >
> 
> It was proposed as a starting template for writing a new nvdimm bus
> driver. All we need is a way to communicate both the address range and
> the flush interface. This could be done with a new SPA Range GUID with
> the NFIT, or a custom virtio-pci device that registers a special
> nvdimm region with this property. My preference is whichever approach
> minimizes the code duplication, because the pmem driver should be
> re-used as much as possible.

Ok, I see.
Thank you very much for your explanation.

Bye,
---
Yasunori Goto


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
