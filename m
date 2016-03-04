Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 2397A1A1DE9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 19:35:04 -0800 (PST)
Date: Fri, 4 Mar 2016 11:34:51 +0800
From: "Zhang, Haozhong" <haozhong.zhang@intel.com>
Subject: Re: [PATCH v2] nfit: Continue init even if ARS commands are
 unimplemented
Message-ID: <20160304033451.GA6267@hz-desktop.sh.intel.com>
References: <1457044781-15443-1-git-send-email-vishal.l.verma@intel.com>
 <56D900EA.2060802@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56D900EA.2060802@linux.intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/04/16 11:28, Xiao Guangrong wrote:
> 
> CCed: Haozhong.
> 
> On 03/04/2016 06:39 AM, Vishal Verma wrote:
> >If firmware doesn't implement any of the ARS commands, take that to
> >mean that ARS is unsupported, and continue to initialize regions without
> >bad block lists. We cannot make the assumption that ARS commands will be
> >unconditionally supported on all NVDIMMs.
> >
> >Cc: Dan Williams <dan.j.williams@intel.com>
> >Reported-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> 
> Thank you for the fix, Vishal! it looks good to me.
> 
> However, It is haozhong's credit as he is the one reported the bug not
> me. :)
> 

Thanks! I have tested on QEMU which has not implemented ARS yet and
this patch does work.

Tested-by: Haozhong Zhang <haozhong.zhang@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
