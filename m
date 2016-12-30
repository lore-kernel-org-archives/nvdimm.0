Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75B3D81943
 for <linux-nvdimm@lists.01.org>; Thu, 29 Dec 2016 19:53:03 -0800 (PST)
Date: Fri, 30 Dec 2016 03:52:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 1/3] introduce memcpy_nocache()
Message-ID: <20161230035252.GV1555@ZenIV.linux.org.uk>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com>
 <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 29, 2016 at 10:23:15AM -0800, Dan Williams wrote:

> > BTW, your "it's iovec, only non-temporal stores there" logics in
> > arch_copy_from_iter_pmem() is simply wrong - for one thing, unaligned
> > copies will have parts done via normal stores, for another 32bit will
> > _not_ go for non-caching codepath for short copies.  What semantics do
> > we really need there?
> 
> For typical pmem platforms we need to make sure all the writes are on
> the way to memory such than a later sfence can guarantee that all
> previous writes are visible to the platform "ADR" logic.  ADR handles
> flushing memory controller write buffers to media. At a minimum
> arch_copy_from_iter_pmem() needs to trigger a clwb (unordered cache
> line writeback) of each touched cache line if it is not using a cache
> bypassing store.

Um...  Then we do have a problem - nocache variant of uaccess primitives
does *not* guarantee that clwb is redundant.

What about the requirements of e.g. tcp_sendmsg() with its use of
skb_add_data_nocache()?  What warranties do we need there?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
