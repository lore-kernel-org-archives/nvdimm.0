Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 908412041B289
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 03:17:36 -0700 (PDT)
From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH ndctl v3 0/3] Documentation: add asciidoctor support
Date: Tue, 24 Apr 2018 12:17:30 +0200
Message-Id: <20180424101733.17233-1-tiwai@suse.de>
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

this is a revised patchset to add the support for asciidoctor to
generate documents.  The reason for adding this feature is that the
future of asciidoc isn't clear as it's written in python2, which is
now hated by all people out of sudden :)

The asciidoctor support is enabled via configure option, the default
is still asciidoc for now.

thanks,

Takashi


v1->v2:
 * more marker fixes to ndctl man pages
 * skip superfluous xmlto processing for asciidoctor
 * add .gitignore entries
 * rebased to v60

v2->v3:
 * fix the link processing regression in v2

===

Takashi Iwai (3):
  Documentation: fix title and section markers
  Documentation: Add the support for asciidoctor
  Documentation: add asciidoctor-extensions.rb to .gitignore

 .gitignore                                  |  2 ++
 Documentation/asciidoctor-extensions.rb.in  | 30 +++++++++++++++++++++++++++++
 Documentation/daxctl/Makefile.am            | 29 ++++++++++++++++++++++++++--
 Documentation/daxctl/daxctl-list.txt        | 13 +++++++------
 Documentation/ndctl/Makefile.am             | 29 ++++++++++++++++++++++++++--
 Documentation/ndctl/ndctl-disable-dimm.txt  |  2 +-
 Documentation/ndctl/ndctl-enable-region.txt |  2 +-
 Documentation/ndctl/ndctl-init-labels.txt   | 15 ++++++++++-----
 Documentation/ndctl/ndctl-list.txt          | 13 ++++++++-----
 Documentation/ndctl/ndctl-start-scrub.txt   |  6 ++++--
 Documentation/ndctl/ndctl-wait-scrub.txt    |  6 ++++--
 configure.ac                                | 17 ++++++++++++++--
 12 files changed, 136 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/asciidoctor-extensions.rb.in

-- 
2.16.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
