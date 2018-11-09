From: Barret Rhoden <brho@google.com>
Subject: [PATCH 0/2] kvm: Use huge pages for DAX-backed files
Date: Fri,  9 Nov 2018 15:39:19 -0500
Message-ID: <20181109203921.178363-1-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, yu.c.zhang@intel.com, yi.z.zhang@intel.com
List-Id: linux-nvdimm@lists.01.org

This patch series depends on dax pages not being PageReserved.  Once
that is in place, these changes will let KVM use huge pages with
dax-backed files.  Without the PageReserved change, KVM and DAX still
work with these patches, simply without huge pages - which is the
current situation.

RFC/discussion thread:
https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/

Barret Rhoden (2):
  mm: make dev_pagemap_mapping_shift() externally visible
  kvm: Use huge pages for DAX-backed files

 arch/x86/kvm/mmu.c  | 34 ++++++++++++++++++++++++++++++++--
 include/linux/mm.h  |  3 +++
 mm/memory-failure.c | 38 +++-----------------------------------
 mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 72 insertions(+), 37 deletions(-)

-- 
2.19.1.930.g4563a0d9d0-goog
