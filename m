Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22f.google.com (mail-io0-x22f.google.com
 [IPv6:2607:f8b0:4001:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5890621A0480F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 07:56:38 -0700 (PDT)
Received: by mail-io0-x22f.google.com with SMTP id o22so24679368iod.3
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 07:56:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jGvy8b8KUb1Pg+h+5c6FVH2H7fbF3hM8wXp8Z=SUYtBw@mail.gmail.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
 <CAPcyv4jGvy8b8KUb1Pg+h+5c6FVH2H7fbF3hM8wXp8Z=SUYtBw@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 19 Apr 2017 07:56:36 -0700
Message-ID: <CAJcbSZH5BrK_ip8DxQd5vxrtckcbZ8vaQhf5h9qsQ+tzakhvKw@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 19, 2017 at 7:34 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Does the randomization ever cross a pgd boundary?

Yes, it can cross a pgd boundary. The original physical memory mapping
might as well but you would need almost 550Gb of memory.

>
> These crashes look very similar to the crashes caused by
> arch_add_memory() racing itself. This issue was fixed in:
>
>     f931ab479dd2 mm: fix devm_memremap_pages crash, use
> mem_hotplug_{begin, done}
>
> ...but that only helps users that call mem_hotplug_begin() to prevent
> concurrent updates.
>

It could be related to page table changes done concurrently or just
done with certain expectations.


-- 
Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
