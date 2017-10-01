Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7258920945BA6
 for <linux-nvdimm@lists.01.org>; Sun,  1 Oct 2017 16:11:50 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id u130so6637398oib.11
 for <linux-nvdimm@lists.01.org>; Sun, 01 Oct 2017 16:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171001215959.GF15067@dastard>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171001075701.GB11554@lst.de>
 <CAPcyv4gKYOdDP_jYJvPaozaOBkuVa-cf8x6TGEbEhzNfxaxhGw@mail.gmail.com>
 <20171001211147.GE15067@dastard>
 <CAPcyv4hLgGb0sO1=qGxt83zumKt82RA8dUr=_1Gaqew7hxajXg@mail.gmail.com>
 <20171001215959.GF15067@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 1 Oct 2017 16:15:06 -0700
Message-ID: <CAPcyv4id1u=DH733rE0AiVDL0q5-53Hs5GRCnEEJNN_Svs0-WQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] dax: require 'struct page' and other fixups
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 1, 2017 at 2:59 PM, Dave Chinner <david@fromorbit.com> wrote:
[..]
> The "capacity tax" had nothing to do with it - the major problem
> with self hosting struct pages was that page locks can be hot and
> contention on them will rapidly burn through write cycles on the
> pmem. That's still a problem, yes?

It was an early concern we had, but it has not born out in practice,
and stopped worrying about it 2 years ago when the ZONE_DEVICE
infrastructure was merged.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
