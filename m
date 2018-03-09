Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED7D322135D30
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 10:16:52 -0800 (PST)
Subject: Re: [PATCH v4 0/2] ndctl: move firmware update to dimm action
References: <152061924045.58280.15236814067229580330.stgit@djiang5-desk3.ch.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <47d5d455-f096-619c-e6fa-cc960a935d4e@intel.com>
Date: Fri, 9 Mar 2018 11:23:09 -0700
MIME-Version: 1.0
In-Reply-To: <152061924045.58280.15236814067229580330.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 03/09/2018 11:16 AM, Dave Jiang wrote:
> The following series moves firmware update to dimm.c in order to take
> advantage of the command line parsing that already exists and remove
> duplications.

Please ignore this series. stgit somehow dropped some chunks. I'll
resend as v5

> 
> v4:
> - Fixed man page for firmware update.
> - Added check for all Intel DSMs for update firmware supported check.
> 
> v3:
> - Modified error printout for op not supported per Dan's comment.
> 
> v2:
> - Add distinct return errors for lack of support in ndctl, kernel, or
>   platform.
> - Moved the firmware update defines and structs to its own header.
> 
> ---
> 
> Dave Jiang (2):
>       ndctl: add check for update firmware supported
>       ndctl: merge firmware-update to dimm.c as one of the dimm ops
> 
> 
>  ndctl/Makefile.am       |    1 
>  ndctl/dimm.c            |  475 +++++++++++++++++++++++++++++++++++++++++
>  ndctl/firmware-update.h |   45 ++++
>  ndctl/lib/firmware.c    |   11 +
>  ndctl/lib/intel.c       |   32 +++
>  ndctl/lib/libndctl.sym  |    1 
>  ndctl/lib/private.h     |    1 
>  ndctl/libndctl.h        |    1 
>  ndctl/update.c          |  545 -----------------------------------------------
>  9 files changed, 564 insertions(+), 548 deletions(-)
>  create mode 100644 ndctl/firmware-update.h
>  delete mode 100644 ndctl/update.c
> 
> --
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
