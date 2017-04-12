Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01A9A21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 17:18:22 -0700 (PDT)
Date: Wed, 12 Apr 2017 10:18:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 8/9] powerpc/mm: Wire up hpte_removebolted for powernv
Message-ID: <20170412101819.402451e0@canb.auug.org.au>
In-Reply-To: <20170412085056.4da27f32@kryten>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-9-oohall@gmail.com>
 <20170412085056.4da27f32@kryten>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: Rashmica Gupta <rashmica.g@gmail.com>, linuxppc-dev@lists.ozlabs.org, Anton Blanchard <anton@samba.org>, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Oliver,

On Wed, 12 Apr 2017 08:50:56 +1000 Anton Blanchard <anton@samba.org> wrote:
>
> > From: Rashmica Gupta <rashmica.g@gmail.com>
> > 
> > Adds support for removing bolted (i.e kernel linear mapping) mappings
> > on powernv. This is needed to support memory hot unplug operations
> > which are required for the teardown of DAX/PMEM devices.
> > 
> > Cc: Rashmica Gupta <rashmica.g@gmail.com>
> > Cc: Anton Blanchard <anton@samba.org>
> > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > ---
> > Could the original author of this add their S-o-b? I pulled it out of
> > Rashmica's memtrace patch, but I remember someone saying Anton wrote
> > it originally.  
> 
> I did.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

If you are going to claim that Rashmica authored this patch (and you do
with the From: line above), then you need her Signed-off-by as well.

-- 
Cheers,
Stephen Rothwell
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
