Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 359C9211CD620
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 09:21:44 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 7/7] libnvdimm/pfn: Fix 'start_pad' implementation
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155000671719.348031.2347363160141119237.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49ftsgsnzp.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4h9s1jYROGqkMfKk0MNBUedP=vQ1nJObLRwFiTB405nOg@mail.gmail.com>
 <x49imxbx22d.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jweuVTm6D2OTaAMGvUXfxqZMDPfaASJ=QL9=8SdGUZqg@mail.gmail.com>
Date: Fri, 22 Feb 2019 12:21:41 -0500
In-Reply-To: <CAPcyv4jweuVTm6D2OTaAMGvUXfxqZMDPfaASJ=QL9=8SdGUZqg@mail.gmail.com>
 (Dan Williams's message of "Fri, 22 Feb 2019 09:12:37 -0800")
Message-ID: <x49a7inwxga.fsf@segfault.boston.devel.redhat.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

>> Great!  Now let's create another one.
>>
>> # ndctl create-namespace -m fsdax -s 132m
>> libndctl: ndctl_pfn_enable: pfn1.1: failed to enable
>>   Error: namespace1.2: failed to enable
>>
>> failed to create namespace: No such device or address
>>
>> (along with a kernel warning spew)
>
> I assume you're seeing this on the libnvdimm-pending branch?

Yes, but also on linus' master branch.  Things have been operating in
this manner for some time.

>> I understand the desire for expediency.  At some point, though, we have
>> to address the root of the problem.
>
> Well, you've defibrillated me back to reality. We've suffered the
> incomplete broken hacks for 2 years, what's another 10 weeks? I'll
> dust off the sub-section patches and take another run at it.

OK, thanks.  Let me know if I can help at all.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
