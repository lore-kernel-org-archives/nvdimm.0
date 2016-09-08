Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F27A1A1F1A
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 21:32:37 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id x125so324631oia.3
 for <linux-nvdimm@lists.01.org>; Wed, 07 Sep 2016 21:32:37 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Sep 2016 21:32:36 -0700
Message-ID: <CAPcyv4iDra+mRqEejfGqapKEAFZmUtUcg0dsJ8nt7mOhcT-Qpw@mail.gmail.com>
Subject: DAX mapping detection (was: Re: [PATCH] Fix region lost in
 /proc/self/smaps)
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
To: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, Michal Hocko <mhocko@suse.com>, KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Gleb Natapov <gleb@kernel.org>, mtosatti@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding linux-fsdevel and linux-nvdimm ]

On Wed, Sep 7, 2016 at 8:36 PM, Xiao Guangrong
<guangrong.xiao@linux.intel.com> wrote:
[..]
> However, it is not easy to handle the case that the new VMA overlays with
> the old VMA
> already got by userspace. I think we have some choices:
> 1: One way is completely skipping the new VMA region as current kernel code
> does but i
>    do not think this is good as the later VMAs will be dropped.
>
> 2: show the un-overlayed portion of new VMA. In your case, we just show the
> region
>    (0x2000 -> 0x3000), however, it can not work well if the VMA is a new
> created
>    region with different attributions.
>
> 3: completely show the new VMA as this patch does.
>
> Which one do you prefer?
>

I don't have a preference, but perhaps this breakage and uncertainty
is a good opportunity to propose a more reliable interface for NVML to
get the information it needs?

My understanding is that it is looking for the VM_MIXEDMAP flag which
is already ambiguous for determining if DAX is enabled even if this
dynamic listing issue is fixed.  XFS has arranged for DAX to be a
per-inode capability and has an XFS-specific inode flag.  We can make
that a common inode flag, but it seems we should have a way to
interrogate the mapping itself in the case where the inode is unknown
or unavailable.  I'm thinking extensions to mincore to have flags for
DAX and possibly whether the page is part of a pte, pmd, or pud
mapping.  Just floating that idea before starting to look into the
implementation, comments or other ideas welcome...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
