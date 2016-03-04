Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 26DD91A1E46
 for <linux-nvdimm@lists.01.org>; Thu,  3 Mar 2016 19:29:08 -0800 (PST)
Subject: Re: [PATCH v2] nfit: Continue init even if ARS commands are
 unimplemented
References: <1457044781-15443-1-git-send-email-vishal.l.verma@intel.com>
From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Message-ID: <56D900EA.2060802@linux.intel.com>
Date: Fri, 4 Mar 2016 11:28:42 +0800
MIME-Version: 1.0
In-Reply-To: <1457044781-15443-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


CCed: Haozhong.

On 03/04/2016 06:39 AM, Vishal Verma wrote:
> If firmware doesn't implement any of the ARS commands, take that to
> mean that ARS is unsupported, and continue to initialize regions without
> bad block lists. We cannot make the assumption that ARS commands will be
> unconditionally supported on all NVDIMMs.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>

Thank you for the fix, Vishal! it looks good to me.

However, It is haozhong's credit as he is the one reported the bug not
me. :)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
