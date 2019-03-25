Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 056FD21B02822
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 07:50:25 -0700 (PDT)
Date: Mon, 25 Mar 2019 15:50:23 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 00/10] mm: Sub-section memory hotplug support
Message-ID: <20190325145023.GG9924@dhcp22.suse.cz>
References: <155327387405.225273.9325594075351253804.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190322180532.GM32418@dhcp22.suse.cz>
 <CAPcyv4gBGNP95APYaBcsocEa50tQj9b5h__83vgngjq3ouGX_Q@mail.gmail.com>
 <20190325101945.GD9924@dhcp22.suse.cz>
 <x494l7rdo5r.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x494l7rdo5r.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 25-03-19 10:28:00, Jeff Moyer wrote:
> Michal Hocko <mhocko@kernel.org> writes:
> 
> >> > and I would like to know that you are
> >> > not just shifting the problem to a smaller unit and a new/creative HW
> >> > will force us to go even more complicated.
> >> 
> >> HW will not do this to us. It's software that has the problem.
> >> Namespace creation is unnecessarily constrained to 128MB alignment.
> >
> > And why is that a problem? A lack of documentation that this is a
> > requirement? Something will not work with a larger alignment? Someting
> > else?
> 
> See this email for one user-visible problem:
>   https://lore.kernel.org/lkml/x49imxbx22d.fsf@segfault.boston.devel.redhat.com/

: # ndctl create-namespace -m fsdax -s 128m
:   Error: '--size=' must align to interleave-width: 6 and alignment: 2097152
:   did you intend --size=132M?
: 
: failed to create namespace: Invalid argument

So the size is in section size units. So what prevents the userspace to
use a proper alignment? I am sorry if this is a stupid question but I am
not really familiar with ndctl nor the pmem side of it.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
