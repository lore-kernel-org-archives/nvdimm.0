Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2001:1868:205::9])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4531681C74
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 22:07:41 -0800 (PST)
Date: Tue, 17 Jan 2017 22:07:40 -0800
From: willy@bombadil.infradead.org
Subject: Re: [LSF/MM TOPIC] Future direction of DAX
Message-ID: <20170118060740.GE18349@bombadil.infradead.org>
References: <20170114002008.GA25379@linux.intel.com>
 <20170118052533.GA18349@bombadil.infradead.org>
 <CAPcyv4jNz=1QdPPtM2A=3avGtVvZG=2d9JC-JD_F6u+-CYQN4g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jNz=1QdPPtM2A=3avGtVvZG=2d9JC-JD_F6u+-CYQN4g@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 17, 2017 at 10:01:30PM -0800, Dan Williams wrote:
> >> - Jan suggested [2] that we could use the radix tree as a cache to service DAX
> >>   faults without needing to call into the filesystem.  Are there any issues
> >>   with this approach, and should we move forward with it as an optimization?
> >
> > Ahem.  I believe I proposed this at last year's LSFMM.  And I sent
> > patches to start that work.  And Dan blocked it.  So I'm not terribly
> > amused to see somebody else given credit for the idea.
> 
> I "blocked" moving the phys to virt translation out of the driver
> since that mapping lifetime is device specific.

The problem is that DAX currently assumes that there *is* a block driver,
and it might be a char device or no device at all (the two examples I
gave earlier).

> However, I think caching the file offset to physical sector/address
> result is a great idea.

OK, great.  The lifetime problem I think you care about (hotplug) can be
handled by removing all the cached entries for every file on every file
on that block device ... I know there were prototype patches for that;
did they ever get merged?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
