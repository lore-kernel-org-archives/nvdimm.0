From: Adam Borowski <kilobyte@angband.pl>
Subject: Re: [PATCH v3 00/18] btrfs dax support
Date: Wed, 17 Apr 2019 18:49:47 +0200
Message-ID: <20190417164947.GA17089@angband.pl>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de, darrick.wong@oracle.com, dsterba@suse.cz, nborisov@suse.com, linux-nvdimm@lists.01.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Apr 16, 2019 at 11:41:36AM -0500, Goldwyn Rodrigues wrote:
> This patch set adds support for dax on the BTRFS filesystem.
> In order to support for CoW for btrfs, there were changes which had to be
> made to the dax handling. The important one is copying blocks into the
> same dax device before using them which is performed by iomap
> type IOMAP_DAX_COW.

I'm afraid that PMDK's testsuite nearly instantly makes this patchset
explode in different ways.

It'd probably be a waste of your time to require a round-trip to report such
fails and re-test.  As PMDK is probably the biggest userspace component, and
exercises DAX paths in interesting ways, I guess it'd be best if you ran its
testsuite locally until it no longer kills the kernel.


Quick start:

git clone https://github.com/pmem/pmdk
deps: libndctl-dev[el], libdaxctl-dev[el]; rest are mostly optional
(full deps for Fedora:
https://github.com/pmem/pmdk/blob/master/utils/docker/images/Dockerfile.fedora-28
SuSE's should be similar)

cp src/test/testconfig.sh{.example,}
-- then edit, you'd want:
PMEM_FS_DIR=/mnt/pmem      # where you have the dax filesystem on
KEEP_GOING=y               # to see more than one broken test

make
make test    # to build tests
make check   # to build and run all tests
cd src/test && ./RUNTESTS a_single_test

Obviously, PMDK's tests may fail due to some difference of behaviour between
ext4, xfs, and your btrfs implementation -- that'll require some
cooperation.  But crashing the kernel is something where the blame is quite
obvious.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
