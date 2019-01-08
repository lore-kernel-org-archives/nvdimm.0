Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com
 [IPv6:2607:f8b0:4864:20::d42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 413C2211B1F90
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 11:47:55 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id m19so4124507ioh.3
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 11:47:55 -0800 (PST)
Subject: Re: [fio PATCH] engines/devdax: Make detection of device-dax
 instances more robust
References: <154697605958.939406.14480036379705502215.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <be0f90f5-b26c-43e6-489e-29770e1634c1@kernel.dk>
Date: Tue, 8 Jan 2019 12:47:51 -0700
MIME-Version: 1.0
In-Reply-To: <154697605958.939406.14480036379705502215.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fio@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 1/8/19 12:34 PM, Dan Williams wrote:
> In preparation for the kernel switching device-dax instances from the
> "/sys/class/dax" subsystem to "/sys/bus/dax" [1], teach the device-dax
> instance detection to be subsystem-type agnostic.
> 
> Note that the subsystem switch will require an administrator, or distro
> opt-in. The opt-in will either be at kernel compile time by disabling
> the default compatibility driver in the kernel, or at runtime with a
> modprobe policy to override which kernel module service device-dax
> devices. The daxctl utility [2] will ship a command to install the
> modprobe policy and include a man page that lists the potential
> regression risk to older FIO and other userspace tools that are hard
> coded to "/sys/class/dax".
> 
> [1]: https://lwn.net/Articles/770128/
> [2]: https://github.com/pmem/ndctl/tree/master/daxctl

Applied, thanks Dan.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
