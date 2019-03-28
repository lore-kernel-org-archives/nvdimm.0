Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71894211EABCE
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 07:16:34 -0700 (PDT)
Date: Thu, 28 Mar 2019 15:16:31 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
Message-ID: <20190328141631.GB7155@dhcp22.suse.cz>
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
 <20190325101945.GD9924@dhcp22.suse.cz>
 <CAPcyv4iJCgu-akJM_O8ZtscqWQt=CU-fvx-ViGYeau-NJufmSQ@mail.gmail.com>
 <20190326080408.GC28406@dhcp22.suse.cz>
 <CAPcyv4jUeUPwbfToWQtWX1AxfgFLNpBUhm8BvgJ2Hv1RbNPiog@mail.gmail.com>
 <20190327161306.GM11927@dhcp22.suse.cz>
 <9e769f3d-00f2-a8bb-2d8d-097735cb2a6d@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9e769f3d-00f2-a8bb-2d8d-097735cb2a6d@redhat.com>
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
To: David Hildenbrand <david@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 28-03-19 14:38:15, David Hildenbrand wrote:
> On 27.03.19 17:13, Michal Hocko wrote:
[...]
> > People are asking for a smaller memory hotplug granularity for other
> > usecases (e.g. memory ballooning into VMs) which are quite dubious to
> > be honest and not really worth all the code rework. If we are talking
> > about something that can be worked around elsewhere then it is preferred
> > because the code base is not in an excellent shape and putting more on
> > top is just going to cause more headaches.
> 
> At least for virtio-mem, it will be handled similar to xen-balloon and
> hyper-v balloon, where whole actions are added and some parts are kept
> "soft-offline". But there, one device "owns" the complete section, it
> does not overlap with other devices. One section only has one owner.

This is exactly what I meant by handing at a higher level.

-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
