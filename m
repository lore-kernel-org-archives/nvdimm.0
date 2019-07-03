Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190701062020.19239-1-hch@lst.de> <20190701062020.19239-21-hch@lst.de>
 <a3108540-e431-2513-650e-3bb143f7f161@nvidia.com>
In-Reply-To: <a3108540-e431-2513-650e-3bb143f7f161@nvidia.com>
From: Ilia Mirkin <imirkin@alum.mit.edu>
Date: Wed, 3 Jul 2019 13:50:45 -0400
Message-ID: <CAKb7Uvid7xfWNRxee4YoDSKu5-eizo-0Bqb3amFczEDXmSKLMA@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 20/22] mm: move hmm_vma_fault to nouveau
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-nvdimm@lists.01.org, Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linux-mm@kvack.org, nouveau <nouveau@lists.freedesktop.org>, Ira Weiny <ira.weiny@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 3, 2019 at 1:49 PM Ralph Campbell <rcampbell@nvidia.com> wrote:
> On 6/30/19 11:20 PM, Christoph Hellwig wrote:
> > hmm_vma_fault is marked as a legacy API to get rid of, but quite suites
> > the current nouvea flow.  Move it to the only user in preparation for
>
> I didn't quite parse the phrase "quite suites the current nouvea flow."
> s/nouvea/nouveau/

As long as you're fixing typos, suites -> suits.
