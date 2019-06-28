Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8EB212AB4DE
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 09:54:17 -0700 (PDT)
Date: Fri, 28 Jun 2019 09:54:17 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
Message-ID: <20190628165417.GD4286@bombadil.infradead.org>
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org>
 <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190628163721.GC4286@bombadil.infradead.org>
 <CAPcyv4jeRwhYWnGw9RrfDA54RRa9LK4JPuF3zQ-av=HdRqCTJw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jeRwhYWnGw9RrfDA54RRa9LK4JPuF3zQ-av=HdRqCTJw@mail.gmail.com>
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
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 28, 2019 at 09:39:01AM -0700, Dan Williams wrote:
> On Fri, Jun 28, 2019 at 9:37 AM Matthew Wilcox <willy@infradead.org> wrote:
> > That was the conclusion I came to; that one thread holding the mmap sem
> > for read isn't being woken up when it should be.  Just need to find it ...
> > obviously it's something to do with the PMD entries.
> 
> Can you explain to me one more time, yes I'm slow on the uptake on
> this, the difference between xas_load() and xas_find_conflict() and
> why it's ok for dax_lock_page() to use xas_load() while
> grab_mapping_entry() uses xas_find_conflict()?

When used with a non-zero 'order', xas_find_conflict() will return
an entry whereas xas_load() might return a pointer to a node.
dax_lock_page() always uses a zero order, so they would always do the
same thing (xas_find_conflict() would be less efficient).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
