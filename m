Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190613094326.24093-1-hch@lst.de> <20190613094326.24093-6-hch@lst.de>
 <20190620191733.GH12083@dhcp22.suse.cz> <CAPcyv4h9+Ha4FVrvDAe-YAr1wBOjc4yi7CAzVuASv=JCxPcFaw@mail.gmail.com>
 <20190625072317.GC30350@lst.de> <20190625150053.GJ11400@dhcp22.suse.cz>
 <CAPcyv4j1e5dbBHnc+wmtsNUyFbMK_98WxHNwuD_Vxo4dX9Ce=Q@mail.gmail.com>
 <20190625190038.GK11400@dhcp22.suse.cz> <CAPcyv4hU13v7dSQpF0WTQTxQM3L3UsHMUhsFMVz7i4UGLoM89g@mail.gmail.com>
 <20190626054645.GB17798@dhcp22.suse.cz>
In-Reply-To: <20190626054645.GB17798@dhcp22.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jun 2019 09:14:32 -0700
Message-ID: <CAPcyv4jLK2F2UHqbwp4bCEiB7tL8sVsr775egKMmJvfZG+W+NQ@mail.gmail.com>
Subject: Re: [PATCH 05/22] mm: export alloc_pages_vma
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 25, 2019 at 10:46 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 25-06-19 12:52:18, Dan Williams wrote:
> [...]
> > > Documentation/process/stable-api-nonsense.rst
> >
> > That document has failed to preclude symbol export fights in the past
> > and there is a reasonable argument to try not to retract functionality
> > that had been previously exported regardless of that document.
>
> Can you point me to any specific example where this would be the case
> for the core kernel symbols please?

The most recent example that comes to mind was the thrash around
__kernel_fpu_{begin,end} [1]. I referenced that when debating _GPL
symbol policy with J=C3=A9r=C3=B4me [2].

[1]: https://lore.kernel.org/lkml/20190522100959.GA15390@kroah.com/
[2]: https://lore.kernel.org/lkml/CAPcyv4gb+r=3D=3DriKFXkVZ7gGdnKe62yBmZ7xO=
a4uBBByhnK9Tzg@mail.gmail.com/
