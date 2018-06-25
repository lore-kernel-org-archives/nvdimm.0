Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 146AF20359E80
 for <linux-nvdimm@lists.01.org>; Sun, 24 Jun 2018 23:43:58 -0700 (PDT)
Received: from aks-ab2.gw.nic.fujitsu.com (aks-ab2.gw.nic.fujitsu.com
 [192.51.207.12])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 830E7AC0155
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 15:43:51 +0900 (JST)
Date: Mon, 25 Jun 2018 15:43:50 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: Bug on ndctl ? (failed to create namespace: No such device or
 address)
In-Reply-To: <CAPcyv4grkb8Gxn_7MjeyKvFgYsk58Nf9us82XgPfASvpt-QsdQ@mail.gmail.com>
References: <20180618134944.587E.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4grkb8Gxn_7MjeyKvFgYsk58Nf9us82XgPfASvpt-QsdQ@mail.gmail.com>
Message-Id: <20180625154346.3A35.E1E9C6FF@jp.fujitsu.com>
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

> >
> > This warning seems to be the following line.
> > ---
> > static int grow_dpa_allocation(struct nd_region *nd_region,
> >                 struct nd_label_id *label_id, resource_size_t n)
> > {
> >         struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
> >         bool is_pmem = strncmp(label_id->id, "pmem", 4) == 0;
> >         int i;
> >   :
> >   :
> >                 }
> >
> >                 dev_WARN_ONCE(&nd_region->dev, rem,                                <----!!!
> >                                 "allocation underrun: %#llx of %#llx bytes\n",     <----!!!
> >                                 (unsigned long long) n - rem,                      <----!!!
> >                                 (unsigned long long) n);                           <----!!!
> >
> 
> Yes, this appears to be a kernel bug from when
> multiple-namespaces-per-region support was added. The accounting of
> free space that ndctl relies on assumes that all free space is
> contiguous. This assumption was correct in the original
> implementation, but not since commit:
> 
>     a1f3e4d6a0c3 libnvdimm, region: update nd_region_available_dpa()
> for multi-pmem support
> 
> The fix has 3 parts:
> 
> 1/ The kernel needs to fail attempts to allocate discontiguous free space
> 
> 2/ The kernel needs a new sysfs attribute to export the maximum
> contiguous free space range
> 
> 3/ ndctl needs to be updated to pick the max contiguous size rather
> than the max free space


Agree. 

Unfortunately, I cound not use the real NVDIMM box which I found this bug now,
because the box is very busy, and the environment will be available
a few months later.

If other person can make the above fixes, it will be faster than me.

Anyone?


> 
> Alternatively we could teach the kernel to support discontiguous pmem
> namespaces, but we would need to check if the EFI namespace
> specification allows for such a configuration.
> 

I suppose this way is not good way probably.


Though I searched EFI specification 2.7a, 
it says just the followings about contiguous namespace,
and I couldn't find any other description.

 ---
 6.1 Block Translation Table (BTT) Background
 A namespace defines a contiguously-addressed range of Non-Volatile Memory
 conceptually similar to a SCSI Logical Unit (LUN) or a NVM Express
 namespace.
 ---

I also searched "NVDIMM Namespace Specification"
https://pmem.io/documents/NVDIMM_Namespace_Spec.pdf

It say the followings
 ---
 2.6 I/O on Namespaces
 A Persistent Memory namespace, by definition, is a contiguous range
 of System Physical Address space."
 ---

So, I could not think that speficications allows discontigous
pmem namespace.

Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
