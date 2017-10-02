Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D899921F9B690
 for <linux-nvdimm@lists.01.org>; Mon,  2 Oct 2017 15:44:20 -0700 (PDT)
Date: Mon, 2 Oct 2017 15:47:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] dax: require 'struct page' and other fixups
Message-Id: <20171002154739.81f24874d93a336890851442@linux-foundation.org>
In-Reply-To: <CAPcyv4id1u=DH733rE0AiVDL0q5-53Hs5GRCnEEJNN_Svs0-WQ@mail.gmail.com>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171001075701.GB11554@lst.de>
 <CAPcyv4gKYOdDP_jYJvPaozaOBkuVa-cf8x6TGEbEhzNfxaxhGw@mail.gmail.com>
 <20171001211147.GE15067@dastard>
 <CAPcyv4hLgGb0sO1=qGxt83zumKt82RA8dUr=_1Gaqew7hxajXg@mail.gmail.com>
 <20171001215959.GF15067@dastard>
 <CAPcyv4id1u=DH733rE0AiVDL0q5-53Hs5GRCnEEJNN_Svs0-WQ@mail.gmail.com>
Mime-Version: 1.0
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
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, 1 Oct 2017 16:15:06 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 1, 2017 at 2:59 PM, Dave Chinner <david@fromorbit.com> wrote:
> [..]
> > The "capacity tax" had nothing to do with it - the major problem
> > with self hosting struct pages was that page locks can be hot and
> > contention on them will rapidly burn through write cycles on the
> > pmem. That's still a problem, yes?
> 
> It was an early concern we had, but it has not born out in practice,
> and stopped worrying about it 2 years ago when the ZONE_DEVICE
> infrastructure was merged.

These are weighty matters and should have been covered in the
changelogs, please.  Could you send along a few paragraphs which
summarise these thoughts and I'll add them in?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
