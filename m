Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DFE0A2116821C
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 23:55:43 -0700 (PDT)
Date: Sun, 14 Oct 2018 08:55:41 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] dax fixes for 4.19-rc8
Message-ID: <20181014065541.GB11198@kroah.com>
References: <8f47e3ce3cbe6e165701dbf665bb1770ca13d907.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8f47e3ce3cbe6e165701dbf665bb1770ca13d907.camel@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Oct 13, 2018 at 05:25:21PM +0000, Williams, Dan J wrote:
> Hi Greg, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc8
> 
> ...to receive (2) urgent dax fixes for 4.19-rc8. They have appeared in
> a -next release.
> 
> However, note that commit d7782145e1ad ("filesystem-dax: Fix
> dax_layout_busy_page() livelock") is immediately replaced with the
> Xarray conversion targeting 4.20, so d7782145e1ad is the backport
> suitable fix for the livelock for v4.19 and earlier.
> 
> Please pull, thanks!
> 
> ---
> 
> The following changes since commit 17b57b1883c1285f3d0dc2266e8f79286a7bef38:
> 
>   Linux 4.19-rc6 (2018-09-30 07:15:35 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-4.19-rc8

Now merged, thanks.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
