Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C66C82118EF74
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 07:44:08 -0800 (PST)
Date: Thu, 15 Nov 2018 07:44:03 -0800
From: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 2/3] MAINTAINERS, Handbook:
 Subsystem Profile
Message-ID: <20181115074403.45d9a16a@silica.lan>
In-Reply-To: <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steve French <stfrench@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-media@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, 14 Nov 2018 20:53:25 -0800
Dan Williams <dan.j.williams@intel.com> escreveu:

> As presented at the 2018 Linux Plumbers conference [1], the Subsystem
> Profile is proposed as a way to reduce friction between committers and
> maintainers and perhaps encourage conversations amongst maintainers
> about best practice policies.
> 
> The profile contains short answers to some of the common policy
> questions a contributor might have, or that a maintainer might consider
> formalizing. The current list of maintenance policies is:
> 
> Overview: General introduction to maintaining the subsystem
> Core: List of source files considered core
> Leaf: List of source files that consume core functionality
> Patches or Pull requests: Simple statement of expected submission format
> Last -rc for new feature submissions: Expected lead time for submissions
> Last -rc to merge features: Deadline for merge decisions
> Non-author Ack / Review Tags Required: Patch review economics
> Test Suite: Pass this suite before requesting inclusion
> Resubmit Cadence: When to ping the maintainer
> Trusted Reviewers: Help for triaging patches
> Time Zone / Office Hours: When might a maintainer be available
> Checkpatch / Style Cleanups: Policy on pure cleanup patches
> Off-list review: Request for review gates
> TODO: Potential development tasks up for grabs, or active focus areas
> 
> The goal of the Subsystem Profile is to set expectations for
> contributors and interim or replacement maintainers for a subsystem.
> 
> See Documentation/maintainer/subsystem-profile.rst for more details, and
> a follow-on example profile for the libnvdimm subsystem.
> 
> [1]: https://linuxplumbersconf.org/event/2/contributions/59/
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Steve French <stfrench@microsoft.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Tobin C. Harding <me@tobin.cc>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Joe Perches <joe@perches.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Ok, I sort of followed the proposed model, adding a documentation for
the media subsystem using the template.

I'm pretty sure this is incomplete and more work would be needed.
So, for now, this is just an example.

Also, I didn't test building it on Sphinx (nor added any reference for it
at MAINTAINERS), as my main goal here was to see how the model would fit
for us.

I noticed a few issues there:

1) Describing the "core" files. The media subsystem is complex: depending on
the device type, we have different APIs and different cores. So, our core
is actually a set of different cores. I ended by adding sub-sections.

Also, several things were not described there. For example, we store
DVB frontend drivers on an specific directory. We have drivers there organized
by bus type. So, one directory for I2C, one for USB, one for PCI, ...

It should probably make sense to be able to tell about that.

So, I would actually prefer to have, at the profile, a "files" section,
instead of "core".

2) As I said before, on media, we have sub-maintainers. Not sure how to
describe them on this template.

3) I noticed one big missing thing there: in the case of media, we are
responsible also to maintaining media staging drivers, that goes at
drivers/staging/media. IMO, it would be important to be able to describe
who maintains staging stuff - e. g. if the subsystem maintainers prefer
to let staging up to staging maintainers or if they'll maintain themselves.

In the latter, it probably makes sense to describe any specific thing
related to it (where staging will be at the tree, are there any special
rules for them?)

Anyway, RFC patch follows.

-

[PATCH] [RFC] Add a system profile description for media subsystem

This RFC aligns with current Dan's proposal for having subsystem
specific ruleset stored at the Kernel tree.

