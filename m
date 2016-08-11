Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5258E1A1DFE
 for <linux-nvdimm@lists.01.org>; Thu, 11 Aug 2016 09:47:28 -0700 (PDT)
Date: Thu, 11 Aug 2016 18:47:40 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [4.6 stable PATCH 0/2] libnvdimm: fix initialization vs autodetect
Message-ID: <20160811164740.GA3676@kroah.com>
References: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147026492600.9715.5445676747822316537.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Micah Parrish <micah.parrish@hpe.com>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 03, 2016 at 03:55:26PM -0700, Dan Williams wrote:
> Commit 1ee6667cd8d1 "libnvdimm, pfn, dax: fix initialization vs
> autodetect for mode + alignment" originally tagged for -stable does not
> apply cleanly to 4.6.  This backport pulls in commit 45a0dac04511
> "libnvdimm, dax: record the specified alignment of a dax-device
> instance" as a pre-requisite.
> 
> The result has been verfied to pass the ndctl unit tests.

Thanks, now queued up.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
