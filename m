Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD4921A1DED
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 15:12:31 -0700 (PDT)
Date: Mon, 19 Sep 2016 16:11:47 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl: bash completion for {enable,disable}-dimm
 commands
Message-ID: <20160919221147.GB8887@omniknight.lm.intel.com>
References: <1474322940-31495-1-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1474322940-31495-1-git-send-email-vishal.l.verma@intel.com>
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

On 09/19, Vishal Verma wrote:
> Add bash completion for the two new commands. Don't add a "-i" by
> default in __ndctl_get_dimms, instead specift "-i" manually where needed

s/specifit/specify/

> (everywhere except the completion for disable-dimm)
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  contrib/ndctl | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
