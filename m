Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 14 Aug 2015 10:00:48 -0700
Message-ID: <CAPcyv4iEuKzNQ-zEMtriLqe+bnoE3jfUSztcSRaH05ZMBWvtfw@mail.gmail.com>
Subject: Switch nvdimm.git to the shared repository
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Stephen,

When you get a chance please switch the nvdimm.git repository in -next
to our newly established shared repo.  I.e. switch from:

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git libnvdimm-for-next

...to...:

git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
libnvdimm-for-next

Thank you!
