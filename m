Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 139B922526485
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 18:03:38 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl 0/2] Documentation: add asciidoctor support
Date: Fri, 13 Apr 2018 01:03:37 +0000
Message-ID: <1523581414.5234.4.camel@intel.com>
References: <20180412110755.31644-1-tiwai@suse.de>
In-Reply-To: <20180412110755.31644-1-tiwai@suse.de>
Content-Language: en-US
Content-ID: <DF9609EF5017C949A589E1D746EF2190@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-12 at 13:07 +0200, Takashi Iwai wrote:
> Hi,
> 
> this is a patchset to add the support for asciidoctor to generate
> documents.  The reason for adding this feature is that the future of
> asciidoc isn't clear as it's written in python2, which is now hated by
> all people out of sudden :)
> 
> The asciidoctor support is enabled via configure option, the default
> is still asciidoc for now.
> 
> 
> thanks,
> 
> Takashi

Hi Takashi,

Thanks for these patches - they look good in general. However since we are
so close to the v60 release, may I ask you to rebase these once v60 is out?
(targeting early next week..)

There will be a few documentation updates in v60, and it would be nice to
get this series applied right after v60 is out.

	-Vishal

> 
> ===
> 
> Takashi Iwai (2):
>   Documentation: fix title and section markers
>   Documentation: Add the support for asciidoctor
> 
>  Documentation/asciidoctor-extensions.rb.in  |   28
> ++++++++++++++++++++++++++++
>  Documentation/daxctl/Makefile.am            |   23 ++++++++++++++++++++-
> --
>  Documentation/daxctl/daxctl-io.txt          |    5 +++--
>  Documentation/daxctl/daxctl-list.txt        |   13 +++++++------
>  Documentation/ndctl/Makefile.am             |   23 ++++++++++++++++++++-
> --
>  Documentation/ndctl/ndctl-disable-dimm.txt  |    2 +-
>  Documentation/ndctl/ndctl-enable-region.txt |    2 +-
>  Documentation/ndctl/ndctl-init-labels.txt   |   15 ++++++++++-----
>  Documentation/ndctl/ndctl-list.txt          |   13 ++++++++-----
>  configure.ac                                |   14 ++++++++++++--
>  10 files changed, 110 insertions(+), 28 deletions(-)
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
