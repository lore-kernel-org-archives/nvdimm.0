Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00AEB21161B0E
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 17:05:39 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 2/2] ndctl, monitor: in daemon mode, exit
 successfully if no DIMMs are found
Date: Fri, 5 Oct 2018 00:05:37 +0000
Message-ID: <ae5d56a43ee6fa728643dfeb8815e3c00cbb7e1e.camel@intel.com>
References: <20181005000057.30186-1-vishal.l.verma@intel.com>
 <20181005000057.30186-2-vishal.l.verma@intel.com>
In-Reply-To: <20181005000057.30186-2-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <42A20BE7277D4F488D0047E441F50C03@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "andreas@canonical.com" <andreas@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-10-04 at 18:00 -0600, Vishal Verma wrote:
> When we are running as a daemon, it is preferred to exit successfully
> when no DIMMs are found. When running in the foreground, retain an
> error
> return so that the user can be notified that nothing was found to
> monitor.
> 
> In the longer term, replace this with a libudev uevent monitor that
> will
> look for DIMM addition/removal events, and update the running
> monitor(s)
> if the DIMMs match the active filter spec.
> 
> Link: https://bugs.launchpad.net/ubuntu/+source/ndctl/+bug/1781268
> Reported-by: Andreas Hasenack <andreas@canonical.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Looks good to me, if no one is sticking around to reap the error might
as well claim success.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
