Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1734880318
 for <linux-nvdimm@lists.01.org>; Sun,  5 Mar 2017 23:06:50 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Mon,  6 Mar 2017 00:04:16 -0700
Message-Id: <1488783873-2614-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v3 00/16] Cleanup chardev instances with helper function
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Olof Johansson <olof@lixom.net>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Haggai Eran <haggaie@mellanox.com>, Parav Pandit <pandit.parav@gmail.com>, Leon Romanovsky <leon@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald-Stadler <pmeerw@pmeerw.net>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Artem Bityutskiy <dedekind1@gmail.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, Matt Porter <mporter@kernel.crashing.org>, Alexandre Bounine <alexandre.bounine@idt.com>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Vladimir Zapolskiy <vz@mleia.com>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Bates <stephen.bates@microsemi.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org, linux-input@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

Here's v3 of this patchset. It's based off of v4.11-rc1 which mostly
rebased clearly except for Jason's IB/ucm patch (but it was pretty
trivial to fix).

I've made this set available on github here (cdev_v3 branch):

https://github.com/lsgunth/linux.git

Also, I've noticed these emails aren't getting through to the
mailing lists at vger.kernel.org. Though, I'm not sure why as my
email logs show they are accepted. Perhaps it has something to do
with the number of lists it's addressed to. I won't be surprised if
v3 doesn't make it either as I'm not sure how to deal with that problem.

Thanks,

Logan

Changes since v2:

* Expanded comments as per Jason's suggestions
* Collected tags
* Updated the switchtec patch seeing it's underlying patch set changed


--

v2 description:

Here's v2 of my chardev cleanup patch-set. I've incorporated some
feedback and decided to extend the concept a little further. The new
helper function now includes both cdev_add and device_add which
significantly simplifies every instance that called it.

Jason's also expressed an interest in creating a general solution to
the problem that occurs if a user tries to utilize a newly created
cdev right before device_add fails. This series doesn't address that
specifically but will make it much easier to do so in future work.

I've also added cdev_set_parent for the cases in IB that set
the kobject parent without using device_add. This is just to ensure
the parent setting code is private within char_dev.c and removes the
lines that appear suspect but are in fact correct. Dan's suggested
WARN_ON is included in this function.

Seeing the new helper function takes in a bit more than before,
the instance patches are a bit heavier. Thus, I've refrained from
collecting the acks and reviews I've already received. In a couple
of cases (mtd and scsi) the cleanup required was a bit more involved
than I would have liked and thus these patches probably need more
attention, review and testing. (Unfortunately, I don't have hardware
to actually test them.) Hopefully that process doesn't throw too big
a wrench in the overall series moving forward.

I've included Dan's cdev_leak patch in this series to avoid a merge
conflict between the two of us.

While the diff stats for the series are much heavier than in v1, we now
have a net loss of more than 100 lines! So this feels much more like a
successful cleanup.

--

v1 story:

Our story for this patch-set begins with a new driver I wrote and am in
the process of submitting upstream. That driver creates a fairly
standard char device and the code for it was copied from a similar
instance in device-dax. However, upon review, Greg Kroah-Hartman
noticed [1] a suspicious line that assigned to the parent field of
the underlying kobject for the char device.

I removed that from my code and endeavoured to remove it from the
code I copied as well. However, Dan Williams pointed out [2] that this
code is necessary for correct reference counting of the underlying
structures. This prompted me to do a fair bit more research and
investigation into whats going on and I found it to be a common pattern.
(Although misleading and though required to be correct, frequently
forgotten.) This pattern is used in at least 15 places in the kernel
and probably should have been used in at least 5 more.

This patch-set aims to correct this and hopefully prevent future
developers from wasting their time on it. The first patch introduces
a new helper API as originally proposed by Dan Williams [3]. Please
see the commit message for that patch for a longer description of the
problem and history.

The subsequent patches either update correct instances to use the
new API or fix incorrect usages to ensure the cdev correctly takes
a reference count using the new API (this is noted in those patches).

This moves all except four of the cdev.kobj.parent usages into the one
cdev function, the remaining four are in the infiniband subsystem and
I've left alone because that subsystem seems to make use of kobjects
directly (instead of struct devices). These are noted in patch 7 of
this series.

This series is based on v4.10 with the exception of the last patch
which is for my new driver which, as yet, has not been accepted
upstream.

[1] https://lkml.org/lkml/2017/2/10/370
[2] https://lkml.org/lkml/2017/2/10/607
[3] https://lkml.org/lkml/2017/2/13/700

Dan Williams (1):
  device-dax: fix cdev leak

Jason Gunthorpe (1):
  IB/ucm: utilize new cdev_device_add helper function

Logan Gunthorpe (14):
  chardev: add helper function to register char devs with a struct
    device
  device-dax: utilize new cdev_device_add helper function
  input: utilize new cdev_device_add helper function
  gpiolib: utilize new cdev_device_add helper function
  tpm-chip: utilize new cdev_device_add helper function
  platform/chrome: cros_ec_dev - utilize new cdev_device_add helper
    function
  infiniband: utilize the new cdev_set_parent function
  iio:core: utilize new cdev_device_add helper function
  media: utilize new cdev_device_add helper function
  mtd: utilize new cdev_device_add helper function
  rapidio: utilize new cdev_device_add helper function
  rtc: utilize new cdev_device_add helper function
  scsi: utilize new cdev_device_add helper function
  switchtec: utilize new device_add_cdev helper function

 drivers/char/tpm/tpm-chip.c              | 19 ++-----
 drivers/dax/dax.c                        | 33 ++++++------
 drivers/gpio/gpiolib.c                   | 23 +++-----
 drivers/iio/industrialio-core.c          | 15 ++----
 drivers/infiniband/core/ucm.c            | 35 ++++++------
 drivers/infiniband/core/user_mad.c       |  4 +-
 drivers/infiniband/core/uverbs_main.c    |  2 +-
 drivers/infiniband/hw/hfi1/device.c      |  2 +-
 drivers/input/evdev.c                    | 11 +---
 drivers/input/joydev.c                   | 11 +---
 drivers/input/mousedev.c                 | 11 +---
 drivers/media/cec/cec-core.c             | 16 ++----
 drivers/media/media-devnode.c            | 20 ++-----
 drivers/mtd/ubi/build.c                  | 91 ++++++--------------------------
 drivers/mtd/ubi/vmt.c                    | 49 ++++++-----------
 drivers/pci/switch/switchtec.c           | 11 +---
 drivers/platform/chrome/cros_ec_dev.c    | 31 +++--------
 drivers/rapidio/devices/rio_mport_cdev.c | 24 +++------
 drivers/rtc/class.c                      | 14 +++--
 drivers/rtc/rtc-dev.c                    | 17 ------
 drivers/scsi/osd/osd_uld.c               | 56 +++++++-------------
 fs/char_dev.c                            | 77 +++++++++++++++++++++++++++
 include/linux/cdev.h                     |  4 ++
 23 files changed, 229 insertions(+), 347 deletions(-)

--
2.1.4
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
