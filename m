Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E56F32116489F
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 16:59:06 -0700 (PDT)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/2] powerpc/pseries: Add driver for PAPR SCM regions
In-Reply-To: <20181010060812.20068-3-oohall@gmail.com>
References: <20181010060812.20068-1-oohall@gmail.com>
 <20181010060812.20068-3-oohall@gmail.com>
Date: Thu, 11 Oct 2018 10:59:01 +1100
Message-ID: <87ftxd2w1m.fsf@concordia.ellerman.id.au>
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
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: nfont@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Oliver O'Halloran <oohall@gmail.com> writes:

> Adds a driver that implements support for enabling and accessing PAPR
> SCM regions. Unfortunately due to how the PAPR interface works we can't
> use the existing of_pmem driver (yet) because:
>
>  a) The guest is required to use the H_SCM_BIND_MEM h-call to add
>     add the SCM region to it's physical address space, and
>  b) There is currently no mechanism for relating a bare of_pmem region
>     to the backing DIMM (or not-a-DIMM for our case).
>
> Both of these are easily handled by rolling the functionality into a
> seperate driver so here we are...
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> The alternative implementation here is that we have the pseries code
> do the h-calls and craft a pmem-region@<addr> node based on that.
> However, that doesn't solve b) and mpe has expressed his dislike of
> adding new stuff to the DT at runtime so i'd say that's a non-starter.

Hmm, from memory you yelled something at me across the office about
that, so my response may not have been entirely well considered.

I'm not quite sure what the state of the OF overlays support is, but
that would be The Right Way to do that sort of modification to the
device tree at runtime.

If we merged this and then later got the of_pmem driver to work for us
would there be any user-visible change?

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
