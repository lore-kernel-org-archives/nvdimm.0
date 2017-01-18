Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0166881E31
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jan 2017 09:22:16 -0800 (PST)
Date: Wed, 18 Jan 2017 10:22:16 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Message-ID: <20170118172216.GA20111@linux.intel.com>
References: <20170114002008.GA25379@linux.intel.com>
 <20170118052533.GA18349@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170118052533.GA18349@bombadil.infradead.org>
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
To: willy@bombadil.infradead.org
Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 17, 2017 at 09:25:33PM -0800, willy@bombadil.infradead.org wrote:
> On Fri, Jan 13, 2017 at 05:20:08PM -0700, Ross Zwisler wrote:
> > We still have a lot of work to do, though, and I'd like to propose a discussion
> > around what features people would like to see enabled in the coming year as
> > well as what what use cases their customers have that we might not be aware of.
> 
> +1 to the discussion
> 
> > - Jan suggested [2] that we could use the radix tree as a cache to service DAX
> >   faults without needing to call into the filesystem.  Are there any issues
> >   with this approach, and should we move forward with it as an optimization?
> 
> Ahem.  I believe I proposed this at last year's LSFMM.  And I sent
> patches to start that work.  And Dan blocked it.  So I'm not terribly
> amused to see somebody else given credit for the idea.
> 
> It's not just an optimisation.  It's also essential for supporting
> filesystems which don't have block devices.  I'm aware of at least two
> customer demands for this in different domains.
> 
> 1. Embedded uses with NOR flash
> 2. Cloud/virt uses with multiple VMs on a single piece of hardware

Yea, I didn't mean the full move to having PFNs in the tree, just using the
sector number in the radix tree instead of calling into the filesystem.

My apologies if you feel I didn't give you proper credit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
