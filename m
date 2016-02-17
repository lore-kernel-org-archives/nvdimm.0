Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 00/10] uuid: convert users to generic UUID API
Date: Wed, 17 Feb 2016 14:17:18 +0200
Message-Id: <1455711448-124103-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Mathias Nyman <mathias.nyman@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Lv Zheng <lv.zheng@intel.com>, Mark Brown <broonie@kernel.org>, Zhang Rui <rui.zhang@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-efi@vger.kernel.org, linux-api@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

There are few fumctions here and there along with type definitions that provide
UUID API. This series consolidates everything under one hood and converts
current users.

This has been tested for a while internally, however it doesn't mean we covered
all possible cases (especially accuracy of UUID constants after conversion).
So, please test this as much as you can and provide your tag. We appreciate the
effort.

Andy Shevchenko (10):
  lib/vsprintf: simplify UUID printing
  lib/uuid: move generate_random_uuid() to uuid.c
  lib/uuid: introduce few more generic helpers for UUID
  lib/uuid: remove FSF address
  ACPI: switch to use generic UUID API
  device property: switch to use UUID API
  sysctl: drop away useless label
  sysctl: use generic UUID library
  efi: redefine type, constant, macro from generic code
  efivars: use generic UUID library

 drivers/acpi/acpi_extlog.c                        |  8 +-
 drivers/acpi/bus.c                                | 29 +------
 drivers/acpi/nfit.c                               | 34 ++++----
 drivers/acpi/nfit.h                               |  3 +-
 drivers/acpi/property.c                           | 18 ++---
 drivers/acpi/utils.c                              |  4 +-
 drivers/char/random.c                             | 21 +----
 drivers/char/tpm/tpm_crb.c                        |  9 +--
 drivers/char/tpm/tpm_ppi.c                        | 20 ++---
 drivers/gpu/drm/i915/intel_acpi.c                 | 14 ++--
 drivers/gpu/drm/nouveau/nouveau_acpi.c            | 20 +++--
 drivers/gpu/drm/nouveau/nvkm/subdev/mxm/base.c    |  9 +--
 drivers/hid/i2c-hid/i2c-hid.c                     |  9 +--
 drivers/iommu/dmar.c                              | 11 ++-
 drivers/pci/pci-acpi.c                            | 11 ++-
 drivers/pci/pci-label.c                           |  4 +-
 drivers/thermal/int340x_thermal/int3400_thermal.c |  6 +-
 drivers/usb/host/xhci-pci.c                       |  9 +--
 fs/btrfs/volumes.c                                |  2 +-
 fs/efivarfs/inode.c                               | 40 +---------
 fs/ext4/ioctl.c                                   |  1 +
 fs/f2fs/file.c                                    |  2 +-
 fs/reiserfs/objectid.c                            |  2 +-
 fs/ubifs/sb.c                                     |  2 +-
 include/acpi/acpi_bus.h                           | 10 ++-
 include/linux/acpi.h                              |  2 +-
 include/linux/efi.h                               | 14 +---
 include/linux/pci-acpi.h                          |  2 +-
 include/linux/random.h                            |  1 -
 include/linux/uuid.h                              | 21 +++--
 include/uapi/linux/uuid.h                         |  4 -
 kernel/sysctl_binary.c                            | 30 +++----
 lib/uuid.c                                        | 96 +++++++++++++++++++++--
 lib/vsprintf.c                                    | 21 ++---
 sound/soc/intel/skylake/skl-nhlt.c                |  7 +-
 35 files changed, 237 insertions(+), 259 deletions(-)

-- 
2.7.0