On this initial RFC, I opted to not add the reviewers e-mail
(adding just a "<>") as a boilerplate. If we decide keeping emails
there, I'll add them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/Documentation/media/subsystem-profile.rst b/Documentation/media/subsystem-profile.rst
new file mode 100644
index 000000000000..7a5d6f691d05
--- /dev/null
+++ b/Documentation/media/subsystem-profile.rst
@@ -0,0 +1,186 @@
+Media Subsystem Profile
+=======================
+
+Overview
+--------
+
+The media subsystem cover support for a variety of devices: stream
+capture, analog and digital TV, cameras, remote controllers, HDMI CEC
+and media pipeline control.
+
+Both our userspace and Kernel APIs are documented and should be kept in
+sync with the API changes. It means that all patches that add new
+features to the subsystem should also bring changes to the corresponding
+API files.
+
+Also, patches for device drivers that changes the Open Firmware/Device
+Tree bindings should be reviewed by the Device Tree maintainers.
+
+Due to the size and wide scope of the media subsystem, our
+maintainership model is to have sub-maintainers that have a broad
+knowledge of an specific aspect of the subsystem. It is a
+sub-maintainers task to review the patches, providing feedback to users
+if the patches are following the subsystem rules and are properly using
+the media internal and external APIs.
+
+We have a set of compliance tools at https://git.linuxtv.org/v4l-utils.git/
+that should be used in order to check if the drivers are properly
+implementing the media APIs.
+
+Patches for the media subsystem should be sent to the media mailing list
+at linux-media@vger.kernel.org as plain text only e-mail. emails with
+HTML will be automacially rejected by the mail server.
+
+Our workflow is heavily based on Patchwork, meaning that, once a patch
+is submitted, it should appear at:
+
+   - https://patchwork.linuxtv.org/project/linux-media/list/
+
+If it doesn't automatically appear there after a few minutes, then
+probably something got wrong on your submission. Please check if the
+email is in plain text only and if your emailer is not mangling with
+whitespaces before complaining or submit it again.
+
+Core
+----
+
+Documentation
++++++++++++++
+
+F: Documentation/media
+
+Kernelspace API headers
++++++++++++++++++++++++
+
+F: include/media/*.h
+
+Digital TV Core
++++++++++++++++
+
+F: drivers/media/dvb-core
+
+HDMI CEC Core
++++++++++++++
+
+F: drivers/media/cec
+
+Media Controller Core
++++++++++++++++++++++
+
+F: drivers/media/media-\*.[ch]
+
+Remote Controller Core
+++++++++++++++++++++++
+
+F: drivers/media/rc/rc-core-priv.h
+F: drivers/media/rc/rc-ir-raw.c
+F: drivers/media/rc/rc-main.c
+F: drivers/media/rc/ir\*-decoder.c
+F: drivers/media/rc/lirc_dev.c
+
+Video4linux Core
+++++++++++++++++
+
+F: drivers/media/v4l2-core
+
+Patches or Pull requests
+------------------------
+
+All patches should be submitted via e-mail for review. We use
+pull requests on our workflow between sub-maintainers and the
+maintainer.
+
+
+Last day for new feature submissions
+------------------------------------
+
+Before -rc5
+
+
+Last day to merge features
+--------------------------
+
+Before -rc7
+
+
+Non-author Ack / Review Tags Required
+-------------------------------------
+
+Not required, but desirable
+
+
+Test Suite
+----------
+
+Use the several *-compliance tools that are part of the v4l-utils
+package.
+
+
+Trusted Reviewers
+-----------------
+
+Sub-maintainers
++++++++++++++++
+
+At the media subsystem, we have a group of senior developers that are
+responsible for doing the code reviews at the drivers (called
+sub-maintainers), and another senior developer responsible for the
+subsystem as a hole. For core changes, whenever possible, multiple
+media (sub-)maintainers do the review.
+
+The sub-maintainers work on specific areas of the subsystem, as
+described below:
+
+- Sensor drivers
+
+  R: Sakari Ailus <>
+
+- V4L2 drivers
+
+  R: Hans Verkuil <>
+
+- Media controller drivers
+
+  R: Laurent Pinchart <>
+
+- HDMI CEC
+
+- Remote Controllers
+
+  R: Sean Young <>
+
+- Digital TV
+
+  R: Michael Krufky <>
+  R: Sean Young <>
+
+
+Resubmit Cadence
+----------------
+
+Provided that your patch is at https://patchwork.linuxtv.org, it should
+be sooner or later handled, so you don't need to re-submit a patch.
+
+Please notice that the media subsystem is a high traffic one, so it
+could take a while for us to be able to review your patches. Feel free
+to ping if you don't get a feedback on a couple of weeks.
+
+Time Zone / Office Hours
+------------------------
+
+Media developers are distributed all around the globe. So, don't assume
+that we're on your time zone. We usually don't work on local holidays or
+at weekends. Please also notice that, during the Kernel merge window,
+we're usually busy ensuring that everything goes smoothly, meaning that
+we usually have a lot of patches waiting for review just after that. So
+you should expect a higher delay during the merge window and one week
+before/after it.
+
+
+Checkpatch / Style cleanups
+---------------------------
+
+Standalone style-cleanups are welcome, but they should be grouped per
+directory. So, for example, if you're doing a cleanup at drivers
+under drivers/media, please send a single patch for all drivers under
+drivers/media/pci, another one for drivers/media/usb and so on.





Cheers,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
