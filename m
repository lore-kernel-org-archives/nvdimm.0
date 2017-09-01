Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6E7220958BC2
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:37:25 -0700 (PDT)
Received: by mail-io0-x242.google.com with SMTP id m40so1496533ioi.5
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 18:40:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFwsfUj1f41w8hqt9LN3-ajmJ=2AB1Nb6ZzwHgE1OKxGOw@mail.gmail.com>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170831100359.GD21443@lst.de>
 <CAPcyv4jvTB4Aiei1-fGybyJNopXQy9zADpnFcuRNdZCS4Mf1QQ@mail.gmail.com>
 <CA+55aFwsfUj1f41w8hqt9LN3-ajmJ=2AB1Nb6ZzwHgE1OKxGOw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 31 Aug 2017 18:40:08 -0700
Message-ID: <CAA9_cmdn3BVjkMTLhcdPqaNcnuPHLjmrG9k4vmpb7bSM8SxpJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 6:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 31, 2017 at 6:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Ugh, nommu defeats the MAP_SHARED_VALIDATE proposal from Linus.
>>
>>         if ((flags & MAP_TYPE) != MAP_PRIVATE &&
>>             (flags & MAP_TYPE) != MAP_SHARED)
>>                 return -EINVAL;
>>
>> ...parisc strikes again.
>
> Why? That's no different from the case statement for the mmu case,
> just written differently.
>
> You *want* existing kernels to fail, since they don't test the bits
> you want to test.
>
> So you just want to rewrite these all as
>
>     switch (flags & MAP_TYPE) {
>     case MAP_SHARED_VALIDATE:
>         .. validate the other bits...
>         /* fallhtough */
>     case MAP_SHARED:
>         .. do the shared case ..
>     case MAP_PRIVATE:
>         .. do the private case ..
>     default:
>         return -EINVAL;
>     }
>
> and you're all good.
>
> I'm not seeing the problem.

Right, I went cross-eyed for a second. There is no problem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
