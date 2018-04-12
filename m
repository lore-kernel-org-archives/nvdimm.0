Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DB302265A357
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 04:08:06 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id A67A2ABD0
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 11:08:03 +0000 (UTC)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl 0/2] Documentation: add asciidoctor support
Date: Thu, 12 Apr 2018 13:07:53 +0200
Message-Id: <20180412110755.31644-1-tiwai@suse.de>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

this is a patchset to add the support for asciidoctor to generate
documents.  The reason for adding this feature is that the future of
asciidoc isn't clear as it's written in python2, which is now hated by
all people out of sudden :)

The asciidoctor support is enabled via configure option, the default
is still asciidoc for now.


thanks,

Takashi

===

Takashi Iwai (2):
  Documentation: fix title and section markers
  Documentation: Add the support for asciidoctor

 Documentation/asciidoctor-extensions.rb.in  |   28 ++++++++++++++++++++++++++++
 Documentation/daxctl/Makefile.am            |   23 ++++++++++++++++++++---
 Documentation/daxctl/daxctl-io.txt          |    5 +++--
 Documentation/daxctl/daxctl-list.txt        |   13 +++++++------
 Documentation/ndctl/Makefile.am             |   23 ++++++++++++++++++++---
 Documentation/ndctl/ndctl-disable-dimm.txt  |    2 +-
 Documentation/ndctl/ndctl-enable-region.txt |    2 +-
 Documentation/ndctl/ndctl-init-labels.txt   |   15 ++++++++++-----
 Documentation/ndctl/ndctl-list.txt          |   13 ++++++++-----
 configure.ac                                |   14 ++++++++++++--
 10 files changed, 110 insertions(+), 28 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
