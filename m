Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com
 [64.147.123.21])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88CD72194EB7A
 for <linux-nvdimm@lists.01.org>; Mon, 27 May 2019 05:12:01 -0700 (PDT)
Date: Mon, 27 May 2019 14:11:56 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [for-4.14.y PATCH] libnvdimm/namespace: Fix label tracking error
Message-ID: <20190527121156.GB607@kroah.com>
References: <155882542900.2471091.11258089584930875450.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155882542900.2471091.11258089584930875450.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, stable@vger.kernel.org, Erwin Tsaur <erwin.tsaur@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, May 25, 2019 at 04:03:49PM -0700, Dan Williams wrote:
> commit c4703ce11c23423d4b46e3d59aef7979814fd608 upstream.
> 

Thanks for both of these, now queued up.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
