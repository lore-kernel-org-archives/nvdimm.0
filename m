Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 897FF21190734
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 21:05:04 -0800 (PST)
Subject: [RFC PATCH 0/3] Maintainer Handbook: Subsystem Profile
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Nov 2018 20:53:13 -0800
Message-ID: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-kernel@vger.kernel.org
Cc: ksummit-discuss@lists.linuxfoundation.org, corbet@lwn.net, Daniel Vetter <daniel.vetter@ffwll.ch>, Ross Zwisler <zwisler@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Olof Johansson <olof@lixom.net>, linux-nvdimm@lists.01.org, Steve French <stfrench@microsoft.com>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

At a recently concluded session at the Linux Plumbers Conference I
proposed a "Subsystem Profile" as a document that a maintainer can
provide to set contributor expectations and provide fodder for a
discussion between maintainers about the merits of different maintainer
policies.

For those that did not attend, the goal of the Subsystem Profile, and the
Maintainer Handbook more generally, is to provide a desk reference for
maintainers both new and experienced. The session introduction was:

    The first rule of kernel maintenance is that there are no hard and
    fast rules. That state of affairs is both a blessing and a curse. It
    has served the community well to be adaptable to the different
    people and different problem spaces that inhabit the kernel
    community. However, that variability also leads to inconsistent
    experiences for contributors, little to no guidance for new
    contributors, and unnecessary stress on current maintainers. There
    are quite a few of people who have been around long enough to make
    enough mistakes that they have gained some hard earned proficiency.
    However if the kernel community expects to keep growing it needs to
    be able both scale the maintainers it has and ramp new ones without
    necessarily let them make a decades worth of mistakes to learn the
    ropes. 

To be clear, the proposed document does not impose or suggest new
rules. Instead it provides an outlet to document the unwritten rules
and policies in effect for each subsystem, and that each subsystem
might decide differently for whatever reason.

---

Dan Williams (3):
      MAINTAINERS: Reclaim the P: tag for Subsystem Profile
      MAINTAINERS, Handbook: Subsystem Profile
      libnvdimm, MAINTAINERS: Subsystem Profile


 Documentation/maintainer/index.rst             |    1 
 Documentation/maintainer/subsystem-profile.rst |  145 ++++++++++++++++++++++++
 Documentation/nvdimm/subsystem-profile.rst     |   86 ++++++++++++++
 MAINTAINERS                                    |   26 +++-
 4 files changed, 249 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/maintainer/subsystem-profile.rst
 create mode 100644 Documentation/nvdimm/subsystem-profile.rst
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
