Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B38E211BA47A
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 11:37:55 -0800 (PST)
Date: Wed, 30 Jan 2019 20:37:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] nfit: Collect shutdown status for NVDIMM_FAMILY_HYPERV
Message-ID: <20190130193752.GA21181@kroah.com>
References: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <PU1P153MB01691690696D8F83FC1872C7BF900@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 30, 2019 at 06:48:40PM +0000, Dexuan Cui wrote:
> 
> See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901"):
> "Get Unsafe Shutdown Count (Function Index 2)".
> 
> Let's expose the info to the userspace (e.g. ntctl) via sysfs.

If you add a new sysfs file, you need to add a new Documentation/ABI/
update as well :(

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
