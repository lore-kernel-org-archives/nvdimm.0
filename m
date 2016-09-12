Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22a.google.com (mail-it0-x22a.google.com
 [IPv6:2607:f8b0:4001:c0b::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F6031A1E0A
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 10:29:19 -0700 (PDT)
Received: by mail-it0-x22a.google.com with SMTP id o3so17941320ita.1
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 10:29:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160912133536.1bdb57a9@roar.ozlabs.ibm.com>
References: <147361509579.17004.5258725187329709824.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160912133536.1bdb57a9@roar.ozlabs.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Sep 2016 10:29:17 -0700
Message-ID: <CAPcyv4hS7i1DApKPDB5PkfBNZVbk321FgP94kUDjmuyGXDidZg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm, mincore2(): retrieve dax and tlb-size
 attributes of an address range
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
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-arch@vger.kernel.org, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-api@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Sep 11, 2016 at 8:35 PM, Nicholas Piggin <npiggin@gmail.com> wrote:
> On Sun, 11 Sep 2016 10:31:35 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> As evidenced by this bug report [1], userspace libraries are interested
>> in whether a mapping is DAX mapped, i.e. no intervening page cache.
>> Rather than using the ambiguous VM_MIXEDMAP flag in smaps, provide an
>> explicit "is dax" indication as a new flag in the page vector populated
>> by mincore.
>
> Can you cc linux-arch when adding new syscalls (or other such things that
> need arch enablement).
>
> I wonder if the changelog for a new syscall should have a bit more grandeur.
> Without seeing patch 2, you might not know this was a new syscall just by
> reading the subject and changelog.

Fair point, I'll beef up the documentation if this moves past an RFC.

> mincore() defines other bits to be reserved, but I guess it probably breaks
> things if you suddenly started using them.

The new bits are left as zero unless an application explicitly asks
for them, so an existing mincore() user shouldn't break.

> It's a bit sad to introduce a new syscall for this and immediately use up
> all bits that can be returned. Would it be a serious problem to return a
> larger mask per page?

Certainly one of the new request flags can indicate that the vector is
made up of larger entries.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
