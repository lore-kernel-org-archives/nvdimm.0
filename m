Return-Path: <owner-linux-mm@kvack.org>
From: Christoph Hellwig <hch@lst.de>
Subject: dev_pagemap related cleanups v3
Date: Wed, 26 Jun 2019 14:26:59 +0200
Message-Id: <20190626122724.13313-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan, Jérôme and Jason,

below is a series that cleans up the dev_pagemap interface so that
it is more easily usable, which removes the need to wrap it in hmm
and thus allowing to kill a lot of code

Note: this series is on top of Linux 5.2-rc5 and has some minor
conflicts with the hmm tree that are easy to resolve.

Diffstat summary:

 32 files changed, 361 insertions(+), 1012 deletions(-)

Git tree:

    git://git.infradead.org/users/hch/misc.git hmm-devmem-cleanup.3

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/hmm-devmem-cleanup.3


Changes since v2:
 - fix nvdimm kunit build
 - add a new memory type for device dax
 - fix a few issues in intermediate patches that didn't show up in the end
   result
 - incorporate feedback from Michal Hocko, including killing of
   the DEVICE_PUBLIC memory type entirely

Changes since v1:
 - rebase
 - also switch p2pdma to the internal refcount
 - add type checking for pgmap->type
 - rename the migrate method to migrate_to_ram
 - cleanup the altmap_valid flag
 - various tidbits from the reviews
