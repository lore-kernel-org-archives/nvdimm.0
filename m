Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF186225264B0
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 23:45:23 -0700 (PDT)
Received: by mail-pl0-x242.google.com with SMTP id x4-v6so17821071pln.7
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 23:45:23 -0700 (PDT)
Date: Thu, 5 Apr 2018 16:45:08 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RESEND 2/3] powerpc/memcpy: Add memcpy_mcsafe for pmem
Message-ID: <20180405164508.7a15a770@roar.ozlabs.ibm.com>
In-Reply-To: <20180405155307.49f748f3@gmail.com>
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-3-bsingharora@gmail.com>
 <20180405095755.58b3891f@roar.ozlabs.ibm.com>
 <CAPcyv4hqKsOy9GU=NcMGj38pXnuEMRhXfox6jVwQ37+mcjnvhA@mail.gmail.com>
 <20180405150405.5b902b41@roar.ozlabs.ibm.com>
 <20180405155307.49f748f3@gmail.com>
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
To: Balbir Singh <bsingharora@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 5 Apr 2018 15:53:07 +1000
Balbir Singh <bsingharora@gmail.com> wrote:

> On Thu, 5 Apr 2018 15:04:05 +1000
> Nicholas Piggin <npiggin@gmail.com> wrote:
> 
> > On Wed, 4 Apr 2018 20:00:52 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >   
> > > [ adding Matthew, Christoph, and Tony  ]
> > > 
> > > On Wed, Apr 4, 2018 at 4:57 PM, Nicholas Piggin <npiggin@gmail.com> wrote:    
> > > > On Thu,  5 Apr 2018 09:19:42 +1000
> > > > Balbir Singh <bsingharora@gmail.com> wrote:
> > > >      
> > > >> The pmem infrastructure uses memcpy_mcsafe in the pmem
> > > >> layer so as to convert machine check excpetions into
> > > >> a return value on failure in case a machine check
> > > >> exception is encoutered during the memcpy.
> > > >>
> > > >> This patch largely borrows from the copyuser_power7
> > > >> logic and does not add the VMX optimizations, largely
> > > >> to keep the patch simple. If needed those optimizations
> > > >> can be folded in.      
> > > >
> > > > So memcpy_mcsafe doesn't return number of bytes copied?
> > > > Huh, well that makes it simple.      
> > > 
> > > Well, not in current kernels, but we need to add that support or
> > > remove the direct call to copy_to_iter() in fs/dax.c. I'm looking
> > > right now to add "bytes remaining" support to the x86 memcpy_mcsafe(),
> > > but for copy_to_user we also need to handle bytes remaining for write
> > > faults. That fix is hopefully something that can land in an early
> > > 4.17-rc, but it won't be ready for -rc1.    
> > 
> > I wonder if the powerpc implementation should just go straight to
> > counting bytes. Backporting to this interface would be trivial, but
> > it would just mean there's only one variant of the code to support.
> > That's up to Balbir though.
> >   
> 
> I'm thinking about it, I wonder what "bytes remaining" mean in pmem context
> in the context of a machine check exception. Also, do we want to be byte
> accurate or cache-line accurate for the bytes remaining? The former is much
> easier than the latter :)

The ideal would be a linear measure of how much of your copy reached
(or can reach) non-volatile storage with nothing further copied. You
may have to allow for some relaxing of the semantics depending on
what the architecture can support.

What's the problem with just counting bytes copied like usercopy --
why is that harder than cacheline accuracy?

> I'd rather implement the existing interface and port/support the new interface
> as it becomes available

Fair enough.

Thanks,
Nick
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
