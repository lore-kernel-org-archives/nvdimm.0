Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B004921A143FE
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 05:28:05 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id c189so12940901oia.2
 for <linux-nvdimm@lists.01.org>; Sat, 17 Jun 2017 05:29:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170617052212.GA8246@lst.de>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170617052212.GA8246@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 17 Jun 2017 05:29:23 -0700
Message-ID: <CAPcyv4g=x+Af1C8_q=+euwNw_Fwk3Wwe45XibtYR5=kbOcmgfg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: introduce bmap_walk()
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 10:22 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 16, 2017 at 06:15:29PM -0700, Dan Williams wrote:
>> Refactor the core of generic_swapfile_activate() into bmap_walk() so
>> that it can be used by a new daxfile_activate() helper (to be added).
>
> No way in hell!  generic_swapfile_activate needs to day and no new users
> of ->bmap over my dead body.  It's a guaranteed to fuck up your data left,
> right and center.

Certainly you're not saying that existing swapfiles are broken, so I
wonder what bugs you're talking about?

Unless you had plans to go remove bmap() I don't see how this gets in
your way at all. That said, I think "please don't add a new bmap()
user, use iomap instead" is a fair comment. You know me well enough to
know that would be all it takes to redirect my work, I can do without
the bluster.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
